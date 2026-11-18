/** Steps of features/audit_trail_features/audit_log_read_only.feature (no inline editing in the grid; no update / delete of one entry through the API). */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { auditPages, auditScenario } from '../../support/audit-trail-scenario';
import { SKIP } from '../../test-data/audit-trail.data';
import { expect } from '../../utils/assertions';
import { exact, readStore, requireDestructive, skipBecause, withTc, type Skippable } from './helpers';

When(/^Double-click the Message cell of the first row$/, async function (this: CustomWorld) {
  const { list } = auditPages(this);
  const scenario = auditScenario(this);
  scenario.snapshot = await list.rows();
  scenario.scratch.editorOpened = await list.editorOpensOnDoubleClick(0, 'Message');
});

When(/^Try to type into Function Name, Class Name and Client IP cells$/, async function (this: CustomWorld) {
  const { list } = auditPages(this);
  const scenario = auditScenario(this);
  let accepted = false;
  for (const column of ['Function Name', 'Class Name', 'Client IP'] as const) {
    accepted = (await list.acceptsTypingIn(0, column, 'x')) || accepted;
  }
  scenario.scratch.typingAccepted = accepted;
});

Then(exact('No cell enters edit mode; values remain unchanged.'), async function (this: CustomWorld) {
  const scenario = auditScenario(this);
  expect(scenario.scratch.editorOpened, withTc(this, 'double-clicking the Message cell opens no editor')).toBe(false);
  expect(scenario.scratch.typingAccepted, withTc(this, 'typing into the cells opens no editor')).toBe(false);
  expect(await auditPages(this).list.rows(), withTc(this, 'the grid values are unchanged')).toEqual(scenario.snapshot);
});

/** Picks one stored entry to attack and remembers it, so the rejected-Then can prove it is unchanged / still there. */
async function pickTarget(world: CustomWorld): Promise<{ id: number | string; message: string } | undefined> {
  const entries = await readStore(world);
  const entry = entries.find((candidate) => candidate.id !== undefined);
  if (!entry) return undefined;
  const target = { id: entry.id as number | string, message: entry.message };
  auditScenario(world).scratch.targetEntry = target;
  return target;
}

When(/^Send PUT\/PATCH to update the Message of an existing audit entry$/, async function (this: CustomWorld): Skippable {
  // If the server wrongly accepted it, the request would tamper with audit data, so it is gated like Clear Log.
  const skipped = requireDestructive(this);
  if (skipped) return skipped;
  const target = await pickTarget(this);
  if (!target) return skipBecause(this, `no audit entry with an id could be read. ${SKIP.noEndpoint}`);
  const result = await auditPages(this).api.updateEntry(target.id, auditScenario(this).datum('Message') || 'Tampered text');
  auditScenario(this).lastApi = result;
  auditScenario(this).lastApis = [result];
  return undefined;
});

When(/^Send DELETE for a single audit entry$/, async function (this: CustomWorld): Skippable {
  const skipped = requireDestructive(this);
  if (skipped) return skipped;
  const target = await pickTarget(this);
  if (!target) return skipBecause(this, `no audit entry with an id could be read. ${SKIP.noEndpoint}`);
  const result = await auditPages(this).api.deleteEntry(target.id);
  auditScenario(this).lastApi = result;
  auditScenario(this).lastApis = [result];
  return undefined;
});

When(/^Query the entry$/, function () {
  // Nothing to do: the shared "Request is rejected" step re-reads the store and compares the entry.
});
