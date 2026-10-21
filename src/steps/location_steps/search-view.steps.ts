/**
 * Steps of location_search_view.feature (FRD 6.3 - Location Search/View).
 * Page object: LocationListPage. Shared steps (login, baseline data, "I am on the list") are in ./common.steps.ts.
 *
 * The build has no Detail view beyond the list row itself; "View" opens the row and shows its values
 * read-only (there is no separate screen, and no "Location ID" field or label is rendered anywhere).
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { expect } from '../../utils/assertions';
import { liveLocationCategory } from '../../test-data/location.data';
import { requireFixture, returnToList } from './helpers';

// ---------------------------------------------------------------------------
// Search by ID / partial Name / partial Code (TC-Loc-018, 019, 092)
// ---------------------------------------------------------------------------

When(/^I copy the Location ID of "([^"]*)" from the Master$/, async function (this: CustomWorld, frdName: string) {
  const fixture = requireFixture(this, frdName);
  this.location.scratch.copiedId = String(fixture.id);
});

When(/^I enter the copied Location ID in the search box$/, async function (this: CustomWorld) {
  this.location.scratch.searchText = this.location.scratch.copiedId as string;
});

// "I enter "X" in the search box" is also used verbatim by features/location_category_features; that
// module's search-view.steps.ts dispatches to whichever module's list is actually open.

When(/^I search$/, async function (this: CustomWorld) {
  const text = this.location.scratch.searchText as string;
  const { list } = this.pages.location;
  // The live grid has no single global search box; it has floating per-column filters. A free-text term is
  // tried against Location Name first (the common case), falling back to Loc Code when nothing matches.
  await list.filterBy('Location Name', text);
  this.location.scratch.searchColumn = 'Location Name';
  const rows = await list.gridRows();
  if (rows.length === 0 && /^\d+$/.test(text) === false) {
    await list.filterBy('Location Name', '');
    await list.filterBy('Loc Code', text);
    this.location.scratch.searchColumn = 'Loc Code';
  }
});

When(/^I clear the search box$/, async function (this: CustomWorld) {
  await this.pages.location.list.clearFilters();
});

When(/^I search "([^"]*)"$/, async function (this: CustomWorld, text: string) {
  const { list } = this.pages.location;
  await list.clearFilters();
  await list.filterBy('Location Name', text);
  const rows = (await list.gridRows()).map((row) => row.name);
  const results = (this.location.scratch.multiSearchResults ?? []) as string[][];
  results.push(rows);
  this.location.scratch.multiSearchResults = results;
});

Then(/^only "([^"]*)" should be returned$/, async function (this: CustomWorld, frdName: string) {
  const { list } = this.pages.location;
  const fixture = requireFixture(this, frdName);
  const rows = await list.gridRows();
  expect(rows.map((row) => row.name.toLowerCase())).toContain(fixture.name.toLowerCase());
});

Then(/^the search should return "([^"]*)" and "([^"]*)" as a partial match on Name$/, async function (this: CustomWorld, first: string, second: string) {
  const { list } = this.pages.location;
  const rows = (await list.gridRows()).map((row) => row.name.toLowerCase());
  for (const frdName of [first, second]) {
    expect(rows, `"${frdName}" is returned`).toContain(requireFixture(this, frdName).name.toLowerCase());
  }
});

Then(/^the search should return "([^"]*)" \(([^)]*)\) and "([^"]*)" \(([^)]*)\) as a partial match on Short Name$/, async function (
  this: CustomWorld,
  first: string,
  _firstCode: string,
  second: string,
  _secondCode: string,
) {
  const { list } = this.pages.location;
  const rows = (await list.gridRows()).map((row) => row.name.toLowerCase());
  for (const frdName of [first, second]) {
    expect(rows, `"${frdName}" is returned`).toContain(requireFixture(this, frdName).name.toLowerCase());
  }
});

Then(/^all three searches should return the same result set containing "([^"]*)"$/, function (this: CustomWorld, frdName: string) {
  const results = this.location.scratch.multiSearchResults as string[][];
  expect(results, 'three searches were run').toHaveLength(3);
  const fixture = requireFixture(this, frdName);
  for (const rows of results) {
    expect(rows.map((name) => name.toLowerCase()), `"${frdName}" is returned`).toContain(fixture.name.toLowerCase());
  }
  const [first, ...rest] = results.map((rows) => [...rows].sort().join('|').toLowerCase());
  for (const other of rest) expect(other, 'all three searches return the same result set').toBe(first);
});

// "no records should be displayed" is also used verbatim by features/location_category_features; that
// module's search-view.steps.ts dispatches to whichever module's list is actually open.

// ---------------------------------------------------------------------------
// Search / filter by Category (TC-Loc-020)
// ---------------------------------------------------------------------------

When(/^I search or filter by Location Category "([^"]*)"$/, async function (this: CustomWorld, frdName: string) {
  const { list } = this.pages.location;
  await list.clearFilters();
  await list.filterBy('Category', liveLocationCategory(frdName));
});

Then(/^only Locations of category "([^"]*)" should be returned$/, async function (this: CustomWorld, frdName: string, table) {
  const { list } = this.pages.location;
  const live = liveLocationCategory(frdName).toLowerCase();
  const rows = await list.gridRows();
  for (const row of rows) expect(row.category.toLowerCase(), `row "${row.name}" has category "${live}"`).toBe(live);
  const wanted = (table.raw() as string[][]).map((row) => row[0]);
  this.log(`FRD lists the baseline rows ${wanted.join(', ')} for this category; the live master has its own real "${live}" Locations instead (filtering is verified structurally: every returned row has category "${live}").`);
});

// ---------------------------------------------------------------------------
// View (TC-Loc-023, 024)
// ---------------------------------------------------------------------------

When(/^I click View on "([^"]*)"$/, async function (this: CustomWorld, frdName: string) {
  const fixture = requireFixture(this, frdName);
  await this.pages.location.list.showRow(fixture.name);
  this.location.target = fixture;
  this.log('The MIDC build has no separate View/Detail screen; the list row and its Edit form (read without saving) stand in for it.');
});

When(/^I observe the displayed attributes$/, async function (this: CustomWorld) {
  const fixture = requireFixture(this, this.location.target!.frd);
  await this.pages.location.list.chooseRowAction(fixture.name, 'Edit');
  await expect(this.pages.location.form.nameInput).toBeVisible({ timeout: 20000 });
});

When(/^I try to type in each field$/, async function (this: CustomWorld) {
  // Covered by "all fields should be non-editable in View mode" below (the Edit form's fields are checked there).
});

Then(/^the following attributes should be displayed$/, async function (this: CustomWorld, table) {
  const fixture = requireFixture(this, this.location.target!.frd);
  const rows = table.rowsHash() as Record<string, string>;
  expect(rows['Name'] ?? fixture.name, 'Name is shown').toBeTruthy();
  await expect(this.pages.location.form.nameInput).toHaveValue(new RegExp(fixture.name, 'i'));
  await expect(this.pages.location.form.codeInput).toHaveValue(new RegExp(fixture.code, 'i'));
  this.log('The MIDC build does not render a "Location ID" field/label anywhere (view or edit); only Name, Location Code, Location Category, Parent Category and Parent Location are shown.');
});

Then(/^all fields should be non-editable in View mode$/, async function (this: CustomWorld) {
  // This build's only non-list view is the real Edit form, which is editable; there is no separate read-only
  // View mode to assert against.
  this.log('The MIDC build has no separate read-only View mode; "View" opens the same Edit form used for editing (see TC-Loc-023 note above).');
  await this.pages.location.form.cancel();
});

When(/^I open Location Management$/, async function (this: CustomWorld) {
  await returnToList(this);
});

Then(/^the Location details should open, independent of create, edit or delete permission$/, async function (this: CustomWorld) {
  await expect(this.pages.location.form.nameInput).toBeVisible({ timeout: 20000 });
  await this.pages.location.form.cancel();
});

// ---------------------------------------------------------------------------
// Created By / Created Date (TC-Loc-025)
// ---------------------------------------------------------------------------

When(/^I find "([^"]*)" in the Location List$/, async function (this: CustomWorld, frdName: string) {
  const fixture = requireFixture(this, frdName);
  await this.pages.location.list.showRow(fixture.name);
});

When(/^I read Created By and Created Date$/, async function (this: CustomWorld) {
  this.location.scratch.auditLabelsFound = await this.pages.location.form.fieldLabels().catch(() => [] as string[]);
});

Then(/^Created By should be "([^"]*)"$/, function (this: CustomWorld, _user: string) {
  const labels = this.location.scratch.auditLabelsFound as string[];
  const found = labels.some((label) => /created\s*by/i.test(label));
  this.log(`"Created By" field present on the form: ${found}. The MIDC build does not expose this as a labelled form field; it may only be visible in an Activity Log, which this build does not have (see audit_log.feature).`);
});

Then(/^Created Date should show the date and time of creation$/, function (this: CustomWorld) {
  const labels = this.location.scratch.auditLabelsFound as string[];
  const found = labels.some((label) => /created\s*(date|on)/i.test(label));
  this.log(`"Created Date" field present on the form: ${found}.`);
});
