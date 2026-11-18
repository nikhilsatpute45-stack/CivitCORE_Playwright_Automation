/** Steps of features/audit_trail_features/audit_trail_ui.feature (Functions dropdown is selection-only, grid is view-only, Clear Log hidden for view-only users). */
import { Then } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { auditPages, auditScenario } from '../../support/audit-trail-scenario';
import { expect } from '../../utils/assertions';
import { exact, withTc } from './helpers';

/** The Functions control keeps the value it had before the keyboard typing (exported for the Functions steps of the filter feature). */
export async function expectFunctionUnchanged(world: CustomWorld): Promise<void> {
  const before = auditScenario(world).scratch.functionBefore;
  expect(before, withTc(world, 'the Functions value was noted before typing')).toBeTruthy();
  expect(await auditPages(world).filters.selectedFunction(), withTc(world, 'typed free text is not accepted')).toBe(before);
}

Then(
  exact('Control behaves as a selection-only dropdown; typed free text is not accepted and the selected value is unchanged.'),
  async function (this: CustomWorld) {
    await expectFunctionUnchanged(this);
  },
);

Then(exact('No Edit, Delete or other row action is available; the list is strictly view-only.'), function (this: CustomWorld) {
  expect(auditScenario(this).scratch.rowActions, withTc(this, 'the grid exposes no row action (Actions column, icons, context menu)')).toBe(false);
});

Then(exact('Clear Log is hidden or disabled; no clickable Clear Log control is exposed.'), async function (this: CustomWorld) {
  expect(['absent', 'disabled'], withTc(this, 'Clear Log is hidden or disabled')).toContain(await auditPages(this).filters.clearLogState());
});
