/**
 * Steps of office_association.feature (FRD 6.5 - Office <-> Location association).
 *
 * Confirmed live: the Add/Edit Office form (Office *, Office Code *, Office Category *, Parent Category,
 * Parent Office) has no field referencing a Location at all; Office and Location are independent hierarchies
 * with no association to test (see LOCATION_OFFICE_ASSOCIATION_GAP). Every scenario in this feature is
 * skipped by the `@location and @office_association` Before hook in ./hooks.ts before any of these steps run;
 * they are defined only so Cucumber has zero undefined steps, and fail loudly (`unreachable`) if one is ever
 * reached, which would mean the hook's premise stopped holding. Declared parameter counts match each
 * regex's capture groups even though the bodies never run, so Cucumber's arity check never crashes in place
 * of the intended `unreachable` error if the hook's skip premise ever stops holding.
 */
import { Given, Then, When } from '@cucumber/cucumber';
import { unreachable } from './helpers';

Given(/^the Add Office screen is open$/, function () {
  return unreachable('the Add Office screen is open');
});

When(/^I open the Location lookup on the Add Office screen$/, function () {
  return unreachable('I open the Location lookup on the Add Office screen');
});

When(/^I compare the options to the Location Master$/, function () {
  return unreachable('I compare the options to the Location Master');
});

Then(/^the lookup should list the Locations from the Location Master \(same set of 12 records\)$/, function () {
  return unreachable('the lookup should list the Locations from the Location Master');
});

When(/^I create Office "([^"]*)" and select Location "([^"]*)"$/, function (_office: string, _location: string) {
  return unreachable('I create Office ... and select Location ...');
});

When(/^I check the stored association via DB\/API$/, function () {
  return unreachable('I check the stored association via DB/API');
});

Then(/^the association should store the Location ID of "([^"]*)"$/, function (_location: string) {
  return unreachable('the association should store the Location ID');
});

Then(/^no Location Name should be used as the reference$/, function () {
  return unreachable('no Location Name should be used as the reference');
});

When(/^I query the dependency check via API\/DB for Location "([^"]*)"$/, function (_location: string) {
  return unreachable('I query the dependency check via API/DB for Location');
});

Then(/^"([^"]*)" should return an Office dependency \(count >= 1\)$/, function (_location: string) {
  return unreachable('"X" should return an Office dependency');
});

Then(/^"([^"]*)" should return no Office dependency$/, function (_location: string) {
  return unreachable('"X" should return no Office dependency');
});

When(/^I change the Location from "([^"]*)" to "([^"]*)"$/, function (_from: string, _to: string) {
  return unreachable('I change the Location from X to Y');
});

When(/^I check the associations of "([^"]*)" and "([^"]*)"$/, function (_first: string, _second: string) {
  return unreachable('I check the associations of X and Y');
});

Then(/^the Office should be associated with "([^"]*)" only$/, function (_location: string) {
  return unreachable('the Office should be associated with X only');
});

Then(/^"([^"]*)" should have no associated Office$/, function (_location: string) {
  return unreachable('"X" should have no associated Office');
});

When(/^without logging out I open Add Office and open the Location lookup$/, function () {
  return unreachable('without logging out I open Add Office and open the Location lookup');
});

Then(/^"([^"]*)" should be available for selection immediately$/, function (_location: string) {
  return unreachable('"X" should be available for selection immediately');
});

When(/^I open Add Office and open the Location lookup$/, function () {
  return unreachable('I open Add Office and open the Location lookup');
});

Then(/^"([^"]*)" should not be listed in the lookup$/, function (_location: string) {
  return unreachable('"X" should not be listed in the lookup');
});

When(/^I try typing "([^"]*)" into the Location field$/, function (_text: string) {
  return unreachable('I try typing ... into the Location field');
});

When(/^I try saving the Office$/, function () {
  return unreachable('I try saving the Office');
});

Then(/^only lookup values should be selectable$/, function () {
  return unreachable('only lookup values should be selectable');
});

Then(/^the Office should not be saved with it$/, function () {
  return unreachable('the Office should not be saved with it');
});

When(/^I send a create-Office request with locationId "([^"]*)" with payload$/, function (_locationId: string, _payload: string) {
  return unreachable('I send a create-Office request with locationId ...');
});

Then(/^no orphan Office-Location association should be created$/, function () {
  return unreachable('no orphan Office-Location association should be created');
});
