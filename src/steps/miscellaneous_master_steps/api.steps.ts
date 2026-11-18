/**
 * "the user sends ..." API requests (creation, update, deletion, display configuration, permissions and Activity Log features) and
 * "requests the Title details ... from the consuming-screen read interface". Requests are sent as the user named in the scenario's
 * Test Data (ensureApiClient). A request an authorised caller could succeed with creates real data, so anything that came back
 * 2xx is recorded for the After hook.
 */
import { When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { SKIP } from '../../test-data/miscellaneous-master.data';
import type { MmApiResult, MmPayload } from '../../pages/miscellaneous_master_pages';
import { ensureApiClient, findRecord, skipBecause, testDatum, withTc, type Skippable } from './helpers';
import { repeatToLength } from './inputs';

function record(world: CustomWorld, result: MmApiResult, createdTitle?: string): void {
  const scenario = mmScenario(world);
  scenario.lastApi = result;
  scenario.lastApis.push(result);
  if (result.status < 300 && createdTitle) scenario.created.push(createdTitle.trim());
}

const REQUESTS =
  "(?:a create-Title request(?: with (?:a 101-character Field Title|a blank Field Title|a non-existent Parent Title Internal ID|a non-numeric Enum ID|an 11-digit Enum ID))?|" +
  "a delete-Title request for '[^']*'(?: through the API)?|a list-Titles request|" +
  "an update-Title request for '[^']*'(?: that includes a different Internal ID value| with Parent Title set to '[^']*')?|" +
  "a Display update request for '[^']*'|an update and a delete request for an entry using the API)";

When(new RegExp(`^the user sends (${REQUESTS})$`), async function (this: CustomWorld, what: string): Skippable {
  if (/an entry using the API/.test(what)) return skipBecause(this, SKIP.activityLog);
  const skipped = await ensureApiClient(this);
  if (skipped) return skipped;
  const { api } = mmPages(this);
  const quoted = [...what.matchAll(/'([^']*)'/g)].map((match) => match[1]);

  if (/^a list-Titles request/.test(what)) {
    record(this, await api.list());
  } else if (/^a create-Title request/.test(what)) {
    const payload: MmPayload = { fieldTitle: testDatum(this, 'Field Title') ?? testDatum(this, 'Title') ?? 'Direct API Title', display: false };
    const enumId = testDatum(this, 'Enum ID');
    if (enumId !== undefined) payload.enumId = enumId;
    if (/101-character/.test(what)) payload.fieldTitle = repeatToLength(101);
    else if (/blank Field Title/.test(what)) payload.fieldTitle = '';
    else if (/non-existent Parent Title Internal ID/.test(what)) payload.parentTitleId = Number(testDatum(this, 'Parent Title Internal ID') ?? 999999);
    else if (/non-numeric Enum ID/.test(what)) payload.enumId = testDatum(this, 'Enum ID') ?? 'abc';
    else if (/11-digit Enum ID/.test(what)) payload.enumId = '12345678901';
    record(this, await api.create(payload), payload.fieldTitle);
  } else {
    const title = quoted[0];
    const target = await findRecord(this, title);
    if (!target) return skipBecause(this, `"${title}" does not exist in this environment (${SKIP.baseline})`);
    if (/^a delete-Title request/.test(what)) {
      record(this, await api.remove(target.id));
    } else if (/^a Display update request/.test(what)) {
      record(this, await api.setDisplay(target.id, !target.display));
    } else if (/with Parent Title set to/.test(what)) {
      const parent = await findRecord(this, quoted[1]);
      if (!parent) return skipBecause(this, `"${quoted[1]}" does not exist in this environment (${SKIP.baseline})`);
      record(this, await api.update(target.id, { fieldTitle: target.fieldTitle, parentTitleId: parent.id, enumId: target.enumId || null, display: target.display }));
    } else if (/different Internal ID value/.test(what)) {
      record(this, await api.update(target.id, { fieldTitle: target.fieldTitle, enumId: target.enumId || null, display: target.display, id: target.id + 1000 }));
    } else if (/^an update-Title request/.test(what)) {
      record(this, await api.update(target.id, { fieldTitle: testDatum(this, 'New Title') ?? `${target.fieldTitle} Rev`, enumId: target.enumId || null, display: target.display }));
    } else {
      throw new Error(withTc(this, `No API handler for "${what}".`));
    }
  }
  return undefined;
});

When(/^the user requests the Title details for '([^']*)' from the consuming-screen read interface$/, async function (this: CustomWorld, title: string): Skippable {
  const skipped = await ensureApiClient(this);
  if (skipped) return skipped;
  const target = await findRecord(this, title);
  if (!target) return skipBecause(this, `"${title}" does not exist in this environment (${SKIP.baseline})`);
  mmScenario(this).lastApi = await mmPages(this).api.detail(target.id);
  return undefined;
});
