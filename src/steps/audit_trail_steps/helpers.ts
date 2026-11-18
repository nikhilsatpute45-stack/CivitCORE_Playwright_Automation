/**
 * Shared building blocks of the Audit Trail step definitions (no steps are registered here).
 *
 * Skipping convention (same as Miscellaneous Master): a step returns SKIPPED, with the reason logged, when the scenario cannot run in
 * this environment (baseline not seeded, destructive run not allowed, role user missing, role management / source modules not
 * automated, ...). Cucumber then reports the rest of the scenario as skipped, never silently passed. Reasons live in
 * test-data/audit-trail.data.ts (SKIP).
 *
 * Traceability: every failure message carries the scenario's @TC_* id (see `withTc`).
 */
import type { CustomWorld } from '../../support/world';
import { auditPages, auditScenario } from '../../support/audit-trail-scenario';
import { testCaseTag } from '../../support/shared-step-registry';
import { alreadyAuthenticated, markAuthenticated } from '../../support/session';
import { config, getCredentials, getRoleCredentials } from '../../support/config';
import {
  BASELINE,
  SKIP,
  addDays,
  isoDate,
  parseFeatureDate,
  roleKeyOfUser,
  shiftIso,
  shiftText,
  shiftToRun,
  type TimedEntryRef,
} from '../../test-data/audit-trail.data';
import { expect, escapeRegExp } from '../../utils/assertions';
import { AuditTrailApi, parseLogDateTime } from '../../pages/audit_trail_pages';
import type { AuditEntry, AuditRow, LogStamp } from '../../pages/audit_trail_pages';

export const SKIPPED = 'skipped' as const;
export type Skippable = Promise<typeof SKIPPED | undefined>;

export function skipBecause(world: CustomWorld, reason: string): typeof SKIPPED {
  world.log(`Skipped: ${reason}`);
  return SKIPPED;
}

/** "@TC_CP_011" prefix for failure messages. */
export function withTc(world: CustomWorld, message: string): string {
  const tc = testCaseTag(world);
  return tc ? `[${tc}] ${message}` : message;
}

/** A RegExp that matches `text` literally, start to end (for the long prose sentences the features use as steps). */
export function exact(text: string): RegExp {
  return new RegExp(`^${escapeRegExp(text)}$`);
}

// ---------------------------------------------------------------------------
// Run gates
// ---------------------------------------------------------------------------

export function requireBaseline(world: CustomWorld): typeof SKIPPED | undefined {
  return config.auditTrail.baselineSeeded ? undefined : skipBecause(world, SKIP.baseline);
}

export function requireDestructive(world: CustomWorld): typeof SKIPPED | undefined {
  return config.auditTrail.allowDestructive ? undefined : skipBecause(world, SKIP.destructive);
}

// ---------------------------------------------------------------------------
// Session
// ---------------------------------------------------------------------------

async function ensureLoggedIn(world: CustomWorld, credentials: { username: string; password: string }): Promise<void> {
  if (alreadyAuthenticated()) return;
  const masters = world.pages.mastersManagementPage;
  if (await masters.mastersManagementLink.isVisible().catch(() => false)) return;
  await world.pages.midcHomePage.open();
  await world.pages.midcHomePage.openDepartmentLogin();
  await world.pages.departmentLoginPage.expectLoaded();
  await world.pages.departmentLoginPage.login(credentials.username, credentials.password);
  if (await world.pages.departmentLoginPage.hasAuthenticationError()) {
    throw new Error(withTc(world, 'Login failed: the portal reported an authentication error.'));
  }
  markAuthenticated(world.page);
}

/**
 * Signs in as the user a feature names. "Admin_User1" uses the default MIDC_USERNAME / MIDC_PASSWORD; every other user uses
 * MIDC_<ROLE>_USERNAME / _PASSWORD (VIEWER, NOACCESS, CLEARONLY), otherwise the scenario is skipped.
 */
export async function logInAs(world: CustomWorld, user: string): Skippable {
  auditPages(world); // built before any traffic so the API object sees the page's bearer token
  auditScenario(world).user = user;
  const key = roleKeyOfUser(user);
  if (key === 'ADMIN') {
    await ensureLoggedIn(world, getCredentials());
    return undefined;
  }
  if (config.sharedSession) return skipBecause(world, SKIP.sharedSession);
  const credentials = getRoleCredentials(key);
  if (!credentials) return skipBecause(world, `no ${user} is configured; set MIDC_${key}_USERNAME and _PASSWORD to run it.`);
  await ensureLoggedIn(world, credentials);
  return undefined;
}

/** Makes sure some user is signed in (Admin_User1 when the scenario named nobody). */
export async function ensureSession(world: CustomWorld): Skippable {
  if (auditScenario(world).user) return undefined;
  return logInAs(world, 'Admin_User1');
}

/** Opens the Audit Trail screen as the signed-in user and waits for the listing to settle. */
export async function openAuditTrail(world: CustomWorld): Skippable {
  const skipped = await ensureSession(world);
  if (skipped) return skipped;
  const { list, dialog } = auditPages(world);
  await dialog.dismiss();
  await list.open(config.auditTrail.url || undefined);
  await list.waitForListing();
  auditScenario(world).initialRows = await list.rows();
  return undefined;
}

// ---------------------------------------------------------------------------
// Dates and test data
// ---------------------------------------------------------------------------

/** A feature date literal ("17-Oct-2026") as the run-date equivalent, or the text untouched when it is not a valid date. */
export function runDateText(world: CustomWorld, literal: string): string {
  const scenario = auditScenario(world);
  return scenario.literalDates ? literal : shiftText(literal, scenario.today);
}

export function runIso(world: CustomWorld, literal: string): string {
  const scenario = auditScenario(world);
  return scenario.literalDates ? literal : shiftIso(literal, scenario.today);
}

/** Wide range that covers every entry the store can hold up to today (for "query the audit store"). */
export function wholeStoreRange(world: CustomWorld): { from: string; to: string } {
  const today = auditScenario(world).today;
  return { from: isoDate(addDays(today, -3650)), to: isoDate(today) };
}

export function stampOf(row: AuditRow): LogStamp | undefined {
  return parseLogDateTime(row.logDateTime);
}

/** True when the row's Log Date & Time is the day / hh:mm of `ref` (seconds are ignored: the features quote hh:mm). */
export function rowIsAt(row: AuditRow, ref: TimedEntryRef): boolean {
  const stamp = stampOf(row);
  return Boolean(stamp) && stamp!.date.getTime() === ref.date.getTime() && stamp!.hours === ref.hours && stamp!.minutes === ref.minutes;
}

export function describeRows(rows: AuditRow[]): string {
  return rows.map((row) => `${row.logDateTime} ${row.functionName}`).join('; ') || '(no rows)';
}

// ---------------------------------------------------------------------------
// Filter actions
// ---------------------------------------------------------------------------

export async function setRange(world: CustomWorld, from?: string, to?: string): Promise<void> {
  const { filters } = auditPages(world);
  const scenario = auditScenario(world);
  if (from !== undefined) {
    const typed = runDateText(world, from);
    await filters.setFromDate(typed);
    scenario.typedRange.from = typed;
  }
  if (to !== undefined) {
    const typed = runDateText(world, to);
    await filters.setToDate(typed);
    scenario.typedRange.to = typed;
  }
}

/** Clicks Search and waits for the listing to settle, unless the click was blocked by a validation message. */
export async function clickSearch(world: CustomWorld): Promise<void> {
  const { filters, list } = auditPages(world);
  await filters.search();
  const blocked = await filters.validationMessages().then((messages) => messages.length > 0);
  if (!blocked) await list.waitForListing().catch(() => undefined);
}

// ---------------------------------------------------------------------------
// Audit store (API)
// ---------------------------------------------------------------------------

/** Every entry the store holds up to today, read through the API. TODO(endpoint): see AuditTrailApi. */
export async function readStore(world: CustomWorld, fn = 'All', from?: string, to?: string): Promise<AuditEntry[]> {
  const { api } = auditPages(world);
  const range = wholeStoreRange(world);
  const result = await api.getEntries({ function: fn, from: from ?? range.from, to: to ?? range.to });
  const scenario = auditScenario(world);
  scenario.lastApi = result;
  scenario.lastApis = [result];
  expect(result.status, withTc(world, `the get-audit-entries request succeeded (${result.status} ${result.message})`)).toBeLessThan(300);
  scenario.lastEntries = AuditTrailApi.entriesOf(result);
  return scenario.lastEntries;
}

/** True for an entry the stored data says is a Clear Log event (FRD 7.1 A-Clear). */
export function isClearLogEntry(entry: AuditEntry): boolean {
  return /clear/i.test(entry.message) || /clear/i.test(entry.functionName);
}

// ---------------------------------------------------------------------------
// Baseline matching (workbook entries #1-#14)
// ---------------------------------------------------------------------------

/** True when a stored entry is baseline entry `no` (same Function, and the same day / time once dates are shifted to the run date). */
export function matchesBaseline(world: CustomWorld, entry: AuditEntry, no: number): boolean {
  const baseline = BASELINE.find((candidate) => candidate.no === no);
  if (!baseline) throw new Error(`There is no baseline entry #${no}.`);
  const featureDate = parseFeatureDate(baseline.featureDate);
  const stamp = parseLogDateTime(entry.logDateTime);
  if (!featureDate || !stamp || entry.functionName.trim().toLowerCase() !== baseline.entity.toLowerCase()) return false;
  const [hours, minutes, seconds] = baseline.time.split(':').map(Number);
  return (
    stamp.date.getTime() === shiftToRun(featureDate, auditScenario(world).today).getTime() &&
    stamp.hours === hours &&
    stamp.minutes === minutes &&
    stamp.seconds === seconds
  );
}

/** Reads the whole store and asserts which baseline entries are still there and which are gone. */
export async function expectBaselineState(world: CustomWorld, present: number[], absent: number[]): Promise<void> {
  const store = await readStore(world);
  for (const no of present) {
    expect(store.some((entry) => matchesBaseline(world, entry, no)), withTc(world, `baseline entry #${no} is still in the audit store`)).toBe(true);
  }
  for (const no of absent) {
    expect(store.some((entry) => matchesBaseline(world, entry, no)), withTc(world, `baseline entry #${no} is no longer in the audit store`)).toBe(false);
  }
}

export const ALL_BASELINE = BASELINE.map((entry) => entry.no);

/**
 * True when a date field's text is the calendar date `expected`, whichever of the likely formats the app uses
 * (DD-Mon-YYYY, DD/MM/YYYY, YYYY-MM-DD). TODO(format): the FRD does not state the date format; narrow this once it is known.
 */
export function sameDate(actual: string, expected: Date): boolean {
  const stamp = parseLogDateTime(`${actual} 00:00`);
  return Boolean(stamp) && stamp!.date.getTime() === expected.getTime();
}
