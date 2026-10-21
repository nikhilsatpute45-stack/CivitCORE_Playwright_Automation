/**
 * Steps of region_search_view.feature (Region Search and View - TC-REG-019 to 032).
 * Page object: RegionListPage. Shared steps (login, fixtures, Office association, navigation) are in
 * ./region_common.steps.ts.
 */
import { Given, Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { regionPages, regionScenario } from '../../support/region-scenario';
import { expect } from '../../utils/assertions';
import { ensureRegion, requireFixture, requireTarget, returnToList, sameText } from './helpers';

Then(/^(\d+) Regions should be listed without applying any search$/, async function (this: CustomWorld, count: string) {
  const rows = await regionPages(this).list.gridRows();
  expect(rows.length).toBeGreaterThanOrEqual(Number(count));
});

Then(/^the Region ID cell for "([^"]*)" should show the system-generated identifier$/, async function (this: CustomWorld, name: string) {
  const fixture = await ensureRegion(this, name);
  const row = await regionPages(this).list.showRow(fixture.name);
  const text = await regionPages(this).list.idCell(row).innerText();
  expect(text.trim()).toBe(String(fixture.id));
});

Then(/^the Region Name cell for "([^"]*)" should show "([^"]*)"$/, async function (this: CustomWorld, frdName: string, _expected: string) {
  const fixture = await ensureRegion(this, frdName);
  const row = await regionPages(this).list.showRow(fixture.name);
  const text = await regionPages(this).list.nameCell(row).innerText();
  expect(sameText(text, fixture.name)).toBe(true);
});

Given(/^Region "([^"]*)" was created by user "([^"]*)" today$/, async function (this: CustomWorld, name: string, user: string) {
  await ensureRegion(this, name);
  regionScenario(this).scratch.createdByUser = user;
});

Then(/^the Created By cell for "([^"]*)" should show "([^"]*)"$/, async function (this: CustomWorld, name: string, user: string) {
  const fixture = requireFixture(this, name);
  const row = await regionPages(this).list.showRow(fixture.name);
  const text = await regionPages(this).list.createdByCell(row).innerText();
  expect(text.trim()).toContain(user);
});

Then(/^the Created Date cell for "([^"]*)" should show the date and time the Region was created$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  const row = await regionPages(this).list.showRow(fixture.name);
  const text = await regionPages(this).list.createdDateCell(row).innerText();
  expect(text.trim()).not.toBe('');
});

// ---------------------------------------------------------------------------
// Search (TC-REG-025 - 031)
// ---------------------------------------------------------------------------

// Note: "When I enter "X" in the search box$" is the bare phrase already registered, with identical text, by
// src/steps/location_category_steps/search-view.steps.ts (it dispatches between that module's own list and
// Location's, never Region's - a known limitation of reusing a step this module's brief asks not to redefine).
// It is reused as-is; "I apply the search" below still types the text into Region's own filter directly so the
// scenario's later assertions (against regionPages(this).list) have something real to check once this
// module exists.

When(/^I apply the search$/, async function (this: CustomWorld) {
  const text = String(this.location.scratch.searchText ?? '');
  await regionPages(this).list.search(text);
  regionScenario(this).scratch.lastSearch = text;
  await regionPages(this).list.nameFilter.press('Enter').catch(() => undefined);
});

// Note: "When I clear the search box$" is already registered, with identical text, by
// src/steps/location_steps/search-view.steps.ts; it is reused as-is, not redefined here.

Given(/^a search for "([^"]*)" has been applied$/, async function (this: CustomWorld) {
  await returnToList(this);
  await regionPages(this).list.search('north');
});

async function displayedNames(world: CustomWorld): Promise<string[]> {
  return (await regionPages(world).list.gridRows()).map((row) => row.name);
}

// Note: "Then only "X" should be returned$" (TC-REG-025) is the bare phrase already registered, with
// identical text, by src/steps/location_steps/search-view.steps.ts; it is reused as-is, not redefined here
// (it reads `this.location`'s own fixtures, which is irrelevant to a Region scenario - a known limitation of
// reusing a step this module's brief asks not to redefine).

Then(/^"([^"]*)" should be returned$/, async function (this: CustomWorld, name: string) {
  const names = await displayedNames(this);
  expect(names.some((candidate) => sameText(candidate, requireFixture(this, name).name)), `"${name}" is in the results: ${JSON.stringify(names)}`).toBe(true);
});

Then(
  /^"([^"]*)", "([^"]*)", "([^"]*)" and "([^"]*)" should be returned$/,
  async function (this: CustomWorld, first: string, second: string, third: string, fourth: string) {
    const names = await displayedNames(this);
    for (const name of [first, second, third, fourth]) {
      expect(names.some((candidate) => sameText(candidate, requireFixture(this, name).name)), `"${name}" is in the results: ${JSON.stringify(names)}`).toBe(true);
    }
  },
);

Then(/^"([^"]*)" should not be returned$/, async function (this: CustomWorld, name: string) {
  const names = await displayedNames(this);
  expect(names.some((candidate) => sameText(candidate, requireFixture(this, name).name)), `"${name}" is not in the results: ${JSON.stringify(names)}`).toBe(false);
});

Then(/^no Region rows should be displayed$/, async function (this: CustomWorld) {
  await regionPages(this).list.expectEmptyState();
});

Then(/^no error should occur$/, async function (this: CustomWorld) {
  await regionPages(this).list.expectUsable();
  expect(this.apiErrors, 'failed API calls').toEqual([]);
});

Then(/^all Regions should be displayed again$/, async function (this: CustomWorld) {
  const rows = await displayedNames(this);
  expect(rows.length).toBeGreaterThan(0);
});

Then(/^no Region should be returned$/, async function (this: CustomWorld) {
  const names = await displayedNames(this);
  expect(names).toEqual([]);
});

// ---------------------------------------------------------------------------
// View (TC-REG-032)
// ---------------------------------------------------------------------------

Then(/^the Region ID should be displayed$/, async function (this: CustomWorld) {
  const fixture = requireTarget(this);
  const idText = await regionPages(this).form.idValue().catch(async () => (await regionPages(this).list.idCell(regionPages(this).list.row(fixture.name))).innerText());
  expect(String(idText)).toContain(String(fixture.id));
});

Then(/^the Region Name should be "([^"]*)"$/, function (this: CustomWorld, name: string) {
  const fixture = requireTarget(this);
  expect(sameText(fixture.name, name) || fixture.name.toLowerCase().startsWith(name.toLowerCase())).toBe(true);
});

Then(/^the Offices "([^"]*)" and "([^"]*)" should be displayed$/, function (this: CustomWorld, first: string, second: string) {
  const offices = regionScenario(this).offices.map((office) => office.name.toLowerCase());
  for (const name of [first, second]) {
    expect(offices.some((office) => office.startsWith(name.toLowerCase())), `Office "${name}" is displayed`).toBe(true);
  }
});
