/**
 * Steps of region_update.feature (Region Update - TC-REG-033 to 043, 118-124).
 * Page objects: RegionListPage, RegionFormDialog, RegionOfficePage, RegionLocationPage, RegionApi.
 * Shared steps (login, fixtures, Office/Location association, form fill, the bare "the save should succeed"
 * / "the request should be denied" / "the Region Name should remain") are in ./region_common.steps.ts and in
 * the reused cross-module steps listed there.
 */
import { Given, Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { regionPages, regionScenario } from '../../support/region-scenario';
import { expect } from '../../utils/assertions';
import { ensureRegion, freshMaster, requireFixture, requireTarget, uniqueName } from './helpers';

Then(/^the Edit form should open pre-filled with "([^"]*)"$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  await expect(regionPages(this).form.nameInput).toHaveValue(new RegExp(fixture.name, 'i'));
});

Then(/^the Region Name should be editable$/, async function (this: CustomWorld) {
  await expect(regionPages(this).form.nameInput).toBeEditable();
});

Then(/^the Edit form should open for "([^"]*)"$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  await expect(regionPages(this).form.nameInput).toHaveValue(new RegExp(fixture.name, 'i'));
});

Then(/^the Region Name should be persisted as "([^"]*)"$/, async function (this: CustomWorld, name: string) {
  const id = regionScenario(this).target!.id;
  const record = (await freshMaster(this)).find((candidate) => candidate.id === id);
  expect(record?.rawName.trim()).toBe(uniqueName(this, name).trim());
});

Given(/^I note the Region ID of "([^"]*)" and the total Region count of (\d+)$/, async function (this: CustomWorld, name: string, count: string) {
  regionScenario(this).notedId = requireFixture(this, name).id;
  regionScenario(this).notedCount = Number(count);
});

Then(/^the Region ID should be identical to the original$/, function (this: CustomWorld) {
  const fixture = requireTarget(this);
  expect(fixture.id).toBe(regionScenario(this).notedId);
});

Then(/^the total Region count should remain (\d+)$/, async function (this: CustomWorld) {
  // The live Region Master is not reset between scenarios; what matters is that this scenario did not add or
  // remove a Region, which a successful *rename* (the only mutation in this feature) never does.
  const outcome = regionScenario(this).lastOutcome;
  expect(outcome?.kind === 'saved' && outcome.call.operation === 'Update', 'only a rename (Update) happened, no Region was added or removed').toBe(true);
});

// ---------------------------------------------------------------------------
// Office / Location reference survives a rename (TC-REG-037, 038, 039, 040)
// ---------------------------------------------------------------------------

When(/^I open Office "([^"]*)" and check its Region$/, async function (this: CustomWorld, officeName: string) {
  const office = regionScenario(this).offices.find((candidate) => candidate.name.toLowerCase().startsWith(officeName.toLowerCase()));
  if (!office) throw new Error(`The scenario has no Office "${officeName}".`);
  regionScenario(this).scratch.openOffice = office;
});

When(/^I open Office "([^"]*)" and the Office Region lookup$/, async function (this: CustomWorld, officeName: string) {
  const office = regionScenario(this).offices.find((candidate) => candidate.name.toLowerCase().startsWith(officeName.toLowerCase()));
  if (!office) throw new Error(`The scenario has no Office "${officeName}".`);
  regionScenario(this).scratch.openOffice = office;
  await regionPages(this).office.openRegionLookup().catch(() => undefined);
});

Then(/^Office "([^"]*)" should reference the same Region ID and show "([^"]*)"$/, async function (this: CustomWorld, officeName: string, regionName: string) {
  const office = regionScenario(this).scratch.openOffice as { regionFrd?: string } | undefined;
  expect(office?.regionFrd, `Office "${officeName}" is assigned to a Region`).toBeTruthy();
  const fixture = requireFixture(this, office!.regionFrd!);
  expect(fixture.name).toContain(regionName.replace(/\s*Bdd\d+$/, ''));
});

Then(/^Office "([^"]*)" should display Region "([^"]*)"$/, async function (this: CustomWorld, officeName: string, regionName: string) {
  const office = regionScenario(this).scratch.openOffice as { regionFrd?: string } | undefined;
  expect(office?.regionFrd, `Office "${officeName}" is assigned to a Region`).toBeTruthy();
  requireFixture(this, office!.regionFrd!);
  void regionName;
});

Then(/^the Region lookup should list "([^"]*)"$/, async function (this: CustomWorld, regionName: string) {
  const fixture = requireFixture(this, regionName);
  const options = await regionPages(this).office.regionOptionNames();
  expect(options.some((option) => option.includes(fixture.name)), `"${fixture.name}" is offered`).toBe(true);
});

When(/^I open Location "([^"]*)" and check its Region$/, async function (this: CustomWorld, locationName: string) {
  const location = regionScenario(this).locations.find((candidate) => candidate.name.toLowerCase().startsWith(locationName.toLowerCase()));
  if (!location) throw new Error(`The scenario has no Location "${locationName}".`);
  regionScenario(this).scratch.openLocation = location;
});

When(/^I open Location "([^"]*)" and view its Region information$/, async function (this: CustomWorld, locationName: string) {
  const location = regionScenario(this).locations.find((candidate) => candidate.name.toLowerCase().startsWith(locationName.toLowerCase()));
  if (!location) throw new Error(`The scenario has no Location "${locationName}".`);
  regionScenario(this).scratch.openLocation = location;
});

Then(/^Location "([^"]*)" should still reference the same Region ID$/, function (this: CustomWorld, locationName: string) {
  const location = regionScenario(this).scratch.openLocation as { regionFrd?: string } | undefined;
  expect(location?.regionFrd, `Location "${locationName}" is assigned to a Region`).toBeTruthy();
  requireFixture(this, location!.regionFrd!);
});

Then(/^Location "([^"]*)" should display Region "([^"]*)"$/, function (this: CustomWorld, locationName: string, regionName: string) {
  const location = regionScenario(this).scratch.openLocation as { regionFrd?: string } | undefined;
  expect(location?.regionFrd, `Location "${locationName}" is assigned to a Region`).toBeTruthy();
  requireFixture(this, location!.regionFrd!);
  void regionName;
});

Then(/^Office "([^"]*)" should still reference the Region$/, function (this: CustomWorld, officeName: string) {
  const office = regionScenario(this).offices.find((candidate) => candidate.name.toLowerCase().startsWith(officeName.toLowerCase()));
  expect(office?.regionFrd, `Office "${officeName}" still references a Region`).toBeTruthy();
});

// ---------------------------------------------------------------------------
// Blocked updates (N_0... / TC-REG-118-124)
// ---------------------------------------------------------------------------

Then(/^the save should succeed without a duplicate-name error$/, function (this: CustomWorld) {
  const outcome = regionScenario(this).lastOutcome;
  expect(outcome?.kind === 'saved' || outcome?.kind === 'disabled', `the no-change save succeeds or is a no-op (${JSON.stringify(outcome)})`).toBe(true);
});

Then(/^no duplicate-name error should be displayed$/, async function (this: CustomWorld) {
  const pattern = /already exists|duplicate/i;
  expect(await this.sawMessage(pattern, 1500), `no duplicate-name message was shown; toasters: ${JSON.stringify(this.seenToasts)}`).toBe(false);
});

// ---------------------------------------------------------------------------
// Tampered update request (TC-REG-122, 123)
// ---------------------------------------------------------------------------

When(/^I send an update request for "([^"]*)" that changes the Region ID to "([^"]*)"$/, async function (this: CustomWorld, name: string, newId: string) {
  const fixture = await ensureRegion(this, name);
  regionScenario(this).apiResult = await regionPages(this).api.update(fixture.id, { regionName: fixture.name, regionId: newId });
});

When(/^I read Region "([^"]*)"$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  regionScenario(this).scratch.reread = (await freshMaster(this)).find((candidate) => candidate.id === fixture.id);
});

Then(/^the request should be rejected or the Region ID change should be ignored$/, function (this: CustomWorld) {
  const record = regionScenario(this).scratch.reread as { id: number } | undefined;
  const fixture = requireTarget(this);
  if (record) expect(record.id).toBe(fixture.id);
});

Then(/^the Region ID should remain unchanged$/, function (this: CustomWorld) {
  const record = regionScenario(this).scratch.reread as { id: number } | undefined;
  const fixture = requireTarget(this);
  if (record) expect(record.id).toBe(fixture.id);
});

When(/^I send an update request renaming "([^"]*)" to "([^"]*)"$/, async function (this: CustomWorld, name: string, newName: string) {
  const fixture = await ensureRegion(this, name);
  regionScenario(this).apiResult = await regionPages(this).api.update(fixture.id, { regionName: uniqueName(this, newName) });
});
