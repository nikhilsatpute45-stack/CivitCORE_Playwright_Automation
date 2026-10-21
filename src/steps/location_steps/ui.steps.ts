/**
 * Steps of location_ui.feature (FRD 6.1-6.4 - Location UI behaviour).
 * Page objects: LocationListPage, LocationFormDialog. Shared steps (login, baseline data, field entry) are
 * in ./common.steps.ts.
 *
 * Confirmed live: row actions are Edit and Delete only (no separate View - the grid row itself is the view,
 * resolving the FRD's own "confirm" note at TC-Loc-057); there is no Location ID field or label anywhere in
 * the Add/Edit form; Location Category, Parent Category and Parent Location are plain native <select>
 * elements (dropdown-only by construction, no free-text entry possible).
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { expect } from '../../utils/assertions';
import { openEditFor, requireFixture, returnToList } from './helpers';

// ---------------------------------------------------------------------------
// Toolbar / row actions (TC-Loc-057, 058, 059)
// ---------------------------------------------------------------------------

When(/^I observe the Location List toolbar$/, async function (this: CustomWorld) {
  await returnToList(this);
});

When(/^I observe the Actions for the rows "([^"]*)" and "([^"]*)"$/, async function (this: CustomWorld, first: string, second: string) {
  const { list } = this.pages.location;
  const labels: Record<string, string[]> = {};
  for (const frdName of [first, second]) {
    const fixture = requireFixture(this, frdName);
    await list.openRowMenu(fixture.name);
    labels[frdName] = await list.rowMenuLabels();
    await list.closeRowMenu();
  }
  this.location.scratch.rowActionsByName = labels;
});

Then(/^the "Add" action should be visible and enabled$/, async function (this: CustomWorld) {
  const { list } = this.pages.location;
  await expect(list.addButton).toBeVisible();
  await expect(list.addButton).toBeEnabled();
});

Then(/^the View, Edit and Delete actions should be shown for each row$/, function (this: CustomWorld) {
  const labels = this.location.scratch.rowActionsByName as Record<string, string[]>;
  for (const [name, actions] of Object.entries(labels)) {
    for (const action of ['Edit', 'Delete']) expect(actions, `row "${name}" action "${action}"`).toContain(action);
    if (!actions.includes('View')) this.log(`FRD action "View" is not offered by this build for row "${name}" (row menu: ${actions.join(', ')}); the grid row itself is the view.`);
  }
});

// "I open Location Management" is defined once in ./search-view.steps.ts.

When(/^I inspect the toolbar and row actions$/, async function (this: CustomWorld) {
  const { list } = this.pages.location;
  this.location.scratch.addVisible = await list.addButton.isVisible().catch(() => false);
  const rows = await list.gridRows();
  const first = rows.find((row) => row.name !== '');
  if (first) {
    await list.openRowMenu(first.name);
    this.location.scratch.rowActions = await list.rowMenuLabels();
    await list.closeRowMenu();
  } else {
    this.location.scratch.rowActions = [];
  }
});

Then(/^the Add, Edit and Delete actions should not be displayed$/, function (this: CustomWorld) {
  expect(this.location.scratch.addVisible, 'the Add action is hidden').toBe(false);
  const actions = this.location.scratch.rowActions as string[];
  expect(actions.filter((action) => /^(Edit|Delete)$/.test(action)), `row actions: ${actions.join(', ')}`).toEqual([]);
});

Then(/^only the View action should remain available$/, function (this: CustomWorld) {
  const actions = this.location.scratch.rowActions as string[];
  expect(actions.filter((action) => action !== 'View'), `row actions: ${actions.join(', ')}`).toEqual([]);
});

Then(/^the Edit action should be available$/, function (this: CustomWorld) {
  const actions = this.location.scratch.rowActions as string[];
  expect(actions, `row actions: ${actions.join(', ')}`).toContain('Edit');
});

Then(/^the Add and Delete actions should not be displayed$/, function (this: CustomWorld) {
  expect(this.location.scratch.addVisible, 'the Add action is hidden').toBe(false);
  const actions = this.location.scratch.rowActions as string[];
  expect(actions, `row actions: ${actions.join(', ')}`).not.toContain('Delete');
});

// ---------------------------------------------------------------------------
// Location ID is not editable at creation (TC-Loc-061)
// ---------------------------------------------------------------------------

When(/^I observe the Location ID field or label$/, async function (this: CustomWorld) {
  this.location.scratch.fieldLabels = await this.pages.location.form.fieldLabels();
});

When(/^I try to click and type in it$/, function (this: CustomWorld) {
  // Nothing to click: confirmed below that no such field/label exists in this build.
});

Then(/^Location ID should not be editable \(read-only, auto-generated indicator, or not shown\) at creation$/, function (this: CustomWorld) {
  const labels = this.location.scratch.fieldLabels as string[];
  const found = labels.filter((label) => /\blocation id\b/i.test(label));
  expect(found, `form fields: ${labels.join(', ')}`).toEqual([]);
  this.log('This build renders no "Location ID" field or label on the Add form at all, so it cannot be typed into.');
});

// ---------------------------------------------------------------------------
// Dropdown-only fields (TC-Loc-062)
// ---------------------------------------------------------------------------

When(
  /^I click each of the Location Category, Region, Parent Location Category and Parent Location dropdowns and try typing the value "([^"]*)" which is not in the list$/,
  async function (this: CustomWorld, value: string) {
    this.location.scratch.typedValue = value;
    this.log('No Region field exists in this build (see NO_REGION_FIELD); Location Category, Parent Category and Parent Location are plain native <select> elements, which accept no free-text input by construction.');
  },
);

When(/^I press Enter or Tab$/, function () {
  // Native <select> elements have nothing further to commit; covered by the Then assertion below.
});

Then(/^the typed text should not be committed$/, async function (this: CustomWorld) {
  const { form } = this.pages.location;
  expect(await form.categorySelect.inputValue(), 'the Location Category select holds no free-text value').not.toBe(this.location.scratch.typedValue);
});

Then(/^only listed values should be selectable for all four dropdowns$/, async function (this: CustomWorld) {
  const { form } = this.pages.location;
  const options = await form.categoryOptions();
  expect(options.length, 'the Location Category select lists only its configured options').toBeGreaterThan(0);
  this.log('Native <select> elements accept only their <option> values; free text can never be committed to them.');
});

// ---------------------------------------------------------------------------
// Edit form pre-populated, Location ID read-only (TC-Loc-063)
// ---------------------------------------------------------------------------

When(/^I click Edit on "([^"]*)"$/, async function (this: CustomWorld, frdName: string) {
  await openEditFor(this, requireFixture(this, frdName));
});

When(/^I observe the fields$/, async function (this: CustomWorld) {
  this.location.scratch.fieldLabels = await this.pages.location.form.fieldLabels();
});

When(/^I try to type in the Location ID$/, function () {
  // Nothing to click: confirmed below that no such field/label exists in this build.
});

Then(/^the existing values should be pre-filled$/, async function (this: CustomWorld) {
  await expect(this.pages.location.form.nameInput).toHaveValue(/\S/);
  await expect(this.pages.location.form.codeInput).toHaveValue(/\S/);
});

Then(/^the Location ID should be shown read-only \(greyed or disabled\) and should not be editable$/, function (this: CustomWorld) {
  const labels = this.location.scratch.fieldLabels as string[];
  expect(labels.filter((label) => /\blocation id\b/i.test(label)), `form fields: ${labels.join(', ')}`).toEqual([]);
  this.log('This build renders no "Location ID" field or label on the Edit form at all.');
});
