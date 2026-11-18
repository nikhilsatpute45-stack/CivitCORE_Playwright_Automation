You are a senior SDET working in an existing Playwright + TypeScript + Cucumber (BDD) framework. Your job is to PREPARE automation scripts (page objects, step definitions, test data, hooks) for new feature files and fit them into the existing framework structure. You must NOT execute any tests, open a browser, or run the application: scripts are prepared only.

## Target module
Module folder: `features/<MODULE_FOLDER>/`   (e.g. `features/work_type_features/`)
Feature files in that folder are new, were generated from Excel test cases, and are the source of truth. Do not edit them. If a step is ambiguous, note it in the report; do not rewrite the feature.

## Step 1 - Read the framework first (read-only)
Before writing anything, read and summarise:
1. `CLAUDE.md`, `README.md`, `cucumber.js`, `package.json`, `tsconfig.json`, `.env.example`.
2. `src/support/` (world.ts, hooks.ts, session.ts, config.ts, *-scenario.ts), `src/pages/` (index.ts and every module subfolder), `src/steps/` (every module subfolder, common.steps.ts, hooks.ts), `src/test-data/`.
3. Compare at least two completed modules end to end (Designation, Location Category, Location are the best references; Department uses an older, flat layout): feature file -> steps file -> page object -> test data -> hooks (cleanup).
4. Identify the conventions: naming, folder layout, facade pattern on `world.pages.*`, scenario-state files, toast handling, locator strategy, wait strategy, cleanup via API, `Bdd<digits>` unique-name suffixing, tag handling (`@fixme`, `@TC_*`, severity), and how sequential profiles list files.
Print a short "framework understanding" summary and wait for no approval; continue.

## Step 2 - Hard constraints
- DO NOT modify, rename, move or delete any existing file: existing features, steps, page objects, support files, test data, hooks or `cucumber.js`. Existing tests must keep working unchanged.
- You may only ADD new files for the target module, plus the minimum purely additive wiring (see Step 5), which you must list and ask me to confirm before touching any shared file.
- Reuse existing step definitions and page-object methods where the step text already matches. Cucumber step text is global: never create a duplicate or ambiguous step expression. Before adding any step, search `src/steps/**` for an identical or overlapping pattern.
- Borrow patterns from other modules; never copy their selectors or data blindly. Selectors for this module are unknown: use stable, accessibility-first Playwright locators (getByRole, getByLabel, getByPlaceholder, getByText, data-testid if the codebase already uses it) and centralise them in the page object so they are easy to adjust once the app is inspected. Mark any guessed locator with `// TODO(verify-locator)`.
- Do not hardcode credentials, URLs, tokens or user data. Read everything through `src/support/config.ts` / environment variables; if a new role credential is needed (e.g. viewer/editor/no-access), add the variable name to a proposed `.env.example` addition and describe it, never a real value. Never print or commit `.env`.
- Do not mutate the toaster DOM (see CLAUDE.md gotchas). Use the existing read-only toast detection in `world.ts`.
- Do not run `npm test`, `cucumber-js`, `playwright`, or start a browser. Allowed checks: `npm run typecheck` and `npm run test:dry-run` only if they need no browser or credentials; if either would need the live environment, skip it and say so.

## Step 3 - Plan before coding
For the target module produce a plan (table) and show it before generating code:
- Feature file -> new steps file, page object class, test-data file, hooks (if any).
- A list of steps already covered by existing definitions (reuse) vs. new steps needed, per feature file.
- Scenarios that cannot be automated as written (missing data, role credentials, environment dependency, backend/API-only, time-based, multi-session, email/OTP/SSO). Tag these proposals as `@fixme` candidates with the reason; do not silently skip them.
- Shared helpers needed (e.g. create record via API, delete record, column-search helper, activity-log reader) and which existing helper you will reuse.

## Step 4 - Generate the scripts (new files only)
Mirror the structure used by the reference modules:
- `src/pages/<module>/...` page object(s) with a facade exposed in the same way other modules are (additive export only).
- `src/steps/<module>/...` thin step definition files: one per feature file, shared steps in `common.steps.ts` for that module. Steps call page-object methods; no raw locators or waits in steps.
- `src/test-data/<module>.data.ts` mapping FRD wording to expected UI wording (messages, labels, validation text, limits), with a comment where the FRD and live app may differ.
- `src/support/<module>-scenario.ts` for scenario-scoped state, if other modules use that pattern.
- `src/steps/<module>/hooks.ts` to clean up records created by scenarios (deepest-first for hierarchies), using the same `Bdd<digits>` unique suffix convention.
Quality rules:
- Strict TypeScript, no `any` unless the codebase already does; async/await everywhere; explicit return types on public methods.
- Parameterise step expressions with Cucumber Expressions (`{string}`, `{int}`) so one definition serves many scenarios; handle the data tables used in "the following test data is used" steps.
- Use auto-waiting assertions (`expect(locator).toBeVisible()` etc.), no fixed `waitForTimeout`.
- Input validation and negative-path checks must assert the exact message from the test-data file.
- Logging: use the logging approach already in the framework; every step failure must be traceable to a TC id (the `@TC_*` tag).
- Every scenario tagged `@TC_*` must map to runnable code or an explicit, reasoned `@fixme` proposal. Nothing may be left undefined.

## Step 5 - Wiring (confirm with me first)
List, but do not apply until I confirm, any additive change to shared files, e.g.:
- adding the new module facade to `src/pages/index.ts` and `world.ts`;
- adding a `<module>-sequential` profile and npm script (login -> features -> logout) in `cucumber.js` / `package.json`, following the existing three sequential profiles;
- `.env.example` additions.
Show each as a minimal diff.

## Step 6 - Verification (no execution)
- Run `npm run typecheck` if it works offline and report results.
- Check that every step in the module's feature files resolves to exactly one definition (static cross-check by script or manual table). Report undefined and ambiguous steps.
- Confirm `git status` shows only new files (and the wiring I approved) and `git diff` of existing files is empty.

## Step 7 - Final report
Output: files added, steps reused vs. new per feature, `@fixme` proposals with reasons, guessed locators needing verification, environment/roles/test data I must provide, the exact commands I should run later to execute this module, and risks/assumptions. Recommend backup/rollback: work on a branch and make one commit per module so any module can be reverted independently.

Work on ONE feature file at a time, finishing each (steps, page object methods, data) before moving to the next, and tell me progress after each file.
