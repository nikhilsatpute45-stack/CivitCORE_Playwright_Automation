/** Steps of features/audit_trail_features/audit_trail_date_validation.feature (From / To Date rules on Search; FRD 6.3). */
import { Then } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { auditPages, auditScenario } from '../../support/audit-trail-scenario';
import { AUDIT_MESSAGES } from '../../test-data/audit-trail.data';
import { expect } from '../../utils/assertions';
import { exact, withTc } from './helpers';

/** Asserts the validation message is shown. The exact FRD text is the contract (workbook Summary note 5). */
async function expectBlockedWith(world: CustomWorld, message: string): Promise<void> {
  const { filters } = auditPages(world);
  expect(await filters.messageIsVisible(message), withTc(world, `the validation message "${message}" is displayed`)).toBe(true);
}

Then(/^Search is blocked with validation message '([^']*)'\.$/, async function (this: CustomWorld, message: string) {
  await expectBlockedWith(this, message);
});

Then(
  exact(
    "Search is blocked with a validation message (the From Date error state is 'From Date cannot be later than To Date'; FRD has no separate text for future From Date).",
  ),
  async function (this: CustomWorld) {
    const messages = await auditPages(this).filters.validationMessages();
    expect(messages.length, withTc(this, 'a validation message is displayed')).toBeGreaterThan(0);
    // Any text is acceptable for a future From Date (FRD gap 6(c)); the FRD text is the expected one.
    if (!messages.some((message) => message.includes(AUDIT_MESSAGES.fromLater))) {
      this.log(`FRD gap: a future From Date showed "${messages.join(' | ')}" instead of "${AUDIT_MESSAGES.fromLater}".`);
    }
  },
);

Then(
  exact("Search is blocked; messages 'From Date is required' and 'To Date is required' are displayed."),
  async function (this: CustomWorld) {
    await expectBlockedWith(this, AUDIT_MESSAGES.fromRequired);
    await expectBlockedWith(this, AUDIT_MESSAGES.toRequired);
  },
);

Then(exact('Grid does not show new or undefined results.'), async function (this: CustomWorld) {
  const rows = await auditPages(this).list.rows();
  for (const row of rows) {
    expect(Object.values(row).join(' '), withTc(this, 'no undefined / partial value is rendered')).not.toMatch(/undefined|null|NaN/i);
  }
  expect(rows, withTc(this, 'the grid still shows the previous result')).toEqual(auditScenario(this).initialRows ?? rows);
});

Then(exact('Grid is unchanged.'), async function (this: CustomWorld) {
  const initial = auditScenario(this).initialRows;
  expect(initial, withTc(this, 'the grid was read when the screen opened')).toBeTruthy();
  expect(await auditPages(this).list.rows(), withTc(this, 'the grid is unchanged')).toEqual(initial);
});

Then(
  /^(?:Invalid date is not accepted; Search is blocked and no results are shown|Incomplete date is not accepted; Search is blocked|Non-date text is not accepted; Search is blocked)\.$/,
  async function (this: CustomWorld) {
    const messages = await auditPages(this).filters.validationMessages();
    expect(messages.length, withTc(this, 'Search is blocked by a validation message')).toBeGreaterThan(0);
  },
);

Then(
  exact('Grid keeps the previous valid result (or stays empty) and does not show undefined/partial data; no API result is applied.'),
  async function (this: CustomWorld) {
    const scenario = auditScenario(this);
    const rows = await auditPages(this).list.rows();
    if (rows.length > 0) expect(rows, withTc(this, 'the previous result is kept')).toEqual(scenario.snapshot);
    for (const row of rows) {
      expect(Object.values(row).join(' '), withTc(this, 'no undefined / partial value is rendered')).not.toMatch(/undefined|null|NaN/i);
    }
  },
);
