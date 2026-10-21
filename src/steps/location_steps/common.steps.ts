/**
 * Location steps shared by more than one feature file in features/location_features. Cucumber step text is
 * global, so a step used by several features is defined once, here; steps used by a single feature live in
 * that feature's own step file.
 *
 * Feature files use FRD vocabulary; location.data.ts maps it onto the MIDC build ("Short Name" = "Location
 * Code", "Parent Location Category" = "Parent Category", Save = "Add / Update Location"). There is no
 * separate "Region" field in this build (see NO_REGION_FIELD); "I select Region ..." is a logged no-op
 * rather than a failure, so the rest of an otherwise-real scenario still runs. Every Location a scenario
 * uses is a unique copy of the FRD baseline record (ensureLocation / ensureBaseline) that ./hooks.ts removes
 * again. "System Configuration > Location" (the FRD's menu path) does not exist in this build; the real path
 * is Masters Management > Organization Configuration icon > "Location" tab (same as every other module).
 */
import { Given, Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { expect } from '../../utils/assertions';
import { NO_REGION_FIELD } from '../../test-data/location.data';
import {
  applyLocationCascade,
  ensureBaseline,
  ensureLocation,
  ensureSession,
  expectMessage,
  expectSaveBlocked,
  fillRemainingValidFields,
  logInAs,
  openAddForm,
  openEditFor,
  plausibleChildCategory,
  requireFixture,
  returnToList,
  skipBecause,
  successfulSaveId,
  uniqueCode,
  uniqueName,
} from './helpers';

// ---------------------------------------------------------------------------
// Session and navigation
// ---------------------------------------------------------------------------

Given(/^"([^"]*)" has valid credentials and Location Management permission$/, async function (this: CustomWorld, _user: string) {
  await ensureSession(this);
});

// Excludes "... with role X" (location_category_features' own phrasing for the same intent) to avoid an
// ambiguous match with that module's common.steps.ts, which registers the identical base text.
Given(/^I am logged in(?: to CivitCORE)? as "([^"]*)"(?: with (?!role\b).*)?$/, async function (this: CustomWorld, role: string) {
  this.location.scratch.role = role;
  return logInAs(this, role);
});

When(/^I login to CivitCORE as "([^"]*)"$/, async function (this: CustomWorld, _user: string) {
  await ensureLoggedIn_(this);
});

async function ensureLoggedIn_(world: CustomWorld): Promise<void> {
  const skipped = await logInAs(world, (world.location.scratch.role as string | undefined) ?? 'Admin_User1');
  if (skipped) throw new Error('Login was skipped; this step cannot continue.');
}

When(/^I navigate to "System Configuration > Location"$/, async function (this: CustomWorld) {
  this.log('FRD menu path "System Configuration > Location" does not exist in this build; using the real path (Masters Management > Organization Configuration icon > "Location" tab).');
  await returnToList(this);
});

When(/^I observe the page that loads$/, async function (this: CustomWorld) {
  await this.pages.location.list.expectListVisible();
});

Given(/^I am on the Location List page$/, async function (this: CustomWorld) {
  await returnToList(this);
});

/**
 * The live master holds none of the FRD's 12 baseline Locations, so the scenario gets its own copy of all of
 * them, created before any form opens so the Parent Location dropdown of a form opened later already offers
 * them.
 */
Given(/^the baseline location data is loaded$/, async function (this: CustomWorld) {
  await ensureSession(this);
  await ensureBaseline(this);
});

Given(/^an API client is authenticated as "([^"]*)"$/, async function (this: CustomWorld, _user: string) {
  await ensureSession(this);
  expect(this.pages.location.api.hasSession(), 'an authenticated Location API session is available').toBe(true);
});

Given(/^two API sessions as "([^"]*)"$/, async function (this: CustomWorld, _user: string) {
  // A second independent session is not opened; the "same time" requests below are sent from the one
  // session this world already has, which still exercises the server's own concurrency handling.
  await ensureSession(this);
  this.log('Both "sessions" are the same authenticated API session; only the server-side race is exercised, not two separate browser sessions.');
});

// ---------------------------------------------------------------------------
// Add / Edit form
// ---------------------------------------------------------------------------

Given(/^the Add Location form is open$/, async function (this: CustomWorld) {
  await openAddForm(this);
});

Given(/^the Edit Location form for "([^"]*)" is open$/, async function (this: CustomWorld, frdName: string) {
  await ensureBaseline(this);
  await openEditFor(this, requireFixture(this, frdName));
});

When(/^I enter (?:the \d+-character )?Name "([^"]*)"$/, async function (this: CustomWorld, value: string) {
  const typed = uniqueName(this, value);
  await this.pages.location.form.type('Location', typed);
  this.location.entered.name = typed;
});

When(/^I enter (\d+) spaces in Name "([^"]*)"$/, async function (this: CustomWorld, _count: string, value: string) {
  const typed = uniqueName(this, value);
  await this.pages.location.form.type('Location', typed);
  this.location.entered.name = typed;
});

When(/^I leave Name blank$/, async function (this: CustomWorld) {
  await this.pages.location.form.clear('Location');
  this.location.entered.name = '';
});

// "I clear the Name field" and "I change Name to "X"" are also used verbatim by
// features/location_category_features; that module's common.steps.ts dispatches to whichever form is open.

/**
 * The plain "I enter Short Name "X"" text is also used, verbatim, by features/location_category_features;
 * that module's common.steps.ts (which registered the phrase first) dispatches to whichever form is open, so
 * only the two extended forms below (unique to this module's feature text) are registered here.
 */
When(/^I enter the (\d+)-character Short Name "([^"]*)"$/, async function (this: CustomWorld, _count: string, value: string) {
  const typed = uniqueCode(this, value);
  await this.pages.location.form.type('Location Code', typed);
  this.location.entered.code = typed;
});

When(/^I enter Short Name "([^"]*)" with a valid Name and other fields$/, async function (this: CustomWorld, value: string) {
  const typed = uniqueCode(this, value);
  await this.pages.location.form.type('Location Code', typed);
  this.location.entered.code = typed;
  if (this.location.entered.name === undefined) await fillRemainingValidFields(this);
});

When(/^I enter (\d+) spaces in Short Name "([^"]*)"$/, async function (this: CustomWorld, _count: string, value: string) {
  const typed = uniqueCode(this, value);
  await this.pages.location.form.type('Location Code', typed);
  this.location.entered.code = typed;
});

// "I leave Short Name blank" is also used verbatim by features/location_category_features; that module's
// common.steps.ts dispatches to whichever form is actually open.

// "I change Short Name to "X"" is also used verbatim by features/location_category_features; that module's
// common.steps.ts dispatches to whichever form is actually open.

When(/^I select Location Category "([^"]*)"$/, async function (this: CustomWorld, frdName: string) {
  this.location.entered.categoryFrd = frdName;
  await applyLocationCascade(this);
});

When(/^I leave Location Category unselected$/, async function (this: CustomWorld) {
  this.location.entered.categoryFrd = undefined;
});

When(/^I select a valid Location Category and a valid Region$/, async function (this: CustomWorld) {
  const category = plausibleChildCategory(this.location.entered.parentCategoryFrd);
  this.location.entered.categoryFrd = category;
  await applyLocationCascade(this);
  this.log(NO_REGION_FIELD);
});

When(/^I select Region "([^"]*)"$/, async function (this: CustomWorld, _region: string) {
  this.log(NO_REGION_FIELD);
});

When(/^I open the Region dropdown$/, function (this: CustomWorld) {
  return skipBecause(this, NO_REGION_FIELD);
});

When(/^I select Parent Location Category "([^"]*)"$/, async function (this: CustomWorld, frdName: string) {
  this.location.entered.parentCategoryFrd = frdName;
  await applyLocationCascade(this);
});

When(/^I change Parent Location Category to "([^"]*)"$/, async function (this: CustomWorld, frdName: string) {
  this.location.entered.parentCategoryFrd = frdName;
  // A different Parent Location Category invalidates whatever Parent Location was chosen for the old one.
  this.location.entered.parentFrd = undefined;
  await this.pages.location.form.clearParentLocation().catch(() => undefined);
  await applyLocationCascade(this);
});

When(/^I keep Parent Location Category "([^"]*)"$/, async function (this: CustomWorld, frdName: string) {
  this.location.entered.parentCategoryFrd = frdName;
  await applyLocationCascade(this);
});

When(/^I select Parent Location "([^"]*)"$/, async function (this: CustomWorld, frdName: string) {
  const parent = await ensureLocation(this, frdName);
  if (this.location.entered.parentCategoryFrd === undefined) this.location.entered.parentCategoryFrd = parent.categoryFrd;
  this.location.entered.parentFrd = frdName;
  await applyLocationCascade(this);
});

When(/^I leave Parent Location blank$/, async function (this: CustomWorld) {
  await this.pages.location.form.clearParentLocation();
  this.location.entered.parentFrd = undefined;
});

When(/^I leave Parent Location Category and Parent Location (?:unselected|empty)$/, async function (this: CustomWorld) {
  await this.pages.location.form.clearParentLocation().catch(() => undefined);
  await this.pages.location.form.clearParentCategory().catch(() => undefined);
  this.location.entered.parentCategoryFrd = undefined;
  this.location.entered.parentFrd = undefined;
});

When(/^I fill the other fields with valid values$/, async function (this: CustomWorld) {
  await fillRemainingValidFields(this);
});

// "I click Save" is also used verbatim by features/location_category_features; that module's
// common.steps.ts (which registered the phrase first) dispatches to whichever form is actually open.

// ---------------------------------------------------------------------------
// Outcome (creation, update, deletion)
// ---------------------------------------------------------------------------

// "the toaster "X" should be displayed" is also used verbatim by features/location_category_features;
// that module's common.steps.ts tries both modules' message aliases and reports whichever is relevant.

Then(/^the save should be blocked(?: and the message "([^"]*)" should be displayed)?$/, async function (this: CustomWorld, message?: string) {
  expectSaveBlocked(this);
  if (message) await expectMessage(this, message);
});

Then(/^the save should be blocked and "([^"]*)" should be displayed$/, async function (this: CustomWorld, message: string) {
  expectSaveBlocked(this);
  await expectMessage(this, message);
});

Then(/^the save should be blocked with "([^"]*)"$/, async function (this: CustomWorld, message: string) {
  expectSaveBlocked(this);
  await expectMessage(this, message);
});

Then(/^the save should be blocked with a Region validation message$/, function (this: CustomWorld) {
  expectSaveBlocked(this);
  this.log(NO_REGION_FIELD);
});

Then(/^the save should be blocked with "([^"]*)" and "([^"]*)"$/, async function (this: CustomWorld, first: string, second: string) {
  expectSaveBlocked(this);
  await expectMessage(this, first);
  await expectMessage(this, second);
});

Then(/^the save should be blocked or the input should be limited to (\d+) characters$/, async function (this: CustomWorld, limit: string) {
  const outcome = this.location.lastOutcome;
  if (outcome?.kind === 'saved') {
    const record = (await this.pages.location.api.fetchMaster()).find((candidate) => candidate.id === outcome.call.id);
    const field = Number(limit) === 100 ? record?.name.length : record?.code.length;
    expect(field, `stored value is limited to ${limit} characters`).toBeLessThanOrEqual(Number(limit));
  } else {
    expectSaveBlocked(this);
  }
});

Then(/^no Location (?:should be created|with a \d+-character Name should be stored|should be created and no Location ID should be generated)$/, async function (this: CustomWorld) {
  await expectNoCreateThroughForm(this);
});

Then(/^no (?:new )?(?:\d+-character )?Short Name should be stored$/, async function (this: CustomWorld) {
  await expectNoCreateThroughForm(this);
});

Then(/^no new Location(?: or Location ID)? should be created$/, async function (this: CustomWorld) {
  await expectNoCreateThroughForm(this);
});

/** Nothing was created through the Add form of this scenario (fixtures are created with direct API calls, which the page does not see). */
export async function expectNoCreateThroughForm(world: CustomWorld): Promise<void> {
  const { api } = world.pages.location;
  const created = api.apiCalls.filter((call) => call.operation === 'Create' && call.status < 300 && !api.directIds.has(call.id ?? -1));
  expect(created.map((call) => call.id), 'no Location was created through the form').toEqual([]);
}

Then(/^the Location should be created$/, function (this: CustomWorld) {
  expect(successfulSaveId(this, 'Create')).toBeGreaterThan(0);
});

// "no error or exception should occur" and "the request should be rejected(?: with ...)?" are also used
// verbatim by features/location_category_features; that module's search-view.steps.ts / creation.steps.ts /
// location-association.steps.ts dispatch to whichever module's state applies.

/**
 * Shared with audit_log.feature (always skipped before this is ever reached there - see ./hooks.ts) and
 * location_deletion.feature's TC-Loc-108, a real scenario that reaches this step after a cancelled delete.
 * The MIDC build has no Activity Log screen for Location Management (confirmed via the same tab strip as
 * Location Category, which already established this), so this only probes and logs, never asserting a log
 * entry that cannot exist.
 */
When(/^I open the Activity Log (?:for "([^"]*)"|for the (?:deleted )?Location)$/, async function (this: CustomWorld, _name?: string) {
  const available = await this.pages.location.activityLog.isAvailable();
  this.location.scratch.activityLogAvailable = available;
  if (!available) this.log('No Activity Log screen exists in this build for Location Management.');
});
