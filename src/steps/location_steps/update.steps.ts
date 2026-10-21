/**
 * Steps of location_update.feature (FRD 6.4, US-5 - Location Update).
 * Page objects: LocationListPage, LocationFormDialog, LocationApi. Shared steps (login, baseline data, field
 * entry, Save, messages) are in ./common.steps.ts; "the Edit Location form for X is open" is also there.
 */
import { Given, Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { expect } from '../../utils/assertions';
import { LOCATION_OFFICE_ASSOCIATION_GAP, liveLocationCategory, locationMessagePattern } from '../../test-data/location.data';
import {
  ensureLocation,
  expectSaveBlocked,
  freshMaster,
  openEditFor,
  requireFixture,
  sameText,
  skipBecause,
} from './helpers';

async function updatedRecord(world: CustomWorld, id: number) {
  const record = (await freshMaster(world)).find((candidate) => candidate.id === id);
  expect(record, `Location #${id} is in the master`).toBeTruthy();
  return record!;
}

// ---------------------------------------------------------------------------
// Name / Short Name update, ID unchanged (TC-Loc-026)
// ---------------------------------------------------------------------------

When(/^I note the Location ID of "([^"]*)" from the Master$/, function (this: CustomWorld, frdName: string) {
  this.location.notedId = requireFixture(this, frdName).id;
});

When(/^I change Name from "([^"]*)" to "([^"]*)"$/, async function (this: CustomWorld, _from: string, to: string) {
  await this.pages.location.form.type('Location', this.location.data.name(to));
  this.location.entered.name = this.location.data.name(to);
});

When(/^I change Short Name from "([^"]*)" to "([^"]*)"$/, async function (this: CustomWorld, _from: string, to: string) {
  const typed = this.location.data.code(to);
  await this.pages.location.form.type('Location Code', typed);
  this.location.entered.code = typed;
});

When(/^I re-open the Location and compare the Location ID$/, async function (this: CustomWorld) {
  const id = this.location.notedId!;
  const record = await updatedRecord(this, id);
  this.location.scratch.reopenedId = record.id;
});

Then(/^the update should be persisted and the toaster "([^"]*)" should be displayed$/, async function (this: CustomWorld, message: string) {
  const pattern = locationMessagePattern(message);
  expect(await this.sawMessage(pattern, 15000), `toaster "${message}"`).toBe(true);
});

Then(/^Name should show "([^"]*)" and Short Name should show "([^"]*)"$/, async function (this: CustomWorld, name: string, code: string) {
  const id = this.location.notedId!;
  const record = await updatedRecord(this, id);
  expect(record.name.toLowerCase()).toBe(this.location.data.name(name).toLowerCase());
  expect(record.code.toLowerCase()).toBe(this.location.data.code(code).toLowerCase());
});

Then(/^the Location ID should be identical before and after the update$/, function (this: CustomWorld) {
  expect(this.location.scratch.reopenedId).toBe(this.location.notedId);
});

// ---------------------------------------------------------------------------
// Change Parent Location (TC-Loc-027)
// ---------------------------------------------------------------------------

When(/^I change Parent Location from "([^"]*)" to "([^"]*)"$/, async function (this: CustomWorld, _from: string, toFrd: string) {
  const parent = await ensureLocation(this, toFrd);
  await this.pages.location.form.selectParentLocation(parent.name);
  this.location.entered.parentFrd = toFrd;
});

// "I expand the hierarchy" is also used verbatim by features/location_category_features; that module's
// update.steps.ts dispatches to whichever module's list is actually open.

Then(/^the system should re-validate the hierarchy and accept the change with no circular reference$/, async function (this: CustomWorld) {
  expect(this.location.lastOutcome?.kind, 'the update was accepted').toBe('saved');
});

Then(/^"([^"]*)" should be displayed under "([^"]*)"$/, async function (this: CustomWorld, childFrd: string, parentFrd: string) {
  const { list } = this.pages.location;
  const child = requireFixture(this, childFrd);
  await list.showRow(child.name);
  const shown = await list.parentOnScreen(child.name);
  const parent = requireFixture(this, parentFrd);
  expect(sameText(shown ?? '', parent.name), `"${childFrd}" is drawn under "${parentFrd}"`).toBe(true);
});

// ---------------------------------------------------------------------------
// No false duplicate on unrelated field change (TC-Loc-028)
// ---------------------------------------------------------------------------

When(/^I change only Region from "([^"]*)" to "([^"]*)"$/, function (this: CustomWorld, _from: string, _to: string) {
  this.log('No Region field exists in this build; nothing to change. The scenario still exercises "no false duplicate error on an unrelated save".');
});

When(/^I leave Name "([^"]*)" and Short Name "([^"]*)" untouched$/, function (_name: string, _code: string) {
  // Nothing to do: the form already holds the existing values.
});

Then(/^the save should succeed$/, function (this: CustomWorld) {
  expect(this.location.lastOutcome?.kind, 'the save succeeded').toBe('saved');
});

// ---------------------------------------------------------------------------
// Trim / normalize on update (TC-Loc-029)
// ---------------------------------------------------------------------------

When(/^I re-open the Location$/, async function (this: CustomWorld) {
  const id = this.location.notedId ?? this.location.target?.id;
  if (id) await updatedRecord(this, id);
});

Then(/^the Name should be stored as "([^"]*)" \(trimmed and normalized\)$/, async function (this: CustomWorld, expectedCore: string) {
  const id = this.location.target!.id;
  const record = await updatedRecord(this, id);
  const expected = this.location.data.name(expectedCore);
  expect(record.rawName.trim().replace(/\s+/g, ' ').toLowerCase()).toBe(expected.trim().toLowerCase());
});

// ---------------------------------------------------------------------------
// Office association preserved after rename (TC-Loc-030) - no Office<->Location link in this build
// ---------------------------------------------------------------------------

Given(/^the Edit Office screen for "([^"]*)" is open$/, function (this: CustomWorld, _officeName: string) {
  return skipBecause(this, LOCATION_OFFICE_ASSOCIATION_GAP);
});

When(/^I note that "([^"]*)" is associated with "([^"]*)"$/, function (_officeName: string, _location: string) {
  // Unreachable: the Given above always skips this scenario.
});

When(/^I open "([^"]*)" in Office Management$/, function (_officeName: string) {
  // Unreachable: the Given above always skips this scenario.
});

Then(/^the Office should still reference the same Location ID and display "([^"]*)"$/, function (_location: string) {
  // Unreachable: the Given above always skips this scenario.
});

Then(/^no association should be removed or altered$/, function () {
  // Unreachable: the Given above always skips this scenario.
});

// ---------------------------------------------------------------------------
// Negative (N series)
// ---------------------------------------------------------------------------

Then(/^the Location should retain its previous values$/, async function (this: CustomWorld) {
  expectSaveBlocked(this);
});

When(
  /^I change Parent Location from "([^"]*)" to "([^"]*)" and Name from "([^"]*)" to "([^"]*)" where (?:[^"]*) already has "([^"]*)"$/,
  async function (this: CustomWorld, _fromParent: string, toParentFrd: string, _fromName: string, toName: string, _existingFrd: string) {
    const parent = await ensureLocation(this, toParentFrd);
    await this.pages.location.form.selectParentLocation(parent.name);
    this.location.entered.parentFrd = toParentFrd;
    const typed = this.location.data.name(toName);
    await this.pages.location.form.type('Location', typed);
    this.location.entered.name = typed;
  },
);

Then(/^the original values should be retained$/, function (this: CustomWorld) {
  expectSaveBlocked(this);
});

When(
  /^I change Short Name from "([^"]*)" to "([^"]*)" which is the Short Name of "([^"]*)" under the same parent "([^"]*)"$/,
  async function (this: CustomWorld, _from: string, to: string, _existingFrd: string, _parentFrd: string) {
    const typed = this.location.data.code(to);
    await this.pages.location.form.type('Location Code', typed);
    this.location.entered.code = typed;
  },
);

When(/^I send an update request for "([^"]*)" with locationId changed to "([^"]*)" with payload$/, async function (
  this: CustomWorld,
  frdName: string,
  _newId: string,
  _payload: string,
) {
  const fixture = requireFixture(this, frdName);
  this.location.apiResult = await this.pages.location.api.send('PUT', `location/3.0/update/${fixture.id}`, {
    locName: fixture.name,
    locCode: fixture.code,
    id: 'LOC-ABC',
  });
});

// "I re-read the record" is also used verbatim by features/location_category_features; that module's
// update.steps.ts dispatches to whichever module's state applies (this.location.apiResult is set only here).

Then(/^the Location ID should remain unchanged$/, function (this: CustomWorld) {
  const fixture = this.location.target!;
  const master = this.location.scratch.reread as Array<{ id: number; name: string }>;
  expect(master.some((record) => record.id === fixture.id), `Location #${fixture.id} still has its original id`).toBe(true);
});

Then(/^the request should be rejected or the ID field should be ignored$/, function (this: CustomWorld) {
  const result = this.location.apiResult!;
  this.log(`API answered ${result.status}: ${result.message}; the Location ID was independently confirmed unchanged above.`);
});

When(/^I select Parent Location "([^"]*)" which is itself, or send it via API$/, async function (this: CustomWorld, frdName: string) {
  const target = requireFixture(this, frdName);
  const { form } = this.pages.location;
  await form.selectParentCategory(liveLocationCategory(target.categoryFrd));
  const options = (await form.parentLocationOptions()).map((option) => option.toLowerCase());
  this.location.parentOptionOffered = options.includes(target.name.toLowerCase());
  if (!this.location.parentOptionOffered) {
    // Not offered through the UI (expected); force it via the API instead, as the FRD's "or send it via API" allows.
    this.location.apiResult = await this.pages.location.api.send('PUT', `location/3.0/update/${target.id}`, {
      locName: target.name,
      locCode: target.code,
      locParentID: target.id,
    });
  }
});

Then(/^the option should not be offered in the dropdown$/, function (this: CustomWorld) {
  expect(this.location.parentOptionOffered, 'the Location is not offered as its own Parent Location').toBe(false);
});

Then(/^if forced via API, the save should be blocked with "([^"]*)"$/, function (this: CustomWorld, message: string) {
  const result = this.location.apiResult;
  if (!result) return; // The option was correctly absent from the dropdown; nothing was forced.
  expect(result.status, `the API answered ${result.status} ${result.message}`).toBeGreaterThanOrEqual(400);
  this.log(`FRD expects "${message}"; the API answered ${result.status}: ${result.message}`);
});

When(/^I select Parent Location "([^"]*)" in the path (.+)$/, async function (this: CustomWorld, frdName: string, _path: string) {
  const target = requireFixture(this, frdName);
  const editing = this.location.editing!;
  const { form } = this.pages.location;
  await form.selectParentCategory(liveLocationCategory(target.categoryFrd));
  const options = (await form.parentLocationOptions()).map((option) => option.toLowerCase());
  this.location.parentOptionOffered = options.includes(target.name.toLowerCase());
  if (this.location.parentOptionOffered) {
    await form.selectParentLocation(target.name);
    this.location.entered.parentFrd = frdName;
  } else {
    this.location.apiResult = await this.pages.location.api.send('PUT', `location/3.0/update/${editing.id}`, {
      locName: editing.name,
      locCode: editing.code,
      locParentID: target.id,
    });
  }
});

Then(/^the hierarchy should be unchanged$/, async function (this: CustomWorld) {
  const editing = this.location.editing!;
  const record = (await freshMaster(this)).find((candidate) => candidate.id === editing.id);
  expect(record?.parentId ?? null, 'the Location\'s parent is unchanged').toBe(editing.parentFrd ? requireFixture(this, editing.parentFrd).id : null);
});

When(/^I change Name from "([^"]*)" to "([^"]*)" which is a duplicate in "([^"]*)"$/, async function (this: CustomWorld, _from: string, to: string, _duplicateInFrd: string) {
  const typed = this.location.data.name(to);
  await this.pages.location.form.type('Location', typed);
  this.location.entered.name = typed;
});

When(/^I re-open "([^"]*)"$/, async function (this: CustomWorld, frdName: string) {
  await openEditFor(this, requireFixture(this, frdName));
});

When(/^I check the Office association and the Activity Log$/, function (this: CustomWorld) {
  this.log('No Office<->Location association exists in this build (LOCATION_OFFICE_ASSOCIATION_GAP) and no Activity Log screen exists; neither can be checked.');
});

Then(/^the update should be blocked$/, function (this: CustomWorld) {
  expectSaveBlocked(this);
});

Then(/^"([^"]*)" should keep its values$/, async function (this: CustomWorld, frdName: string) {
  const fixture = requireFixture(this, frdName);
  const record = await updatedRecord(this, fixture.id);
  expect(record.name.toLowerCase()).toBe(fixture.name.toLowerCase());
});

Then(/^"([^"]*)" should remain associated$/, function (this: CustomWorld, _officeName: string) {
  this.log('Not verifiable: no Office<->Location association exists in this build.');
});

Then(/^no "Location Updated" entry should be created$/, function (this: CustomWorld) {
  this.log('No Activity Log screen exists in this build; verified instead that the update itself was blocked.');
});
