You are a senior QA automation engineer working in this repository: a Playwright + TypeScript + Cucumber (BDD) suite for the CivitCORE portal.

## Goal
Write the automation scripts (page objects, step definitions, test data, hooks/scenario state) for the **Audit Trail** module so they fit this framework's existing structure. The Gherkin is already written; you implement what is needed to make it executable.

IMPORTANT: We cannot execute tests right now (no live Audit Trail build/URL, the product is in its design phase). Prepare the scripts only. Do NOT run `npm test` or open a browser. Static checks ARE expected and allowed: `npm run typecheck` and `npm run test:dry-run` (the dry-run only verifies every step has a definition).

## Hard rules
1. Do NOT modify any existing file that belongs to another module (Department, Designation, Location, Location Category, Miscellaneous Master, Region, Specialization, etc.), and do not edit any existing `.feature` file.
2. Only touch shared files where unavoidable and then ADD-ONLY (e.g. one export line in `src/pages/index.ts`, one facade entry on `CustomWorld`, adding the new feature path to `cucumber.js`). Show me each such addition before making it and keep it minimal.
3. Use the other modules only as a reference for conventions. The closest and most recent reference is **Region** (`src/pages/region_pages/`, `src/steps/region_steps/`, `src/support/region-scenario.ts`, `src/test-data/region.data.ts`, `features/region_management_features/`). Also compare Designation / Location for how the page-object facade and scenario state are wired.
4. Do not edit `README.md`, `CLAUDE.md`, or `.env.example` content except to add Audit Trail notes/vars when I approve.
5. No hardcoded credentials, URLs, or secrets. All environment settings come from `src/support/config.ts` (`getCredentials()` / `getRoleCredentials(role)`); never read `process.env` anywhere else. Add any new env vars (e.g. `MIDC_CLEARONLY_*`) to `.env.example` as placeholders only.

## Step 1 - Read before writing (report back a short summary, then wait for my "go")
- Read `CLAUDE.md`, `README.md`, `cucumber.js`, `package.json`, `src/support/*` (world, hooks, session, config, shared-step-registry), `src/pages/index.ts`.
- Read the full Region implementation end to end (pages, steps, scenario state, test data, hooks/cleanup) and one other module's `common` steps, to learn: naming, folder layout, how steps stay thin and page objects hold locators/waits, how toasts are asserted (read-only, never mutate toaster DOM), how test data is generated/cleaned (`Bdd<digits>` suffix, API cleanup), how the `@shared-session` / `@isolated-session` tags work, and how permission/role scenarios log in as other users.
- Read ALL feature files in `features/audit_trail_features/` (8 files, 120 scenarios; tags `@AuditTrail` + per-file tag, `@TC_CP_nnn`, `@Functional|@UI|@Negative`, `@High|@Medium|@Low`, `@Automation`). Source workbook: `D:\Softtechglobal_Automation_CivCore_CivInfra\Excel_TestCases\CivitCORE_AuditTrail_TestCases.xlsx` (Summary sheet has baseline data and FRD notes; FRD = CC-F-005 Audit Trail).
- Already created, empty folders to use: `src/pages/audit_trail_pages/` and `src/steps/audit_trail_steps/`.
- List every distinct step in the audit-trail features and detect duplicates / near-duplicates and steps already defined globally in another module (Cucumber step text is global; an identical step text defined twice causes an "ambiguous step" error). Reuse existing shared steps (login, navigation) where the text matches; do not redefine them.

## Step 2 - Design (show me the plan first)
Propose, in a table, the files you will create, mirroring Region's layout:
- `src/pages/audit_trail_pages/`: e.g. `AuditTrailListPage`, `AuditTrailFilterPanel` (Functions dropdown, From/To date pickers, Search, Clear Log), `ClearAuditLogDialog`, `AuditTrailApi` (get-audit-entries and baseline seeding/cleanup via API), `AuditTrailPages.ts` facade, `index.ts`; re-export from `src/pages/index.ts`.
- `src/steps/audit_trail_steps/`: one step file per feature file (`audit_trail_initiation.steps.ts`, `audit_logging.steps.ts`, `audit_trail_view_search_filter.steps.ts`, `audit_trail_date_validation.steps.ts`, `clear_audit_log.steps.ts`, `permissions.steps.ts`, `audit_log_read_only.steps.ts`, `audit_trail_ui.steps.ts`), plus `common.steps.ts` for shared steps, `helpers.ts`, `hooks.ts`.
- `src/support/audit-trail-scenario.ts` (scenario-scoped state, same pattern as `region-scenario.ts`) and `src/test-data/audit-trail.data.ts` (FRD terms -> UI wording, verbatim messages from the workbook Summary note 5, baseline entries #1-#14 expressed RELATIVE to the real run date: T-0, T-2, ... not hardcoded 16-Nov-2026, users Admin_User1 / Viewer_User1 / ClearOnly_User1 / NoAccess_User1 mapped to `getRoleCredentials(...)`).
- The one-line additive wiring needed in `world.ts` / `cucumber.js` (add `features/audit_trail_features` and a `test:audit-trail` script only if consistent with how other modules did it).

## Step 3 - Implement (after I approve the plan)
- Page objects hold ALL locators and waits; step definitions stay thin. Prefer `getByRole` / `getByLabel` / `getByText` and stable attributes; avoid brittle XPath and fixed `waitForTimeout` sleeps (use auto-waiting / `expect(...).toBeVisible()` / response waits).
- Because the real UI is not available, centralize every locator in one place per page object, mark guessed locators with `// TODO(locator): confirm against live UI`, and never invent behavior silently.
- Steps are written in the feature files' natural-language wording. Map the Gherkin as-is; do not rewrite or delete scenarios. If a step is ambiguous or untestable as written, implement it as best you can and list it in the gap report instead of editing the feature.
- API-style scenarios (e.g. the 403 check for a user without View Audit Trail): implement with Playwright's `APIRequestContext` through `AuditTrailApi`, using the role token, no UI.
- Destructive scenarios (Clear Log): seed the baseline before each such scenario and clean/restore after it in `hooks.ts`; tag handling must follow the `@isolated-session` / `@shared-session` pattern used by other modules. Date-based data is computed relative to "today".
- Assertions on audit entries must cover Function Name, Log Date & Time, Class Name, Client IP and Message (e.g. `'[Entity] created successfully.'`) exactly as the scenarios state; the grid is read-only (no edit/delete controls).
- Strict TypeScript, no `any` unless justified, async/await everywhere, no unused imports, errors with clear messages, no `console.log` noise; follow the repo's existing code style (inspect formatting in Region files).
- Security: no secrets in code, no PII in logs, validate/escape any value interpolated into locators or API payloads.

## Step 4 - Verify (static only)
1. `npm run typecheck` must pass with zero errors.
2. `npm run test:dry-run` must show 0 undefined and 0 ambiguous steps for `@AuditTrail`, and must not break any other module (compare the total step/scenario counts for non-audit features before and after; they must be unchanged).
3. `git status` / `git diff --stat`: confirm that the ONLY changes are new files under the audit-trail folders plus the minimal additive wiring edits you showed me. If any other existing file changed, revert it.

## Final report (keep it short)
- Files created / files minimally edited (with the exact added lines).
- Scenario coverage: total scenarios in the audit-trail features vs. scenarios whose every step is now defined.
- Gap list: steps with guessed locators (`TODO(locator)`), FRD ambiguities that block exact assertions (see workbook Summary note 6), env vars/roles/test data I must supply (`MIDC_CLEARONLY_*` etc.), and any scenario that needs an API endpoint I must confirm.
- Reminder that nothing was executed against a live environment.

Work incrementally: finish and verify one feature file's steps at a time (start with `audit_trail_initiation` and `permissions`), run the typecheck + dry-run after each, and only then continue.
