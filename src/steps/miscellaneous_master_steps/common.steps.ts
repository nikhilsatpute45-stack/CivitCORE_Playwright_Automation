/**
 * Miscellaneous Master steps shared by more than one feature file in features/miscellaneous_master_features. Cucumber step text is
 * global, so a step used by several features is defined once, here; steps used by a single feature live in that feature's own
 * step file. Quoted values use single quotes in these features ('Obsolete Field'), which keeps them distinct from the
 * double-quoted steps of the Designation / Location / Region modules.
 *
 * Phrases this module has in common, word for word, with the Audit Trail and Contractor Category modules are NOT registered here:
 *   - the five Audit Trail / Contractor Category shared phrases go through the shared registry (shared_handlers.steps.ts);
 *   - the generic UI phrases Contractor Category also registers ("the user clicks 'Add'", "... Save", "Esc", "Baseline data (see
 *     Summary) is loaded", ...) are isolated in shared_with_contract_category.steps.ts so a merge fix is one mechanical edit.
 *
 * Families of near-identical sentences are registered as ONE step each (a vocabulary-guarded regex) and routed by a small table,
 * so two definitions can never match the same sentence.
 */
import { Given, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { SKIP } from '../../test-data/miscellaneous-master.data';
import {
  ensureRecord,
  logInAs,
  openList,
  openRowMenuAndSelect,
  requireBulk,
  requireExactCount,
  saveForm,
  skipBecause,
  testDatum,
  withToast,
  type Skippable,
} from './helpers';

const USER = '([A-Za-z]+_User\\d+)';

// ---------------------------------------------------------------------------
// Login + landing (the bare forms "X_User1 (...) is logged in" are in the shared registry)
// ---------------------------------------------------------------------------

Given(
  new RegExp(`^${USER} \\((?:Miscellaneous Master: )?[^)]*\\) is logged in and on the Title List page(?: \\(Admin > Configuration > Miscellaneous Master\\))?$`),
  async function (this: CustomWorld, user: string): Skippable {
    return (await logInAs(this, user)) ?? (await openList(this));
  },
);

// ---------------------------------------------------------------------------
// Datasets and role / multi-user preconditions
// ---------------------------------------------------------------------------

Given(/^Pagination Dataset ([ABC]) \([^)]*\) is loaded$/, async function (this: CustomWorld, dataset: string): Skippable {
  return dataset === 'C' ? requireBulk(this) : requireExactCount(this);
});

Given(/^(?:A Role Admin account is available|Admin_User1 and Admin_User2 are both assigned role '[^']*' \([^)]*\))$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.roleManagement);
});

Given(/^Admin_User1 performs the actions and Auditor_User1 \([^)]*\) views the log$/, async function (this: CustomWorld): Skippable {
  if (await mmPages(this).activityLog.isAvailable()) return undefined;
  return skipBecause(this, SKIP.activityLog);
});

// ---------------------------------------------------------------------------
// Role Management, second sessions and the other modules (not automated)
// ---------------------------------------------------------------------------

When(/^(?:In the Role Admin account|As Role Admin) .+$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.roleManagement);
});

When(/^(?:In Session [AB]|In another session|In the first session|Session [AB]:) .+$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.secondSession);
});

When(/^the user logs in as Admin_User[12] .*$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.roleManagement);
});

When(/^the user opens the kebab on '[^']*' for both users$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.roleManagement);
});

When(
  /^the user opens (?:Specialization Master(?: and note the available fields)?|or refresh Specialization Master|the Vendor Registration form(?: and the Specialization Master)?|the Vendor Registration and Contractor Registration forms|a transaction that uses the Title|transaction TXN-\d+)$|^the user re-opens the Vendor Registration(?: and Contractor Registration forms| form)$/,
  async function (this: CustomWorld): Skippable {
    return skipBecause(this, SKIP.crossModule);
  },
);

When(/^the user (?:configures the Display update API to return a server error|throttles the (?:Display update|save) API response? by 5 seconds|throttles the Display update API by 5 seconds)$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.serviceFailure);
});

// ---------------------------------------------------------------------------
// "As <user> ..." (Admin_User1 / Editor_User1 / Auditor_User1) - one routed step
// ---------------------------------------------------------------------------

When(/^As (Admin_User1|Editor_User1|Auditor_User1) (.+)$/, async function (this: CustomWorld, user: string, action: string): Skippable {
  const scenario = mmScenario(this);
  const { list, view, form } = mmPages(this);

  if (user === 'Auditor_User1') return (await mmPages(this).activityLog.isAvailable()) ? undefined : skipBecause(this, SKIP.activityLog);
  if (/Specialization Master|Vendor|Contractor Registration/.test(action)) return skipBecause(this, SKIP.crossModule);
  if (user !== 'Admin_User1') {
    // Editor_User1 acts under their own login; the scenario's Given already signed that user in.
    if (/check its Display checkbox/.test(action)) {
      const title = scenario.target ?? (await list.titles())[0];
      await withToast(this, () => list.clickDisplay(title), 8000);
      return undefined;
    }
    const edit = /edit '([^']*)' and change the Field Title/.exec(action);
    if (edit) {
      await openRowMenuAndSelect(this, edit[1], 'Edit');
      await form.fill('Field Title', `${edit[1]} Rev`);
      await saveForm(this);
      return undefined;
    }
  }

  let m: RegExpExecArray | null;
  if ((m = /^open View for '([^']*)'(?: and close it)?$/.exec(action))) {
    await openRowMenuAndSelect(this, m[1], 'View');
    if (/and close it/.test(action)) await view.clickClose();
  } else if ((m = /^select Delete on '([^']*)'$/.exec(action))) {
    await withToast(this, () => openRowMenuAndSelect(this, m![1], 'Delete'), 5000);
  } else if ((m = /^delete '([^']*)' and click Yes$/.exec(action))) {
    await openRowMenuAndSelect(this, m[1], 'Delete');
    await withToast(this, () => mmPages(this).deletion.yes(), 8000);
  } else if ((m = /^create Title '([^']*)' without Enum ID and Title '([^']*)' with Enum ID (\d+)$/.exec(action))) {
    return (await ensureRecord(this, m[1])) ?? (await ensureRecord(this, m[2], m[3], testDatum(this, 'Parent Title') ?? undefined));
  } else if ((m = /^create Title '([^']*)', then edit it, then delete it$/.exec(action))) {
    return skipBecause(this, `${SKIP.activityLog} (the create / edit / delete sequence only feeds the Activity Log assertions)`);
  } else if (/^create the Title$/.test(action)) {
    return ensureRecord(this, testDatum(this, 'Field Title') ?? testDatum(this, 'Title') ?? 'Contractor Category', testDatum(this, 'Enum ID'), testDatum(this, 'Parent Title'));
  } else if ((m = /^(?:edit|rename|open Edit on) '([^']*)'(?: to '([^']*)')?(.*)$/.exec(action))) {
    return skipBecause(this, `the multi-step Admin edit "${action.slice(0, 80)}" only feeds the Activity Log / Display assertions that follow (${SKIP.activityLog}).`);
  } else if (/^check Display of '([^']*)' in the list$/.test(action)) {
    const title = /'([^']*)'/.exec(action)![1];
    scenario.scratch.displayShown = await list.isDisplayChecked(title);
  } else {
    return skipBecause(this, `no automation for the Admin step "${action.slice(0, 80)}" (${SKIP.activityLog}).`);
  }
  return undefined;
});
