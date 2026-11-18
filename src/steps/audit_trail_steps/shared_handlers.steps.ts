/**
 * Audit Trail's handlers for the step phrases several modules' features share word for word. Those phrases are registered once, in
 * src/steps/shared_steps/shared.steps.ts, and routed by the scenario's module tag to the handlers registered below (see
 * src/support/shared-step-registry.ts). Phrases covered:
 *   "the following test data is used"
 *   "API client authenticated with the token of the user named in Test Data"
 *   "<User> is logged in" / "<User> (<permissions>) is logged in"
 *   "the user observes|inspects|..." (not used by the Audit Trail features; a no-op here)
 *   "Request is rejected (403[/405]); ..."
 */
import type { DataTable } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { auditScenario } from '../../support/audit-trail-scenario';
import { registerSharedHandlers, type SharedResult } from '../../support/shared-step-registry';
import { expect } from '../../utils/assertions';
import { logInAs, readStore, withTc, type Skippable } from './helpers';

/** Strips one pair of wrapping single quotes ("'abc'" -> "abc"). */
export function unquote(value: string): string {
  return /^'.*'$/s.test(value) && value.length >= 2 ? value.slice(1, -1) : value;
}

async function testData(world: CustomWorld, table: DataTable): Skippable {
  const scenario = auditScenario(world);
  scenario.testRows = table.raw().map(([key, value]) => [(key ?? '').trim(), unquote((value ?? '').trim())]);
  scenario.testData = Object.fromEntries(scenario.testRows);
  // "API client authenticated with the token of the user named in Test Data" precedes the table, so the login happens here.
  if (scenario.apiClientRequested && !scenario.user) {
    const user = scenario.datum('User') || 'Admin_User1';
    const skipped = await logInAs(world, user);
    if (skipped) return skipped;
  }
  return undefined;
}

async function apiClient(world: CustomWorld): Skippable {
  auditScenario(world).apiClientRequested = true;
  return undefined;
}

async function loggedIn(world: CustomWorld, user: string): Skippable {
  return logInAs(world, user);
}

/**
 * "Request is rejected (403[/405]); <consequence>": every request the scenario sent was answered with one of the named codes, and the
 * consequence the sentence names (nothing returned / entries still exist / entry unchanged) holds.
 */
async function rejected(world: CustomWorld, sentence: string, codes: string, rest: string): Skippable {
  const scenario = auditScenario(world);
  const results = scenario.lastApis.length > 0 ? scenario.lastApis : scenario.lastApi ? [scenario.lastApi] : [];
  expect(results.length, withTc(world, `an API response was recorded for: ${sentence}`)).toBeGreaterThan(0);
  const allowed = codes.split('/').map(Number);
  for (const result of results) {
    expect(allowed, withTc(world, `the request is rejected with ${codes} (got ${result.status} ${result.message})`)).toContain(result.status);
  }

  if (/no audit entries are returned/i.test(rest)) {
    expect(scenario.lastEntries, withTc(world, 'no audit entries were returned')).toHaveLength(0);
  }
  if (/entries of the range still exist/i.test(rest)) {
    const before = scenario.notedCount;
    const after = (await readStore(world)).length;
    if (before !== undefined) expect(after, withTc(world, 'no entry of the range was removed')).toBe(before);
    expect(after, withTc(world, 'the entries of the range still exist')).toBeGreaterThan(0);
  }
  if (/no Clear Log entry is created/i.test(rest) && scenario.notedCount !== undefined) {
    expect((await readStore(world)).length, withTc(world, 'no Clear Log entry was added')).toBe(scenario.notedCount);
  }
  if (/entry (?:is unchanged|still exists)/i.test(rest)) {
    const target = scenario.scratch.targetEntry as { id?: number | string; message: string } | undefined;
    expect(target, withTc(world, 'an audit entry was identified before the request')).toBeTruthy();
    const after = (await readStore(world)).find((entry) => entry.id === target!.id);
    expect(after, withTc(world, 'the audit entry still exists')).toBeTruthy();
    expect(after!.message, withTc(world, 'the audit entry is unchanged')).toBe(target!.message);
  }
  return undefined;
}

registerSharedHandlers('@AuditTrail', {
  testData,
  apiClient,
  loggedIn,
  observe: async (): SharedResult => undefined,
  rejected: async (world, sentence, codes, rest): SharedResult => rejected(world, sentence, codes, rest),
});
