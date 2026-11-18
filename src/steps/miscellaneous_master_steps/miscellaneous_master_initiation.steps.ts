/**
 * Steps of miscellaneous_master_initiation.feature (navigation, kebab menus, permissions) and permissions.feature (direct URL):
 * the "opens Miscellaneous Master ..." family, the navigation tree, kebab menu clicks and the open-menu counter. Login / landing
 * Givens and the observe / notes / checks verbs are in common.steps.ts and shared_handlers.steps.ts.
 */
import { When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { miscellaneousMasterConfig } from '../../support/miscellaneous-master-config';
import { SKIP } from '../../test-data/miscellaneous-master.data';
import { logInAs, openList, skipBecause, type Skippable } from './helpers';

When(/^From the left navigation tree open Admin > Configuration > Miscellaneous Master$/, async function (this: CustomWorld): Skippable {
  const { list } = mmPages(this);
  if (!(await list.isModuleAvailable())) return skipBecause(this, SKIP.moduleMissing);
  await list.open();
  return undefined;
});

When(/^the user logs in to CivitINFRA as ([A-Za-z]+_User\d+)$/, async function (this: CustomWorld, user: string): Skippable {
  return logInAs(this, user);
});

When(
  /^the user opens Miscellaneous Master(?: (and count rows on page 1|on page 1|and observe the Display dropdown))?$/,
  async function (this: CustomWorld, variant?: string): Skippable {
    const skipped = await openList(this);
    if (skipped) return skipped;
    if (variant === 'and count rows on page 1') mmScenario(this).notedCount = await mmPages(this).list.rowCount();
    return undefined;
  },
);

When(/^the user opens the Miscellaneous Master URL directly$/, async function (this: CustomWorld): Skippable {
  if (!miscellaneousMasterConfig.directUrl) {
    return skipBecause(this, "the Miscellaneous Master route is not known; set MM_URL to the screen's absolute URL to run direct-URL scenarios.");
  }
  await mmPages(this).list.openUrl(miscellaneousMasterConfig.directUrl);
  return undefined;
});

When(/^the user reloads the Title List$/, async function (this: CustomWorld): Promise<void> {
  await mmPages(this).list.refresh();
});

When(/^the user clicks the kebab icon on the row '([^']*)'$/, async function (this: CustomWorld, title: string): Promise<void> {
  mmScenario(this).target = title;
  await mmPages(this).list.openKebab(title);
});

When(/^Without closing it, click the kebab icon on the row '([^']*)'$/, async function (this: CustomWorld, title: string): Promise<void> {
  // The first menu is deliberately left open: opening a second one must close the first.
  await mmPages(this).list.openKebab(title);
});

When(/^the user counts the open menus$/, async function (this: CustomWorld): Promise<void> {
  mmScenario(this).scratch.openMenus = await mmPages(this).list.openMenuCount();
});

When(/^the user opens the Title List and note '([^']*)' as deletable$/, async function (this: CustomWorld, title: string): Skippable {
  const skipped = await openList(this);
  if (skipped) return skipped;
  mmScenario(this).target = title;
  return undefined;
});

When(/^the user searches the list and check the Activity Log$/, async function (this: CustomWorld): Skippable {
  const { activityLog } = mmPages(this);
  if (!(await activityLog.isAvailable())) return skipBecause(this, SKIP.activityLog);
  await activityLog.open();
  return undefined;
});

When(/^the user opens the Parent Title dropdown$/, async function (this: CustomWorld): Promise<void> {
  const { form } = mmPages(this);
  mmScenario(this).scratch.options = await form.parentOptions();
});

When(/^the user rechecks the entry count$/, async function (this: CustomWorld): Skippable {
  const { activityLog } = mmPages(this);
  if (!(await activityLog.isAvailable())) return skipBecause(this, SKIP.activityLog);
  mmScenario(this).scratch.recount = await activityLog.count();
  return undefined;
});
