/**
 * Steps of region_audit_log.feature (Region Audit Log - TC-REG-070 to 081).
 * Page object: RegionActivityLogPage (TODO: verify locator once the Region module - and an Activity Log
 * screen for it - is developed; see that page object's own doc comment, modelled on
 * LocationCategoryActivityLogPage's "entry point probe" pattern but written as if a working screen exists,
 * per this feature file's own assumption).
 * Shared steps (login, fixtures, Office / Location association, delete, save) are in ./region_common.steps.ts
 * and ./region_deletion.steps.ts.
 */
import { Given, Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { regionPages, regionScenario } from '../../support/region-scenario';
import { expect } from '../../utils/assertions';
import { ensureRegion, openAddForm, submitForm, uniqueName } from './helpers';

/** Opens the log (scoped to one or two Regions when named) and records the entries for later assertions. */
When(
  /^an? "([^"]*)" opens the Activity Logs?(?: for (?:the Region|"([^"]*)"(?: and "([^"]*)")?))?$/,
  async function (this: CustomWorld, _role: string, first?: string, second?: string) {
    const names = [first, second].filter((name): name is string => Boolean(name));
    await regionPages(this).activityLog.open(names[0]);
    regionScenario(this).scratch.auditLogEntries = await regionPages(this).activityLog.entries();
    regionScenario(this).scratch.auditLogRegions = names;
  },
);

When(/^I create Region "([^"]*)"$/, async function (this: CustomWorld, name: string) {
  const { form } = regionPages(this);
  await openAddForm(this);
  const typed = uniqueName(this, name);
  await form.type(typed);
  const outcome = await submitForm(this);
  if (outcome.kind === 'saved') regionScenario(this).remember({ id: outcome.call.id!, frd: name, name: typed });
});

function entries(world: CustomWorld) {
  return (regionScenario(world).scratch.auditLogEntries ?? []) as Array<{
    action: string;
    user: string;
    dateTime: string;
    regionId: string;
    regionName: string;
    fieldChanged?: string;
    previousValue?: string;
    newValue?: string;
    reference?: string;
  }>;
}

function findEntry(world: CustomWorld, action: RegExp, regionName?: string) {
  return entries(world).find((entry) => action.test(entry.action) && (!regionName || entry.regionName.toLowerCase().includes(regionName.toLowerCase())));
}

Then(/^a "Region Created" entry should exist$/, function (this: CustomWorld) {
  expect(findEntry(this, /created/i), `a "Region Created" entry exists: ${JSON.stringify(entries(this))}`).toBeTruthy();
});

// Note: every "Then the entry should contain User, Date/Time, ..." variant (TC-REG-070, 071, 073, 075, 076)
// is already matched, in full, by the catch-all `^the entry should contain User.*$` registered in
// src/steps/location_category_steps/audit-log.steps.ts (it unconditionally throws there, reached only once
// that module's own un-skipped Activity Log scenarios need it); they are reused as-is, not redefined here -
// a dedicated step would be ambiguous with that one (see the PR description's "reused steps" table).

Then(/^a "Region Updated" entry should exist$/, function (this: CustomWorld) {
  expect(findEntry(this, /updated/i), `a "Region Updated" entry exists: ${JSON.stringify(entries(this))}`).toBeTruthy();
});

Then(/^the Field Changed should be "([^"]*)"$/, function (this: CustomWorld, field: string) {
  const entry = entries(this).find((candidate) => candidate.fieldChanged);
  expect(entry?.fieldChanged, `Field Changed is "${field}"`).toBe(field);
});

Then(/^the Previous Value should be "([^"]*)"$/, function (this: CustomWorld, value: string) {
  const entry = entries(this).find((candidate) => candidate.previousValue);
  expect(entry?.previousValue, `Previous Value is "${value}"`).toContain(value.split(' Bdd')[0]);
});

Then(/^the New Value should be "([^"]*)"$/, function (this: CustomWorld, value: string) {
  const entry = entries(this).find((candidate) => candidate.newValue);
  expect(entry?.newValue, `New Value is "${value}"`).toContain(value.split(' Bdd')[0]);
});

Then(/^a "Region Deleted" entry should exist$/, function (this: CustomWorld) {
  expect(findEntry(this, /deleted/i), `a "Region Deleted" entry exists: ${JSON.stringify(entries(this))}`).toBeTruthy();
});

Then(/^a "Region Deletion Blocked" entry should exist(?: for "([^"]*)")?$/, function (this: CustomWorld, name?: string) {
  expect(findEntry(this, /deletion blocked/i, name), `a "Region Deletion Blocked" entry exists: ${JSON.stringify(entries(this))}`).toBeTruthy();
});

Then(/^the entry should identify the Location dependency$/, function (this: CustomWorld) {
  const entry = findEntry(this, /deletion blocked/i);
  expect(entry?.reference, 'the entry identifies the blocking Location').toBeTruthy();
});

// ---------------------------------------------------------------------------
// Office / Location association logging (TC-REG-075 - 078)
// ---------------------------------------------------------------------------

When(/^I create Office "([^"]*)" and select Region "([^"]*)"$/, async function (this: CustomWorld, officeName: string, regionName: string) {
  await ensureRegion(this, regionName);
  regionScenario(this).offices.push({ name: uniqueName(this, officeName), regionFrd: regionName });
});

Then(/^a "Region Assigned to Office" entry should exist$/, function (this: CustomWorld) {
  expect(findEntry(this, /assigned to office/i), `a "Region Assigned to Office" entry exists: ${JSON.stringify(entries(this))}`).toBeTruthy();
});

Then(/^a "Region Removed from Office" entry should exist$/, function (this: CustomWorld) {
  expect(findEntry(this, /removed from office/i), `a "Region Removed from Office" entry exists: ${JSON.stringify(entries(this))}`).toBeTruthy();
});

Then(/^the "([^"]*)" log should have "([^"]*)" for "([^"]*)"$/, function (this: CustomWorld, regionName: string, action: string, reference: string) {
  const entry = findEntry(this, new RegExp(action.replace(/\s+/g, '\\s+'), 'i'), regionName);
  expect(entry, `the "${regionName}" log has a "${action}" entry: ${JSON.stringify(entries(this))}`).toBeTruthy();
  expect(entry!.reference ?? '', `"${action}" entry names "${reference}"`).toContain(reference.split(' Bdd')[0]);
});

Then(/^the change should be captured in the Activity Log with the Location reference$/, function (this: CustomWorld) {
  const entry = entries(this).find((candidate) => (candidate.reference ?? '').length > 0);
  expect(entry, `an entry carries a Location reference: ${JSON.stringify(entries(this))}`).toBeTruthy();
});

// ---------------------------------------------------------------------------
// Ordering and immutability (TC-REG-079, 080)
// ---------------------------------------------------------------------------

Given(
  /^Region "([^"]*)" has been created, renamed and then had a delete attempt blocked at different times$/,
  async function (this: CustomWorld, name: string) {
    const fixture = await ensureRegion(this, name);
    regionScenario(this).target = fixture;
  },
);

Then(/^the entries should be sorted in reverse-chronological order with the latest first$/, function (this: CustomWorld) {
  const log = entries(this);
  const parsed = log.map((entry) => Date.parse(entry.dateTime)).filter((value) => !Number.isNaN(value));
  for (let index = 1; index < parsed.length; index += 1) {
    expect(parsed[index - 1], 'entries are newest first').toBeGreaterThanOrEqual(parsed[index]);
  }
});

// Note: "When I open the Activity Log$" (TC-REG-080) is the bare phrase already registered, with identical
// text (optional "Location Category " prefix), by src/steps/location_category_steps/audit-log.steps.ts. That
// step unconditionally throws (it is only ever reached there once its own @audit_log scenarios are un-skipped
// by a real Activity Log screen); Region's own @region_audit_log tag is untouched by that module's
// Before-hook skip, so this scenario will fail loudly here instead of skipping gracefully until this step is
// re-pointed at Region's own RegionActivityLogPage - a known limitation of reusing a step this module's brief
// asks not to redefine (see the PR description's "reused steps" table).

Then(/^no edit or delete control should be available on any entry$/, async function (this: CustomWorld) {
  expect(await regionPages(this).activityLog.hasEditOrDeleteControls(), 'no edit/delete controls on any entry').toBe(false);
});

When(/^I attempt to modify or delete the "([^"]*)" entry through the API$/, async function (this: CustomWorld, action: string) {
  const entry = findEntry(this, new RegExp(action, 'i'));
  // TODO: Verify endpoint once the Region Activity Log is developed; guessed as region/3.0/activityLog/<id>.
  regionScenario(this).apiResult = await regionPages(this).api.send('DELETE', `region/3.0/activityLog/${entry?.regionId ?? ''}`);
});

Then(/^the API should reject the modification or deletion$/, function (this: CustomWorld) {
  const result = regionScenario(this).apiResult!;
  expect(result.status, `the API answered ${result.status} ${result.message}`).toBeGreaterThanOrEqual(400);
});

// Narrowed to "Region ..." text (not a bare `"([^"]*)"`) so this does not collide with the already-registered,
// identically-shaped `no "Location Updated" entry should be created$` in src/steps/location_steps/update.steps.ts.
Then(/^no "(Region [^"]*)" entry should be created$/, function (this: CustomWorld, action: string) {
  expect(findEntry(this, new RegExp(action, 'i')), `no "${action}" entry exists: ${JSON.stringify(entries(this))}`).toBeFalsy();
});

// region_audit_log.feature's own "I click "Cancel"" (bare, distinct from region_deletion's "I click "Cancel" on
// the confirmation prompt") - both exist as literal step text in the FRD.
When(/^I click "Cancel"$/, async function (this: CustomWorld) {
  await regionPages(this).deletion.cancel();
});
