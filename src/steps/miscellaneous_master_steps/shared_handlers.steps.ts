/**
 * This module's handlers for the step phrases several modules' features share word for word. Those phrases are registered once,
 * in src/steps/shared_steps/shared.steps.ts, and routed by the scenario's module tag to the handlers registered below (see
 * src/support/shared-step-registry.ts). Phrases covered:
 *   "the following test data is used"
 *   "API client authenticated with the token of the user named in Test Data"
 *   "<User> is logged in" / "<User> (<permissions>) is logged in"
 *   "the user observes|inspects|notes|checks|queries|reads|compares|re-counts|exports ..."
 *   "Request is rejected (403[/405]); ..."
 */
import type { DataTable } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { registerSharedHandlers, type SharedResult } from '../../support/shared-step-registry';
import { SKIP } from '../../test-data/miscellaneous-master.data';
import { expect } from '../../utils/assertions';
import { logInAs, openEditFor, openRowMenuAndSelect, rememberGrid, rememberOriginal, requireDatum, requireBaseline, skipBecause, withTc, withToast, type Skippable } from './helpers';

/** Strips one pair of wrapping single quotes ("' Contractor Grade '" -> " Contractor Grade "), keeping inner spaces. */
export function unquote(value: string): string {
  return /^'.*'$/s.test(value) && value.length >= 2 ? value.slice(1, -1) : value;
}

async function testData(world: CustomWorld, table: DataTable): Skippable {
  const scenario = mmScenario(world);
  scenario.testRows = table.raw().map(([key, value]) => [(key ?? '').trim(), unquote((value ?? '').trim())]);
  scenario.testData = Object.fromEntries(scenario.testRows);
  if (scenario.deferredOpen === 'edit') {
    scenario.deferredOpen = undefined;
    await openEditFor(world, requireDatum(world, 'Row', 'Title', 'Field Title'));
  }
  return undefined;
}

async function apiClient(world: CustomWorld): Skippable {
  mmScenario(world).scratch.apiClientRequested = true;
  return undefined;
}

async function loggedIn(world: CustomWorld, user: string): Skippable {
  return logInAs(world, user);
}

async function rejected(world: CustomWorld, sentence: string, codes: string): Skippable {
  const results = mmScenario(world).lastApis.length > 0 ? mmScenario(world).lastApis : mmScenario(world).lastApi ? [mmScenario(world).lastApi!] : [];
  expect(results.length, withTc(world, `an API response was recorded for: ${sentence}`)).toBeGreaterThan(0);
  const allowed = codes.split('/').map(Number);
  for (const result of results) expect(allowed, withTc(world, `the request is rejected with ${codes} (got ${result.status})`)).toContain(result.status);
  return undefined;
}

/**
 * "the user observes|inspects|notes|checks|queries ...": most of these only describe where the tester looks (the Then step
 * asserts it). The ones that do something - tick a Display checkbox, note a Sl. No., read the Internal ID - are handled here.
 */
async function observe(world: CustomWorld, verb: string, rest: string): Skippable {
  const { list, view, form, api, activityLog } = mmPages(world);
  const scenario = mmScenario(world);
  const text = rest.trim();

  // Activity Log reads: no confirmed entry point yet, so they skip rather than guess.
  if (/Activity Log/i.test(text)) {
    if (!(await activityLog.isAvailable())) return skipBecause(world, SKIP.activityLog);
    if (/entry count/.test(text)) scenario.notedCount = await activityLog.count();
    else await activityLog.open();
    return undefined;
  }
  // Specialization Master / Vendor or Contractor Registration / transactions / the consuming screens.
  if (/Specialization Master|Vendor Registration|Contractor Registration|transaction|TXN-|parent reference|Firm Type field|menu for Miscellaneous Master/i.test(text)) {
    if (/menu for Miscellaneous Master/.test(text)) {
      scenario.scratch.menuVisible = await list.isNavEntryVisible();
      return undefined;
    }
    return skipBecause(world, SKIP.crossModule);
  }

  if (verb === 'checks' && /^the Display checkbox of '([^']*)'$/.test(text)) {
    const title = /'([^']*)'/.exec(text)![1];
    scenario.target = title;
    await rememberOriginal(world, title);
    if (!(await list.isDisplayChecked(title))) await withToast(world, () => list.clickDisplay(title), 8000);
    return undefined;
  }
  if (verb === 'notes') {
    const sl = [...text.matchAll(/'([^']*)' \((\d+)\)/g)];
    if (/Sl\. No\./.test(text) && sl.length > 0) {
      for (const match of sl) scenario.notedSlNos[match[1]] = (await list.rowOf(match[1]))?.slNo ?? match[2];
    } else if (/all values of '([^']*)' in View/.test(text)) {
      scenario.scratch.viewText = await view.text();
    } else if (/^'([^']*)' (?:in the list|as deletable)|^the row '/.test(text)) {
      await rememberGrid(world);
      scenario.notedTitles = await list.titles();
    }
    return undefined;
  }
  if (verb === 'queries' && /Internal ID|Title store/.test(text)) {
    if (!api.hasSession()) return skipBecause(world, 'no authenticated API session is available to query the Internal ID.');
    const title = /'([^']*)'/.exec(text)?.[1] ?? scenario.target;
    const all = await api.fetchAll();
    scenario.scratch.records = all;
    scenario.notedInternalId = title ? all.find((record) => record.fieldTitle === title)?.id : scenario.notedInternalId;
    return undefined;
  }
  if (/Internal ID/.test(text) && /^(?:inspects|observes)/.test(verb)) {
    const columns = await list.columnNames();
    let visible = columns.some((name) => /internal\s*id/i.test(name));
    const first = (await list.titles())[0];
    if (first) {
      await openRowMenuAndSelect(world, first, 'View');
      visible = visible || /internal id/i.test(await view.text());
      await view.clickClose();
      await openEditFor(world, first);
      visible = visible || /internal id/i.test(await form.text());
      await form.cancel();
    }
    scenario.scratch.internalIdVisible = visible;
    return undefined;
  }
  if (verb === 'observes' && /^and click the Display checkboxes of 'List of Title' \(checked\) and 'List of Specialization' \(unchecked\)$/.test(text)) {
    const skipped = requireBaseline(world);
    if (skipped) return skipped;
    for (const title of ['List of Title', 'List of Specialization']) {
      scenario.scratch[`display:${title}`] = await list.isDisplayChecked(title);
    }
    return undefined;
  }
  if (verb === 'observes' && /the pagination area|the order of rows|the new row|the Enum ID column|the Parent Title column|the list|rows and indicator|first Sl\. No/.test(text)) {
    await list.expectListVisible();
    return undefined;
  }
  if (/for 5 seconds/.test(text)) {
    await world.captureNewToast(await world.visibleToasts(), 5000);
  }
  if (/Display of 'Draft Field'/.test(text)) return skipBecause(world, SKIP.crossModule);
  // Every other observation only describes where the tester looks; the Then step asserts it.
  return undefined;
}

registerSharedHandlers('@MiscellaneousMaster', {
  testData,
  apiClient,
  loggedIn,
  observe: async (world, verb, rest): SharedResult => observe(world, verb, rest),
  rejected: async (world, sentence, codes): SharedResult => rejected(world, sentence, codes),
});
