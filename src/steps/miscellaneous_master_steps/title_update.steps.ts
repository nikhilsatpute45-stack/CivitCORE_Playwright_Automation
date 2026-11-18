/**
 * Steps of title_update.feature: "the user edits ..." (one routed step; it opens the Edit pop-up for the named Title and applies
 * whatever the rest of the sentence says). The input family ("changes Field Title ...", "changes Enum ID ...", "clicks Save")
 * is in title_creation.steps.ts / shared_with_contract_category.steps.ts. Edits of baseline Titles are restored by the After hook.
 */
import { When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { SKIP } from '../../test-data/miscellaneous-master.data';
import { enterField } from './inputs';
import { openEditFor, saveForm, skipBecause, testDatum, withTc, type Skippable } from './helpers';

/** The Misc-only forms of "edits ..." (Contractor Category's own "edits 'Class-V' Description ..." sentences must not match). */
const EDIT_FORMS = String.raw`'[^']*'(?: \(Enum ID (?:\d+|blank)\)| \(child '[^']*', grandchild '[^']*'\)| and (?:change Field Title(?: to '[^']*')?|clear Enum ID; save|change Enum ID (?:to \d+; save|from \d+ to \d+)|enter Enum ID \d+; save; open Vendor Registration form|check Display))?|it: change Field Title and Enum ID, then Save`;

When(new RegExp(`^the user edits (${EDIT_FORMS})$`), async function (this: CustomWorld, text: string): Skippable {
  const scenario = mmScenario(this);
  const { form } = mmPages(this);
  const named = /^'([^']*)'/.exec(text)?.[1];
  const title = named ?? scenario.target ?? scenario.created.at(-1);
  if (!title) throw new Error(withTc(this, 'No Title was named for the edit, and no earlier step selected one.'));
  await openEditFor(this, title);

  let m: RegExpExecArray | null;
  if ((m = /^it: change Field Title and Enum ID, then Save$/.exec(text))) {
    await enterField(this, 'Field Title', testDatum(this, 'New Title') ?? testDatum(this, 'New Field Title') ?? `${title} Rev`);
    await enterField(this, 'Enum ID', testDatum(this, 'New Enum ID') ?? testDatum(this, 'Enum ID') ?? '999');
    await saveForm(this);
  } else if ((m = /and change Field Title to '([^']*)'$/.exec(text))) {
    await enterField(this, 'Field Title', m[1]);
  } else if (/and change Field Title$/.test(text)) {
    await enterField(this, 'Field Title', testDatum(this, 'New Title') ?? testDatum(this, 'New Field Title') ?? `${title} Rev`);
  } else if (/and clear Enum ID; save$/.test(text)) {
    await form.clear('Enum ID');
    await saveForm(this);
  } else if ((m = /and change Enum ID to (\d+); save$/.exec(text))) {
    await enterField(this, 'Enum ID', m[1]);
    await saveForm(this);
  } else if ((m = /and enter Enum ID (\d+); save; open Vendor Registration form$/.exec(text))) {
    await enterField(this, 'Enum ID', m[1]);
    await saveForm(this);
    return skipBecause(this, SKIP.crossModule);
  } else if ((m = /and change Enum ID from (\d+) to (\d+)$/.exec(text))) {
    await enterField(this, 'Enum ID', m[2]);
  } else if (/and check Display$/.test(text)) {
    await form.setDisplay(true);
    scenario.entered.display = true;
  }
  // "(Enum ID 104)", "(Enum ID blank)", "(child 'State', grandchild 'District')" and a bare "edits 'X'" only open the pop-up.
  return undefined;
});
