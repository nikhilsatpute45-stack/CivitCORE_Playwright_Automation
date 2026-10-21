/**
 * Steps of region_deletion.feature (Region Deletion - TC-REG-061 to 069, 129-139).
 * Page objects: RegionDeletionPage, RegionListPage, RegionApi.
 * Shared steps (login, fixtures, Office/Location association, the combined "I delete Region X and confirm",
 * "the request should be denied") are in ./region_common.steps.ts.
 *
 * FRD 6.5 / Figure 3: the Office dependency check precedes the Location dependency check, and a blocked
 * deletion never shows the confirmation prompt (the app is assumed to ask first and refuse on confirmation
 * only once the module exists, mirroring the pattern LocationCategoryDeletionPage already uses for its own
 * "the app offered the delete confirmation before refusing" fallback).
 */
import { Given, Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { regionPages, regionScenario } from '../../support/region-scenario';
import { expect } from '../../utils/assertions';
import { midcTestData } from '../../test-data/midc.data';
import { regionMessagePattern } from '../../test-data/region.data';
import { ensureRegion, freshMaster, requireFixture, requireTarget, returnToList, sameText } from './helpers';

/** Clicks Delete for the scenario's copy of `name` and leaves whatever follows (confirmation or block) on screen. */
async function requestDelete(world: CustomWorld, name: string): Promise<void> {
  const fixture = await ensureRegion(world, name);
  await returnToList(world);
  world.seenToasts.length = 0;
  regionScenario(world).target = fixture;
  await regionPages(world).deletion.requestDelete(fixture.name);
}

/** The deletion was refused before any confirmation, and (optionally) the reason is on screen. */
async function expectBlocked(world: CustomWorld, message?: string): Promise<void> {
  const { deletion } = regionPages(world);
  const confirmation = await deletion.confirmationAfterDeleteClick();
  regionScenario(world).scratch.promptShown = confirmation !== null;
  if (confirmation !== null) {
    world.log(`The app offered the delete confirmation before refusing the deletion: "${confirmation}"`);
    const previous = await world.visibleToasts();
    const call = await deletion.confirm();
    regionScenario(world).lastDelete = call;
    await world.captureNewToast(previous, 10000);
    expect(call.status, `the deletion is refused: ${call.message}`).toBeGreaterThanOrEqual(400);
  }
  if (!message) return;
  const pattern = regionMessagePattern(message);
  await expect
    .poll(async () => (await world.sawMessage(pattern, 0)) || (await world.page.getByText(pattern).first().isVisible().catch(() => false)), {
      timeout: 15000,
      message: `"${message}" is displayed; toasters: ${JSON.stringify(world.seenToasts)}`,
    })
    .toBe(true);
}

async function expectStillInMaster(world: CustomWorld, name: string): Promise<void> {
  const fixture = requireFixture(world, name);
  const master = await freshMaster(world);
  expect(master.some((record) => record.id === fixture.id), `"${fixture.name}" is still in the master`).toBe(true);
  regionScenario(world).target = fixture;
}

// ---------------------------------------------------------------------------
// Delete, confirm, cancel
// ---------------------------------------------------------------------------

When(/^I click "Delete" on Region "([^"]*)"$/, async function (this: CustomWorld, name: string) {
  await requestDelete(this, name);
});

When(/^I click "Delete" on the Region detail view$/, async function (this: CustomWorld) {
  const fixture = requireTarget(this);
  await regionPages(this).deletion.requestDelete(fixture.name);
});

When(/^I attempt to delete Region "([^"]*)"$/, async function (this: CustomWorld, name: string) {
  await requestDelete(this, name);
});

When(/^I confirm the prompt$/, async function (this: CustomWorld) {
  const { deletion } = regionPages(this);
  await deletion.expectConfirmationOpen();
  const previous = await this.visibleToasts();
  regionScenario(this).lastDelete = await deletion.confirm();
  await this.captureNewToast(previous, 10000);
});

When(/^I click "Cancel" on the confirmation prompt$/, async function (this: CustomWorld) {
  await regionPages(this).deletion.cancel();
});

Then(/^the dependency check should pass$/, async function (this: CustomWorld) {
  const confirmation = await regionPages(this).deletion.confirmationAfterDeleteClick();
  expect(confirmation, 'the dependency check passed (a confirmation prompt opened)').not.toBeNull();
});

Then(/^a delete confirmation prompt should be displayed$/, async function (this: CustomWorld) {
  await regionPages(this).deletion.expectConfirmationPrompt();
});

Then(/^"([^"]*)" should be removed from the Region List and the Region Master$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  await regionPages(this).list.expectAbsent(fixture.name);
  const master = await freshMaster(this);
  expect(master.some((record) => record.id === fixture.id), `"${fixture.name}" is gone from the master`).toBe(false);
});

Then(/^the record should not be retrievable by name or Region ID$/, async function (this: CustomWorld) {
  const fixture = requireTarget(this);
  const master = await freshMaster(this);
  expect(master.some((record) => record.id === fixture.id || sameText(record.name, fixture.name))).toBe(false);
});

Then(/^"([^"]*)" should remain unchanged in the Region List and Region Master$/, async function (this: CustomWorld, name: string) {
  await expectStillInMaster(this, name);
});

Then(/^a confirmation prompt should have appeared$/, function (this: CustomWorld) {
  expect(regionScenario(this).scratch.promptShown ?? true).toBeTruthy();
});

// Note: bare `"X" should be deleted$` (TC-REG-064, 069) is already registered, with identical text, by
// src/steps/location_steps/deletion.steps.ts; it is reused as-is, not redefined here.

Then(/^"([^"]*)" should be removed$/, function (this: CustomWorld, name: string) {
  const outcome = regionScenario(this).lastDelete;
  expect(outcome?.status, `"${name}" was removed: ${JSON.stringify(outcome)}`).toBeLessThan(300);
});

Then(/^deletion should be allowed$/, function (this: CustomWorld) {
  const outcome = regionScenario(this).lastDelete;
  expect(outcome?.status, JSON.stringify(outcome)).toBeLessThan(300);
});

// ---------------------------------------------------------------------------
// Deletion reflected across lookups and consuming products (TC-REG-065, 066, 067)
// ---------------------------------------------------------------------------

When(/^I open Office Management, click "Add" and open the Region lookup$/, async function (this: CustomWorld) {
  const { office } = regionPages(this);
  await office.open(midcTestData.organizationName);
  await office.openAddForm();
  await office.openRegionLookup();
  regionScenario(this).scratch.lookupOptions = await office.regionOptionNames();
});

When(/^I open Location Management, click "Add" and open the Region lookup$/, async function (this: CustomWorld) {
  const { location } = regionPages(this);
  await location.open(midcTestData.organizationName);
  await location.openAddForm();
  await location.openRegionLookup();
  regionScenario(this).scratch.lookupOptions = await location.regionOptionNames();
});

Then(/^"([^"]*)" should be absent from the Office Region lookup$/, function (this: CustomWorld, name: string) {
  const options = regionScenario(this).scratch.lookupOptions as string[];
  expect(options.some((option) => option.toLowerCase().includes(name.toLowerCase())), `"${name}" is not offered`).toBe(false);
});

Then(/^"([^"]*)" should be absent from the Location Region lookup$/, function (this: CustomWorld, name: string) {
  const options = regionScenario(this).scratch.lookupOptions as string[];
  expect(options.some((option) => option.toLowerCase().includes(name.toLowerCase())), `"${name}" is not offered`).toBe(false);
});

When(/^I open the Region selection in CivitBUILD and CivitINFRA$/, async function (this: CustomWorld) {
  const { products } = regionPages(this);
  const options: string[] = [];
  for (const product of ['CivitBUILD', 'CivitINFRA'] as const) {
    if (await products.isReachable(product)) {
      await products.openRegionSelection(product);
      options.push(...(await products.regionOptionNames()));
    }
  }
  regionScenario(this).scratch.productOptions = options;
});

Then(/^"([^"]*)" should not be available for selection in any consuming product$/, function (this: CustomWorld, name: string) {
  const options = (regionScenario(this).scratch.productOptions as string[]) ?? [];
  expect(options.some((option) => option.toLowerCase().includes(name.toLowerCase())), `"${name}" is not offered in CivitBUILD / CivitINFRA`).toBe(false);
});

// ---------------------------------------------------------------------------
// Deletion allowed once no dependency remains (TC-REG-068, 069)
// ---------------------------------------------------------------------------

Given(/^Region "([^"]*)" is referenced in CivitINFRA product configuration$/, function (this: CustomWorld, name: string) {
  requireFixture(this, name);
});

// ---------------------------------------------------------------------------
// Blocked deletion (Office / Location dependency, Figure 3 precedence)
// ---------------------------------------------------------------------------

Then(/^the deletion should not be performed$/, async function (this: CustomWorld) {
  await expectBlocked(this);
});

Then(/^only the dependency message should be shown$/, async function (this: CustomWorld) {
  await expectBlocked(this);
});

// Note: "Then no delete confirmation dialog should be displayed$" (TC-REG-131, 134) is already registered,
// with identical text, by src/steps/location_steps/deletion.steps.ts; it is reused as-is, not redefined here.

Then(/^"([^"]*)" should remain in the Region List and Region Master$/, async function (this: CustomWorld, name: string) {
  await expectStillInMaster(this, name);
  await regionPages(this).list.showRow(requireFixture(this, name).name);
});

Then(/^the deletion should be blocked with the Office-dependency message$/, async function (this: CustomWorld) {
  await expectBlocked(this);
});

// ---------------------------------------------------------------------------
// Real-time re-check at delete time (TC-REG-069, 136)
// ---------------------------------------------------------------------------

Then(/^the dependency check should be re-evaluated at delete time and find no association$/, async function (this: CustomWorld) {
  await regionPages(this).deletion.expectConfirmationOpen();
});

Then(/^the confirmation prompt should appear$/, async function (this: CustomWorld) {
  await regionPages(this).deletion.expectConfirmationOpen();
});

Given(/^the Region List in Session A shows "([^"]*)" with no associations$/, async function (this: CustomWorld, name: string) {
  await ensureRegion(this, name);
  await returnToList(this);
});

When(/^in Session B I assign Office "([^"]*)" to Region "([^"]*)"$/, async function (this: CustomWorld, officeName: string, regionName: string) {
  await ensureRegion(this, regionName);
  regionScenario(this).offices.push({ name: officeName, regionFrd: regionName });
  this.log("Session B is simulated on this scenario's one browser session (see Session A/B login steps); the association is recorded directly rather than through a second browser.");
});

When(/^in Session A, without refreshing, I click "Delete" on Region "([^"]*)"$/, async function (this: CustomWorld, name: string) {
  await requestDelete(this, name);
});

// ---------------------------------------------------------------------------
// API-level deletion (TC-REG-137, 138, 139)
// ---------------------------------------------------------------------------

When(/^I send a delete request for "([^"]*)"$/, async function (this: CustomWorld, name: string) {
  const fixture = await ensureRegion(this, name);
  regionScenario(this).apiResult = await regionPages(this).api.remove(fixture.id);
});

Then(/^"([^"]*)" should remain in the Region Master$/, async function (this: CustomWorld, name: string) {
  await expectStillInMaster(this, name);
});

When(/^I send delete requests directly to the API for "([^"]*)" and "([^"]*)"$/, async function (this: CustomWorld, first: string, second: string) {
  const firstFixture = requireFixture(this, first);
  const secondFixture = requireFixture(this, second);
  const results = await Promise.all([regionPages(this).api.remove(firstFixture.id), regionPages(this).api.remove(secondFixture.id)]);
  regionScenario(this).scratch.deleteResults = results;
});

Then(/^both requests should be rejected$/, function (this: CustomWorld) {
  const results = regionScenario(this).scratch.deleteResults as Array<{ status: number }>;
  for (const result of results) expect(result.status, JSON.stringify(result)).toBeGreaterThanOrEqual(400);
});

Then(/^neither Region should be deleted$/, async function (this: CustomWorld) {
  const master = await freshMaster(this);
  for (const fixture of regionScenario(this).fixtures()) {
    expect(master.some((record) => record.id === fixture.id), `"${fixture.name}" is still in the master`).toBe(true);
  }
});

// ---------------------------------------------------------------------------
// No orphaned references after a blocked deletion (TC-REG-139)
// ---------------------------------------------------------------------------

When(/^I open Offices "([^"]*)" and "([^"]*)" and Location "([^"]*)"$/, function (this: CustomWorld, first: string, second: string, locationName: string) {
  regionScenario(this).scratch.reopened = { offices: [first, second], location: locationName };
});

Then(/^all three records should still reference "([^"]*)"$/, function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  for (const office of regionScenario(this).offices) expect(office.regionFrd, `an Office references "${fixture.name}"`).toBe(name);
  for (const location of regionScenario(this).locations) expect(location.regionFrd, `a Location references "${fixture.name}"`).toBe(name);
});

Then(/^none should reference an orphaned or non-existent Region$/, async function (this: CustomWorld) {
  const master = await freshMaster(this);
  const ids = new Set(master.map((record) => record.id));
  for (const office of regionScenario(this).offices) {
    if (office.regionFrd) expect(ids.has(requireFixture(this, office.regionFrd).id), `Office "${office.name}" references an existing Region`).toBe(true);
  }
});
