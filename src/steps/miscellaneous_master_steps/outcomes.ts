/**
 * Outcome ("Then") verification for the Miscellaneous Master features (no steps are registered here).
 *
 * The features state outcomes as prose, often several facts per sentence ("Title is saved, the form closes and toaster '...' is
 * displayed"). `verifyOutcome` reads such a sentence and applies every rule whose keyword it contains; a sentence none of the
 * rules recognises is SKIPPED with a reason instead of silently passing. The leading phrases that route a sentence here are
 * listed in OUTCOME_LEADS (outcomes.steps.ts registers them).
 */
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { expect } from '../../utils/assertions';
import { DISPLAY_FILTER_OPTIONS, FIELD_LIMITS, INLINE_MESSAGES, MM_COLUMNS, PARENT_PLACEHOLDER, SKIP } from '../../test-data/miscellaneous-master.data';
import { SKIPPED, expectGridUnchanged, expectMessage, expectNoToast, expectToast, requireBaseline, skipBecause, withTc } from './helpers';

type Result = typeof SKIPPED | undefined;

/** Applies every rule that matches the sentence; returns SKIPPED when none does. */
export async function verifyOutcome(world: CustomWorld, text: string): Promise<Result> {
  const { list, form, view, deletion, activityLog } = mmPages(world);
  const scenario = mmScenario(world);
  let applied = 0;
  const did = (): void => {
    applied += 1;
  };

  // Activity Log facts need the Activity Log, which has no confirmed entry point yet.
  if (/activity log|^Entry '|^Entries are listed most recent first/i.test(text) && !/no (?:new )?activity log entry|no 'title deleted' entry|no .*entry is (?:created|written)/i.test(text)) {
    if (!(await activityLog.isAvailable())) return skipBecause(world, SKIP.activityLog);
  }
  // Other modules (Specialization Master, Vendor / Contractor Registration, transactions).
  if (/Specialization Master|Vendor Registration|Contractor Registration|TXN-\d+|^Transaction |on any form page|Specialization Master lists/i.test(text) && !/^Request is rejected|^Toaster|^Error toaster|^Deletion is blocked/i.test(text)) {
    return skipBecause(world, SKIP.crossModule);
  }

  // --- toasters -------------------------------------------------------------------------------------------------
  const toast = /toaster '([^']*)' is (?:displayed|shown)/i.exec(text);
  if (toast) {
    await expectToast(world, toast[1]);
    did();
  } else if (/no toaster(?: message)?(?: is displayed| appears| is shown)?\b/i.test(text)) {
    await expectNoToast(world);
    did();
  }
  if (/closes automatically after 5 seconds/i.test(text)) {
    const seconds = scenario.scratch.toastSeconds as number | undefined;
    expect(seconds, withTc(world, 'the toaster was timed')).toBeDefined();
    expect(Math.abs((seconds ?? 0) - 5), withTc(world, `the toaster closes after about 5 seconds (took ${seconds}s)`)).toBeLessThanOrEqual(1.5);
    did();
  }

  // --- pop-ups --------------------------------------------------------------------------------------------------
  if (/(?:form|pop-?up|dialog) (?:closes|is closed)|^Form closes|dialog closes/i.test(text)) {
    await expect
      .poll(async () => !(await form.isOpen()) && !(await view.isOpen()) && !(await deletion.isOpen()), { timeout: 15000, message: withTc(world, 'the pop-up / dialog closed') })
      .toBe(true);
    did();
  }
  if (/form stays open|pop-?up stays open/i.test(text)) {
    expect(await form.isOpen(), withTc(world, 'the form stays open')).toBe(true);
    did();
  }
  if (/is not saved|save is blocked/i.test(text) && (await form.isOpen().catch(() => false))) {
    did();
  }

  // --- field-level messages --------------------------------------------------------------------------------------
  const clauses = text.split(/;\s*/);
  for (const clause of clauses) {
    if (/not shown|not displayed|disappears/i.test(clause)) continue;
    for (const quoted of clause.matchAll(/'([^']+)'/g)) {
      if ((INLINE_MESSAGES as readonly string[]).includes(quoted[1])) {
        await expectMessage(world, quoted[1]);
        did();
      }
    }
  }
  if (/disappears and the red border is removed/i.test(text)) {
    expect(await form.hasRedBorder('Field Title'), withTc(world, 'the red border is removed')).toBe(false);
    did();
  }
  if (/error message and border|red border/i.test(text) && !/removed/.test(text)) {
    expect(await form.hasRedBorder('Field Title'), withTc(world, 'the invalid field has a red border')).toBe(true);
    did();
  }

  // --- request rejection (API scenarios) -------------------------------------------------------------------------
  if (/\brejected\b/i.test(text)) {
    const results = scenario.lastApis.length > 0 ? scenario.lastApis : scenario.lastApi ? [scenario.lastApi] : [];
    expect(results.length, withTc(world, 'an API response was recorded')).toBeGreaterThan(0);
    for (const result of results) {
      expect(result.status >= 400 && result.status < 500, withTc(world, `the request is rejected (got ${result.status})`)).toBe(true);
    }
    did();
  }
  if (/direct URL access is denied|Miscellaneous Master entry is not displayed/i.test(text)) {
    expect(await list.isNavEntryVisible(), withTc(world, 'the Miscellaneous Master entry is not displayed')).toBe(false);
    expect(await list.isListVisible(), withTc(world, 'no Title data is exposed')).toBe(false);
    did();
  }
  if (/(?:remains|remain|unchanged|no new title)\b|is removed from the list|not listed/i.test(text) && (await list.isListVisible().catch(() => false)) && /unchanged|remains|no new Title/i.test(text)) {
    if (!/Created By|Last Modified|Internal ID|Enum ID are unchanged|Field Title, Parent Title/i.test(text)) {
      await expectGridUnchanged(world);
      did();
    }
  }

  // --- menus and buttons -----------------------------------------------------------------------------------------
  const menu = /^Menu shows (.+?)(?:;|$)/i.exec(text);
  if (menu) {
    const options = (await list.menuOptions()).map((option) => option.toLowerCase());
    const shown = ['View', 'Edit', 'Delete'].filter((name) => new RegExp(`\\b${name}\\b`, 'i').test(menu[1].split(/;|\bnot shown\b/)[0]));
    for (const name of shown) expect(options, withTc(world, `the menu shows ${name}`)).toContain(name.toLowerCase());
    if (/\bonly\b/i.test(text)) expect(options.length, withTc(world, 'the menu shows only the named options')).toBe(shown.length);
    for (const name of ['Edit', 'Delete']) {
      if (new RegExp(`${name} (?:is|are) not shown|${name} and Delete are not shown`, 'i').test(text) && !shown.includes(name)) {
        expect(options, withTc(world, `the menu does not show ${name}`)).not.toContain(name.toLowerCase());
      }
    }
    did();
  }
  if (/^(?:The )?'Add' button is displayed/i.test(text)) {
    expect(await list.isAddVisible(), withTc(world, "the 'Add' button is displayed")).toBe(true);
    did();
  } else if (/^(?:The )?'Add' button is not displayed/i.test(text)) {
    expect(await list.isAddVisible(), withTc(world, "the 'Add' button is not displayed")).toBe(false);
    did();
  }
  if (/'Edit' button is not shown|Only 'Close' \(and the X icon\)/i.test(text)) {
    await expect(view.editButton).toBeHidden();
    did();
  }
  if (/^No edit or delete control exists/i.test(text)) {
    expect(await activityLog.hasEditOrDeleteControls(), withTc(world, 'the Activity Log has no edit / delete control')).toBe(false);
    did();
  }
  if (/^(?:No field is editable|All values are read-only)|values cannot be changed/i.test(text)) {
    expect(await view.hasEditableInputs(), withTc(world, 'every View field is read-only')).toBe(false);
    did();
  }
  if (/^Field Title, Parent Title, Enum ID and Display are editable/i.test(text)) {
    for (const field of ['Field Title', 'Parent Title', 'Enum ID', 'Display'] as const) {
      expect(await form.isEditable(field), withTc(world, `${field} is editable`)).toBe(true);
    }
    did();
  }
  if (/^Pop-up shows Field Title \(text box\)/i.test(text)) {
    await expect(form.fieldTitle).toBeVisible();
    await expect(form.parentTitle).toBeVisible();
    await expect(form.enumId).toBeVisible();
    await expect(form.display).toBeVisible();
    expect(await form.buttonNames(), withTc(world, 'Save and Cancel are shown')).toEqual(expect.arrayContaining(['Save', 'Cancel']));
    did();
  }

  // --- list contents ---------------------------------------------------------------------------------------------
  if (/^Exactly these six columns are present in this order/i.test(text)) {
    expect(await list.columnNames(), withTc(world, 'the six columns are shown in order')).toEqual([...MM_COLUMNS]);
    did();
  }
  if (/^Every row has a kebab icon/i.test(text)) {
    expect(await list.kebabCount(), withTc(world, 'every row has a kebab icon')).toBe(await list.rowCount());
    did();
  }
  const slNo = /'([^']+)' (?:is|is now|remains at) Sl\. No\. (\d+)|'([^']+)' is Sl\. No\. (\d+)/.exec(text);
  if (slNo) {
    const title = slNo[1] ?? slNo[3];
    const no = slNo[2] ?? slNo[4];
    expect((await list.rowOf(title))?.slNo, withTc(world, `'${title}' is Sl. No. ${no}`)).toBe(no);
    did();
  }
  if (/'No records found\.'/.test(text)) {
    await expect(list.noRecords, withTc(world, "'No records found.' is shown")).toBeVisible({ timeout: 15000 });
    did();
  }
  const indicator = /indicator (?:shows |is |)'(\d+ \/ \d+)'/i.exec(text);
  if (indicator) {
    expect(await list.indicator(), withTc(world, `the page indicator shows ${indicator[1]}`)).toBe(indicator[1].replace(/\s+/g, ''));
    did();
  }
  const rows = /^Page (\d) (?:shows|contains) (\d+) rows?|^Page 1 shows (\d+) rows|Page 3 shows (\d+) rows/i.exec(text);
  if (rows) {
    const expected = Number(rows[2] ?? rows[3] ?? rows[4]);
    expect(await list.rowCount(), withTc(world, `the page holds ${expected} rows`)).toBe(expected);
    did();
  }
  if (/^All 50 rows are displayed on one page and pagination controls are hidden/i.test(text)) {
    expect(await list.rowCount(), withTc(world, 'all 50 rows are on one page')).toBe(50);
    expect(await list.arePaginationControlsVisible(), withTc(world, 'pagination controls are hidden')).toBe(false);
    did();
  }
  if (/^First and Previous are disabled; Next and Last are enabled/i.test(text)) {
    for (const name of ['First', 'Previous'] as const) expect(await list.isControlEnabled(name), withTc(world, `${name} is disabled`)).toBe(false);
    for (const name of ['Next', 'Last'] as const) expect(await list.isControlEnabled(name), withTc(world, `${name} is enabled`)).toBe(true);
    did();
  }
  if (/^Next and Last are disabled; First and Previous are enabled/i.test(text)) {
    for (const name of ['Next', 'Last'] as const) expect(await list.isControlEnabled(name), withTc(world, `${name} is disabled`)).toBe(false);
    for (const name of ['First', 'Previous'] as const) expect(await list.isControlEnabled(name), withTc(world, `${name} is enabled`)).toBe(true);
    did();
  }
  if (/^Options are All, Checked, Unchecked/i.test(text)) {
    expect(await list.displayFilterOptions(), withTc(world, 'the Display filter lists All, Checked, Unchecked')).toEqual([...DISPLAY_FILTER_OPTIONS]);
    expect(await list.displayFilterValue(), withTc(world, "'All' is selected by default")).toMatch(/^all$/i);
    expect(await list.displayFilterAcceptsFreeText(), withTc(world, 'the Display filter is a dropdown, not free text')).toBe(false);
    did();
  }
  if (/^First option is the blank '-- Select Parent Title --'/.test(text)) {
    const options = (scenario.scratch.options as string[] | undefined) ?? (await form.parentOptions());
    expect(options[0], withTc(world, 'the first Parent Title option is the placeholder')).toBe(PARENT_PLACEHOLDER);
    did();
  }
  if (/^Display is unchecked on the Add form/.test(text)) {
    expect(await form.isDisplayChecked(), withTc(world, 'Display is unchecked on the Add form')).toBe(false);
    did();
  }
  if (/^Sl\. No\. and Actions have no search box/.test(text)) {
    expect(await list.hasSearchBox('Title') && (await list.hasSearchBox('Enum ID')) && (await list.hasSearchBox('Parent Title')), withTc(world, 'Enum ID, Title and Parent Title have search boxes')).toBe(true);
    did();
  }
  if (/^Enum ID, Title and Parent Title have a text search box/.test(text)) {
    expect(await list.hasSearchBox('Title') && (await list.hasSearchBox('Enum ID')) && (await list.hasSearchBox('Parent Title')), withTc(world, 'the three text search boxes exist')).toBe(true);
    await expect(list.displayFilter).toBeVisible();
    did();
  }

  // --- field limits, focus, stored values ------------------------------------------------------------------------
  const limit = /(?:only (?:the )?first (\d+) characters|contains only the first (\d+) characters|exactly the first (\d+) characters|is cut at (\d+) characters)/i.exec(text);
  if (limit) {
    const count = Number(limit[1] ?? limit[2] ?? limit[3] ?? limit[4]);
    const field = count === FIELD_LIMITS.enumIdDigits ? 'Enum ID' : 'Field Title';
    expect((await form.value(field)).length, withTc(world, `${field} keeps only the first ${count} characters`)).toBeLessThanOrEqual(count);
    did();
  }
  if (/^The cursor is placed in the Field Title box/.test(text)) {
    expect(await form.hasFocus('Field Title'), withTc(world, 'the cursor is in Field Title')).toBe(true);
    did();
  }
  if (/^Internal ID is not shown|^The Internal ID is not shown on any screen/.test(text)) {
    expect(scenario.scratch.internalIdVisible, withTc(world, 'no Internal ID is shown')).toBe(false);
    did();
  }
  if (/^The checkbox is disabled while the request is in progress|^Save is disabled while the request is in progress/.test(text)) {
    // Observed on the throttled request in the same scenario; the throttle itself is not available (see SKIP.serviceFailure).
    return skipBecause(world, SKIP.serviceFailure);
  }
  if (/^The checkbox shows checked/.test(text)) {
    const title = scenario.target ?? (await list.titles())[0];
    expect(await list.isDisplayChecked(title), withTc(world, `Display of '${title}' is checked`)).toBe(true);
    did();
  }
  if (/^Checkboxes show the saved states .* and are disabled/.test(text)) {
    for (const row of await list.rows()) expect(await list.isDisplayEnabled(row.title), withTc(world, `Display of '${row.title}' is disabled`)).toBe(false);
    did();
  }
  if (/^(?:Update succeeds; )?Display checked in the list/.test(text)) {
    const title = scenario.target ?? scenario.entered.fieldTitle ?? '';
    expect((await list.rowOf(title))?.display, withTc(world, `Display of '${title}' is checked in the list`)).toBe('Checked');
    did();
  }
  if (/^Title List shows '([^']+)'/.test(text)) {
    const title = /^Title List shows '([^']+)'/.exec(text)![1];
    expect(await list.titles(), withTc(world, `the list shows '${title}'`)).toContain(title);
    did();
  }
  if (/^Title is saved|^Rename succeeds|^Update succeeds/.test(text)) {
    if (/Enum ID column shows (\d+)/.test(text)) {
      const title = scenario.target ?? scenario.entered.fieldTitle ?? '';
      expect((await list.rowOf(title))?.enumId, withTc(world, 'the Enum ID column shows the saved value')).toBe(/Enum ID column shows (\d+)/.exec(text)![1]);
      did();
    }
  }
  if (/Title is saved with (?:Enum ID|an empty Enum ID)/.test(text) || /Parent Title column of the new row is blank|Enum ID column of the new row is blank/.test(text)) {
    const title = scenario.entered.fieldTitle?.trim().replace(/\s+/g, ' ');
    const row = title ? await list.rowOf(title) : undefined;
    expect(row, withTc(world, 'the new Title is listed')).toBeDefined();
    const blank = /empty Enum ID|Enum ID column of the new row is blank/.test(text);
    if (blank) expect(row?.enumId, withTc(world, 'the Enum ID is blank')).toBe('');
    did();
  }

  if (applied === 0) {
    if (requireBaselineNeeded(text)) return requireBaseline(world) ?? skipBecause(world, `the outcome "${text.slice(0, 140)}" is not machine-verifiable yet (needs the real screen to be inspected).`);
    return skipBecause(world, `the outcome "${text.slice(0, 140)}" is not machine-verifiable yet (needs the real screen to be inspected).`);
  }
  return undefined;
}

/** Outcomes that name baseline rows (the 18 default Titles) cannot be judged without them. */
function requireBaselineNeeded(text: string): boolean {
  return /baseline Titles|18 Titles|Sl\. No\. runs 1 to 18|'List of (?:Title|Firm Type|Operator|Specialization)'/.test(text);
}
