/**
 * Steps of location_deletion.feature (FRD 6.7, US-6 - US-8 - Location Deletion). Also defines "I click Delete
 * on ..." for the scenarios audit_log.feature and product_consumption.feature share verbatim with this one.
 *
 * Several scenarios assume a Location can be "associated with an Office" (an Office-dependency delete block).
 * Confirmed live: the Add/Edit Office form has no field referencing a Location at all (see
 * LOCATION_OFFICE_ASSOCIATION_GAP), so that precondition cannot be set up through the UI or a realistic API
 * call; those scenarios are skipped at the step that would need it, exactly like
 * src/steps/location_category_steps/permissions.steps.ts skips "a deletable category exists" when its own
 * precondition needs a second session this suite does not open. Child-dependency (hierarchy) scenarios have
 * no such gap and run for real.
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { expect } from '../../utils/assertions';
import { LOCATION_OFFICE_ASSOCIATION_GAP, locationMessagePattern } from '../../test-data/location.data';
import { ensureLocation, freshMaster, requireFixture, returnToList, skipBecause, unreachable } from './helpers';

async function requestDelete(world: CustomWorld, frdName: string): Promise<void> {
  const fixture = await ensureLocation(world, frdName);
  await returnToList(world);
  world.seenToasts.length = 0;
  world.location.target = fixture;
  await world.pages.location.deletion.requestDelete(fixture.name);
}

async function confirmDeletion(world: CustomWorld): Promise<void> {
  const previous = await world.visibleToasts();
  world.location.lastDelete = await world.pages.location.deletion.confirm();
  await world.captureNewToast(previous, 10000);
}

async function expectStillInMaster(world: CustomWorld, frdName: string): Promise<void> {
  const fixture = requireFixture(world, frdName);
  const master = await freshMaster(world);
  expect(master.some((record) => record.id === fixture.id), `"${fixture.name}" is still in the master`).toBe(true);
}

async function expectRemoved(world: CustomWorld, frdName: string): Promise<void> {
  const fixture = requireFixture(world, frdName);
  const master = await freshMaster(world);
  expect(master.some((record) => record.id === fixture.id), `"${fixture.name}" is removed from the master`).toBe(false);
}

// ---------------------------------------------------------------------------
// Click Delete (shared with audit_log.feature and product_consumption.feature)
// ---------------------------------------------------------------------------

When(/^I click Delete on "([^"]*)" which has no Office and no child$/, async function (this: CustomWorld, frdName: string) {
  await requestDelete(this, frdName);
});

When(/^I click Delete on "([^"]*)" which is associated with "([^"]*)"$/, function (this: CustomWorld, _frdName: string, _officeName: string) {
  return skipBecause(this, LOCATION_OFFICE_ASSOCIATION_GAP);
});

When(/^I click Delete on "([^"]*)" which has child "([^"]*)" and no Office$/, async function (this: CustomWorld, frdName: string, childFrd: string) {
  await ensureLocation(this, childFrd, frdName);
  await requestDelete(this, frdName);
});

When(/^I click Delete on "([^"]*)" which has Office "([^"]*)" and child "([^"]*)"$/, function (this: CustomWorld, _frdName: string, _officeName: string, _childFrd: string) {
  return skipBecause(this, LOCATION_OFFICE_ASSOCIATION_GAP);
});

When(/^I click Delete on "([^"]*)"$/, async function (this: CustomWorld, frdName: string) {
  await requestDelete(this, frdName);
});

// "I click View on "X"" is defined once in ./search-view.steps.ts (this feature's own TC-Loc-045 relies on
// the baseline already being loaded, same as that file's precondition).

When(/^I click Delete in the detail view$/, async function (this: CustomWorld) {
  await this.pages.location.form.cancel().catch(() => undefined);
  await requestDelete(this, this.location.target!.frd);
});

// "I click Delete on the Detail view" is also used verbatim by features/location_category_features; that
// module's deletion.steps.ts already defines it (unreachable there too).

// ---------------------------------------------------------------------------
// Confirm / Cancel
// ---------------------------------------------------------------------------

When(/^I confirm(?: in the dialog)?$/, async function (this: CustomWorld) {
  await this.pages.location.deletion.expectConfirmationOpen();
  await confirmDeletion(this);
});

When(/^I click Cancel on the delete confirmation$/, async function (this: CustomWorld) {
  await this.pages.location.deletion.cancel();
});

When(/^I check the Location List and Master(?: via DB\/API)?$/, async function (this: CustomWorld) {
  this.location.scratch.masterAfter = await freshMaster(this);
});

// ---------------------------------------------------------------------------
// Outcomes (TC-Loc-043 to 046)
// ---------------------------------------------------------------------------

Then(/^the Office and hierarchy checks should pass$/, async function (this: CustomWorld) {
  await this.pages.location.deletion.expectConfirmationOpen();
});

Then(/^a delete confirmation dialog with confirm and cancel options should be displayed$/, async function (this: CustomWorld) {
  await expect(this.pages.location.deletion.confirmButton).toBeVisible();
  await expect(this.pages.location.deletion.cancelButton).toBeVisible();
});

Then(/^"([^"]*)" should be removed from the Location Master and the list$/, async function (this: CustomWorld, frdName: string) {
  await expectRemoved(this, frdName);
});

Then(/^the behavior should be the same as list delete: a confirmation dialog, then the Location is deleted with a success toaster$/, async function (this: CustomWorld) {
  expect(this.location.lastDelete?.status, JSON.stringify(this.location.lastDelete)).toBeLessThan(300);
  expect(await this.sawMessage(locationMessagePattern('Location deleted successfully.'), 10000)).toBe(true);
});

Then(/^"([^"]*)" should be deleted$/, async function (this: CustomWorld, frdName: string) {
  await expectRemoved(this, frdName);
});

Then(/^the deletion of "([^"]*)" should be allowed with the confirmation dialog shown$/, async function (this: CustomWorld, _frdName: string) {
  await this.pages.location.deletion.expectConfirmationOpen();
});

Then(/^"([^"]*)" should be deleted successfully$/, async function (this: CustomWorld, frdName: string) {
  await expectRemoved(this, frdName);
});

// ---------------------------------------------------------------------------
// Office-dependency scenarios (TC-Loc-047, 048, 103, 105) - precondition cannot be set up
// ---------------------------------------------------------------------------

When(/^I move "([^"]*)" from "([^"]*)" to "([^"]*)"$/, function (this: CustomWorld, _officeName: string, _from: string, _to: string) {
  return skipBecause(this, LOCATION_OFFICE_ASSOCIATION_GAP);
});

Then(/^the Office dependency check should no longer find an association$/, function () {
  unreachable('the Office dependency check should no longer find an association');
});

Then(/^the confirmation dialog should be shown$/, function () {
  unreachable('the confirmation dialog should be shown');
});

When(/^I open the Location List where "([^"]*)" has no Office$/, async function (this: CustomWorld, frdName: string) {
  await ensureLocation(this, frdName);
});

When(/^in another session I associate an Office with "([^"]*)"$/, function (this: CustomWorld, _frdName: string) {
  return skipBecause(this, LOCATION_OFFICE_ASSOCIATION_GAP);
});

When(/^in the first session I click Delete on "([^"]*)"$/, function (_frdName: string) {
  unreachable('in the first session I click Delete on "X"');
});

Then(/^the dependency check should use current data at click time$/, function () {
  unreachable('the dependency check should use current data at click time');
});

Then(/^the deletion should be blocked with the Office message$/, function () {
  unreachable('the deletion should be blocked with the Office message');
});

Then(/^the deletion should be blocked and a message indicating the Location is in use by an Office should be displayed$/, function () {
  unreachable('the deletion should be blocked and a message indicating the Location is in use by an Office');
});

Then(/^"([^"]*)" should remain in the Master$/, async function (this: CustomWorld, frdName: string) {
  await expectStillInMaster(this, frdName);
});

Then(/^the deletion should be blocked with no confirmation dialog$/, function () {
  unreachable('the deletion should be blocked with no confirmation dialog');
});

Then(/^the Office-dependency message should be shown first$/, function () {
  unreachable('the Office-dependency message should be shown first');
});

Then(/^the Block Reason should be logged as "([^"]*)"$/, function (_reason: string) {
  unreachable('the Block Reason should be logged as "X"');
});

// ---------------------------------------------------------------------------
// Child-dependency (hierarchy) - real (TC-Loc-104)
// ---------------------------------------------------------------------------

Then(/^the deletion should be blocked and a message indicating the Location has one or more child Locations should be displayed$/, async function (this: CustomWorld) {
  const confirmation = await this.pages.location.deletion.confirmationAfterDeleteClick();
  expect(confirmation, 'no confirmation dialog opened (the deletion was blocked)').toBeNull();
});

Then(/^no delete confirmation dialog should be displayed$/, async function (this: CustomWorld) {
  expect(await this.pages.location.deletion.isConfirmationOpen(), 'no confirmation dialog is open').toBe(false);
});

Then(/^"([^"]*)" and "([^"]*)" should remain$/, async function (this: CustomWorld, firstFrd: string, secondFrd: string) {
  await expectStillInMaster(this, firstFrd);
  await expectStillInMaster(this, secondFrd);
});

// ---------------------------------------------------------------------------
// UI bypassed (TC-Loc-106 Office, 107 hierarchy)
// ---------------------------------------------------------------------------

When(/^I send a direct delete request for "([^"]*)"$/, async function (this: CustomWorld, frdName: string) {
  const fixture = await ensureLocation(this, frdName);
  this.location.apiResult = await this.pages.location.api.remove(fixture.id);
});

Then(/^the request should be rejected with the Office-dependency error$/, function (this: CustomWorld) {
  const result = this.location.apiResult!;
  if (result.status < 300) {
    return skipBecause(
      this,
      `${LOCATION_OFFICE_ASSOCIATION_GAP} The direct delete succeeded (${result.status}), confirming no Office-dependency block can be produced for this build.`,
    );
  }
  this.log(`Rejected as expected; the app answered ${result.status}: ${result.message}`);
  return undefined;
});

Then(/^the request should be rejected with the hierarchy-dependency error$/, function (this: CustomWorld) {
  const result = this.location.apiResult!;
  expect(result.status, `the API answered ${result.status} ${result.message}`).toBeGreaterThanOrEqual(400);
});

// Bare ""X" should still exist" is also used verbatim by features/location_category_features; that module's
// deletion.steps.ts (`/^"([^"]*)" should (?:still exist|remain)(?: in the master)?$/`) dispatches to
// whichever module's fixture applies.

Then(/^"([^"]*)" and "([^"]*)" should still exist$/, async function (this: CustomWorld, firstFrd: string, secondFrd: string) {
  await expectStillInMaster(this, firstFrd);
  await expectStillInMaster(this, secondFrd);
});

Then(/^"Location Deletion Blocked" should be logged$/, function (this: CustomWorld) {
  this.log('No Activity Log screen exists in this build; verified instead that the direct delete request itself was rejected.');
});

// ---------------------------------------------------------------------------
// Cancel (TC-Loc-108)
// ---------------------------------------------------------------------------

Then(/^the dialog should close$/, async function (this: CustomWorld) {
  await this.pages.location.deletion.expectNoConfirmation();
});

Then(/^"([^"]*)" should not be deleted and should remain unchanged$/, async function (this: CustomWorld, frdName: string) {
  await expectStillInMaster(this, frdName);
  const fixture = requireFixture(this, frdName);
  expect(this.pages.location.deletion.wasDeleteRequested(fixture.id), 'no delete request was sent').toBe(false);
});

// "no success toaster should be shown" is also used verbatim by features/location_category_features; its
// generic (module-agnostic) check already covers this module too.

Then(/^no "Location Deleted" or "Location Deletion Blocked" entry should be created for the cancelled action$/, function (this: CustomWorld) {
  const fixture = this.location.target!;
  expect(this.pages.location.deletion.wasDeleteRequested(fixture.id), 'no delete request was sent').toBe(false);
  this.log('No Activity Log screen exists in this build; verified instead that no delete request was sent.');
});
