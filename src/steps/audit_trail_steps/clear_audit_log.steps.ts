/**
 * Steps of features/audit_trail_features/clear_audit_log.feature (Clear Log validation, confirmation, cancel, range semantics).
 * Everything that confirms a Clear Log is destructive and gated by AUDIT_TRAIL_ALLOW_DESTRUCTIVE (see common.steps.ts); the outcome
 * assertions read the audit store through the API (TODO(endpoint)) and match entries against the workbook baseline (#1-#14).
 */
import { Then } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { auditPages, auditScenario } from '../../support/audit-trail-scenario';
import { AUDIT_MESSAGES, DEFAULT_FUNCTION } from '../../test-data/audit-trail.data';
import { expect } from '../../utils/assertions';
import { ALL_BASELINE, exact, expectBaselineState, isClearLogEntry, readStore, sameDate, withTc } from './helpers';

/** Baseline entries of the 01-Sep..30-Sep Clear Log range (#9 Office, #10 Department, #11 Standards & Formats). */
const IN_RANGE = [9, 10, 11];
const OUTSIDE_RANGE = ALL_BASELINE.filter((no) => !IN_RANGE.includes(no));

// ---------------------------------------------------------------------------
// Confirmation dialog
// ---------------------------------------------------------------------------

Then(exact('Date range is validated successfully.'), async function (this: CustomWorld) {
  expect(auditScenario(this).clearOutcome, withTc(this, 'the range passed validation and the dialog opened')).toBe('dialog-open');
  expect(await auditPages(this).filters.validationMessages(), withTc(this, 'no validation message is displayed')).toHaveLength(0);
});

Then(
  exact('A confirmation dialog is displayed stating that audit log entries within the selected date range will be cleared.'),
  async function (this: CustomWorld) {
    const { dialog } = auditPages(this);
    await dialog.expectOpen();
    const text = await dialog.text();
    // The FRD gives no exact wording (gap 6(c)): the dialog must at least say it clears audit log entries for the selected range.
    expect(text, withTc(this, `the dialog speaks of clearing audit log entries ("${text}")`)).toMatch(/clear/i);
    expect(text, withTc(this, 'the dialog mentions the selected date range')).toMatch(/range|between|from/i);
  },
);

Then(exact('No entry is removed before confirmation.'), async function (this: CustomWorld) {
  await expectBaselineState(this, ALL_BASELINE, []);
});

Then(
  exact('All entries are still present while the confirmation dialog is open; removal only occurs after the user confirms.'),
  async function (this: CustomWorld) {
    await auditPages(this).dialog.expectOpen();
    await expectBaselineState(this, ALL_BASELINE, []);
  },
);

// ---------------------------------------------------------------------------
// Validation (Clear Log uses the same rules as Search)
// ---------------------------------------------------------------------------

Then(/^Operation is blocked with validation message '([^']*)'(?: \(consistent with Search\))?\.$/, async function (this: CustomWorld, message: string) {
  expect(await auditPages(this).filters.messageIsVisible(message), withTc(this, `the validation message "${message}" is displayed`)).toBe(true);
  expect(auditScenario(this).clearOutcome, withTc(this, 'no confirmation dialog opened')).toBe('blocked');
});

Then(exact('No confirmation dialog; no entries removed.'), async function (this: CustomWorld) {
  expect(await auditPages(this).dialog.isOpen(500), withTc(this, 'no confirmation dialog is displayed')).toBe(false);
  await expectBaselineState(this, ALL_BASELINE, []);
});

Then(exact('No entries removed.'), async function (this: CustomWorld) {
  await expectBaselineState(this, ALL_BASELINE, []);
});

Then(exact('No Clear Log entry is recorded because the operation was blocked.'), async function (this: CustomWorld) {
  expect((await readStore(this)).filter(isClearLogEntry), withTc(this, 'no Clear Log entry exists')).toHaveLength(0);
});

// ---------------------------------------------------------------------------
// Cancel / close
// ---------------------------------------------------------------------------

Then(exact('Dialog closes; no audit log entry is deleted.'), async function (this: CustomWorld) {
  await auditPages(this).dialog.expectClosed();
  await expectBaselineState(this, ALL_BASELINE, []);
});

Then(exact('Audit Trail listing remains unchanged.'), async function (this: CustomWorld) {
  expect(await auditPages(this).list.rows(), withTc(this, 'the listing is unchanged')).toEqual(auditScenario(this).initialRows);
});

Then(exact('No entries are removed in either case; listing unchanged. FRD does not define this explicitly.'), async function (this: CustomWorld) {
  await auditPages(this).dialog.expectClosed();
  await expectBaselineState(this, ALL_BASELINE, []);
  expect(await auditPages(this).list.rows(), withTc(this, 'the listing is unchanged')).toEqual(auditScenario(this).initialRows);
});

Then(exact('No Clear Log entry is created and no success toaster is displayed.'), async function (this: CustomWorld) {
  expect((await readStore(this)).filter(isClearLogEntry), withTc(this, 'no Clear Log entry exists')).toHaveLength(0);
  expect(await this.sawMessage(AUDIT_MESSAGES.cleared, 1500), withTc(this, 'no success toaster was displayed')).toBe(false);
});

// ---------------------------------------------------------------------------
// Confirmed clears
// ---------------------------------------------------------------------------

Then(
  exact('The 3 entries in the range (Office 25-Sep, Department 20-Sep, Standards & Formats 05-Sep) are removed.'),
  async function (this: CustomWorld) {
    await expectBaselineState(this, [], IN_RANGE);
  },
);

Then(exact('Entries outside the range remain.'), async function (this: CustomWorld) {
  await expectBaselineState(this, OUTSIDE_RANGE, IN_RANGE);
});

Then(
  exact('Entries of all Functions in the range (Office, Department, Standards & Formats) are cleared, not only Department.'),
  async function (this: CustomWorld) {
    await expectBaselineState(this, [], IN_RANGE);
  },
);

Then(
  exact('Entries of 01-Sep-2026 to 30-Sep-2026 are cleared (the currently selected range), not the previously applied default range.'),
  async function (this: CustomWorld) {
    await expectBaselineState(this, [1, 2, 3, 4, 5, 6, 7], IN_RANGE);
  },
);

Then(
  exact('Only the Department entry of 20-Sep-2026 14:00 is removed; the entries of 25-Sep and 05-Sep remain.'),
  async function (this: CustomWorld) {
    await expectBaselineState(this, [9, 11], [10]);
  },
);

Then(
  exact('Both boundary-adjacent entries still exist; only entries between the selected dates (inclusive) are cleared.'),
  async function (this: CustomWorld) {
    await expectBaselineState(this, [12, 13], IN_RANGE);
  },
);

Then(
  exact('Listing is refreshed to the default filter (All, 17-Oct-2026 to 16-Nov-2026) and shows the remaining records.'),
  async function (this: CustomWorld) {
    const { filters, list } = auditPages(this);
    expect(await filters.selectedFunction(), withTc(this, 'Function is back to the default')).toBe(DEFAULT_FUNCTION);
    expect(sameDate(await filters.toValue(), auditScenario(this).today), withTc(this, 'To Date is back to today')).toBe(true);
    expect((await list.rows()).length, withTc(this, 'the remaining records are listed')).toBeGreaterThan(0);
  },
);

Then(exact("Listing is refreshed and an appropriate 'No records found' message is shown instead of rows."), async function (this: CustomWorld) {
  await auditPages(this).list.waitForListing();
  expect(await auditPages(this).list.isNoRecordsShown(), withTc(this, 'the "No records found" message is shown')).toBe(true);
});

Then(exact("'No records found' state is displayed for the cleared range."), async function (this: CustomWorld) {
  await auditPages(this).list.waitForListing();
  expect(await auditPages(this).list.isNoRecordsShown(), withTc(this, 'the "No records found" state is shown for the cleared range')).toBe(true);
});

Then(exact('Operation executes once; exactly one Clear Log entry and one success toaster; no error.'), async function (this: CustomWorld) {
  expect((await readStore(this)).filter(isClearLogEntry), withTc(this, 'exactly one Clear Log entry exists')).toHaveLength(1);
  const toasters = this.seenToasts.filter((text) => text.includes(AUDIT_MESSAGES.cleared));
  expect(toasters, withTc(this, 'exactly one success toaster was displayed')).toHaveLength(1);
  expect(this.apiErrors, withTc(this, 'no API error')).toEqual([]);
});
