/**
 * Steps of display_configuration.feature: the Display checkbox of the list (saved immediately, no Save button), plus the toaster
 * timer used by the 5-second auto-close scenarios. "the user checks the Display checkbox of 'X'" is an observe-family sentence
 * and is handled in shared_handlers.steps.ts. Display scenarios that need the Specialization Master skip (SKIP.crossModule); the
 * ones that force or throttle the Display update API skip (SKIP.serviceFailure).
 */
import { When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { rememberOriginal, withToast } from './helpers';

async function toggle(world: CustomWorld, title: string, only?: 'check' | 'uncheck'): Promise<void> {
  const { list } = mmPages(world);
  mmScenario(world).target = title;
  await rememberOriginal(world, title);
  const checked = await list.isDisplayChecked(title);
  if (only === 'check' && checked) return;
  if (only === 'uncheck' && !checked) return;
  mmScenario(world).scratch.displayBefore = checked;
  await withToast(world, () => list.clickDisplay(title), 8000);
}

When(/^the user clicks the Display checkbox of '([^']*)'(?: \((?:un)?checked\))?$/, async function (this: CustomWorld, title: string): Promise<void> {
  await toggle(this, title);
});

When(/^the user unchecks (?:the Display checkbox|Display) of '([^']*)'$/, async function (this: CustomWorld, title: string): Promise<void> {
  await toggle(this, title, 'uncheck');
});

When(/^the user re-checks Display of '([^']*)'$/, async function (this: CustomWorld, title: string): Promise<void> {
  await toggle(this, title, 'check');
});

When(/^Immediately try to click it again$/, async function (this: CustomWorld): Promise<void> {
  const title = mmScenario(this).target;
  if (title) await mmPages(this).list.clickDisplay(title).catch(() => undefined);
});

When(/^the user closes and open View for '([^']*)' \(Display unchecked\)$/, async function (this: CustomWorld, title: string): Promise<void> {
  const { view } = mmPages(this);
  if (await view.isOpen()) await view.clickClose();
  mmScenario(this).target = title;
  await mmPages(this).list.openKebab(title);
  await mmPages(this).list.selectMenuItem('View');
  await view.expectOpen();
  mmScenario(this).scratch.viewText = await view.text();
});

/** Times how long the toaster stays on screen (read-only polling, never touching the toaster's DOM). */
When(/^the user starts a timer when the (?:error )?toaster appears and observe it$/, async function (this: CustomWorld): Promise<void> {
  const started = Date.now();
  const deadline = started + 15000;
  let appeared = (await this.visibleToasts()).length > 0;
  let appearedAt = appeared ? started : 0;
  while (Date.now() < deadline) {
    const visible = (await this.visibleToasts()).length > 0;
    if (visible && !appeared) {
      appeared = true;
      appearedAt = Date.now();
    }
    if (!visible && appeared) {
      mmScenario(this).scratch.toastSeconds = (Date.now() - appearedAt) / 1000;
      return;
    }
  }
});
