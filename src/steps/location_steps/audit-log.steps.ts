/**
 * Steps of audit_log.feature (FRD 7, US-9 - Location Activity / Audit Log).
 *
 * The Location Category module (the same Organization Configuration tab strip: Department, Designation,
 * Location Category, Location, Office Category, Office, Position, Industrial Area) already confirmed it has
 * no Activity Log screen. Every scenario in this feature is skipped by the `@location and @audit_log` Before
 * hook in ./hooks.ts before any of these steps run; they are defined only so Cucumber has zero undefined
 * steps, and fail loudly (`unreachable`) if one is ever reached, which would mean the hook's premise stopped
 * holding. "I click Delete on ..." steps this feature shares verbatim with location_deletion.feature are
 * defined once, there, not duplicated here.
 */
import { Given, Then, When } from '@cucumber/cucumber';
import { unreachable } from './helpers';

// "I open the Activity Log for "X"" is also reached by location_deletion.feature's TC-Loc-108 (a real, never-
// skipped scenario), so it is implemented for real, in ./common.steps.ts, not as unreachable here.

Then(/^a "Location Created" entry should exist with User "([^"]*)", Date\/Time, Location ID, Name, Short Name and key creation attributes$/, function (_user: string) {
  return unreachable('a "Location Created" entry should exist');
});

Then(/^a "Location Updated" entry should exist with User, Date\/Time, Location ID$/, function () {
  return unreachable('a "Location Updated" entry should exist');
});

Then(/^a "Location Deleted" entry should exist with User, Date\/Time, Location ID and Name$/, function () {
  return unreachable('a "Location Deleted" entry should exist');
});

When(/^I check the log for a "Location Deleted" entry$/, function () {
  return unreachable('I check the log for a "Location Deleted" entry');
});

Then(/^a "Location Deletion Blocked" entry should exist with User, Date\/Time, Location ID, Name and Block Reason "([^"]*)"$/, function (_reason: string) {
  return unreachable('a "Location Deletion Blocked" entry should exist');
});

Then(/^no "Location Deleted" entry should be created for the blocked action$/, function () {
  return unreachable('no "Location Deleted" entry should be created for the blocked action');
});

Given(/^Location "([^"]*)" has been created, renamed and deleted in that order$/, function (_frdName: string) {
  return unreachable('Location "X" has been created, renamed and deleted in that order');
});

Then(/^the entries should be listed most recent first$/, function () {
  return unreachable('the entries should be listed most recent first');
});

// "the Activity Log has entries" and bare "I open the Activity Log" are also used verbatim by
// features/location_category_features; that module's audit-log.steps.ts already defines both (always
// skipped before either is reached here too).

When(/^I look for edit and delete controls$/, function () {
  return unreachable('I look for edit and delete controls');
});

When(/^I attempt PUT and DELETE on a log entry via API$/, function () {
  return unreachable('I attempt PUT and DELETE on a log entry via API');
});

Then(/^no edit or delete controls should be present$/, function () {
  return unreachable('no edit or delete controls should be present');
});

Then(/^the API modification attempts should be rejected$/, function () {
  return unreachable('the API modification attempts should be rejected');
});

Given(/^"([^"]*)" was deleted earlier$/, function (_frdName: string) {
  return unreachable('"X" was deleted earlier');
});

Given(/^the platform retention policy is enabled$/, function () {
  return unreachable('the platform retention policy is enabled');
});

When(/^I search the Activity Log for the deleted Location ID$/, function () {
  return unreachable('I search the Activity Log for the deleted Location ID');
});

Then(/^the historical entries \(Created, Updated, Deleted\) should remain retrievable for audit$/, function () {
  return unreachable('the historical entries should remain retrievable for audit');
});
