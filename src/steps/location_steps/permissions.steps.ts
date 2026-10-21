/**
 * Steps of location_permissions.feature (FRD 6.1 BR-1, 3 - Location permissions).
 * Page object: LocationListPage, LocationApi. Role credentials come from MIDC_<ROLE>_USERNAME/_PASSWORD
 * (see getRoleCredentials); a scenario whose role is not configured is skipped (see ./helpers.ts logInAs).
 */
import { Given, Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { expect } from '../../utils/assertions';
import { getRoleCredentials } from '../../support/config';
import { categoryId, ensureSession, skipBecause, uniqueCode, uniqueName } from './helpers';

When(/^I check the System Configuration menu for Location$/, async function (this: CustomWorld) {
  const { list } = this.pages.location;
  if (await this.pages.mastersManagementPage.mastersManagementLink.isVisible().catch(() => false)) {
    await this.pages.mastersManagementPage.openMastersManagement();
    await this.pages.mastersManagementPage.expectAdminPortalLoaded();
  }
  if (await list.organizationConfigurationIcon.isVisible().catch(() => false)) await list.organizationConfigurationIcon.click();
  this.location.scratch.menuVisible = await list.locationTab.isVisible({ timeout: 5000 }).catch(() => false);
});

When(/^I open the Location Management URL directly$/, async function (this: CustomWorld) {
  await ensureSession(this);
  this.location.apiResult = await this.pages.location.api.send('POST', 'location/3.0/getHierarchy', { specifiedOrgOnly: false, orgID: 1 });
});

Then(/^the menu entry should not be displayed$/, function (this: CustomWorld) {
  expect(this.location.scratch.menuVisible, 'the Location tab is hidden').toBe(false);
});

Then(/^direct URL access should be denied$/, function (this: CustomWorld) {
  const result = this.location.apiResult!;
  expect([401, 403], `the API answered ${result.status} ${result.message}`).toContain(result.status);
});

Then(/^no Location data should be exposed$/, function (this: CustomWorld) {
  const body = this.location.apiResult!.body;
  expect(Array.isArray(body) && body.length > 0, 'no Locations came back').toBe(false);
});

Given(/^a "([^"]*)" token is available$/, function (this: CustomWorld, role: string) {
  if (!getRoleCredentials(role)) {
    const key = role.toUpperCase().replace(/[^A-Z]/g, '');
    return skipBecause(this, `no ${role} user is configured; set MIDC_${key}_USERNAME and MIDC_${key}_PASSWORD to run it.`);
  }
  this.location.scratch.tokenRole = role;
  return undefined;
});

When(/^I send a create-Location request using the Viewer's token with payload$/, async function (this: CustomWorld, payload: string) {
  const body = JSON.parse(payload) as { name: string; shortName: string };
  const credentials = getRoleCredentials('Viewer')!;
  // A fresh, non-shared login as the Viewer is required so the replayed bearer token is actually theirs.
  await this.pages.midcHomePage.open();
  await this.pages.midcHomePage.openDepartmentLogin();
  await this.pages.departmentLoginPage.expectLoaded();
  await this.pages.departmentLoginPage.login(credentials.username, credentials.password);
  await this.pages.location.list.open('MIDC');
  const name = uniqueName(this, body.name);
  const catId = await categoryId(this, 'District');
  this.location.scratch.apiName = name;
  this.location.apiResult = await this.pages.location.api.create({
    locName: name,
    locCode: uniqueCode(this, body.shortName),
    locCatID: catId,
  });
});

Then(/^the request should be rejected with 403$/, function (this: CustomWorld) {
  const result = this.location.apiResult!;
  expect(result.status, `the API answered ${result.status} ${result.message}`).toBe(403);
});

Then(/^I check the Location Master$/, async function (this: CustomWorld) {
  this.location.scratch.masterAfter = await this.pages.location.api.fetchMaster();
});

Given(/^an "([^"]*)" token with View and Edit access is available$/, function (this: CustomWorld, role: string) {
  if (!getRoleCredentials(role)) {
    const key = role.toUpperCase().replace(/[^A-Z]/g, '');
    return skipBecause(this, `no ${role} user is configured; set MIDC_${key}_USERNAME and MIDC_${key}_PASSWORD to run it.`);
  }
  // The Editor has no Add permission to create their own fixture, so one would have to be seeded by a
  // second (Admin) session; this suite does not open a second session (same precedent as
  // src/steps/location_category_steps/permissions.steps.ts's "a deletable category exists").
  return skipBecause(this, 'the Location to delete must be created by an Admin session while the scenario runs as the Editor; seed it out of band.');
});

// "I send a delete request for "X" using the Editor's token" is also used verbatim by
// features/location_category_features, whose own permissions.steps.ts already defines it (unreachable there
// too, since its own Given always skips first).
