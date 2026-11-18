/**
 * Shared building blocks of the Miscellaneous Master step definitions (no steps are registered here).
 *
 * Skipping convention (same as Audit Trail / Contractor Category): a step returns SKIPPED, with the reason logged, when the
 * scenario cannot run in this environment (module not reachable, role user missing, baseline / bulk data not seeded,
 * cross-module dependency, second session, ...). Cucumber then reports the rest of the scenario as skipped, never silently
 * passed. The reasons live in test-data/miscellaneous-master.data.ts (SKIP) and double as the @fixme proposals.
 *
 * Traceability: every failure message carries the scenario's @TC_* id (see `withTc`; the tags come from the shared Before hook).
 */
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { miscellaneousMasterConfig } from '../../support/miscellaneous-master-config';
import { testCaseTag } from '../../support/shared-step-registry';
import { alreadyAuthenticated, markAuthenticated } from '../../support/session';
import { config, getCredentials, getRoleCredentials } from '../../support/config';
import { expect } from '../../utils/assertions';
import { SKIP, mmMessagePattern, roleKeyOfUser } from '../../test-data/miscellaneous-master.data';
import type { MmRecord } from '../../pages/miscellaneous_master_pages';

export const SKIPPED = 'skipped' as const;
export type Skippable = Promise<typeof SKIPPED | undefined>;

export function skipBecause(world: CustomWorld, reason: string): typeof SKIPPED {
  world.log(`Skipped: ${reason}`);
  return SKIPPED;
}

export function requireBaseline(world: CustomWorld): typeof SKIPPED | undefined {
  return miscellaneousMasterConfig.baselineSeeded ? undefined : skipBecause(world, SKIP.baseline);
}

export function requireBulk(world: CustomWorld): typeof SKIPPED | undefined {
  return miscellaneousMasterConfig.bulkSeeded ? undefined : skipBecause(world, SKIP.bulk);
}

export function requireExactCount(world: CustomWorld): typeof SKIPPED | undefined {
  return miscellaneousMasterConfig.exactCountSeeded ? undefined : skipBecause(world, SKIP.exactCount);
}

/** "@TC_MM_011" for the running scenario (empty when untagged); prefix of every failure message. */
export function tcOf(world: CustomWorld): string {
  return testCaseTag(world);
}

export function withTc(world: CustomWorld, message: string): string {
  const tc = tcOf(world);
  return tc ? `[${tc}] ${message}` : message;
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
 * MIDC_<ROLE>_USERNAME / _PASSWORD (VIEWER, ADDER, EDITOR, DELETER, NOACCESS, AUDITOR), otherwise the scenario is skipped.
 */
export async function logInAs(world: CustomWorld, user: string): Skippable {
  mmScenario(world).user = user;
  const key = roleKeyOfUser(user);
  if (key === 'ADMIN') {
    await ensureLoggedIn(world, getCredentials());
    return undefined;
  }
  if (config.sharedSession) return skipBecause(world, SKIP.sharedSession);
  const credentials = getRoleCredentials(key);
  if (!credentials) {
    return skipBecause(world, `no ${user} is configured; set MIDC_${key.toUpperCase().replace(/[^A-Z]/g, '')}_USERNAME and _PASSWORD to run it.`);
  }
  await ensureLoggedIn(world, credentials);
  return undefined;
}

/** Makes sure some user is signed in (the Admin when the scenario named nobody). */
export async function ensureSession(world: CustomWorld): Skippable {
  if (mmScenario(world).user) return undefined;
  return logInAs(world, 'Admin_User1');
}

/** Opens the Title List; skips when the module is not reachable in this build. */
export async function openList(world: CustomWorld): Skippable {
  const skipped = await ensureSession(world);
  if (skipped) return skipped;
  const { list } = mmPages(world);
  await mmPages(world).dismissOverlays();
  if (!(await list.isModuleAvailable())) return skipBecause(world, SKIP.moduleMissing);
  await list.open();
  return undefined;
}

// ---------------------------------------------------------------------------
// Test data table
// ---------------------------------------------------------------------------

function normalizeKey(key: string): string {
  return key.trim().replace(/^\d+\)\s*/, '').toLowerCase();
}

/** Value of the nth (1-based) test-data row called `key`; the feature tables sometimes number their rows ("1) Title"). */
export function testDatum(world: CustomWorld, key: string, nth = 1): string | undefined {
  const wanted = normalizeKey(key);
  const rows = mmScenario(world).testRows.filter(([name]) => normalizeKey(name) === wanted);
  return rows[nth - 1]?.[1];
}

export function requireDatum(world: CustomWorld, ...keys: string[]): string {
  for (const key of keys) {
    const value = testDatum(world, key);
    if (value !== undefined) return value;
  }
  throw new Error(withTc(world, `The scenario's test data has no "${keys.join('" / "')}" row for this step.`));
}

export function userFromTestData(world: CustomWorld): string {
  return requireDatum(world, 'User').trim();
}

// ---------------------------------------------------------------------------
// Toasters and inline messages
// ---------------------------------------------------------------------------

/** Runs `action`, capturing the toast it raises (stale toasts are ignored). */
export async function withToast(world: CustomWorld, action: () => Promise<void>, timeoutMs = 10000): Promise<void> {
  const previous = await world.visibleToasts();
  await action();
  await world.captureNewToast(previous, timeoutMs);
}

export async function expectToast(world: CustomWorld, message: string): Promise<void> {
  const pattern = mmMessagePattern(message);
  const seen = await world.sawMessage(pattern, 10000);
  expect(seen, withTc(world, `toaster "${message}" is displayed; toasters seen: ${JSON.stringify(world.seenToasts)}`)).toBe(true);
}

export async function expectNoToast(world: CustomWorld): Promise<void> {
  expect(world.seenToasts, withTc(world, 'no toaster is displayed')).toEqual([]);
}

/** An inline (field-level) message anywhere on the page, or in a toast. */
export async function expectMessage(world: CustomWorld, message: string): Promise<void> {
  const pattern = mmMessagePattern(message);
  await expect
    .poll(async () => (await world.sawMessage(pattern, 0)) || (await world.page.getByText(pattern).first().isVisible().catch(() => false)), {
      timeout: 15000,
      message: withTc(world, `message "${message}" is displayed; toasters: ${JSON.stringify(world.seenToasts)}`),
    })
    .toBe(true);
}

// ---------------------------------------------------------------------------
// Grid snapshots, records, fixtures
// ---------------------------------------------------------------------------

export async function snapshotGrid(world: CustomWorld): Promise<string[]> {
  return (await mmPages(world).list.rows()).map((row) => `${row.slNo}|${row.enumId}|${row.title}|${row.parentTitle}|${row.display}`);
}

export async function expectGridUnchanged(world: CustomWorld): Promise<void> {
  const before = mmScenario(world).scratch.gridBefore as string[] | undefined;
  if (!before) return;
  expect(await snapshotGrid(world), withTc(world, 'the list is unchanged')).toEqual(before);
}

export async function rememberGrid(world: CustomWorld): Promise<void> {
  mmScenario(world).scratch.gridBefore = await snapshotGrid(world);
}

/** Records the original values of a Title before it is edited, so the After hook can restore them. */
export async function rememberOriginal(world: CustomWorld, title: string): Promise<void> {
  const scenario = mmScenario(world);
  if (scenario.originals.has(title) || scenario.created.includes(title)) return;
  const row = await mmPages(world).list.rowOf(title);
  if (row) {
    scenario.originals.set(title, { fieldTitle: row.title, parentTitle: row.parentTitle, enumId: row.enumId, display: row.display === 'Checked' });
  }
}

export async function findRecord(world: CustomWorld, title: string): Promise<MmRecord | undefined> {
  const { api } = mmPages(world);
  if (!api.hasSession()) return undefined;
  return (await api.fetchAll()).find((record) => record.fieldTitle === title);
}

/** Creates a Title through the API when it is not there yet (fixture for delete / update scenarios). */
export async function ensureRecord(world: CustomWorld, title: string, enumId?: string, parentTitle?: string): Skippable {
  const { api } = mmPages(world);
  if (!api.hasSession()) return skipBecause(world, 'no authenticated API session is available to create the fixture Title.');
  if (await findRecord(world, title)) return undefined;
  const parent = parentTitle ? await findRecord(world, parentTitle) : undefined;
  const result = await api.create({ fieldTitle: title, enumId: enumId ?? null, parentTitleId: parent?.id ?? null, display: false });
  if (result.status >= 300) return skipBecause(world, `the fixture "${title}" could not be created through the API (${result.status} ${result.message}).`);
  mmScenario(world).created.push(title);
  return undefined;
}

/** Signs in as the user named in Test Data and loads the list once, so the page has an authenticated request to replay. */
export async function ensureApiClient(world: CustomWorld): Skippable {
  const skipped = await logInAs(world, userFromTestData(world));
  if (skipped) return skipped;
  const { api, list } = mmPages(world);
  if (!api.hasSession()) {
    if (!(await list.isModuleAvailable())) return skipBecause(world, SKIP.moduleMissing);
    await list.open().catch(() => undefined);
  }
  if (!api.hasSession()) return skipBecause(world, 'no authenticated API request could be observed for this user, so there is no token to replay.');
  return undefined;
}

// ---------------------------------------------------------------------------
// Form / dialog actions
// ---------------------------------------------------------------------------

export async function openAddForm(world: CustomWorld): Promise<void> {
  const { list, form } = mmPages(world);
  await list.clickAdd();
  await form.expectOpen(/Add Title/i);
}

export async function openRowMenuAndSelect(world: CustomWorld, title: string, item: 'View' | 'Edit' | 'Delete'): Promise<void> {
  const { list } = mmPages(world);
  mmScenario(world).target = title;
  await list.openKebab(title);
  if (item === 'Edit') await rememberOriginal(world, title);
  await list.selectMenuItem(item);
}

export async function openEditFor(world: CustomWorld, title: string): Promise<void> {
  await openRowMenuAndSelect(world, title, 'Edit');
  await mmPages(world).form.expectOpen(/Edit Title/i);
}

/** Saves the open form, recording what was created and the toast raised. */
export async function saveForm(world: CustomWorld, clicks = 1): Promise<void> {
  const { form } = mmPages(world);
  const scenario = mmScenario(world);
  const adding = /Add Title/i.test(await form.text());
  await withToast(world, () => form.save(clicks), 6000);
  if (adding && scenario.entered.fieldTitle && (await form.isOpen().then((open) => !open).catch(() => false))) {
    scenario.created.push(scenario.entered.fieldTitle.trim().replace(/\s+/g, ' '));
  }
}

/** "x".repeat(n) with a recognisable shape. */
export function filler(length: number, prefix = 'A'): string {
  return (prefix.repeat(Math.ceil(length / prefix.length)) + 'x'.repeat(length)).slice(0, length);
}
