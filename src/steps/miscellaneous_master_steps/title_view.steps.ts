/**
 * Steps of title_view.feature: the "the user opens ... in View" family and "tries to click into and change every value". The
 * View pop-up's own buttons ('Close', 'Edit', the X icon) are in shared_with_contract_category.steps.ts; its assertions are
 * routed through outcomes.ts.
 */
import { When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { openRowMenuAndSelect, withTc } from './helpers';

When(
  /^the user opens (?:View for '([^']*)'(?: \([^)]*\))?(?: and note Created and Last Modified values)?|View for any row|View again|the (?:new )?Title in View)$/,
  async function (this: CustomWorld, title?: string): Promise<void> {
    const { list, view } = mmPages(this);
    const scenario = mmScenario(this);
    const row = title ?? scenario.target ?? scenario.entered.fieldTitle?.trim().replace(/\s+/g, ' ') ?? scenario.created.at(-1) ?? (await list.titles())[0];
    if (!row) throw new Error(withTc(this, 'There is no row to open in View.'));
    await openRowMenuAndSelect(this, row, 'View');
    await view.expectOpen();
    scenario.scratch.viewText = await view.text();
  },
);

When(/^the user tries to click into and change every value$/, async function (this: CustomWorld): Promise<void> {
  const { view } = mmPages(this);
  // Typing into a read-only pop-up must change nothing; the Then step checks that no field accepts input.
  mmScenario(this).scratch.viewEditable = await view.hasEditableInputs();
});
