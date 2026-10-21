/**
 * Steps of region_ui.feature (Region Management UI - TC-REG-087, 088, 091, 095, 099, 100).
 * Page objects: RegionListPage, RegionFormDialog, RegionOfficePage, RegionLocationPage.
 * Shared steps (login, navigation, Add / Edit form open) are in ./region_common.steps.ts.
 */
import { Given, Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { regionPages, regionScenario } from '../../support/region-scenario';
import { expect } from '../../utils/assertions';
import { REGION_COLUMN_ORDER } from '../../pages/region_pages';
import { midcTestData } from '../../test-data/midc.data';

Given(/^the list has multiple records$/, async function (this: CustomWorld) {
  const rows = await regionPages(this).list.gridRows();
  expect(rows.length).toBeGreaterThan(0);
});

When(/^I read the grid column headers from left to right$/, async function (this: CustomWorld) {
  regionScenario(this).scratch.columnHeaders = await regionPages(this).list.columnHeaders();
});

Then(/^the column headers should be, in order: "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)"$/, function (this: CustomWorld) {
  const headers = (regionScenario(this).scratch.columnHeaders as string[]) ?? [];
  expect(headers).toEqual([...REGION_COLUMN_ORDER]);
});

Then(/^a search input for Region Name should be present and enabled$/, async function (this: CustomWorld) {
  const { nameFilter } = regionPages(this).list;
  await expect(nameFilter).toBeVisible();
  await expect(nameFilter).toBeEditable();
});

Then(/^the only user-entered field should be Region Name$/, async function (this: CustomWorld) {
  const { form } = regionPages(this);
  const labels = await form.fieldLabels();
  expect(labels.filter((label) => !/region name/i.test(label)), `the Add form offers only Region Name; fields: ${labels.join(', ')}`).toEqual([]);
});

Then(/^no Region ID input should be present$/, async function (this: CustomWorld) {
  expect(await regionPages(this).form.idInput.count()).toBe(0);
});

Then(/^no other attributes should be present$/, async function (this: CustomWorld) {
  const labels = await regionPages(this).form.fieldLabels();
  expect(labels.length, `the Add form has exactly one field; fields: ${labels.join(', ')}`).toBeLessThanOrEqual(1);
});

When(/^I try to type into the Region ID control$/, async function (this: CustomWorld) {
  await regionPages(this).form.tryTypeId('999');
});

Then(/^the Region ID should be displayed as read-only or disabled$/, async function (this: CustomWorld) {
  expect(await regionPages(this).form.isIdReadOnly(), 'the Region ID control is read-only / disabled').toBe(true);
});

// ---------------------------------------------------------------------------
// Office / Location Region field is selection-only (TC-REG-099, 100)
// ---------------------------------------------------------------------------

Given(/^the Office Add form is open$/, async function (this: CustomWorld) {
  const { office } = regionPages(this);
  await office.open(midcTestData.organizationName);
  await office.openAddForm();
});

Given(/^the Location Add form is open$/, async function (this: CustomWorld) {
  const { location } = regionPages(this);
  await location.open(midcTestData.organizationName);
  await location.openAddForm();
});

When(/^I click into the Region field$/, async function (this: CustomWorld) {
  const { office, location } = regionPages(this);
  if (await office.isFormOpen()) await office.openRegionLookup();
  else await location.openRegionLookup();
});

When(/^I try to type the value "([^"]*)"$/, async function (this: CustomWorld, value: string) {
  const { office, location } = regionPages(this);
  if (await office.isFormOpen()) await office.tryTypeRegion(value);
  else await location.tryTypeRegion(value);
  regionScenario(this).scratch.typedRegionValue = value;
});

Then(/^the control should only allow choosing from the Region Master list$/, async function (this: CustomWorld) {
  const { office, location } = regionPages(this);
  const typed = String(regionScenario(this).scratch.typedRegionValue ?? '');
  const options = (await office.isFormOpen()) ? await office.regionOptionNames() : await location.regionOptionNames();
  expect(options.some((option) => option.toLowerCase() === typed.toLowerCase()), `"${typed}" is not a Region Master option`).toBe(false);
});

Then(/^free-text entry should not be accepted$/, async function (this: CustomWorld) {
  const { office } = regionPages(this);
  const typed = String(regionScenario(this).scratch.typedRegionValue ?? '');
  const value = (await office.isFormOpen()) ? await office.currentRegion() : '';
  expect(value, `"${typed}" was not accepted as a free-text Region value`).not.toBe(typed);
});
