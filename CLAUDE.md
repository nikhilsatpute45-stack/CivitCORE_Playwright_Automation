# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Cucumber BDD suite (Playwright + TypeScript) for the MIDC / CivitCORE portal (`smartgovcivit.com`, admin at `admin.smartgovcivit.com`). Four feature areas, each written against its own FRD vocabulary (test data/messages map FRD terms to actual MIDC UI wording):

- Department Management — `features/department_management_features/`
- Designation Management — `features/designation_management_features/`
- Location Category Management — `features/location_category_features/`
- Location Management — `features/location_features/`

Department was converted from original Playwright Test specs (`CONVERSION_REPORT.md`, Department-only, predates the other three modules); `seed.spec.ts` and `specs/` are leftovers for the Playwright planner/generator/healer agents (`.claude/agents/`, `.github/agents/`), not part of the Cucumber run.

Tests run against a live environment and need real credentials: copy `.env.example` to `.env` and set `MIDC_USERNAME` / `MIDC_PASSWORD` (single-quote passwords containing `$ @ #`). Role-scoped credentials (`MIDC_VIEWER_*`, `MIDC_EDITOR_*`, `MIDC_NOACCESS_*`, `MIDC_AUDITOR_*`) are used by Location/Location Category permission scenarios. Never commit `.env`. Node >= 20; Java is needed only for rendering Allure reports.

## Commands

```bash
npm test                         # all scenarios (@shared-session ones are excluded by default)
npm run test:dry-run             # verifies every step has a definition, no browser
npm run typecheck                # tsc --noEmit (no linter is configured; ts-node runs transpile-only)
npm run test:headed              # visible browser (HEADLESS=false)

# One tag / one scenario
npx cucumber-js --tags "@edit-department and not @fixme"
npx cucumber-js --tags @TC_N_0001
npx cucumber-js features/department_management_features/add-department.feature:12   # by file:line

npm run test:sequential                 # ordered 11-feature Department run, ONE shared browser + login
npm run test:designation:sequential     # login -> 9 Designation features -> logout, shared session
npm run test:location-category:sequential   # login -> 8 Location Category features -> logout, shared session
npm run test:location:sequential        # login -> 10 Location features -> logout, shared session
npm run test:designation                # @Designation, isolated sessions
npm run test:location-category          # @location_category, isolated sessions
npm run test:location                   # @location and not @location_category, isolated sessions
npm run test:parallel                   # PARALLEL=4 workers
npm run test:chromium|firefox|webkit | test:all-browsers   # scripts/run-browsers.js
npm run test:report              # clean, run, build Allure report (extra args forwarded to cucumber)
npm run allure:report | report:open | clean:reports
```

Other `test:*` scripts are tag filters for individual Department scenarios (`@add-department`, `@negative`, `@search-department`, ...) — Department has no single umbrella tag the way `@Designation`/`@location_category`/`@location` do the other three modules. Every run writes the Cucumber HTML report (`reports/html/index.html`), JSON, per-scenario artifacts (`reports/artifacts/`) and `allure-results/`; the `ci` profile adds JUnit.

## Architecture

- **`cucumber.js`** defines the profiles: `default`, `ci`, `sequential`, `designation-sequential`, `location-category-sequential`, `location-sequential`. `default` loads `features/**/*.feature` with `ts-node/register` (transpile-only, so `npm run typecheck` is the only type check) and requires `src/support/**` and `src/steps/**`. The four `*-sequential` profiles each pin an explicit file order for one module (login first, logout last), force `parallel: 0`, `retry: 0`, `order: 'defined'`, and flip the tag filter from `not @shared-session` to `not @isolated-session`. When adding a feature file that belongs in an ordered run, add it to the relevant path list there. Note: `department-management-ui.feature` (`@department-ui`) exists under Department but is wired into no sequential profile and no dedicated `test:*` script.
- **Two session modes** (`src/support/hooks.ts`, `session.ts`, `world.ts`): by default each scenario gets a fresh BrowserContext + page. With `SHARED_SESSION=1` one context is created and logged in during `BeforeAll`, every scenario borrows it (the After hook must not close it), and `AfterAll` logs out. `session.ts` pins `landingUrl` at login and `returnToLandingPage` restores it between features, because features may end in the admin portal, which has no "Masters Management" link. Steps use `alreadyAuthenticated()` to skip login work.
- **`CustomWorld`** (`src/support/world.ts`) owns the context/page, page objects, `TestDataStore`, and toast capture. All environment settings come from `src/support/config.ts` (including `getCredentials()`/`getViewerCredentials()`/`getRoleCredentials(role)`); do not read `process.env` elsewhere. `world.pages` is **not** uniformly nested: Department page objects sit flat on `world.pages.*` (e.g. `world.pages.departmentListPage`), while Designation, Location Category, and Location are each grouped behind one facade (`world.pages.designation`, `world.pages.locationCategory`, `world.pages.location`). Scenario-scoped cross-step state for the latter three lives directly on the World (`world.designation`, `world.locationCategory`, `world.location`, backed by `src/support/designation-scenario.ts` / `location-category-scenario.ts` / `location-scenario.ts`) — separate from the `pages` bag.
- **Page objects** in `src/pages/` hold all locators/waits; step files in `src/steps/` stay thin. Both are split into one subfolder per module — `department_pages/`, `designation/`, `location_category/`, `location/` — mirrored by `src/steps/department_steps/`, `src/steps/designation/`, `src/steps/location_category_steps/`, `src/steps/location_steps/`. `src/pages/index.ts` re-exports everything, so callers always `import ... from '../pages'` rather than reaching into a subfolder. Cucumber step text is **global** across files, so steps shared by several feature files within a module live in that module's `common.steps.ts`. Designation/Location Category/Location each have one page object and one step file per feature file (mapping tables in `README.md`).
- **Test data**: `src/test-data/{designation,location-category,location}.data.ts` map FRD terms to the MIDC UI wording (and alias app messages that differ from the FRD; `STRICT_FRD_MESSAGES=true` asserts FRD wording verbatim). All three document real FRD-vs-live gaps (e.g. Location has no Region field and a 20-char short-name limit vs FRD's 30; Location Category/Location hierarchies are far larger live than the FRD's baseline fixtures, so scenarios create their own uniquely-suffixed records via API). Generated names get a per-scenario `Bdd<digits>` suffix; each module's `src/steps/<module>/hooks.ts` deletes created records afterward (deepest-first for hierarchies). After a killed run, leftovers can be found by filtering the relevant grid for `Bdd`. `src/test-data/department.data.ts` and `midc.data.ts` hold Department's static messages/patterns and shared credentials respectively.
- **Tags** drive behaviour: `@fixme` scenarios are skipped in a hook, `@TC-*`/`@TC_N_*` become the Allure `testId`, `@REQ-*` the `story`, `@severity:*` the severity; `@no-retry` is excluded from `RETRY>0`.

## Gotchas

- **Never mutate the toaster DOM from tests** (e.g. `setAttribute` via `page.evaluate` to mark stale toasts). It stops later toasts from rendering on this portal. Toast detection in `world.ts` is read-only and tells stale from new by text (repeated text counts as new once it has disappeared and reappeared).
- `README.md`'s project-layout diagram still shows Department page objects flat under `src/pages/` — the real location is `src/pages/department_pages/` (same split as the other three modules). The public import surface (`from '../pages'`) is unaffected.
- Video, trace and screenshot default to `on`; set `VIDEO` / `TRACE` / `SCREENSHOT` to `retain-on-failure` or `off` for faster local runs.
- Location and Location Category test against real, large live hierarchies (not the FRD's small baseline), and several FRD-assumed fields/screens don't exist in this build (Region field, Office↔Location association, Activity Log, CivitBUILD/CivitINFRA reachability) — the corresponding scenarios are intentionally skipped/fixme'd; see the Location/Location Category sections of `README.md` before "fixing" one.

## Effort routing

| Task type                             | Model  | Effort |
|---------------------------------------|--------|--------|
| Lookup / list files / grep / search   | Haiku  | medium |
| Coding tasks (general implementation) | Sonnet | high   |
| Test scaffolding, routine edits       | Sonnet | medium |
| Code review, debugging                | Sonnet | high   |

Rules of thumb:

- Default to the lowest tier that can do the job correctly; escalate only when a task turns out to need more reasoning.
- Delegate pure lookups (find/list/grep) to a Haiku subagent rather than doing them yourself at high effort.
