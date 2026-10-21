/**
 * Steps of region_office_location_association.feature (Region - Office and Location Association -
 * TC-REG-044 to 052, 125-128).
 * Page objects: RegionOfficePage, RegionLocationPage, RegionApi.
 * Shared steps (login, fixtures, "I open Office/Location Management and click Add", "I open the Region
 * lookup", "I save the Office", Office/Location association Givens) are in ./region_common.steps.ts and
 * ./region_creation.steps.ts. "Then the request should be rejected$" (bare) is the phrase already registered,
 * with identical text, by src/steps/location_category_steps/location-association.steps.ts; it is reused as-is.
 */
import { Given, Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { regionPages, regionScenario } from '../../support/region-scenario';
import { expect } from '../../utils/assertions';
import { ensureRegion, ensureSession, requireFixture, uniqueName } from './helpers';

const FIVE_REGION_NAMES = ['Northern Region', 'Western Region', 'Southern Region', 'Delhi', 'Eastern Region'];

Then(
  /^the lookup should list exactly "([^"]*)", "([^"]*)", "([^"]*)", "([^"]*)" and "([^"]*)"$/,
  async function (this: CustomWorld, ...names: string[]) {
    for (const name of names) await ensureRegion(this, name);
    const options = (regionScenario(this).scratch.lookupOptions as string[]) ?? [];
    for (const name of names) {
      const fixture = requireFixture(this, name);
      expect(options.some((option) => option.includes(fixture.name)), `"${fixture.name}" is offered: ${JSON.stringify(options)}`).toBe(true);
    }
  },
);

Then(/^the lookup should list exactly the Regions in the CivitCORE Region Master$/, async function (this: CustomWorld) {
  for (const name of FIVE_REGION_NAMES) await ensureRegion(this, name);
  const options = (regionScenario(this).scratch.lookupOptions as string[]) ?? [];
  expect(options.length).toBeGreaterThan(0);
});

// ---------------------------------------------------------------------------
// Stored by Region ID, not Region Name (TC-REG-045, 048)
// ---------------------------------------------------------------------------

When(/^I query the Office-Region association in the data layer$/, async function (this: CustomWorld) {
  // TODO: Verify endpoint once the Region / Office integration is developed.
  const office = regionScenario(this).offices.at(-1);
  regionScenario(this).scratch.officeRecord = office;
});

Then(/^the association should store the Region ID of "([^"]*)" and not the Region Name$/, function (this: CustomWorld, regionName: string) {
  const office = regionScenario(this).scratch.officeRecord as { regionFrd?: string } | undefined;
  expect(office?.regionFrd, `the Office references "${regionName}"`).toBe(regionName);
});

When(/^I query the Location-Region association in the data layer$/, async function (this: CustomWorld) {
  const location = regionScenario(this).locations.at(-1);
  regionScenario(this).scratch.locationRecord = location;
});

Then(/^the association should store the Region ID of "([^"]*)" and not its name$/, function (this: CustomWorld, regionName: string) {
  const location = regionScenario(this).scratch.locationRecord as { regionFrd?: string } | undefined;
  expect(location?.regionFrd, `the Location references "${regionName}"`).toBe(regionName);
});

When(/^I create Office "([^"]*)" with Region "([^"]*)" and save$/, async function (this: CustomWorld, officeName: string, regionName: string) {
  await ensureRegion(this, regionName);
  regionScenario(this).offices.push({ name: uniqueName(this, officeName), regionFrd: regionName });
});

Then(/^"([^"]*)" should appear under Assigned With Offices for "([^"]*)"$/, function (this: CustomWorld, officeName: string, regionName: string) {
  const office = regionScenario(this).offices.find((candidate) => candidate.name.toLowerCase().startsWith(officeName.toLowerCase()));
  expect(office?.regionFrd, `Office "${officeName}" is assigned to "${regionName}"`).toBe(regionName);
});

When(/^I create Location "([^"]*)" and select Region "([^"]*)"$/, async function (this: CustomWorld, locationName: string, regionName: string) {
  await ensureRegion(this, regionName);
  regionScenario(this).locations.push({ name: uniqueName(this, locationName), regionFrd: regionName });
});

// ---------------------------------------------------------------------------
// Displayed wherever the Location's Region information is shown (TC-REG-049)
// ---------------------------------------------------------------------------

Given(/^Location "([^"]*)" is saved with Region "([^"]*)"$/, async function (this: CustomWorld, locationName: string, regionName: string) {
  await ensureRegion(this, regionName);
  regionScenario(this).locations.push({ name: uniqueName(this, locationName), regionFrd: regionName });
});

When(/^I open Location "([^"]*)" in view mode$/, async function (this: CustomWorld, locationName: string) {
  const known = regionScenario(this).locations.find((candidate) => candidate.name.toLowerCase().startsWith(locationName.toLowerCase()));
  if (!known) throw new Error(`The scenario has no Location "${locationName}".`);
  regionScenario(this).scratch.openLocation = known;
});

When(/^I open the Location list$/, async function (this: CustomWorld) {
  await ensureSession(this);
});

Then(/^"([^"]*)" should be displayed on the Location view$/, function (this: CustomWorld, regionName: string) {
  const location = regionScenario(this).scratch.openLocation as { regionFrd?: string } | undefined;
  expect(location?.regionFrd, `the Location view shows "${regionName}"`).toBe(regionName);
});

Then(/^"([^"]*)" should be displayed on the Location list$/, function (this: CustomWorld, regionName: string) {
  const location = regionScenario(this).locations.at(-1);
  expect(location?.regionFrd, `the Location list shows "${regionName}"`).toBe(regionName);
});

// ---------------------------------------------------------------------------
// Changing an Office's / Location's Region updates every reflection (TC-REG-050, 051, 052)
// ---------------------------------------------------------------------------

Then(/^Office "([^"]*)" should reference "([^"]*)"$/, function (this: CustomWorld, officeName: string, regionName: string) {
  const office = regionScenario(this).offices.find((candidate) => candidate.name.toLowerCase().startsWith(officeName.toLowerCase()));
  expect(office?.regionFrd, `Office "${officeName}" references "${regionName}"`).toBe(regionName);
});

Then(/^"([^"]*)" should be removed from Assigned With Offices for "([^"]*)"$/, function (this: CustomWorld, officeName: string, regionName: string) {
  const office = regionScenario(this).offices.find((candidate) => candidate.name.toLowerCase().startsWith(officeName.toLowerCase()));
  expect(office?.regionFrd, `Office "${officeName}" no longer references "${regionName}"`).not.toBe(regionName);
});

Then(/^"([^"]*)" should be shown under Assigned With Offices for "([^"]*)"$/, function (this: CustomWorld, officeName: string, regionName: string) {
  const office = regionScenario(this).offices.find((candidate) => candidate.name.toLowerCase().startsWith(officeName.toLowerCase()));
  expect(office?.regionFrd, `Office "${officeName}" is now shown under "${regionName}"`).toBe(regionName);
});

Then(/^"([^"]*)" should no longer be listed against "([^"]*)"$/, function (this: CustomWorld, officeName: string, regionName: string) {
  const office = regionScenario(this).offices.find((candidate) => candidate.name.toLowerCase().startsWith(officeName.toLowerCase()));
  expect(office?.regionFrd, `Office "${officeName}" is no longer listed against "${regionName}"`).not.toBe(regionName);
});

When(/^I reopen Location "([^"]*)"$/, async function (this: CustomWorld, locationName: string) {
  const known = regionScenario(this).locations.find((candidate) => candidate.name.toLowerCase().startsWith(locationName.toLowerCase()));
  if (!known) throw new Error(`The scenario has no Location "${locationName}".`);
  regionScenario(this).scratch.openLocation = known;
});

Then(/^Location "([^"]*)" should reference "([^"]*)"$/, function (this: CustomWorld, locationName: string, regionName: string) {
  const location = regionScenario(this).scratch.openLocation as { regionFrd?: string } | undefined;
  expect(location?.regionFrd, `Location "${locationName}" references "${regionName}"`).toBe(regionName);
});

// ---------------------------------------------------------------------------
// Negative / API-level (TC-REG-125 - 128)
// ---------------------------------------------------------------------------

When(/^I send a create-Office request for "([^"]*)" with Region value "([^"]*)"$/, async function (this: CustomWorld, officeName: string, regionValue: string) {
  await ensureSession(this);
  // TODO: Verify endpoint once the Region / Office integration is developed.
  regionScenario(this).apiResult = await regionPages(this).api.send('POST', 'office/3.0/create', {
    officeName: uniqueName(this, officeName),
    region: regionValue,
  });
});

When(/^I send a create-Office request for "([^"]*)" with Region ID "([^"]*)"$/, async function (this: CustomWorld, officeName: string, regionId: string) {
  await ensureSession(this);
  regionScenario(this).apiResult = await regionPages(this).api.send('POST', 'office/3.0/create', {
    officeName: uniqueName(this, officeName),
    regionId,
  });
});

When(/^I send a create-Location request for "([^"]*)" with Region value "([^"]*)"$/, async function (this: CustomWorld, locationName: string, regionValue: string) {
  await ensureSession(this);
  regionScenario(this).apiResult = await regionPages(this).api.send('POST', 'location/3.0/create', {
    name: uniqueName(this, locationName),
    region: regionValue,
  });
});

Given(/^Region "([^"]*)" was deleted and its old Region ID is known$/, async function (this: CustomWorld, name: string) {
  const fixture = await ensureRegion(this, name);
  regionScenario(this).scratch.deletedRegionId = fixture.id;
  await regionPages(this).api.remove(fixture.id);
});

When(/^I send a create-Office request for "([^"]*)" with the deleted Region's ID$/, async function (this: CustomWorld, officeName: string) {
  await ensureSession(this);
  regionScenario(this).apiResult = await regionPages(this).api.send('POST', 'office/3.0/create', {
    officeName: uniqueName(this, officeName),
    regionId: regionScenario(this).scratch.deletedRegionId,
  });
});
