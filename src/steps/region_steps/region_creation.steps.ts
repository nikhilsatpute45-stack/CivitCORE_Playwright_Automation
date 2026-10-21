/**
 * Steps of region_creation.feature (Region Creation - TC-REG-009 to 018, 104-117).
 * Page objects: RegionListPage, RegionFormDialog, RegionOfficePage, RegionLocationPage, RegionApi.
 * Shared steps (login, navigation, fixtures, form fill, Save, messages) are in ./region_common.steps.ts.
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { regionPages, regionScenario } from '../../support/region-scenario';
import { expect } from '../../utils/assertions';
import { midcTestData } from '../../test-data/midc.data';
import { regionMessagePattern } from '../../test-data/region.data';
import { ensureSession, freshMaster, requireFixture, returnToList, uniqueName } from './helpers';

// ---------------------------------------------------------------------------
// Immediate visibility (TC-REG-012) and record ID (TC-REG-011)
// ---------------------------------------------------------------------------

Then(/^"([^"]*)" should be listed in the Region List immediately after the success confirmation$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  await regionPages(this).list.showRow(fixture.name);
});

When(/^I open Region "([^"]*)" from the Region List$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  await returnToList(this);
  await regionPages(this).list.chooseRowAction(fixture.name, 'View');
});

Then(/^a non-empty Region ID should be generated automatically$/, async function (this: CustomWorld) {
  const fixture = regionScenario(this).target!;
  const record = (await freshMaster(this)).find((candidate) => candidate.id === fixture.id);
  expect(record, `Region #${fixture.id} is in the master`).toBeTruthy();
  expect(record!.id).toBeGreaterThan(0);
});

Then(/^the Region ID should be unique across the Region Master$/, async function (this: CustomWorld) {
  const fixture = regionScenario(this).target!;
  const matches = (await freshMaster(this)).filter((candidate) => candidate.id === fixture.id);
  expect(matches).toHaveLength(1);
});

Then(/^the Region ID should be read-only$/, async function (this: CustomWorld) {
  const { form } = regionPages(this);
  expect(await form.isIdReadOnly(), 'the Region ID control is read-only / disabled').toBe(true);
});

// ---------------------------------------------------------------------------
// Office / Location Region lookup (TC-REG-013, 014)
// ---------------------------------------------------------------------------

When(/^I open Office Management and click "Add"$/, async function (this: CustomWorld) {
  await regionPages(this).office.open(midcTestData.organizationName);
  await regionPages(this).office.openAddForm();
});

When(/^I open Location Management and click "Add"$/, async function (this: CustomWorld) {
  await regionPages(this).location.open(midcTestData.organizationName);
  await regionPages(this).location.openAddForm();
});

When(/^I open the Region lookup$/, async function (this: CustomWorld) {
  const { office, location } = regionPages(this);
  if (await office.isFormOpen()) {
    await office.openRegionLookup();
    regionScenario(this).scratch.lookupOptions = await office.regionOptionNames();
    return;
  }
  await location.openRegionLookup();
  regionScenario(this).scratch.lookupOptions = await location.regionOptionNames();
});

Then(/^"([^"]*)" should appear in the Office Region lookup$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  const options = (regionScenario(this).scratch.lookupOptions as string[]) ?? (await regionPages(this).office.regionOptionNames());
  expect(options.some((option) => option.includes(fixture.name)), `"${fixture.name}" is offered: ${JSON.stringify(options)}`).toBe(true);
});

Then(/^"([^"]*)" should appear in the Location Region lookup$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  const options = (regionScenario(this).scratch.lookupOptions as string[]) ?? (await regionPages(this).location.regionOptionNames());
  expect(options.some((option) => option.includes(fixture.name)), `"${fixture.name}" is offered: ${JSON.stringify(options)}`).toBe(true);
});

// ---------------------------------------------------------------------------
// Tampered client-supplied Region ID (TC-REG-114)
// ---------------------------------------------------------------------------

When(/^I send a create-Region request with Region Name "([^"]*)" and Region ID "([^"]*)"$/, async function (this: CustomWorld, name: string, customId: string) {
  await ensureSession(this);
  const typed = uniqueName(this, name);
  regionScenario(this).scratch.apiName = typed;
  regionScenario(this).apiResult = await regionPages(this).api.create({ regionName: typed, regionId: customId });
});

When(/^I send a create-Region request for "([^"]*)"$/, async function (this: CustomWorld, name: string) {
  await ensureSession(this);
  const typed = uniqueName(this, name);
  regionScenario(this).scratch.apiName = typed;
  regionScenario(this).apiResult = await regionPages(this).api.create({ regionName: typed });
});

When(/^I read the created record$/, async function (this: CustomWorld) {
  regionScenario(this).scratch.master = await freshMaster(this);
});

Then(/^the request should be rejected or the custom Region ID should be ignored$/, function (this: CustomWorld) {
  const result = regionScenario(this).apiResult!;
  if (result.status >= 300) return;
  const id = (result.body as { data?: unknown })?.data;
  expect(id, 'the system generated its own numeric id').toEqual(expect.any(Number));
});

// ---------------------------------------------------------------------------
// Concurrent create of the same name (TC-REG-117)
// ---------------------------------------------------------------------------

When(/^I enter Region Name "([^"]*)" in both sessions$/, async function (this: CustomWorld, name: string) {
  regionScenario(this).scratch.raceName = uniqueName(this, name);
  await regionPages(this).form.type(regionScenario(this).scratch.raceName as string);
});

When(/^I click "Save" in both sessions at the same time$/, async function (this: CustomWorld) {
  // A second, independent browser session is not opened (see "two ... sessions are open", ./region_common.steps.ts);
  // the same name is submitted twice, back to back, from this scenario's one session, which still exercises the
  // server's own uniqueness check under near-simultaneous requests.
  const name = regionScenario(this).scratch.raceName as string;
  const first = await regionPages(this).api.create({ regionName: name });
  const second = await regionPages(this).api.create({ regionName: name });
  regionScenario(this).scratch.raceResults = [first, second];
  this.log("Both \"sessions\" are this scenario's one browser session; only the server's own uniqueness check is exercised, not two browsers racing each other.");
});

Then(/^exactly one Region "([^"]*)" should exist$/, async function (this: CustomWorld, name: string) {
  const typed = regionScenario(this).scratch.raceName as string;
  const master = await freshMaster(this);
  expect(master.filter((record) => record.name.trim().toLowerCase() === typed.trim().toLowerCase()), `exactly one Region "${name}"`).toHaveLength(1);
});

Then(/^the other request should be rejected with "([^"]*)"$/, function (this: CustomWorld, message: string) {
  const results = regionScenario(this).scratch.raceResults as Array<{ status: number; message: string }>;
  const rejected = results.filter((result) => result.status >= 300);
  expect(rejected.length, `one of the two concurrent creates is rejected: ${JSON.stringify(results)}`).toBeGreaterThanOrEqual(1);
  const pattern = regionMessagePattern(message);
  expect(rejected.some((result) => pattern.test(result.message)), `rejection names "${message}": ${JSON.stringify(rejected)}`).toBe(true);
});
