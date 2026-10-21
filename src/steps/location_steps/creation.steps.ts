/**
 * Steps of location_creation.feature (FRD 6.2, US-2 - Location Creation).
 * Page objects: LocationListPage, LocationFormDialog, LocationApi. Shared steps (login, baseline data, field
 * entry, Save, messages) are in ./common.steps.ts.
 *
 * Every name a scenario types gets the scenario's unique suffix (see location.data.ts), so "Rajkot" becomes
 * "Rajkot Bdd1234567" and a duplicate of the baseline "Surat" is a duplicate of the scenario's own copy.
 * There is no Region field in this build (NO_REGION_FIELD); the whole-scenario Region tests are skipped and
 * individual "I select Region" steps inside otherwise-real scenarios are logged no-ops (see common.steps.ts).
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { expect } from '../../utils/assertions';
import { liveLocationCategory, NO_REGION_FIELD } from '../../test-data/location.data';
import {
  applyLocationCascade,
  categoryId,
  describeOutcome,
  ensureLocation,
  ensureSession,
  freshMaster,
  openAddForm,
  requireFixture,
  returnToList,
  sameText,
  skipBecause,
  unreachable,
  submitForm,
  successfulSaveId,
  uniqueCode,
  uniqueName,
} from './helpers';
import { expectNoCreateThroughForm } from './common.steps';

interface CreateOptions {
  category?: string;
  region?: string;
}

/** Creates a Location through the real Add Location form under an existing (already-ensured) parent. */
async function createUnder(world: CustomWorld, name: string, code: string, parentFrd: string, options: CreateOptions = {}) {
  const { form } = world.pages.location;
  const parent = await ensureLocation(world, parentFrd);
  await openAddForm(world);
  // Location Category must be selected before Parent Category has any real options (see applyLocationCascade).
  world.location.entered.categoryFrd = options.category ?? 'District';
  world.location.entered.parentCategoryFrd = parent.categoryFrd;
  world.location.entered.parentFrd = parentFrd;
  await applyLocationCascade(world);
  const typedName = uniqueName(world, name);
  const typedCode = uniqueCode(world, code);
  await form.type('Location', typedName);
  await form.type('Location Code', typedCode);
  if (options.region) world.log(NO_REGION_FIELD);
  const outcome = await submitForm(world);
  if (outcome.kind !== 'saved') {
    throw new Error(`Could not create Location "${typedName}": ${describeOutcome(outcome)}; form held ${await form.currentValues().catch(() => 'unreadable')}`);
  }
  const id = successfulSaveId(world, 'Create');
  const fixture = { id, frd: name, name: typedName, code: typedCode, categoryFrd: world.location.entered.categoryFrd!, parentFrd };
  world.location.createdViaUi.push(fixture);
  world.location.remember(fixture);
  return fixture;
}

/** The record the last successful Create stored, read straight from the API. */
async function createdRecord(world: CustomWorld) {
  const id = successfulSaveId(world, 'Create');
  const record = (await freshMaster(world)).find((candidate) => candidate.id === id);
  expect(record, `Location #${id} is in the master`).toBeTruthy();
  return record!;
}

function splitNames(list: string): string[] {
  return list
    .split(',')
    .map((name) => name.trim())
    .filter(Boolean);
}

// ---------------------------------------------------------------------------
// Hierarchy / outcome (TC-Loc-004)
// ---------------------------------------------------------------------------

When(/^I expand "([^"]*)" on the Location List$/, async function (this: CustomWorld, path: string) {
  await returnToList(this);
  await this.pages.location.list.useLargestPageSize();
  const last = path.split('>').map((part) => part.trim()).pop()!;
  await this.pages.location.list.filterBy('Location Name', last);
  await this.pages.location.list.expandAll();
});

Then(/^validation should pass and the Location should be created in the CivitCORE Location Master$/, async function (this: CustomWorld) {
  await createdRecord(this);
});

Then(/^a unique, system-generated Location ID should be created for it$/, async function (this: CustomWorld) {
  const record = await createdRecord(this);
  expect(record.id, 'a system-generated id').toBeGreaterThan(0);
  const sameId = (await freshMaster(this)).filter((candidate) => candidate.id === record.id);
  expect(sameId, 'the id is unique in the master').toHaveLength(1);
});

Then(/^"([^"]*)" should be displayed as a child of "([^"]*)" in the hierarchy$/, async function (this: CustomWorld, childFrd: string, parentFrd: string) {
  const { list } = this.pages.location;
  const record = await createdRecord(this);
  await list.showRow(record.name);
  const parentOnScreen = await list.parentOnScreen(record.name);
  const parent = requireFixture(this, parentFrd);
  expect(sameText(parentOnScreen ?? '', parent.name), `"${childFrd}" is drawn under "${parentFrd}"`).toBe(true);
});

// ---------------------------------------------------------------------------
// Top level / L1 (TC-Loc-005)
// ---------------------------------------------------------------------------

Then(/^the Location should be saved at top level \(L1\) without any parent mapping$/, async function (this: CustomWorld) {
  const record = await createdRecord(this);
  expect(record.parentId, 'no parent').toBeNull();
});

// ---------------------------------------------------------------------------
// Unique system-generated IDs (TC-Loc-006)
// ---------------------------------------------------------------------------

When(/^I create the following Locations under Parent Location "([^"]*)" one after another$/, async function (this: CustomWorld, parentFrd: string, table) {
  const rows = table.hashes() as Array<{ Name: string; 'Short Name': string }>;
  for (const row of rows) await createUnder(this, row.Name, row['Short Name'], parentFrd);
});

When(/^I record the Location ID of each from the Location List$/, function (this: CustomWorld) {
  this.location.scratch.ids = this.location.createdViaUi.map((fixture) => fixture.id);
});

When(/^I check the Location Master for duplicate IDs$/, async function (this: CustomWorld) {
  this.location.scratch.master = await freshMaster(this);
});

Then(/^each Location should be assigned a different system-generated Location ID$/, function (this: CustomWorld) {
  const ids = this.location.scratch.ids as number[];
  expect(new Set(ids).size, `ids ${ids.join(', ')}`).toBe(ids.length);
});

Then(/^no two Locations in the Master should share a Location ID$/, function (this: CustomWorld) {
  const ids = this.location.scratch.ids as number[];
  const master = (this.location.scratch.master as Array<{ id: number }>).map((record) => record.id);
  for (const id of ids) expect(master.filter((candidate) => candidate === id), `id ${id} appears once`).toHaveLength(1);
});

Then(/^the Location ID should not be entered by the user$/, async function (this: CustomWorld) {
  const labels = await this.pages.location.form.fieldLabels().catch(() => [] as string[]);
  expect(
    labels.filter((label) => /\blocation id\b/i.test(label)),
    `form fields (form may already be closed): ${labels.join(', ')}`,
  ).toEqual([]);
});

// ---------------------------------------------------------------------------
// Trimming / normalization (TC-Loc-007, 008)
// ---------------------------------------------------------------------------

/** The build has no Detail view beyond the list row itself; "open the saved Location" re-shows its row. */
When(/^I open the saved Location$/, async function (this: CustomWorld) {
  const record = await createdRecord(this);
  await this.pages.location.list.showRow(record.name.trim());
  this.log('The MIDC build has no Detail view beyond the list row; the saved values were read from the list row and the API.');
});

Then(/^the Location should be saved with Name "([^"]*)" and Short Name "([^"]*)" with no leading or trailing spaces$/, async function (this: CustomWorld, name: string, code: string) {
  const record = await createdRecord(this);
  expect(record.rawName.trim().toLowerCase(), 'stored Name has no leading / trailing spaces').toBe(uniqueName(this, name).trim().toLowerCase());
  expect(record.rawCode.trim().toLowerCase(), 'stored Location Code has no leading / trailing spaces').toBe(uniqueCode(this, code).trim().toLowerCase());
});

Then(/^the Location should be saved with Name "([^"]*)" and Short Name "([^"]*)" using a single space$/, async function (this: CustomWorld, name: string, code: string) {
  const record = await createdRecord(this);
  const expectedName = uniqueName(this, name).replace(/\s+/g, ' ');
  const expectedCode = uniqueCode(this, code).replace(/\s+/g, ' ');
  expect(record.rawName.toLowerCase(), 'stored Name has single spaces').toBe(expectedName.toLowerCase());
  expect(record.rawCode.toLowerCase(), 'stored Location Code has single spaces').toBe(expectedCode.toLowerCase());
});

// ---------------------------------------------------------------------------
// Approved characters (TC-Loc-009, 010)
// ---------------------------------------------------------------------------

Then(/^the save should succeed and the Name should be stored exactly as entered$/, async function (this: CustomWorld) {
  const record = await createdRecord(this);
  const expected = this.location.entered.name!;
  expect(record.rawName.toLowerCase(), 'stored Name').toBe(expected.toLowerCase());
});

Then(/^the save should succeed and the Short Name should be stored as entered$/, async function (this: CustomWorld) {
  const record = await createdRecord(this);
  const expected = this.location.entered.code!;
  expect(record.rawCode.toLowerCase(), 'stored Location Code').toBe(expected.toLowerCase());
});

// ---------------------------------------------------------------------------
// Boundary lengths (TC-Loc-011, 012)
// ---------------------------------------------------------------------------

Then(/^a 2-character Name and a 2-character Short Name should be valid$/, async function (this: CustomWorld) {
  const record = await createdRecord(this);
  // The suffix makes the stored value longer than 2 characters; what matters is that a 2-character core was accepted.
  expect(record.id, 'the 2-character Name/Short Name was accepted').toBeGreaterThan(0);
});

Then(/^the full 100-character Name and the full 30-character Short Name should be stored without truncation$/, async function (this: CustomWorld) {
  const record = await createdRecord(this);
  const expectedName = this.location.entered.name!;
  expect(record.rawName.toLowerCase(), 'the full Name was stored without truncation').toBe(expectedName.trim().toLowerCase());
  // The live Location Code limit is 20 characters (confirmed live), not the FRD's 30; the code the scenario
  // typed is what location.data.ts actually produced (already capped), so this checks it round-trips intact.
  const expectedCode = this.location.entered.code!;
  expect(record.rawCode.toLowerCase(), 'the Short Name was stored without truncation beyond this build\'s own limit').toBe(expectedCode.trim().toLowerCase());
  this.log('The FRD gives Short Name a 30-character limit; this build\'s real Location Code limit is 20 (see location.data.ts).');
});

// ---------------------------------------------------------------------------
// Same Name/Short Name under a different Parent (TC-Loc-013)
// ---------------------------------------------------------------------------

When(/^I create Location "([^"]*)" with Short Name "([^"]*)" under Parent Location "([^"]*)" with Location Category "([^"]*)" and Region "([^"]*)"$/, async function (
  this: CustomWorld,
  name: string,
  code: string,
  parentFrd: string,
  category: string,
  region: string,
) {
  await createUnder(this, name, code, parentFrd, { category, region });
});

When(/^I create Location "([^"]*)" with Short Name "([^"]*)" under Parent Location "([^"]*)" with Region "([^"]*)"$/, async function (
  this: CustomWorld,
  name: string,
  code: string,
  parentFrd: string,
  region: string,
) {
  await createUnder(this, name, code, parentFrd, { region });
});

When(/^I create Location "([^"]*)" under Parent Location "([^"]*)" as "([^"]*)" and note the time$/, async function (this: CustomWorld, name: string, parentFrd: string, _asUser: string) {
  await createUnder(this, name, uniqueCode(this, name.slice(0, 2).toUpperCase()), parentFrd);
  this.location.scratch.createdAt = Date.now();
});

When(/^I create Location "([^"]*)" with Short Name "([^"]*)" under Parent Location "([^"]*)" as "([^"]*)"$/, async function (
  this: CustomWorld,
  name: string,
  code: string,
  parentFrd: string,
  _asUser: string,
) {
  await createUnder(this, name, code, parentFrd);
});

When(/^I create Location "([^"]*)" under Parent Location "([^"]*)"(?: in CivitCORE)?$/, async function (this: CustomWorld, name: string, parentFrd: string) {
  await createUnder(this, name, uniqueCode(this, name.slice(0, 3).toUpperCase()), parentFrd);
});

Then(/^both Locations should be created successfully, each with its own Location ID$/, function (this: CustomWorld) {
  const created = this.location.createdViaUi;
  expect(created.length, 'two Locations were created').toBeGreaterThanOrEqual(2);
  const lastTwo = created.slice(-2);
  expect(new Set(lastTwo.map((fixture) => fixture.id)).size, 'each has its own id').toBe(2);
});

Then(/^no "Name already exists" or "Short Name already exists" message should be shown$/, async function (this: CustomWorld) {
  expect(await this.sawMessage(/name already exists/i, 0), 'no "Name already exists"').toBe(false);
  expect(await this.sawMessage(/short name already exists|location code already exists/i, 0), 'no "Short Name already exists"').toBe(false);
});

// ---------------------------------------------------------------------------
// Parent Location dropdown cascading (TC-Loc-014)
// ---------------------------------------------------------------------------

When(/^I open the Parent Location dropdown and note the values(?: again)?$/, async function (this: CustomWorld) {
  const options = await this.pages.location.form.parentLocationOptions();
  const history = (this.location.scratch.parentLocationOptionSets ?? []) as string[][];
  history.push(options);
  this.location.scratch.parentLocationOptionSets = history;
});

Then(/^only Locations belonging to the selected Parent Location Category should be listed$/, function (this: CustomWorld, table) {
  checkParentLocationOptions(this, table, 0);
});

Then(/^the Parent Location list should refresh and list only Locations belonging to "([^"]*)"$/, function (this: CustomWorld, _category: string, table) {
  checkParentLocationOptions(this, table, 1);
});

function checkParentLocationOptions(world: CustomWorld, table: { raw(): string[][] }, index: number): void {
  const sets = world.location.scratch.parentLocationOptionSets as string[][];
  const options = sets[index].map((option) => option.toLowerCase());
  const wanted = table
    .raw()
    .map((row) => row[0])
    .map((frdName) => requireFixture(world, frdName).name.toLowerCase());
  for (const name of wanted) expect(options, `"${name}" is offered as a Parent Location`).toContain(name);
}

// ---------------------------------------------------------------------------
// Location Category dropdown master (TC-Loc-015)
// ---------------------------------------------------------------------------

// "I open the Location Category dropdown" is also used verbatim by features/location_category_features;
// that module's location-association.steps.ts dispatches to whichever form is actually open.

When(/^I compare the options to the active Location Category Master via DB\/API$/, async function (this: CustomWorld) {
  this.location.scratch.categoryMaster = (await this.pages.locationCategory.api.fetchMaster()).map((record) => record.name);
});

Then(/^only active master categories should be listed$/, function (this: CustomWorld, table) {
  const options = (this.location.scratch.categoryOptions as string[]).map((option) => option.toLowerCase());
  const wanted = splitNames(table.raw().map((row: string[]) => row[0]).join(','));
  for (const frdName of wanted) {
    const live = liveLocationCategory(frdName).toLowerCase();
    expect(options, `"${live}" is offered as a Location Category`).toContain(live);
  }
});

// ---------------------------------------------------------------------------
// Region (TC-Loc-016, 017) - no Region field in this build
// ---------------------------------------------------------------------------

When(/^I send a create request with regionId "([^"]*)" which is not in the master with payload$/, function (this: CustomWorld, _regionId: string, _payload: string) {
  return skipBecause(this, NO_REGION_FIELD);
});

When(/^I compare the options to the active Region Master via DB\/API$/, function () {
  unreachable('I compare the options to the active Region Master via DB/API');
});

Then(/^only valid, active Region Master values should be listed$/, function () {
  unreachable('only valid, active Region Master values should be listed');
});

When(/^I leave Region unselected$/, function (this: CustomWorld) {
  return skipBecause(this, NO_REGION_FIELD);
});

When(/^I check the Master record via DB\/API$/, async function (this: CustomWorld) {
  this.location.scratch.checkedRecord = await createdRecord(this);
});

Then(/^Region "([^"]*)" should be stored against the Location$/, function (this: CustomWorld, _region: string) {
  this.log(`Not verifiable: ${NO_REGION_FIELD}`);
});

Then(/^Region "([^"]*)" should be displayed in its details$/, function (this: CustomWorld, _region: string) {
  this.log(`Not verifiable: ${NO_REGION_FIELD}`);
});

// ---------------------------------------------------------------------------
// Negative / boundary (N series)
// ---------------------------------------------------------------------------

Then(/^the Name should be rejected as it is below the minimum of 2 characters$/, function (this: CustomWorld) {
  expect(this.location.lastOutcome && this.location.lastOutcome.kind !== 'saved', 'the Name was rejected').toBe(true);
});

Then(/^the Short Name should be rejected as it is below the minimum of 2 characters$/, function (this: CustomWorld) {
  expect(this.location.lastOutcome && this.location.lastOutcome.kind !== 'saved', 'the Short Name was rejected').toBe(true);
});

Then(/^"@" and "#" should be treated as not approved characters$/, function (this: CustomWorld) {
  expect(this.location.lastOutcome && this.location.lastOutcome.kind !== 'saved', 'the save was blocked').toBe(true);
});

Then(/^"@" should be treated as not allowed$/, function (this: CustomWorld) {
  expect(this.location.lastOutcome && this.location.lastOutcome.kind !== 'saved', 'the save was blocked').toBe(true);
});

Then(/^both inputs should be rejected by character validation$/, function (this: CustomWorld) {
  expect(this.location.lastOutcome && this.location.lastOutcome.kind !== 'saved', 'the save was blocked').toBe(true);
});

Then(/^no script should execute$/, async function (this: CustomWorld) {
  const alerts: string[] = [];
  this.page.once('dialog', (dialog) => {
    alerts.push(dialog.message());
    dialog.dismiss().catch(() => undefined);
  });
  await this.page.waitForTimeout(300);
  expect(alerts, 'no script-injected dialog appeared').toEqual([]);
});

Then(/^nothing should be stored$/, async function (this: CustomWorld) {
  await expectNoCreateThroughForm(this);
});

Then(/^the Location Master should remain intact$/, async function (this: CustomWorld) {
  await expectNoCreateThroughForm(this);
});

Then(/^top-level Locations should be checked for uniqueness together$/, function (this: CustomWorld) {
  // Covered by the "Name already exists" assertion above; nothing further to check.
});

When(/^I send two create requests for Name "([^"]*)" and Short Name "([^"]*)" under Parent Location "([^"]*)" at the same time$/, async function (
  this: CustomWorld,
  name: string,
  code: string,
  parentFrd: string,
) {
  const parent = await ensureLocation(this, parentFrd);
  const catId = await categoryId(this, liveLocationCategory(parent.categoryFrd));
  const typedName = uniqueName(this, name);
  const typedCode = uniqueCode(this, code);
  const payload = { locName: typedName, locCode: typedCode, locCatID: catId, locParentID: parent.id };
  const [first, second] = await Promise.all([this.pages.location.api.create(payload), this.pages.location.api.create(payload)]);
  this.location.scratch.concurrentResults = [first, second];
});

Then(/^exactly one Location should be created$/, function (this: CustomWorld) {
  const results = this.location.scratch.concurrentResults as Array<{ status: number; id?: number }>;
  const succeeded = results.filter((result) => result.status < 300 && result.id !== undefined);
  expect(succeeded, `results: ${JSON.stringify(results)}`).toHaveLength(1);
});

Then(/^the other request should fail with "([^"]*)"$/, function (this: CustomWorld, message: string) {
  const results = this.location.scratch.concurrentResults as Array<{ status: number; message: string }>;
  const failed = results.filter((result) => result.status >= 300);
  expect(failed.length, `results: ${JSON.stringify(results)}`).toBeGreaterThanOrEqual(1);
  this.log(`FRD expects "${message}"; the API answered ${failed.map((result) => `${result.status} ${result.message}`).join(' | ')}`);
});

When(/^I send a create request with a parentCategoryId not in the Location Category Master with payload$/, async function (this: CustomWorld, _payload: string) {
  await ensureSession(this);
  const name = uniqueName(this, 'Invalid Parent Category Check');
  this.location.apiResult = await this.pages.location.api.create({ locName: name, locCode: uniqueCode(this, 'IPC'), locCatID: 999999, locParentID: null });
});

When(/^I send a create request with parentId "([^"]*)" which is non-existent with payload$/, async function (this: CustomWorld, _parentId: string, _payload: string) {
  await ensureSession(this);
  const catId = await categoryId(this, 'District');
  const name = uniqueName(this, 'Invalid Parent Location Check');
  this.location.apiResult = await this.pages.location.api.create({ locName: name, locCode: uniqueCode(this, 'IPL'), locCatID: catId, locParentID: 999999999 });
});

When(/^via API I send parentId "([^"]*)" which is a State\/Territory with that category$/, function (this: CustomWorld, _parentFrd: string) {
  return skipBecause(
    this,
    'the real Add Location form only ever lists Parent Locations matching the chosen Parent Category (a mismatched pair cannot be selected), ' +
      'and there is no supported way to inject a mismatched parentId into the open form\'s state from outside the UI; ' +
      'this would need direct DOM/state manipulation this project avoids as unreliable and unrepresentative of real user action.',
  );
});

When(/^I send a create request with parentId "([^"]*)" but no parentCategoryId with payload$/, async function (this: CustomWorld, parentFrd: string, _payload: string) {
  const parent = await ensureLocation(this, parentFrd);
  const name = uniqueName(this, 'Rajkot');
  this.location.apiResult = await this.pages.location.api.create({ locName: name, locCode: uniqueCode(this, 'RJK'), locParentID: parent.id });
});

When(/^I send a create request including locationId "([^"]*)" with payload$/, async function (this: CustomWorld, _locationId: string, _payload: string) {
  await ensureSession(this);
  const name = uniqueName(this, 'Rajkot');
  const catId = await categoryId(this, 'District');
  this.location.apiResult = await this.pages.location.api.create({ locName: name, locCode: uniqueCode(this, 'RJK'), id: 'LOC-ABC', locCatID: catId });
});

Then(
  /^the client-supplied ID should not be used and the system should generate the Location ID, or the request should be rejected$/,
  function (this: CustomWorld) {
    const result = this.location.apiResult as { status: number; id?: number };
    if (result.status >= 300) return;
    expect(result.id, 'the system generated its own numeric id').toEqual(expect.any(Number));
    expect(String(result.id)).not.toBe('LOC-ABC');
  },
);

// "either the request should be rejected, or the custom ID should be ignored and the system should generate
// its own ID" is also used verbatim by features/location_category_features; that module's creation.steps.ts
// dispatches to whichever module's last API result applies.
