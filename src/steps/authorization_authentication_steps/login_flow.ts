/**
 * Login-form building blocks shared by the AuthN/AuthZ step files (no steps are registered here).
 * Passwords come from MIDC_<PERSONA>_PASSWORD only; a "valid" password quoted in a feature is never typed, and a WRONG password is
 * generated (or taken from the test-data table when it is clearly a wrong one). Secrets are never logged or put in a message.
 */
import type { CustomWorld } from '../../support/world';
import { authPages, authScenario, type AttemptRecord } from '../../support/authorization-authentication-scenario';
import { authnConfig } from '../../support/authn-authz-config';
import { config } from '../../support/config';
import { SKIP, messageMatches } from '../../test-data/authorization-authentication.data';
import { expect } from '../../utils/assertions';
import { personaCredentials, requireCaptcha, skipBecause, withTc, type Skippable, SKIPPED } from './helpers';

export interface LoginFields {
  username?: string;
  password?: string;
  /** Organization label to pick; undefined leaves the dropdown untouched. */
  organization?: string;
  /** CAPTCHA text to type; undefined / '' leaves the box untouched. */
  captcha?: string;
}

export async function fillLogin(world: CustomWorld, fields: LoginFields): Promise<void> {
  const { login } = authPages(world);
  if (fields.username !== undefined) await login.enterUsername(fields.username);
  if (fields.password !== undefined) await login.enterPassword(fields.password);
  if (fields.organization) await login.selectOrganization(fields.organization);
  if (fields.captcha) await login.enterCaptcha(fields.captcha);
}

/** Clicks Login, waits for the toaster, and records the messages and the authentication requests of this attempt. */
export async function submitLogin(world: CustomWorld): Promise<AttemptRecord> {
  const { login } = authPages(world);
  const before = await world.visibleToasts();
  const watcher = login.watchAuthRequests();
  await login.clickLogin();
  await world.captureNewToast(before, config.expectTimeoutMs);
  watcher.stop();
  const record: AttemptRecord = {
    persona: authScenario(world).persona,
    messages: [...world.seenToasts, ...(await login.visibleMessages())],
    authRequests: watcher.count(),
  };
  authScenario(world).attempts.push(record);
  return record;
}

export function lastAttempt(world: CustomWorld): AttemptRecord {
  const attempt = authScenario(world).attempts.at(-1);
  if (!attempt) throw new Error(withTc(world, 'no Login click was recorded before this check.'));
  return attempt;
}

export function expectAttemptMessage(world: CustomWorld, attempt: AttemptRecord, expected: string): void {
  expect(
    attempt.messages.some((message) => messageMatches(message, expected)),
    withTc(world, `'${expected}' is displayed (screen showed: ${attempt.messages.join(' | ') || 'no message'})`),
  ).toBe(true);
}

export function expectAttemptShowsOnly(world: CustomWorld, attempt: AttemptRecord, expected: string, forbidden: string[]): void {
  expectAttemptMessage(world, attempt, expected);
  for (const other of forbidden) {
    expect(
      attempt.messages.some((message) => messageMatches(message, other)),
      withTc(world, `'${other}' is NOT displayed (it would disclose account state)`),
    ).toBe(false);
  }
}

/** The signed-in header appears within the navigation timeout (a session started). */
export async function expectSessionStarted(world: CustomWorld): Promise<void> {
  expect(await authPages(world).header.isSessionVisible(config.navigationTimeoutMs), withTc(world, 'a session started (header with Logout is shown)')).toBe(true);
}

export async function expectNoSession(world: CustomWorld): Promise<void> {
  expect(await authPages(world).header.isSessionVisible(2000), withTc(world, 'no session started')).toBe(false);
}

/** A wrong password: the table's value when it is plainly a wrong one, else a generated value (never a real credential). */
export function wrongPassword(world: CustomWorld): string {
  const quoted = [authScenario(world).datum('Wrong password'), authScenario(world).datum('Wrong'), authScenario(world).datum('Data')];
  const given = quoted.find((value) => /^wrong/i.test(value));
  return given ?? `Wrong${Date.now() % 100000}!aB`;
}

/** Persona the step names, else the table's User / Username, else the scenario's last persona, else the default persona. */
export function personaOf(world: CustomWorld, named?: string): string {
  const scenario = authScenario(world);
  const persona = named || scenario.datum('User') || scenario.datum('Username') || scenario.persona || 'rahul.sharma';
  scenario.persona = persona;
  return persona;
}

/** Stores a value one step of the scenario hands to a later one. */
export function note(world: CustomWorld, key: string, value: unknown): void {
  authScenario(world).scratch[key] = value;
}

/** A value an earlier step stored with `note`. */
export function noted<T>(world: CustomWorld, key: string): T | undefined {
  return authScenario(world).scratch[key] as T | undefined;
}

/** Credentials of the persona, or the SKIPPED marker. */
export function credentialsOf(world: CustomWorld, persona: string): { username: string; password: string } | typeof SKIPPED {
  authScenario(world).persona = persona;
  return personaCredentials(world, persona);
}

/** The failed-attempt counter of a persona, or undefined when the test-support API is not configured (the caller says so in the log). */
export async function failedAttempts(world: CustomWorld, username: string): Promise<number | undefined> {
  const { api } = authPages(world);
  if (!api.apiConfigured) return undefined;
  return (await api.userState(username))?.failedAttempts;
}

export function noteCounterUnavailable(world: CustomWorld, what: string): void {
  world.log(`Not verified: ${what} (the failed-attempt counter needs AUTHN_API_URL / AUTHN_API_TOKEN; ${SKIP.api}).`);
}

export function requireLockout(world: CustomWorld): typeof SKIPPED | undefined {
  if (!authnConfig.lockoutEnabled) return skipBecause(world, SKIP.lockout);
  return authPages(world).api.apiConfigured ? undefined : skipBecause(world, SKIP.api);
}

/** Opens a fresh Login page and signs in with the persona's real credentials and the test CAPTCHA, then clicks Login. */
export async function loginWithCredentials(world: CustomWorld, persona: string, organization: string): Skippable {
  const gated = requireCaptcha(world);
  if (gated) return gated;
  const credentials = credentialsOf(world, persona);
  if (typeof credentials === 'string') return credentials;
  const { login } = authPages(world);
  await login.open();
  await fillLogin(world, { ...credentials, organization, captcha: authnConfig.captchaTestValue });
  await submitLogin(world);
  return undefined;
}

/** `times` consecutive failed logins of the persona (fresh page each time, valid CAPTCHA, wrong password). */
export async function failLogins(world: CustomWorld, persona: string, times: number, organization = authnConfig.organization): Skippable {
  const gated = requireCaptcha(world);
  if (gated) return gated;
  const credentials = credentialsOf(world, persona);
  if (typeof credentials === 'string') return credentials;
  const wrong = wrongPassword(world);
  for (let attempt = 0; attempt < times; attempt += 1) {
    await authPages(world).login.open();
    await fillLogin(world, { username: credentials.username, password: wrong, organization, captcha: authnConfig.captchaTestValue });
    await submitLogin(world);
  }
  return undefined;
}

/** Swaps the letter case of the test CAPTCHA value; undefined when it has no letters (the check would be meaningless). */
export function oppositeCase(value: string): string | undefined {
  const swapped = [...value].map((ch) => (ch === ch.toUpperCase() ? ch.toLowerCase() : ch.toUpperCase())).join('');
  return swapped === value ? undefined : swapped;
}
