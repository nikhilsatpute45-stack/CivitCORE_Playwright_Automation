/** Steps of features/audit_trail_features/audit_trail_initiation.feature (screen load, default filters, Clear Log presence). */
import { Then } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { auditPages, auditScenario } from '../../support/audit-trail-scenario';
import { DEFAULT_FUNCTION, DEFAULT_RANGE_DAYS, addDays, formatDate } from '../../test-data/audit-trail.data';
import { expect } from '../../utils/assertions';
import { exact, withTc } from './helpers';

Then(exact('Audit Trail listing screen is displayed with default Function and date range applied.'), async function (this: CustomWorld) {
  const { list, filters } = auditPages(this);
  await list.expectLoaded();
  const today = auditScenario(this).today;
  expect(await filters.selectedFunction(), withTc(this, 'default Function')).toBe(DEFAULT_FUNCTION);
  expect(await filters.toValue(), withTc(this, 'default To Date is today')).toBe(formatDate(today));
  expect(await filters.fromValue(), withTc(this, `default From Date is ${DEFAULT_RANGE_DAYS} days before To Date`)).toBe(
    formatDate(addDays(today, -DEFAULT_RANGE_DAYS)),
  );
});

Then(
  exact('Screen contains a Functions dropdown, From Date picker, To Date picker, Search action, Clear Log action and the Audit Log grid.'),
  async function (this: CustomWorld) {
    const { list, filters } = auditPages(this);
    const present = await filters.hasAllControls();
    for (const [control, visible] of Object.entries(present)) {
      expect(visible, withTc(this, `the ${control} control is displayed`)).toBe(true);
    }
    await expect(list.grid, withTc(this, 'the Audit Log grid')).toBeVisible();
  },
);

Then(exact('Clear Log action is displayed and available to the authorized user.'), async function (this: CustomWorld) {
  expect(await auditPages(this).filters.clearLogState(), withTc(this, 'Clear Log is displayed and enabled')).toBe('enabled');
});
