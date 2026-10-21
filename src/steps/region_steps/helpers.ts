/**
 * Shared building blocks of the Region step definitions (no steps are registered here).
 *
 * The Region module does not exist yet in the live build (see CLAUDE.md and every page object's own doc
 * comment under src/pages/region_pages). These helpers are written exactly as if it did, following the
 * conventions of the completed modules (see src/steps/location_category_steps/helpers.ts), so the step
 * definitions read the same way and are ready to run, unmodified, once the module and its placeholder
 * locators are replaced with real ones.
 *
 * Login reuse: the bare phrase "Given I am logged in as "X"" that most Region scenarios open with is already
 * registered by src/steps/location_steps/common.steps.ts (Cucumber step text is global); Region does not
 * redefine it; `logInAs` below is only reached from Region's own extended login phrasings (see
 * region_common.steps.ts) and from fixture helpers that need to guarantee a session.
 */
import type { CustomWorld } from '../../support/world';
import { regionPages, regionScenario, type RegionFixture } from '../../support/region-scenario';
import { alreadyAuthenticated, markAuthenticated } from '../../support/session';
import { config, getCredentials, getRoleCredentials } from '../../support/config';
import type { RegionRecord } from '../../pages/region_pages';
import type { SubmitOutcome } from '../../pages/region_pages/RegionFormDialog';
import { expect } from '../../utils/assertions';
import { midcTestData } from '../../test-data/midc.data';
import { normalizeRegionText, regionMessagePattern } from '../../test-data/region.data';

/** Cucumber marks a step (and the rest of its scenario) as skipped when it returns this. */
export const SKIPPED = 'skipped' as const;

/** Logs why a scenario cannot run in this environment and skips it. */
export function skipBecause(world: CustomWorld, reason: string): typeof SKIPPED {
  world.log(`Skipped: ${reason}`);
  return SKIPPED;
}

/** For steps that can only follow a step which always skips; reaching one means the feature changed. */
export function unreachable(step: string): never {
  throw new Error(`"${step}" needs data this environment cannot provide; its scenario should have been skipped earlier.`);
}

export const NO_REGION_MODULE =
  'the MIDC build has no Region module yet (no "Region" tab under Organization Configuration, no Region API); ' +
  'this step is scaffolding for when it ships (see src/pages/region_pages).';

// ---------------------------------------------------------------------------
// Session and navigation
// ---------------------------------------------------------------------------

export async function ensureLoggedIn(world: CustomWorld, credentials = midcTestData.credentials): Promise<void> {
  if (alreadyAuthenticated()) return;
  const masters = world.pages.mastersManagementPage;
  if (await masters.mastersManagementLink.isVisible().catch(() => false)) return;
  if (await regionPages(world).list.organizationConfigurationIcon.isVisible().catch(() => false)) return;

  await world.pages.midcHomePage.open();
  await world.pages.midcHomePage.openDepartmentLogin();
  await world.pages.departmentLoginPage.expectLoaded();
  await world.pages.departmentLoginPage.login(credentials.username, credentials.password);
  if (await world.pages.departmentLoginPage.hasAuthenticationError()) {
    throw new Error('Department Login failed: the portal reported an authentication error.');
  }
  markAuthenticated(world.page);
}

/** "Region Viewer" -> the generic MIDC_VIEWER_* credential the other modules' permission scenarios already use. */
function genericRoleKey(role: string): 'ADMIN' | string {
  if (/region\s*admin$/i.test(role.trim()) || /^admin/i.test(role.trim())) return 'ADMIN';
  if (/no.?access/i.test(role)) return 'NoAccess';
  if (/view/i.test(role)) return 'Viewer';
  if (/edit/i.test(role)) return 'Editor';
  if (/audit/i.test(role)) return 'Auditor';
  return role;
}

/**
 * Signs in as the role a feature names. "Region Admin" / any role starting with "Admin" uses the configured
 * default credentials; any other role reuses the generic MIDC_<ROLE>_USERNAME / _PASSWORD credentials the
 * Location / Location Category permission scenarios already document (CLAUDE.md), otherwise the scenario
 * is skipped.
 */
export async function logInAs(world: CustomWorld, role: string): Promise<typeof SKIPPED | undefined> {
  regionScenario(world).role = role;
  const key = genericRoleKey(role);
  if (key === 'ADMIN') {
    await ensureLoggedIn(world);
    return undefined;
  }
  if (config.sharedSession) {
    return skipBecause(world, `a ${role} login cannot run inside the shared Admin session; run it without SHARED_SESSION.`);
  }
  const credentials = getRoleCredentials(key);
  if (!credentials) {
    return skipBecause(world, `no ${role} user is configured; set MIDC_${key.toUpperCase()}_USERNAME and MIDC_${key.toUpperCase()}_PASSWORD to run it.`);
  }
  await ensureLoggedIn(world, credentials);
  return undefined;
}

/** Logged in and the page has made at least one authenticated API request (needed for fixtures and API scenarios). */
export async function ensureSession(world: CustomWorld): Promise<void> {
  const { api, list } = regionPages(world);
  if (api.hasSession()) return;
  await ensureLoggedIn(world);
  await list.open(midcTestData.organizationName);
}

/** True once the page has made an authenticated API request whose headers can be replayed (for "I have API access as ..."). */
export async function ensureApiAccess(world: CustomWorld, role: string): Promise<typeof SKIPPED | undefined> {
  const skipped = await logInAs(world, role);
  if (skipped) return skipped;
  await ensureSession(world);
  return undefined;
}

/** Back to the list, discarding any open form, menu or confirmation dialog and any search. */
export async function returnToList(world: CustomWorld): Promise<void> {
  const { list } = regionPages(world);
  await regionPages(world).dismissOverlays();
  await ensureLoggedIn(world);
  if (!(await list.isListVisible())) await list.open(midcTestData.organizationName);
  await list.clearSearch();
}

// ---------------------------------------------------------------------------
// Test data / fixtures
// ---------------------------------------------------------------------------

export function uniqueName(world: CustomWorld, value: string): string {
  return regionScenario(world).data.name(value);
}

export function requireFixture(world: CustomWorld, frdName: string): RegionFixture {
  const fixture = regionScenario(world).fixture(frdName);
  if (!fixture) throw new Error(`No test copy of Region "${frdName}" exists in this scenario; an earlier step should have created it.`);
  return fixture;
}

export function requireTarget(world: CustomWorld): RegionFixture {
  const target = regionScenario(world).target;
  if (!target) throw new Error('No Region has been selected by an earlier step of this scenario.');
  return target;
}

/** The scenario's own copy of `frdName` ("Delhi" -> "Delhi Bdd1234567"), created through the (placeholder) API. */
export async function ensureRegion(world: CustomWorld, frdName: string): Promise<RegionFixture> {
  const scenario = regionScenario(world);
  const existing = scenario.fixture(frdName);
  if (existing) {
    scenario.target = existing;
    return existing;
  }
  await ensureSession(world);
  const name = scenario.data.name(frdName);
  const result = await regionPages(world).api.create({ regionName: name });
  if (result.status >= 300 || result.id === undefined) {
    throw new Error(`Could not create the test Region "${name}": ${result.status} ${result.message}`);
  }
  return scenario.remember({ id: result.id, frd: frdName, name });
}

export async function freshMaster(world: CustomWorld): Promise<RegionRecord[]> {
  return regionPages(world).api.fetchMaster();
}

export function sameText(actual: string | undefined, expected: string): boolean {
  return normalizeRegionText(actual ?? '') === normalizeRegionText(expected);
}

export async function expectNoRegionNamed(world: CustomWorld, name: string): Promise<void> {
  const found = (await freshMaster(world)).filter((record) => sameText(record.name, name));
  expect(found.map((record) => record.name), `no Region "${name}" exists`).toEqual([]);
}

// ---------------------------------------------------------------------------
// Add / Edit form
// ---------------------------------------------------------------------------

export async function openAddForm(world: CustomWorld): Promise<void> {
  const { form, list } = regionPages(world);
  if (await form.isOpen()) return;
  await returnToList(world);
  await list.addButton.click();
  await expect(form.nameInput).toBeVisible({ timeout: 20000 });
  regionScenario(world).entered = {};
  regionScenario(world).editing = undefined;
}

export async function openEditFor(world: CustomWorld, fixture: RegionFixture): Promise<void> {
  const { form, list } = regionPages(world);
  await returnToList(world);
  await list.chooseRowAction(fixture.name, 'Edit');
  await expect(form.nameInput).toBeVisible({ timeout: 20000 });
  regionScenario(world).entered = {};
  regionScenario(world).editing = fixture;
  regionScenario(world).target = fixture;
}

/** Submits the open form and records what happened. */
export async function submitForm(world: CustomWorld): Promise<SubmitOutcome> {
  const { form } = regionPages(world);
  const previous = await world.visibleToasts();
  const outcome = await form.submit();
  regionScenario(world).lastOutcome = outcome;
  if (outcome.kind !== 'saved') {
    const values = await form.currentValues().catch(() => 'unreadable');
    world.log(`Save refused (${describeOutcome(outcome)}); form held ${values}`);
  }
  if (outcome.kind === 'saved' || outcome.kind === 'rejected') await world.captureNewToast(previous, 10000);
  return outcome;
}

export function describeOutcome(outcome: SubmitOutcome | undefined): string {
  if (!outcome) return 'nothing was submitted';
  switch (outcome.kind) {
    case 'saved':
      return `saved (#${outcome.call.id}): ${outcome.call.message}`;
    case 'rejected':
      return `rejected by the API (${outcome.call.status}): ${outcome.call.message}`;
    case 'client-validation':
      return `blocked by form validation: ${outcome.messages.join(' | ')}`;
    case 'disabled':
      return 'the Save button is disabled until a field changes';
    case 'no-response':
      return 'no request was sent and no validation message was shown';
  }
}

/** The id of the record the last Create / Update saved; fails with the outcome when the save did not succeed. */
export function successfulSaveId(world: CustomWorld, operation: 'Create' | 'Update'): number {
  const outcome = regionScenario(world).lastOutcome;
  if (outcome?.kind !== 'saved' || outcome.call.operation !== operation || outcome.call.id === undefined) {
    throw new Error(`Expected the ${operation} to succeed, but ${describeOutcome(outcome)}.`);
  }
  return outcome.call.id;
}

export function expectSaveBlocked(world: CustomWorld): void {
  const outcome = regionScenario(world).lastOutcome;
  expect(outcome && outcome.kind !== 'saved', `the save is blocked, but ${describeOutcome(outcome)}`).toBe(true);
}

/** The FRD message is shown: as a toast, as an inline form message, or at least as the API's own error text. */
export async function expectMessage(world: CustomWorld, message: string): Promise<void> {
  const pattern = regionMessagePattern(message);
  const outcome = regionScenario(world).lastOutcome;
  const apiText =
    outcome?.kind === 'rejected' ? outcome.call.message : outcome?.kind === 'client-validation' ? outcome.messages.join(' ') : '';
  const onScreen = async (): Promise<boolean> =>
    (await world.sawMessage(pattern, 0)) || (await world.page.getByText(pattern).first().isVisible().catch(() => false));
  await expect
    .poll(async () => (await onScreen()) || pattern.test(apiText), {
      timeout: 15000,
      message: `message "${message}" is displayed; toasters: ${JSON.stringify(world.seenToasts)}; API: "${apiText}"`,
    })
    .toBe(true);
}

/** Nothing was created through the Add form of this scenario (fixtures are created with direct API calls). */
export function expectNoCreateThroughForm(world: CustomWorld): void {
  const { api } = regionPages(world);
  const created = api.apiCalls.filter((call) => call.operation === 'Create' && call.status < 300 && !api.directIds.has(call.id ?? -1));
  expect(created.map((call) => call.id), 'no Region was created through the form').toEqual([]);
}

export { getCredentials };
