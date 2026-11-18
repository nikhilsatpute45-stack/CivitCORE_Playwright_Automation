/**
 * Audit Trail steps shared by more than one feature file in features/audit_trail_features. Cucumber step text is global, so a step used
 * by several features is defined once, here; steps used by a single feature live in that feature's own step file.
 *
 * NOT redefined here (already registered, once, in src/steps/shared_steps/shared.steps.ts and routed to ./shared_handlers.steps.ts):
 * "the following test data is used", "API client authenticated with the token ...", "<User> (...) is logged in" and
 * "Request is rejected (403[/405]); ...".
 */
import { Given, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { auditPages, auditScenario } from '../../support/audit-trail-scenario';
import { config } from '../../support/config';
import { SKIP, featureDateToIso, formatDate, parseFeatureDate } from '../../test-data/audit-trail.data';
import { expect } from '../../utils/assertions';
import {
  clickSearch,
  logInAs,
  openAuditTrail,
  readStore,
  requireBaseline,
  requireDestructive,
  runDateText,
  runIso,
  setRange,
  skipBecause,
  withTc,
  type Skippable,
} from './helpers';

/** A date literal as the features write it (DD-Mon-YYYY). */
const D = '(\\d{2}-[A-Za-z]{3}-\\d{4})';
const re = (pattern: string): RegExp => new RegExp(`^${pattern}$`);

// ---------------------------------------------------------------------------
// Background: users, baseline, "today"
// ---------------------------------------------------------------------------

Given(/^Viewer_User1 has Audit Trail open$/, async function (this: CustomWorld): Skippable {
  const skipped = await logInAs(this, 'Viewer_User1');
  return skipped ?? openAuditTrail(this);
});

Given(/^Admin user with Role Management access is logged in$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.roleManagement);
});

Given(
  /^(?:Admin user configures the role of NoAccess_User1 in Role Management|NoAccess_User1 currently has no Audit Trail right|Admin removes 'View Audit Trail' from Viewer_User1's role)$/,
  async function (this: CustomWorld): Skippable {
    return skipBecause(this, SKIP.roleManagement);
  },
);

Given(/^Baseline audit data \(see Summary\) is loaded$/, function (this: CustomWorld): 'skipped' | undefined {
  return requireBaseline(this);
});

Given(/^Baseline contains Department entry dated 01-Jan-2025 08:00:00 \(older than 400 days\)$/, function (this: CustomWorld): 'skipped' | undefined {
  return requireBaseline(this);
});

Given(
  /^Only entries dated 05-Sep-2026 to 25-Sep-2026 exist in the Audit Trail \(test environment seeded accordingly\)$/,
  function (this: CustomWorld): 'skipped' {
    return skipBecause(this, SKIP.customSeed);
  },
);

Given(
  /^Backend configuration and the inventory of CRUD functions of CivitCORE and applicable Civit products are accessible to the tester$/,
  function (this: CustomWorld): 'skipped' {
    return skipBecause(this, SKIP.backendAccess);
  },
);

Given(/^Today \(T\) = (\d{2}-[A-Za-z]{3}-\d{4})$/, function (this: CustomWorld, featureToday: string) {
  // The workbook's T is a fixed date; every date literal is shifted so that T becomes the real run date (see audit-trail.data.ts).
  const scenario = auditScenario(this);
  this.log(`Feature T = ${featureToday}; running with T = ${formatDate(scenario.today)}. Dates are shifted accordingly.`);
});

Given(re(`System date is set to ${D}`), async function (this: CustomWorld, literal: string) {
  const date = parseFeatureDate(literal);
  if (!date) throw new Error(`"${literal}" is not a valid date.`);
  const scenario = auditScenario(this);
  scenario.today = date;
  scenario.literalDates = true;
  scenario.clockDate = date;
  // Only the BROWSER clock moves; the server clock cannot be changed from here (SKIP.systemClock).
  await this.page.clock.setFixedTime(date);
  this.log(`Browser clock fixed at ${literal}. ${SKIP.systemClock}`);
});

Given(/^Audit Trail screen is open with default filters$/, async function (this: CustomWorld): Skippable {
  return openAuditTrail(this);
});

// ---------------------------------------------------------------------------
// Navigation
// ---------------------------------------------------------------------------

When(/^Login to CivitCORE as Admin_User1$/, async function (this: CustomWorld): Skippable {
  return logInAs(this, 'Admin_User1');
});

When(
  /^(?:Navigate to Audit Trail(?: \(default filters\))?|Open the Audit Trail screen|Open Audit Trail(?: with default filters)?)$/,
  async function (this: CustomWorld): Skippable {
    return openAuditTrail(this);
  },
);

When(/^Open Audit Trail and filter Function 'Office' for today$/, async function (this: CustomWorld): Skippable {
  const skipped = await openAuditTrail(this);
  if (skipped) return skipped;
  await auditPages(this).filters.selectFunction('Office');
  await clickSearch(this);
  return undefined;
});

When(/^Immediately open Audit Trail and Search$/, async function (this: CustomWorld): Skippable {
  const skipped = await openAuditTrail(this);
  if (skipped) return skipped;
  await clickSearch(this);
  return undefined;
});

When(/^Open Audit Trail, change filters and click Search several times$/, async function (this: CustomWorld): Skippable {
  const skipped = await openAuditTrail(this);
  if (skipped) return skipped;
  const { filters } = auditPages(this);
  for (const name of ['Department', 'Post', 'All']) {
    await filters.selectFunction(name);
    await clickSearch(this);
  }
  return undefined;
});

When(/^Open Audit Trail and review all available row\/screen actions$/, async function (this: CustomWorld): Skippable {
  const skipped = await openAuditTrail(this);
  if (skipped) return skipped;
  auditScenario(this).scratch.rowActions = await auditPages(this).list.hasRowActions();
  return undefined;
});

When(/^(?:Inspect the navigation menu for Audit Trail|Look for Audit Trail in the menu)$/, async function (this: CustomWorld): Skippable {
  const skipped = await (auditScenario(this).user ? Promise.resolve(undefined) : logInAs(this, 'Admin_User1'));
  if (skipped) return skipped;
  auditScenario(this).menuVisible = await auditPages(this).list.isMenuEntryVisible();
  return undefined;
});

When(/^(?:Enter the Audit Trail screen URL directly in the browser|Open the Audit Trail URL directly)$/, async function (this: CustomWorld): Skippable {
  if (!config.auditTrail.url) return skipBecause(this, 'AUDIT_TRAIL_URL is not set, so there is no direct URL to open (the FRD does not state one).');
  const { list } = auditPages(this);
  await list.openUrl(config.auditTrail.url);
  auditScenario(this).directAccess = { displayed: await list.isScreenDisplayed(8000) };
  return undefined;
});

// ---------------------------------------------------------------------------
// Observation steps: they only describe where the tester looks; the Then step asserts what is there.
// ---------------------------------------------------------------------------

When(
  /^(?:Observe (?:the screen that loads|the Audit Trail listing|the listing|the block|the validation error|the Audit Log grid without changing any filter)|Inspect (?:the action area next to Search|the toolbar next to Search|the Clear Log action|a grid row|the Search action state(?: without changing any filter)?|for action icons, menus or an Actions column)|Check the response(?: and audit store integrity)?|Compare (?:both lists|it with To Date)|Confirm it is not shifted to the previous Friday or the next Monday|Check the entries at .+|Locate the new entry|Open (?:the new audit entry|both audit entries))$/,
  function () {
    // Nothing to do: the following Then step reads the screen.
  },
);

When(/^Read (?!the backend|the (?:Function Name|Log Date & Time|Class Name|Client IP|Message) of the )(.+)$/, function (this: CustomWorld, what: string) {
  auditScenario(this).scratch.read = what;
});

When(/^Hover over and right-click grid rows$/, async function (this: CustomWorld): Skippable {
  const { list } = auditPages(this);
  auditScenario(this).scratch.rowActions = await list.hasRowActions();
  return undefined;
});

// ---------------------------------------------------------------------------
// Filters
// ---------------------------------------------------------------------------

When(/^Select Function '([^']*)'(?: \(do not need to Search\))?$/, async function (this: CustomWorld, name: string) {
  await auditPages(this).filters.selectFunction(name);
});

When(/^(?:Select|Apply) Function '([^']*)' and click Search$/, async function (this: CustomWorld, name: string) {
  await auditPages(this).filters.selectFunction(name);
  await clickSearch(this);
});

When(/^As Viewer_User1 select Function 'Office' and click Search \(or refresh the screen\)$/, async function (this: CustomWorld) {
  await auditPages(this).filters.selectFunction('Office');
  await clickSearch(this);
});

When(/^Change Functions (?:from 'All' )?to '([^']*)'(?: \(Search becomes active\))?$/, async function (this: CustomWorld, name: string) {
  await auditPages(this).filters.selectFunction(name);
});

When(/^Keep Function = All and click Search$/, async function (this: CustomWorld) {
  await auditPages(this).filters.selectFunction('All');
  await clickSearch(this);
});

When(/^Click Search(?: \(or use the default view\))?$/, async function (this: CustomWorld) {
  await clickSearch(this);
});

When(/^Click Search after setting Function = (.+)$/, async function (this: CustomWorld, name: string) {
  await auditPages(this).filters.selectFunction(name);
  await clickSearch(this);
});

When(re(`Set From Date = ${D}(?: \\(future\\))?`), async function (this: CustomWorld, from: string) {
  await setRange(this, from);
});

When(re(`Set To Date = ${D}(?: \\(T \\+ 1\\))?`), async function (this: CustomWorld, to: string) {
  await setRange(this, undefined, to);
});

When(re(`Set From Date = ${D} and To Date = ${D}`), async function (this: CustomWorld, from: string, to: string) {
  await setRange(this, from, to);
});

When(re(`Set To Date = ${D} and From Date = ${D}`), async function (this: CustomWorld, to: string, from: string) {
  await setRange(this, from, to);
});

When(re(`Set To Date = ${D} first, then set From Date = ${D}`), async function (this: CustomWorld, to: string, from: string) {
  await setRange(this, undefined, to);
  await setRange(this, from);
});

When(re(`Change From Date (?:from ${D} )?to ${D}`), async function (this: CustomWorld, _previous: string | undefined, from: string) {
  await setRange(this, from);
});

When(re(`Change To Date (?:from ${D} )?to ${D}`), async function (this: CustomWorld, _previous: string | undefined, to: string) {
  await setRange(this, undefined, to);
});

When(re(`Change From Date to ${D} and To Date to ${D}(?: \\(do NOT click Search\\))?`), async function (this: CustomWorld, from: string, to: string) {
  await setRange(this, from, to);
});

When(/^Type (From|To) Date = '?([^' ]+)'?(?: \(.+\))?$/, async function (this: CustomWorld, which: string, text: string) {
  // Typed verbatim (after date shifting): a non-existent / incomplete / non-date value is the point of these scenarios.
  const { filters } = auditPages(this);
  if (which === 'From') await filters.setFromDate(runDateText(this, text));
  else await filters.setToDate(runDateText(this, text));
});

When(/^Clear (?:the )?From Date(?: field)?$/, async function (this: CustomWorld) {
  await auditPages(this).filters.clearFromDate();
});

When(/^Clear (?:the )?To Date(?: field)?$/, async function (this: CustomWorld) {
  await auditPages(this).filters.clearToDate();
});

When(/^Clear From Date and To Date$/, async function (this: CustomWorld) {
  const { filters } = auditPages(this);
  await filters.clearFromDate();
  await filters.clearToDate();
});

When(re(`Keep From Date = ${D} and To Date = ${D}`), async function (this: CustomWorld, from: string, to: string) {
  const { filters } = auditPages(this);
  expect(await filters.fromValue(), withTc(this, 'From Date keeps its default')).toBe(runDateText(this, from));
  expect(await filters.toValue(), withTc(this, 'To Date keeps its default')).toBe(runDateText(this, to));
});

When(re(`Keep To Date = ${D}`), async function (this: CustomWorld, to: string) {
  expect(await auditPages(this).filters.toValue(), withTc(this, 'To Date keeps its default')).toBe(runDateText(this, to));
});

When(/^Keep the default range$/, function () {
  // Nothing to do: the default range stays as it is.
});

When(re(`Confirm To Date = ${D}`), async function (this: CustomWorld, to: string) {
  expect(await auditPages(this).filters.toValue(), withTc(this, 'To Date is today')).toBe(runDateText(this, to));
});

When(/^Click the Functions control$|^Click inside the Functions control$/, async function (this: CustomWorld) {
  await auditPages(this).filters.functions.click();
});

When(/^Open the Functions dropdown$/, async function (this: CustomWorld) {
  auditScenario(this).scratch.functionOptions = await auditPages(this).filters.functionOptions();
});

When(/^Try typing '([^']*)' using the keyboard$/, async function (this: CustomWorld, text: string) {
  const { filters } = auditPages(this);
  auditScenario(this).scratch.functionBefore = await filters.selectedFunction();
  await filters.typeIntoFunctions(text);
});

When(/^Type '([^']*)' and press Enter$/, async function (this: CustomWorld, text: string) {
  const { filters } = auditPages(this);
  auditScenario(this).scratch.functionBefore = await filters.selectedFunction();
  await filters.typeIntoFunctions(text, true);
});

When(/^Look for a blank\/none option or attempt to clear the selection$/, async function (this: CustomWorld) {
  const { filters } = auditPages(this);
  await filters.functions.click({ timeout: 3000 }).catch(() => undefined);
  await this.page.keyboard.press('Backspace');
  await this.page.keyboard.press('Delete');
  await this.page.keyboard.press('Escape');
});

// ---------------------------------------------------------------------------
// Clear Log (destructive on confirm: gated by AUDIT_TRAIL_ALLOW_DESTRUCTIVE)
// ---------------------------------------------------------------------------

/** Clicks Clear Log and records whether a confirmation dialog opened or a validation message blocked it. */
async function clickClearLog(world: CustomWorld): Promise<void> {
  const { filters, dialog } = auditPages(world);
  await filters.clickClearLog();
  auditScenario(world).clearOutcome = (await dialog.isOpen(3000)) ? 'dialog-open' : 'blocked';
}

/** Confirms the open dialog and keeps the toast it raises for the Then steps. */
async function confirmClearLog(world: CustomWorld): Promise<void> {
  const { dialog } = auditPages(world);
  await dialog.expectOpen();
  const before = await world.visibleToasts();
  await dialog.confirm();
  await world.captureNewToast(before);
  auditScenario(world).clearOutcome = 'confirmed';
  await auditPages(world).list.waitForListing().catch(() => undefined);
}

When(/^Click Clear Log$/, async function (this: CustomWorld) {
  await clickClearLog(this);
});

When(/^Click Clear Log and confirm$/, async function (this: CustomWorld): Skippable {
  const skipped = requireDestructive(this);
  if (skipped) return skipped;
  await clickClearLog(this);
  await confirmClearLog(this);
  return undefined;
});

When(re(`Clear Log for ${D} to ${D} and confirm`), async function (this: CustomWorld, from: string, to: string): Skippable {
  const skipped = requireDestructive(this);
  if (skipped) return skipped;
  await setRange(this, from, to);
  await clickClearLog(this);
  await confirmClearLog(this);
  return undefined;
});

When(/^Click Confirm$/, async function (this: CustomWorld): Skippable {
  const skipped = requireDestructive(this);
  if (skipped) return skipped;
  await confirmClearLog(this);
  return undefined;
});

When(/^Double-click Confirm quickly$/, async function (this: CustomWorld): Skippable {
  const skipped = requireDestructive(this);
  if (skipped) return skipped;
  const { dialog } = auditPages(this);
  await dialog.expectOpen();
  const before = await this.visibleToasts();
  await dialog.doubleClickConfirm();
  await this.captureNewToast(before);
  auditScenario(this).clearOutcome = 'confirmed';
  return undefined;
});

When(/^Click Cancel in the dialog$/, async function (this: CustomWorld) {
  await auditPages(this).dialog.cancel();
  auditScenario(this).clearOutcome = 'cancelled';
});

When(/^Set a valid range and click Clear Log$/, async function (this: CustomWorld) {
  await setRange(this, '01-Sep-2026', '30-Sep-2026');
  await clickClearLog(this);
});

When(/^Set a valid range, click Clear Log and then Cancel$/, async function (this: CustomWorld) {
  await setRange(this, '01-Sep-2026', '30-Sep-2026');
  await clickClearLog(this);
  await auditPages(this).dialog.cancel();
  auditScenario(this).clearOutcome = 'cancelled';
});

When(/^Close the dialog using X, then repeat and press Esc$/, async function (this: CustomWorld) {
  const { dialog } = auditPages(this);
  await dialog.closeWithIcon();
  await dialog.expectClosed();
  await clickClearLog(this);
  await dialog.closeWithEscape();
  await dialog.expectClosed();
  auditScenario(this).clearOutcome = 'cancelled';
});

// ---------------------------------------------------------------------------
// Audit store reads (API). TODO(endpoint): see AuditTrailApi.
// ---------------------------------------------------------------------------

When(
  /^(?:While the dialog is open, query|Query) the (?:Audit Trail \/ )?audit store(?: \(DB\/API\))?(?: for the new entry| for the Clear Log entry| for Clear Log events| and view the listing)?$/,
  async function (this: CustomWorld) {
    await readStore(this);
  },
);

When(re(`Query the audit store for entries dated ${D} to ${D}`), async function (this: CustomWorld, from: string, to: string) {
  await readStore(this, 'All', runIso(this, featureDateToIso(from)), runIso(this, featureDateToIso(to)));
});

When(/^Query the audit store for entries at .+$/, async function (this: CustomWorld) {
  await readStore(this);
});

When(/^Query Clear Log events and observe toasters$/, async function (this: CustomWorld) {
  await readStore(this);
});

When(/^Note the count of entries in the audit store$/, async function (this: CustomWorld) {
  auditScenario(this).notedCount = (await readStore(this)).length;
});

When(/^Re-count entries$/, async function (this: CustomWorld) {
  auditScenario(this).scratch.recount = (await readStore(this)).length;
});

When(/^Note the (?:currently displayed grid|7 default entries)$/, async function (this: CustomWorld) {
  auditScenario(this).snapshot = await auditPages(this).list.rows();
});

When(/^Read the (Function Name|Log Date & Time|Class Name|Client IP|Message) of the (\d{2}-[A-Za-z]{3}-\d{4} \d{2}:\d{2}) entry$/, function (this: CustomWorld, column: string, when: string) {
  auditScenario(this).scratch.readColumn = column;
  auditScenario(this).scratch.readEntryAt = when;
});

/** FRD notes the workbook leaves inside the scenarios ("Note: ...", "See Notes: ..."); they document an ambiguity and assert nothing. */
When(/^(?:See )?Notes?: .+$/, function () {
  // Documentation only.
});
