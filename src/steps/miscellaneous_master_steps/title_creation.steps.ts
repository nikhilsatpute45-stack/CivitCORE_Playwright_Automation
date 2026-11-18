/**
 * Steps of title_creation.feature (and the Add-form steps the add_edit_title_ui, consumption and permissions features reuse):
 * the 'Add' click variants, the Field Title / Enum ID / Parent Title / Display input family and "creates / adds a Title".
 * The bare "clicks 'Add'" / "clicks Save" and the other generic clicks are in shared_with_contract_category.steps.ts.
 *
 * The form-input sentences are ONE routed step (vocabulary guard: a form verb plus Field Title / Enum ID / Parent Title / Title,
 * and none of the search / kebab / Display / Delete words that belong to other families).
 */
import { When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { enterField, enterFromData, mustHave, phraseValue, repeatToLength, selectParent, swapCase, valueFor } from './inputs';
import { openAddForm, saveForm, testDatum, withTc } from './helpers';

// ---------------------------------------------------------------------------
// 'Add' click variants (the bare "clicks 'Add'" is in shared_with_contract_category.steps.ts)
// ---------------------------------------------------------------------------

When(
  /^the user clicks 'Add'(?: (and click Save with Field Title blank|and observe the Display checkbox|and open the Parent Title dropdown|on the Title List)|, enter Field Title(?: '([^']*)' and click Save)?)$/,
  async function (this: CustomWorld, variant?: string, literal?: string): Promise<void> {
    const { form } = mmPages(this);
    await openAddForm(this);
    if (variant === 'and click Save with Field Title blank') {
      await form.clear('Field Title');
      await saveForm(this);
    } else if (variant === 'and open the Parent Title dropdown') {
      mmScenario(this).scratch.options = await form.parentOptions();
    } else if (variant === undefined) {
      // "'Add', enter Field Title [...]": the title comes from the sentence, else from the test data.
      await enterField(this, 'Field Title', literal ?? valueFor(this, 'Field Title'));
      if (literal) await saveForm(this);
    }
  },
);

When(/^the user opens 'Add' and enter Field Title as Adder_User1$/, async function (this: CustomWorld): Promise<void> {
  await openAddForm(this);
  await enterFromData(this, 'Field Title');
});

// ---------------------------------------------------------------------------
// Form input (Add / Edit pop-up)
// ---------------------------------------------------------------------------

const FORM_VERBS = 'enters|types|pastes|leaves|clears|selects|changes|creates|adds';

/** Existing Title to collide with: the test data's, else a baseline one. */
function existingTitle(world: CustomWorld, literal?: string): string {
  return literal ?? testDatum(world, 'Existing Title') ?? testDatum(world, 'Title') ?? testDatum(world, 'Field Title') ?? 'List of Title';
}

/** The Field Title to use when the sentence only says "Field Title": the test data's, else generated. */
function titleFor(world: CustomWorld, phrase = ''): string {
  return testDatum(world, 'Field Title') ?? testDatum(world, 'Title') ?? phraseValue('Field Title', phrase);
}

/** Enum ID for a phrase such as "with leading zeros", "surrounded by spaces", "0", "401". */
function enumFor(world: CustomWorld, phrase: string): string {
  const literal = /Enum ID (\d+)\b/.exec(phrase)?.[1];
  const data = testDatum(world, 'Enum ID') ?? testDatum(world, 'Enum ID typed');
  if (literal !== undefined) return literal;
  if (/10-character Enum ID padded with zeros/.test(phrase)) return '0000000012';
  if (/10-digit/.test(phrase)) return '1234567890';
  if (/surrounded by spaces|leading and trailing spaces/.test(phrase)) return `  ${data ?? '501'}  `;
  if (/spaces only/.test(phrase)) return '     ';
  if (/leading zeros/.test(phrase)) return data ?? '0012';
  return data ?? '501';
}

When(
  new RegExp(
    `^the user ((?:${FORM_VERBS}) (?=.*(?:Field Title|Enum ID|Parent Title|\\bTitle\\b))(?!.*(?:search|Search|kebab)).*)$`,
  ),
  async function (this: CustomWorld, text: string): Promise<void> {
    const { form } = mmPages(this);
    const scenario = mmScenario(this);
    let m: RegExpExecArray | null;

    if ((m = /^(?:enters|types) (?:the )?Enum ID(?: (\d+))?$/.exec(text))) {
      await enterField(this, 'Enum ID', m[1] ?? enumFor(this, text));
    } else if ((m = /^enters Field Title(?: '([^']*)')?$/.exec(text))) {
      await enterField(this, 'Field Title', m[1] ?? titleFor(this));
    } else if (/^enters Field Title and (?:Enum ID|an? )/.test(text) && /Enum ID/.test(text)) {
      await enterField(this, 'Field Title', titleFor(this));
      const duplicate = /used by another Title|equals an existing one/.test(text);
      await enterField(this, 'Enum ID', duplicate ? (testDatum(this, 'Enum ID') ?? '101') : enumFor(this, text));
      if (/and click Save/.test(text)) await saveForm(this);
    } else if ((m = /^enters Field Title and (click Save(?: without touching Display)?|leave Enum ID blank|leave Parent Title as '[^']*'|select Parent Title)$/.exec(text))) {
      await enterField(this, 'Field Title', titleFor(this));
      if (/^click Save/.test(m[1])) await saveForm(this);
      else if (/select Parent Title/.test(m[1])) await selectParent(this, mustHave(this, testDatum(this, 'Parent Title') ?? testDatum(this, 'Parent'), 'Parent Title'));
    } else if (/^enters Field Title, check Display and click Save$/.test(text)) {
      await enterField(this, 'Field Title', titleFor(this));
      await form.setDisplay(true);
      scenario.entered.display = true;
      await saveForm(this);
    } else if (/^enters Field Title, select Parent Title, enter Enum ID and check Display$/.test(text)) {
      await enterField(this, 'Field Title', titleFor(this));
      await selectParent(this, mustHave(this, testDatum(this, 'Parent Title') ?? testDatum(this, 'Parent'), 'Parent Title'));
      await enterField(this, 'Enum ID', enumFor(this, ''));
      await form.setDisplay(true);
      scenario.entered.display = true;
    } else if ((m = /^enters Field Title (containing special characters|in mixed case|with SQL-like text|with a script tag|with leading and trailing spaces|with runs of internal spaces)$/.exec(text))) {
      await enterField(this, 'Field Title', valueFor(this, 'Field Title', m[1]));
    } else if ((m = /^enters a Field Title of (1 character|exactly 100 characters)$/.exec(text))) {
      await enterField(this, 'Field Title', /^1 /.test(m[1]) ? (testDatum(this, 'Field Title') ?? 'Z') : repeatToLength(100));
    } else if ((m = /^enters duplicate Field Title '([^']*)' and click Save$/.exec(text))) {
      await enterField(this, 'Field Title', m[1]);
      await saveForm(this);
    } else if (/^enters (?:an existing Title name|a duplicate Title name and a duplicate Enum ID|another Title's name with leading and trailing spaces|the existing Title in different case with surrounding spaces|the existing Title with repeated internal spaces|the name of a Title that is on page 3 of the list)/.test(text)) {
      const existing = existingTitle(this);
      let value = existing;
      if (/in lower case/.test(text)) value = existing.toLowerCase();
      else if (/in upper case/.test(text)) value = existing.toUpperCase();
      else if (/leading and trailing spaces/.test(text)) value = `  ${existing}  `;
      else if (/different case with surrounding spaces/.test(text)) value = `  ${swapCase(existing)}  `;
      else if (/repeated internal spaces/.test(text)) value = existing.replace(/ /g, '   ');
      await enterField(this, 'Field Title', value);
      if (/duplicate Enum ID/.test(text)) await enterField(this, 'Enum ID', testDatum(this, 'Enum ID') ?? '101');
      if (/invalid Enum ID/.test(text)) await enterField(this, 'Enum ID', '0');
    } else if (/^enters spaces only in Field Title$/.test(text)) {
      await enterField(this, 'Field Title', '     ');
    } else if (/^enters an Enum ID with a decimal point$/.test(text)) {
      await enterField(this, 'Enum ID', '12.5');
    } else if ((m = /^types '([^']*)' in Field Title$/.exec(text))) {
      await enterField(this, 'Field Title', m[1], 'type');
    } else if ((m = /^types (\d+) characters into Field Title$/.exec(text))) {
      await enterField(this, 'Field Title', repeatToLength(Number(m[1])), 'type');
    } else if ((m = /^types (\d+) digits (?:in|into) Enum ID(?: and click Save)?$/.exec(text))) {
      await enterField(this, 'Enum ID', '1'.repeat(Number(m[1])), 'type');
      if (/and click Save/.test(text)) await saveForm(this);
    } else if ((m = /^pastes (\d+) (characters|digits) into (Field Title|Enum ID)$/.exec(text))) {
      const field = m[3] as 'Field Title' | 'Enum ID';
      await enterField(this, field, m[2] === 'digits' ? '1'.repeat(Number(m[1])) : (testDatum(this, 'Pasted text') ?? repeatToLength(Number(m[1]))), 'paste');
    } else if (/^leaves Field Title blank(?: and enter an invalid Enum ID)?$/.test(text)) {
      await form.clear('Field Title');
      if (/invalid Enum ID/.test(text)) await enterField(this, 'Enum ID', testDatum(this, 'Enum ID') ?? '0');
    } else if (/^clears Field Title$/.test(text)) {
      await form.clear('Field Title');
    } else if (/^clears the Enum ID box$/.test(text)) {
      await form.clear('Enum ID');
    } else if (/^selects a Parent Title$/.test(text)) {
      await selectParent(this, mustHave(this, testDatum(this, 'Parent Title') ?? testDatum(this, 'Parent'), 'Parent Title'));
    } else if (/^selects '-- Select Parent Title --' in Parent Title$/.test(text)) {
      await form.selectNoParent();
      scenario.entered.parentTitle = '';
    } else if (/^changes Enum ID(?: to (\d+))?$/.test(text)) {
      m = /^changes Enum ID(?: to (\d+))?$/.exec(text)!;
      await enterField(this, 'Enum ID', m[1] ?? testDatum(this, 'New Enum ID') ?? testDatum(this, 'Enum ID') ?? '999');
    } else if ((m = /^changes Field Title(?: to (?:'([^']*)'|(lower case)|the name of another Title in different case))?$/.exec(text))) {
      const current = await form.value('Field Title');
      let value: string;
      if (m[1]) value = m[1];
      else if (m[2]) value = current.toLowerCase();
      else if (/another Title in different case/.test(text)) value = swapCase(existingTitle(this, testDatum(this, 'Other Title') ?? undefined));
      else value = testDatum(this, 'New Title') ?? testDatum(this, 'New Field Title') ?? `${current} Rev`;
      await enterField(this, 'Field Title', value);
    } else if ((m = /^changes Parent Title from '([^']*)' to '([^']*)'$/.exec(text))) {
      await selectParent(this, m[2]);
    } else if ((m = /^changes only Field Title, leaving Enum ID (\d+)$/.exec(text))) {
      await enterField(this, 'Field Title', testDatum(this, 'New Title') ?? `${await form.value('Field Title')} Rev`);
    } else if ((m = /^creates Title '([^']*)'(?: as Admin_User1)?$/.exec(text))) {
      await openAddForm(this);
      await enterField(this, 'Field Title', m[1]);
      const data = testDatum(this, 'Enum ID');
      if (data) await enterField(this, 'Enum ID', data);
      await saveForm(this);
    } else if ((m = /^adds a new Title using Enum ID (\d+)$/.exec(text))) {
      await openAddForm(this);
      await enterField(this, 'Field Title', testDatum(this, 'New Title') ?? testDatum(this, 'Field Title') ?? 'Legacy Replacement');
      await enterField(this, 'Enum ID', m[1]);
      await saveForm(this);
    } else {
      throw new Error(withTc(this, `No form-input handler for "the user ${text}".`));
    }
  },
);

When(/^the user changes nothing and click Save$/, async function (this: CustomWorld): Promise<void> {
  await saveForm(this);
});

When(/^the user double-clicks Save and observe the button$/, async function (this: CustomWorld): Promise<void> {
  await saveForm(this, 2);
});
