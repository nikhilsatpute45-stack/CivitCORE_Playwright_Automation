/**
 * Step texts this module shares, word for word, with features/contract_category_features (branch contract-category-automation-scripts):
 * the two modules have the same list / pop-up UI, so their generic sentences are identical. Cucumber step text is global: when
 * BOTH branches are merged, each of these phrases would be registered twice and Cucumber would report them as ambiguous. They are
 * kept in this one file so the merge fix is a single, mechanical edit:
 *
 *   1. delete this file, and
 *   2. route the phrases listed below through a shared registry key (like the five already in src/support/shared-step-registry.ts),
 *      or let Contractor Category's definitions serve both modules (their bodies call that module's page objects, so they need the
 *      same module-tag routing).
 *
 * Until then each module works on its own branch. Phrases covered:
 *   "Baseline data (see Summary) is loaded"
 *   "the user clicks 'Add' | 'Close' | 'Edit' | 'No' | 'Yes' | Cancel | Save | First | Last | Next | Previous | page number N |
 *    the close (X) icon [of the dialog] | on an empty area of the page outside the menu"
 *   "the user presses the Esc key"
 *   "the user selects Delete on '<title>'"
 */
import { Given, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { SKIP } from '../../test-data/miscellaneous-master.data';
import { openAddForm, openRowMenuAndSelect, requireBaseline, rememberGrid, saveForm, skipBecause, withToast, withTc, type Skippable } from './helpers';

/**
 * The Activity Log scenarios end with steps this module cannot run without an Activity Log entry point, so they skip BEFORE they
 * change any data when it is missing, which is checked here.
 */
async function requireActivityLogWhenNeeded(world: CustomWorld): Skippable {
  if (!mmScenario(world).tags.includes('@ActivityAuditLog')) return undefined;
  if (await mmPages(world).activityLog.isAvailable()) return undefined;
  return skipBecause(world, SKIP.activityLog);
}

Given(/^Baseline data \(see Summary\) is loaded$/, async function (this: CustomWorld): Skippable {
  return requireBaseline(this) ?? (await requireActivityLogWhenNeeded(this));
});

/** Closes whichever pop-up is open with its X icon. */
async function closeWithIcon(world: CustomWorld): Promise<void> {
  const { form, view } = mmPages(world);
  if (await form.isOpen()) await form.close();
  else if (await view.isOpen()) await view.clickCloseIcon();
  else throw new Error(withTc(world, 'No pop-up is open, so there is no close (X) icon to click.'));
}

When(
  /^the user clicks ('Add'|'Close'|'Edit'|'No'|'Yes'|Cancel|Save|First|Last|Next|Previous|page number \d+|the close \(X\) icon(?: of the dialog)?|on an empty area of the page outside the menu)$/,
  async function (this: CustomWorld, what: string): Promise<void> {
    const { list, form, view, deletion } = mmPages(this);
    if (what === "'Add'") await openAddForm(this);
    else if (what === "'Close'") await view.clickClose();
    else if (what === "'Edit'") await view.clickEdit();
    else if (what === "'No'") await deletion.no();
    else if (what === "'Yes'") await withToast(this, () => deletion.yes(), 8000);
    else if (what === 'Cancel') await form.cancel();
    else if (what === 'Save') await saveForm(this);
    else if (/^(First|Last|Next|Previous)$/.test(what)) await list.clickControl(what as 'First' | 'Last' | 'Next' | 'Previous');
    else if (/^page number/.test(what)) await list.goToPage(Number(/\d+/.exec(what)![0]));
    else if (/^the close \(X\) icon/.test(what)) await closeWithIcon(this);
    else await list.closeMenusByClickingOutside();
  },
);

When(/^the user presses the Esc key$/, async function (this: CustomWorld): Promise<void> {
  const { form, view } = mmPages(this);
  if (await form.isOpen()) await form.pressEscape();
  else if (await view.isOpen()) await view.pressEscape();
  else await this.page.keyboard.press('Escape');
});

When(/^the user selects Delete on '([^']*)'$/, async function (this: CustomWorld, title: string): Promise<void> {
  await rememberGrid(this);
  // A blocked delete shows an error toaster instead of the confirmation dialog, so the toaster is captured too.
  await withToast(this, () => openRowMenuAndSelect(this, title, 'Delete'), 4000);
});
