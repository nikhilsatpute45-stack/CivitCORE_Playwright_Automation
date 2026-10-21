/**
 * Shared building blocks of the Location step definitions (no steps are registered here).
 *
 * Feature files use an FRD vocabulary and a fictional 12-record baseline (INDIA > Gujarat/Maharashtra/Bihar >
 * districts > 2 cities) that the live ~2,700-record master does not contain; location.data.ts maps the
 * vocabulary and `ensureLocation` creates a unique copy of a baseline Location (through the API) the first
 * time a scenario refers to it. The clean-up hook removes every copy. Location Categories themselves (City,
 * Country, State, District, Zone, ...) are real, permanent master data shared with the Location Category
 * module; they are never created or deleted, only looked up by name for their id.
 */
import type { CustomWorld } from '../../support/world';
import type { LocationFixture } from '../../support/location-scenario';
import { alreadyAuthenticated, markAuthenticated } from '../../support/session';
import { config, getRoleCredentials } from '../../support/config';
import type { LocationRecord, SubmitOutcome } from '../../pages/location';
import { expect } from '../../utils/assertions';
import { midcTestData } from '../../test-data/midc.data';
import {
  baselineLocation,
  baselineNames,
  liveLocationCategory,
  locationMessagePattern,
  normalizeLocationText,
} from '../../test-data/location.data';

/** Cucumber marks a step (and the rest of its scenario) as skipped when it returns this. */
export const SKIPPED = 'skipped' as const;

export function skipBecause(world: CustomWorld, reason: string): typeof SKIPPED {
  world.log(`Skipped: ${reason}`);
  return SKIPPED;
}

/** For steps that can only follow a step which always skips; reaching one means the feature changed. */
export function unreachable(step: string): never {
  throw new Error(`"${step}" needs data this environment cannot provide; its scenario should have been skipped earlier.`);
}

// ---------------------------------------------------------------------------
// Session and navigation
// ---------------------------------------------------------------------------

export async function ensureLoggedIn(world: CustomWorld, credentials = midcTestData.credentials): Promise<void> {
  if (alreadyAuthenticated()) return;
  const masters = world.pages.mastersManagementPage;
  if (await masters.mastersManagementLink.isVisible().catch(() => false)) return;
  if (await world.pages.location.list.organizationConfigurationIcon.isVisible().catch(() => false)) return;

  await world.pages.midcHomePage.open();
  await world.pages.midcHomePage.openDepartmentLogin();
  await world.pages.departmentLoginPage.expectLoaded();
  await world.pages.departmentLoginPage.login(credentials.username, credentials.password);
  if (await world.pages.departmentLoginPage.hasAuthenticationError()) {
    throw new Error('Department Login failed: the portal reported an authentication error.');
  }
  markAuthenticated(world.page);
}

/**
 * Signs in as the role a feature names. Admin uses the configured credentials; any other role needs
 * MIDC_<ROLE>_USERNAME / _PASSWORD and a fresh (non-shared) session, otherwise the scenario is skipped.
 */
export async function logInAs(world: CustomWorld, role: string): Promise<typeof SKIPPED | undefined> {
  if (/^admin/i.test(role)) {
    await ensureLoggedIn(world);
    return undefined;
  }
  if (config.sharedSession) {
    return skipBecause(world, `a ${role} login cannot run inside the shared Admin session; run it without SHARED_SESSION.`);
  }
  const credentials = getRoleCredentials(role);
  if (!credentials) {
    const key = role.toUpperCase().replace(/[^A-Z]/g, '');
    return skipBecause(world, `no ${role} user is configured; set MIDC_${key}_USERNAME and MIDC_${key}_PASSWORD to run it.`);
  }
  await ensureLoggedIn(world, credentials);
  return undefined;
}

export async function ensureSession(world: CustomWorld): Promise<void> {
  const { api, list } = world.pages.location;
  if (api.hasSession()) return;
  await ensureLoggedIn(world);
  await list.open(midcTestData.organizationName);
}

export async function ensureOnList(world: CustomWorld): Promise<void> {
  const { list } = world.pages.location;
  await ensureLoggedIn(world);
  if (world.location.needsRefresh) {
    await world.pages.location.dismissOverlays();
    await list.refresh(midcTestData.organizationName);
    world.location.needsRefresh = false;
    return;
  }
  if (!(await list.isListVisible())) await list.open(midcTestData.organizationName);
}

export async function reloadIfFixturesAreNew(world: CustomWorld): Promise<void> {
  if (!world.location.needsRefresh) return;
  await world.page.reload();
  world.location.needsRefresh = false;
}

export async function returnToList(world: CustomWorld): Promise<void> {
  await world.pages.location.dismissOverlays();
  await ensureOnList(world);
  await world.pages.location.list.clearFilters();
}

// ---------------------------------------------------------------------------
// Location Category master (real, permanent data - looked up, never created/deleted)
// ---------------------------------------------------------------------------

const categoryIdCache = new Map<string, number>();

/** Numeric id of a real, permanent Location Category value ("State", "District", "Zone", ...). */
export async function categoryId(world: CustomWorld, liveLabel: string): Promise<number> {
  const key = normalizeLocationText(liveLabel);
  const cached = categoryIdCache.get(key);
  if (cached !== undefined) return cached;
  await ensureSession(world);
  const records = await world.pages.locationCategory.api.fetchMaster();
  const match = records.find((record) => normalizeLocationText(record.name) === key);
  if (!match) throw new Error(`No Location Category named "${liveLabel}" exists in the live master.`);
  categoryIdCache.set(key, match.id);
  return match.id;
}

// ---------------------------------------------------------------------------
// Test data (Locations - created/removed per scenario)
// ---------------------------------------------------------------------------

/**
 * The scenario's own copy of the FRD Location `frdName` ("Gujarat" -> "Gujarat Bdd1234567"), created through
 * the API under its FRD parent (also a copy, created first). Later references return the same copy.
 */
export async function ensureLocation(world: CustomWorld, frdName: string, parentFrd?: string): Promise<LocationFixture> {
  const scenario = world.location;
  const existing = scenario.fixture(frdName);
  if (existing) {
    scenario.target = existing;
    return existing;
  }
  await ensureSession(world);
  const baseline = baselineLocation(frdName);
  if (!baseline) throw new Error(`"${frdName}" is not one of the known baseline Locations; create it through the scenario's own steps instead.`);
  const parentName = parentFrd ?? baseline.parent;
  const parent = parentName ? await ensureLocation(world, parentName) : undefined;

  const name = scenario.data.name(frdName);
  const code = scenario.data.code(baseline.code);
  const catId = await categoryId(world, liveLocationCategory(baseline.category));
  const result = await world.pages.location.api.create({
    locName: name,
    locCode: code,
    locCatID: catId,
    locParentID: parent?.id ?? null,
  });
  if (result.status >= 300 || result.id === undefined) {
    throw new Error(`Could not create the test Location "${name}": ${result.status} ${result.message}`);
  }
  scenario.needsRefresh = true;
  return scenario.remember({ id: result.id, frd: frdName, name, code, categoryFrd: baseline.category, parentFrd: parentName });
}

/** Copies of all twelve FRD baseline Locations, parents first. */
export async function ensureBaseline(world: CustomWorld): Promise<LocationFixture[]> {
  const created: LocationFixture[] = [];
  for (const name of baselineNames) created.push(await ensureLocation(world, name));
  return created;
}

export function requireFixture(world: CustomWorld, frdName: string): LocationFixture {
  const fixture = world.location.fixture(frdName);
  if (!fixture) throw new Error(`No test copy of "${frdName}" exists in this scenario; an earlier step should have created it.`);
  return fixture;
}

export function requireTarget(world: CustomWorld): LocationFixture {
  const target = world.location.target;
  if (!target) throw new Error('No Location has been selected by an earlier step of this scenario.');
  return target;
}

/** Master record as the grid last loaded it (re-read after every save). */
export function storedRecord(world: CustomWorld, id: number): LocationRecord | undefined {
  return world.pages.location.api.recordById(id);
}

/** The master straight from the API (independent of what the grid has loaded; ~2,700 rows live). */
export async function freshMaster(world: CustomWorld): Promise<LocationRecord[]> {
  return world.pages.location.api.fetchMaster();
}

export function sameText(actual: string | undefined, expected: string): boolean {
  return normalizeLocationText(actual ?? '') === normalizeLocationText(expected);
}

/** Unique copy of a name the feature types ("Rajkot" -> "Rajkot Bdd..."), leaving blanks untouched. */
export function uniqueName(world: CustomWorld, value: string): string {
  return world.location.data.name(value);
}

export function uniqueCode(world: CustomWorld, value: string): string {
  return world.location.data.code(value);
}

// ---------------------------------------------------------------------------
// Forms
// ---------------------------------------------------------------------------

export async function openAddForm(world: CustomWorld): Promise<void> {
  const { form, list } = world.pages.location;
  if (await form.isOpen()) return;
  // The Parent Category / Parent Location dropdowns are populated once per page load; a fixture created
  // through the API after that load needs a reload before it is offered.
  await reloadIfFixturesAreNew(world);
  await ensureOnList(world);
  await list.addButton.click();
  await expect(form.nameInput).toBeVisible({ timeout: 20000 });
  world.location.entered = {};
  world.location.editing = undefined;
}

export async function openEditFor(world: CustomWorld, fixture: LocationFixture): Promise<void> {
  const { form, list } = world.pages.location;
  await reloadIfFixturesAreNew(world);
  await returnToList(world);
  await list.chooseRowAction(fixture.name, 'Edit');
  await expect(form.nameInput).toBeVisible({ timeout: 20000 });
  await expect(form.nameInput).toHaveValue(/\S/);
  world.location.entered = {};
  world.location.editing = fixture;
  world.location.target = fixture;
}

/**
 * Applies the scenario's selections (world.location.entered) to the Location Category / Parent Category /
 * Parent Location selects, in the only order the live form actually supports.
 *
 * Confirmed live: Parent Category has NO options at all until Location Category holds a value - its options
 * are not "every other category" but the ONE category configured as that Location Category's parent in the
 * category hierarchy (e.g. choosing "District" populates Parent Category with only "State"). Gherkin step
 * order is "Parent Location Category" then "Location Category" (matching the FRD's field table order), which
 * is the reverse of what the UI needs; this function is called again after every field-selection step so the
 * DOM always reflects the fullest state applied in the correct order, regardless of which order the
 * scenario's own steps ran in. When the scenario only sets a Parent Location Category (never an explicit
 * Location Category - e.g. a pure dropdown-cascade scenario) and the form is in Add mode, a provisional
 * Location Category is chosen from the baseline's own parent/child mapping purely to unlock the cascade.
 */
export async function applyLocationCascade(world: CustomWorld): Promise<void> {
  const { form } = world.pages.location;
  const entered = world.location.entered;

  const categoryToApply =
    entered.categoryFrd ?? (entered.parentCategoryFrd && !world.location.editing ? plausibleChildCategory(entered.parentCategoryFrd) : undefined);
  if (categoryToApply) {
    await form.selectCategory(liveLocationCategory(categoryToApply));
    if (!entered.categoryFrd) {
      world.log(`Selected Location Category "${categoryToApply}" to unlock the Parent Category dropdown (not itself requested by this step).`);
    }
  }

  if (entered.parentCategoryFrd) {
    await form.selectParentCategory(liveLocationCategory(entered.parentCategoryFrd));
  }

  if (entered.parentFrd) {
    const parent = await ensureLocation(world, entered.parentFrd);
    await form.selectParentLocation(parent.name);
  }
}

/** Submits the open form and records what happened. */
export async function submitForm(world: CustomWorld): Promise<SubmitOutcome> {
  const { form } = world.pages.location;
  const previous = await world.visibleToasts();
  const outcome = await form.submit();
  world.location.lastOutcome = outcome;
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

export function successfulSaveId(world: CustomWorld, operation: 'Create' | 'Update'): number {
  const outcome = world.location.lastOutcome;
  if (outcome?.kind !== 'saved' || outcome.call.operation !== operation || outcome.call.id === undefined) {
    throw new Error(`Expected the ${operation} to succeed, but ${describeOutcome(outcome)}.`);
  }
  return outcome.call.id;
}

export function expectSaveBlocked(world: CustomWorld): void {
  const outcome = world.location.lastOutcome;
  expect(outcome && outcome.kind !== 'saved', `the save is blocked, but ${describeOutcome(outcome)}`).toBe(true);
}

export async function expectMessage(world: CustomWorld, message: string): Promise<void> {
  const pattern = locationMessagePattern(message);
  const outcome = world.location.lastOutcome;
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

/** A plausible own Location Category for a child of `parentCategoryFrd`, following the FRD baseline nesting. */
export function plausibleChildCategory(parentCategoryFrd?: string): string {
  switch (parentCategoryFrd) {
    case 'Country':
      return 'State/Territory';
    case 'State/Territory':
      return 'District';
    case 'District':
      return 'City';
    default:
      return 'District';
  }
}

/**
 * Fills whatever the scenario's own steps have not already filled (Name, Location Code, Location Category,
 * Parent Location Category + Parent Location), so a negative scenario that only names one invalid field can
 * attempt Save with every other field valid.
 */
export async function fillRemainingValidFields(world: CustomWorld): Promise<void> {
  const { form } = world.pages.location;
  const entered = world.location.entered;
  if (entered.name === undefined) {
    const name = uniqueName(world, 'Filler Location');
    await form.type('Location', name);
    entered.name = name;
  }
  if (entered.code === undefined) {
    const code = uniqueCode(world, 'FL');
    await form.type('Location Code', code);
    entered.code = code;
  }
  if (entered.parentFrd === undefined) {
    const parent = await ensureLocation(world, 'Gujarat');
    entered.parentCategoryFrd = parent.categoryFrd;
    entered.parentFrd = 'Gujarat';
  }
  if (entered.categoryFrd === undefined) {
    entered.categoryFrd = plausibleChildCategory(entered.parentCategoryFrd);
  }
  await applyLocationCascade(world);
}

export async function expectNoLocationNamed(world: CustomWorld, name: string): Promise<void> {
  const found = (await freshMaster(world)).filter((record) => sameText(record.name, name));
  expect(
    found.map((record) => record.name),
    `no Location "${name}" exists`,
  ).toEqual([]);
}
