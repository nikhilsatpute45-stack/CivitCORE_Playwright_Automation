/**
 * Steps of region_initiation.feature (Region Management Initiation - TC-REG-001 to 007).
 * Page object: RegionListPage. Shared steps (login, navigation, fixtures) are in ./region_common.steps.ts.
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { regionPages, regionScenario } from '../../support/region-scenario';
import { expect } from '../../utils/assertions';
import { ensureRegion, returnToList } from './helpers';

// Note: "Then the "Add" action should be visible and enabled$" (TC-REG-002) is already registered, with
// identical text, by src/steps/location_steps/ui.steps.ts; it is reused as-is, not redefined here.

Then(/^the "Add" action should be hidden or disabled$/, async function (this: CustomWorld) {
  const { list } = regionPages(this);
  if (await list.addButton.isVisible().catch(() => false)) await expect(list.addButton).toBeDisabled();
});

Then(/^the "([^"]*)" row should display the "View", "Edit" and "Delete" actions$/, async function (this: CustomWorld, name: string) {
  const fixture = await ensureRegion(this, name);
  await returnToList(this);
  await regionPages(this).list.openRowMenu(fixture.name);
  const labels = await regionPages(this).list.rowMenuLabels();
  for (const action of ['View', 'Edit', 'Delete']) expect(labels, `row action "${action}"`).toContain(action);
  await regionPages(this).list.closeRowMenu();
});

Then(/^all Regions in the Region Master should be listed$/, async function (this: CustomWorld) {
  const rows = await regionPages(this).list.gridRows();
  expect(rows.length).toBeGreaterThan(0);
});

When(/^I locate the "([^"]*)" row$/, async function (this: CustomWorld, name: string) {
  const fixture = await ensureRegion(this, name);
  regionScenario(this).target = fixture;
  await regionPages(this).list.showRow(fixture.name);
});

Then(/^the "Edit" action should be hidden or disabled$/, async function (this: CustomWorld) {
  const fixture = requireLocatedRow(this);
  await regionPages(this).list.openRowMenu(fixture.name);
  const hasEdit = await regionPages(this).list.hasRowAction('Edit');
  expect(hasEdit, 'the "Edit" row action is not offered').toBe(false);
  await regionPages(this).list.closeRowMenu();
});

Then(/^the "Delete" action should be hidden or disabled$/, async function (this: CustomWorld) {
  const fixture = requireLocatedRow(this);
  await regionPages(this).list.openRowMenu(fixture.name);
  const hasDelete = await regionPages(this).list.hasRowAction('Delete');
  expect(hasDelete, 'the "Delete" row action is not offered').toBe(false);
  await regionPages(this).list.closeRowMenu();
});

function requireLocatedRow(world: CustomWorld) {
  const target = regionScenario(world).target;
  if (!target) throw new Error('No Region row has been located by an earlier step of this scenario.');
  return target;
}
