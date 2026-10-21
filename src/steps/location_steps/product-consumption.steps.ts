/**
 * Steps of product_consumption.feature (FRD 6.6 - CivitBUILD / CivitINFRA consumption of Location).
 *
 * Confirmed live: CivitBUILD and CivitINFRA are not reachable from this portal at all (no link, menu entry
 * or URL for either product anywhere, and no credentials for them are configured). Every scenario in this
 * feature is skipped by the `@location and @product_consumption` Before hook in ./hooks.ts before any of
 * these steps run; they are defined only so Cucumber has zero undefined steps, and fail loudly
 * (`unreachable`) if one is ever reached. Declared parameter counts match each regex's capture groups even
 * though the bodies never run, so Cucumber's arity check never crashes in place of the intended
 * `unreachable` error if the hook's skip premise ever stops holding.
 */
import { Given, Then, When } from '@cucumber/cucumber';
import { unreachable } from './helpers';

Given(/^"([^"]*)" has access to CivitBUILD$/, function (_user: string) {
  return unreachable('"X" has access to CivitBUILD');
});

When(/^in CivitBUILD I open a feature that uses Location and select "([^"]*)"$/, function (_location: string) {
  return unreachable('in CivitBUILD I open a feature that uses Location and select "X"');
});

When(/^I inspect the stored reference via DB\/API$/, function () {
  return unreachable('I inspect the stored reference via DB/API');
});

When(/^I repeat the same check in CivitINFRA$/, function () {
  return unreachable('I repeat the same check in CivitINFRA');
});

Then(/^the stored reference should be the Location ID of "([^"]*)", not its Name or Short Name$/, function (_location: string) {
  return unreachable('the stored reference should be the Location ID of "X"');
});

When(/^I open the Location selection in CivitBUILD$/, function () {
  return unreachable('I open the Location selection in CivitBUILD');
});

Then(/^"([^"]*)" should be available for reference in both CivitBUILD and CivitINFRA with the same Location ID$/, function (_location: string) {
  return unreachable('"X" should be available for reference in both CivitBUILD and CivitINFRA');
});

Then(/^no product-level re-creation should be needed$/, function () {
  return unreachable('no product-level re-creation should be needed');
});

When(/^I rename "([^"]*)" to "([^"]*)" in CivitCORE$/, function (_from: string, _to: string) {
  return unreachable('I rename "X" to "Y" in CivitCORE');
});

When(/^I open the CivitBUILD screen that displays Nashik's Location$/, function () {
  return unreachable("I open the CivitBUILD screen that displays Nashik's Location");
});

Then(/^both CivitBUILD and CivitINFRA should show the current CivitCORE value "([^"]*)"$/, function (_value: string) {
  return unreachable('both CivitBUILD and CivitINFRA should show the current CivitCORE value "X"');
});

Then(/^the reference should still point to the same Location ID$/, function () {
  return unreachable('the reference should still point to the same Location ID');
});

When(/^in CivitBUILD I reference "([^"]*)" which has no Office and no child$/, function (_location: string) {
  return unreachable('in CivitBUILD I reference "X" which has no Office and no child');
});

When(/^in CivitCORE I click Delete on "([^"]*)"$/, function (_location: string) {
  return unreachable('in CivitCORE I click Delete on "X"');
});

When(/^I confirm the dialog$/, function () {
  return unreachable('I confirm the dialog');
});

Then(/^the delete confirmation dialog should be displayed and the Location should be deleted$/, function () {
  return unreachable('the delete confirmation dialog should be displayed and the Location should be deleted');
});

Then(/^consumption by a product should not block deletion$/, function () {
  return unreachable('consumption by a product should not block deletion');
});

When(/^I open the Location selection in CivitBUILD and CivitINFRA or call the Location lookup API$/, function () {
  return unreachable('I open the Location selection in CivitBUILD and CivitINFRA or call the Location lookup API');
});

Then(/^"([^"]*)" should not be available for new product references in either product$/, function (_location: string) {
  return unreachable('"X" should not be available for new product references in either product');
});

Then(/^lookup by its ID should return not found$/, function () {
  return unreachable('lookup by its ID should return not found');
});

When(/^in CivitBUILD I configure a product-specific setting for "([^"]*)"$/, function (_location: string) {
  return unreachable('in CivitBUILD I configure a product-specific setting for "X"');
});

When(/^I inspect the CivitCORE Location Master record for "([^"]*)" via DB\/API$/, function (_location: string) {
  return unreachable('I inspect the CivitCORE Location Master record for "X" via DB/API');
});

Then(/^the Location Master record should contain no product-specific fields or values$/, function () {
  return unreachable('the Location Master record should contain no product-specific fields or values');
});

Then(/^the setting should be stored in CivitBUILD$/, function () {
  return unreachable('the setting should be stored in CivitBUILD');
});

Given(/^an API client is authenticated for "([^"]*)"$/, function (_product: string) {
  return unreachable('an API client is authenticated for "CivitBUILD"');
});

When(/^I attempt to create Location "([^"]*)" via a CivitBUILD endpoint$/, function (_location: string) {
  return unreachable('I attempt to create Location "X" via a CivitBUILD endpoint');
});

Then(/^no product-local Location should be created$/, function () {
  return unreachable('no product-local Location should be created');
});

Then(/^the product should only be able to reference CivitCORE Locations by Location ID$/, function () {
  return unreachable('the product should only be able to reference CivitCORE Locations by Location ID');
});
