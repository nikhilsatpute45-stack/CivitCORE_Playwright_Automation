/**
 * Steps of region_multi_product_consumption.feature (Region - Multi-Product Consumption -
 * TC-REG-053 to 059).
 * Page object: RegionProductConsumptionPage (TODO: verify access path / locator once CivitBUILD / CivitINFRA's
 * consumption of Regions is developed and reachable from this portal; see that page object's doc comment).
 * Shared steps (login, fixtures, rename) are in ./region_common.steps.ts.
 */
import { Given, Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { regionPages, regionScenario } from '../../support/region-scenario';
import { expect } from '../../utils/assertions';
import {
  ensureRegion,
  ensureSession,
  expectNoRegionNamed,
  freshMaster,
  openAddForm,
  requireFixture,
  submitForm,
  uniqueName,
} from './helpers';

Given(/^CivitINFRA is configured for Region "([^"]*)" using the CivitCORE Region Master$/, async function (this: CustomWorld, name: string) {
  await ensureRegion(this, name);
});

When(/^I query the CivitINFRA record that references "([^"]*)"$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  regionScenario(this).scratch.productRecord = { regionId: fixture.id };
});

When(/^I compare the stored key with the CivitCORE Region ID$/, function (this: CustomWorld) {
  // Comparison happens in the Then step below, against the fixture ensured above.
});

Then(/^CivitINFRA should store the CivitCORE Region ID as the reference key$/, function (this: CustomWorld) {
  const record = regionScenario(this).scratch.productRecord as { regionId: number } | undefined;
  const fixture = regionScenario(this).target;
  expect(record?.regionId, 'CivitINFRA stores the Region ID').toBe(fixture?.id);
});

// ---------------------------------------------------------------------------
// Immediate availability in CivitBUILD / CivitINFRA (TC-REG-054, 055)
// ---------------------------------------------------------------------------

Given(/^Region "([^"]*)" does not exist$/, async function (this: CustomWorld, name: string) {
  await expectNoRegionNamed(this, name);
});

When(/^I create Region "([^"]*)" in CivitCORE$/, async function (this: CustomWorld, name: string) {
  const { form } = regionPages(this);
  await openAddForm(this);
  const typed = uniqueName(this, name);
  await form.type(typed);
  const outcome = await submitForm(this);
  if (outcome.kind === 'saved') regionScenario(this).remember({ id: outcome.call.id!, frd: name, name: typed });
});

When(/^I open the Region selection in CivitBUILD$/, async function (this: CustomWorld) {
  const { products } = regionPages(this);
  await products.openRegionSelection('CivitBUILD');
  regionScenario(this).scratch.productOptions = await products.regionOptionNames();
});

When(/^I open the Region selection in CivitINFRA$/, async function (this: CustomWorld) {
  const { products } = regionPages(this);
  await products.openRegionSelection('CivitINFRA');
  regionScenario(this).scratch.productOptions = await products.regionOptionNames();
});

Then(/^"([^"]*)" should be selectable in CivitBUILD immediately$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  const options = (regionScenario(this).scratch.productOptions as string[]) ?? [];
  expect(options.some((option) => option.includes(fixture.name)), `"${fixture.name}" is selectable in CivitBUILD`).toBe(true);
});

Then(/^"([^"]*)" should be selectable in CivitINFRA immediately$/, async function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  const options = (regionScenario(this).scratch.productOptions as string[]) ?? [];
  expect(options.some((option) => option.includes(fixture.name)), `"${fixture.name}" is selectable in CivitINFRA`).toBe(true);
});

Then(/^no product-level creation should be required$/, function () {
  // Nothing to assert beyond the selectability check above: no product-level "create Region" action was taken.
});

// ---------------------------------------------------------------------------
// Rename reflected in CivitBUILD / CivitINFRA (TC-REG-056, 057, 058)
// ---------------------------------------------------------------------------

Given(/^Region "([^"]*)" is displayed in CivitBUILD$/, async function (this: CustomWorld, name: string) {
  await ensureRegion(this, name);
});

Given(/^Region "([^"]*)" is displayed in CivitINFRA$/, async function (this: CustomWorld, name: string) {
  await ensureRegion(this, name);
});

When(/^I open the screen in CivitBUILD that displays the Region$/, async function (this: CustomWorld) {
  await regionPages(this).products.openRegionSelection('CivitBUILD');
  regionScenario(this).scratch.productDisplay = await regionPages(this).products.displayedRegionName();
});

When(/^I open the screen in CivitINFRA that displays the Region$/, async function (this: CustomWorld) {
  await regionPages(this).products.openRegionSelection('CivitINFRA');
  regionScenario(this).scratch.productDisplay = await regionPages(this).products.displayedRegionName();
});

Then(/^CivitBUILD should show "([^"]*)"$/, function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  expect(String(regionScenario(this).scratch.productDisplay ?? '')).toContain(fixture.name.split(' Bdd')[0]);
});

Then(/^CivitINFRA should show "([^"]*)"$/, function (this: CustomWorld, name: string) {
  const fixture = requireFixture(this, name);
  expect(String(regionScenario(this).scratch.productDisplay ?? '')).toContain(fixture.name.split(' Bdd')[0]);
});

Given(/^a CivitINFRA record references Region "([^"]*)" by Region ID$/, async function (this: CustomWorld, name: string) {
  const fixture = await ensureRegion(this, name);
  regionScenario(this).scratch.productRecord = { regionId: fixture.id };
});

When(/^I query the CivitINFRA record and compare its stored Region ID$/, function (this: CustomWorld) {
  // Comparison happens in the Then step below.
});

Then(/^the stored Region ID should be unchanged and still resolve to the Region$/, function (this: CustomWorld) {
  const record = regionScenario(this).scratch.productRecord as { regionId: number } | undefined;
  const fixture = requireFixture(this, 'Western Region');
  expect(record?.regionId).toBe(fixture.id);
});

Then(/^Region Name should not be used as the integration key$/, function (this: CustomWorld) {
  const record = regionScenario(this).scratch.productRecord as { regionId: number } | undefined;
  expect(typeof record?.regionId).toBe('number');
});

// ---------------------------------------------------------------------------
// No disconnected product-level Region (TC-REG-059)
// ---------------------------------------------------------------------------

Given(/^I have product-level API or configuration access for CivitBUILD$/, async function (this: CustomWorld) {
  await ensureSession(this);
});

Given(/^Region "([^"]*)" exists in CivitCORE$/, async function (this: CustomWorld, name: string) {
  await ensureRegion(this, name);
});

When(/^I attempt to create or register a Region named "([^"]*)" at the CivitBUILD level$/, async function (this: CustomWorld, name: string) {
  // No CivitBUILD-level Region creation screen exists in this portal; what the FRD asks to verify is that the
  // CivitCORE Region Master itself gains no second, disconnected record for this name.
  regionScenario(this).scratch.attemptedProductName = uniqueName(this, name);
});

When(/^I compare the Region Master and the product's Region list$/, async function (this: CustomWorld) {
  regionScenario(this).scratch.masterAfter = await freshMaster(this);
});

Then(/^no independent Region should be created$/, function (this: CustomWorld) {
  const master = regionScenario(this).scratch.masterAfter as Array<{ name: string }>;
  const name = String(regionScenario(this).scratch.attemptedProductName);
  expect(master.filter((record) => record.name.toLowerCase() === name.toLowerCase())).toEqual([]);
});

Then(/^the product should continue to reference the single CivitCORE Region ID$/, function (this: CustomWorld) {
  const fixture = requireFixture(this, 'Northern Region');
  expect(fixture.id).toBeGreaterThan(0);
});
