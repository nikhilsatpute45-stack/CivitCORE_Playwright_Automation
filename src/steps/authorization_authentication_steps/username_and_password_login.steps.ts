/**
 * Steps of features/authorization_authentication_features/username_and_password_login.feature (@UsernamePasswordLogin,
 * TC_CP_008 - TC_CP_021, TC_CP_145 - TC_CP_164).
 *
 * Credentials: every "valid" password / username comes from the persona's MIDC_<PERSONA>_* variables, never from the feature text.
 * CAPTCHA: only the TEST value (AUTHN_CAPTCHA_TEST_VALUE) is typed; scenarios that need a correct CAPTCHA skip without it. Wrong-CAPTCHA
 * and empty-field scenarios need no test value.
 * Failed-attempt counter: asserted only when AUTHN_API_URL / AUTHN_API_TOKEN are set; otherwise the message and screen checks still run
 * and the unverified counter is written to the scenario log (never silently dropped).
 */
import { Given, Then, When } from '@cucumber/cucumber';
import type { Route } from '@playwright/test';
import type { CustomWorld } from '../../support/world';
import { authPages, authScenario } from '../../support/authorization-authentication-scenario';
import { authnConfig, personaEmail } from '../../support/authn-authz-config';
import { ORGANIZATION_PLACEHOLDER, LOGIN_MESSAGES, MESSAGES, SKIP, TOASTER_MESSAGES, POLICY } from '../../test-data/authorization-authentication.data';
import { escapeRegExp, expect } from '../../utils/assertions';
import { exact, requireCaptcha, requireMailbox, skipBecause, withTc, type Skippable } from './helpers';
import {
  credentialsOf,
  expectAttemptMessage,
  expectAttemptShowsOnly,
  expectNoSession,
  expectSessionStarted,
  failLogins,
  failedAttempts,
  fillLogin,
  lastAttempt,
  loginWithCredentials,
  note,
  noteCounterUnavailable,
  noted,
  oppositeCase,
  personaOf,
  requireLockout,
  submitLogin,
  wrongPassword,
} from './login_flow';

const ORG = (): string => authnConfig.organization;

/** The characters of `pattern` repeated up to exactly `length` (e.g. 'Aa1!' x 16 = 64). */
function filler(pattern: string, length: number): string {
  return pattern.repeat(Math.ceil(length / pattern.length)).slice(0, length);
}

// ---------------------------------------------------------------------------
// TC_CP_008 / TC_CP_009 / TC_CP_013: successful login
// ---------------------------------------------------------------------------

When(/^the user enters Username '([^']*)' and Password '([^']*)'$/, async function (this: CustomWorld, user: string): Skippable {
  const credentials = credentialsOf(this, user.trim());
  if (typeof credentials === 'string') return credentials;
  await fillLogin(this, credentials);
  return undefined;
});

When(/^the user selects Organization '([^']*)'$/, async function (this: CustomWorld, organization: string) {
  await authPages(this).login.selectOrganization(organization);
});

When(exact('the user enters the displayed CAPTCHA correctly'), async function (this: CustomWorld): Skippable {
  const gated = requireCaptcha(this);
  if (gated) return gated;
  await authPages(this).login.enterCaptcha(authnConfig.captchaTestValue);
  return undefined;
});

When(exact('the user clicks Login'), async function (this: CustomWorld) {
  await submitLogin(this);
});

Then(
  new RegExp(`^(?:The )?[Tt]oaster '(${TOASTER_MESSAGES.map(escapeRegExp).join('|')})' is (?:displayed|shown)$`),
  function (this: CustomWorld, message: string) {
    expectAttemptMessage(this, lastAttempt(this), message);
  },
);

Then(/^A session starts with '([^']*)' as active organization and the ERP opens \(.*\)$/, async function (this: CustomWorld, organization: string) {
  await expectSessionStarted(this);
  expect(await authPages(this).header.text(), withTc(this, `'${organization}' is the active organization`)).toContain(organization);
});

When(/^the user enters Username '([^']*)' \(leading and trailing spaces, upper case\)$/, async function (this: CustomWorld, padded: string): Skippable {
  const credentials = credentialsOf(this, padded.trim().toLowerCase());
  if (typeof credentials === 'string') return credentials;
  await authPages(this).login.enterUsername(` ${credentials.username.toUpperCase()} `);
  return undefined;
});

When(/^the user enters Password '([^']*)', select '([^']*)', enter the CAPTCHA$/, async function (this: CustomWorld, _password: string, organization: string): Skippable {
  const gated = requireCaptcha(this);
  if (gated) return gated;
  const credentials = credentialsOf(this, personaOf(this));
  if (typeof credentials === 'string') return credentials;
  await fillLogin(this, { password: credentials.password, organization, captcha: authnConfig.captchaTestValue });
  return undefined;
});

Then(
  exact("Username is trimmed and matched case-insensitively; login succeeds with 'Login successful.' (6.2 BR-1, 6.2 F-Username)"),
  async function (this: CustomWorld) {
    expectAttemptMessage(this, lastAttempt(this), LOGIN_MESSAGES.success);
    await expectSessionStarted(this);
  },
);

When(/^the user enters ([a-z.]+) credentials \(mapped only to ([^)]+)\)$/, async function (this: CustomWorld, persona: string): Skippable {
  const credentials = credentialsOf(this, persona);
  if (typeof credentials === 'string') return credentials;
  await fillLogin(this, credentials);
  note(this, 'organizationBefore', await authPages(this).login.organizationText());
  return undefined;
});

When(exact("the user selects Organization 'Alpha Infra Ltd' manually and enter the CAPTCHA"), async function (this: CustomWorld): Skippable {
  const gated = requireCaptcha(this);
  if (gated) return gated;
  await fillLogin(this, { organization: 'Alpha Infra Ltd', captcha: authnConfig.captchaTestValue });
  return undefined;
});

Then(
  /^The dropdown is not pre-selected for the single-org user; after manual selection login succeeds and '([^']*)' becomes the active organization \(.*\)$/,
  async function (this: CustomWorld, organization: string) {
    expect(noted<string>(this, 'organizationBefore'), withTc(this, 'the Organization dropdown is not pre-selected')).toBe(ORGANIZATION_PLACEHOLDER);
    await expectSessionStarted(this);
    expect(await authPages(this).header.text(), withTc(this, `'${organization}' is the active organization`)).toContain(organization);
  },
);

// ---------------------------------------------------------------------------
// TC_CP_010 / 011 / 153 / 154: field length limits
// ---------------------------------------------------------------------------

function fieldValue(kind: string, length: number): string {
  return kind.toLowerCase() === 'username' ? 'a'.repeat(length) : filler('Aa1!', length);
}

When(/^the user enters a (\d+)-character (Username|Password) in the (?:Username|Password) box$/, async function (this: CustomWorld, length: string, kind: string) {
  const { login } = authPages(this);
  note(this, 'lastField', kind.toLowerCase());
  if (kind === 'Username') await login.enterUsername(fieldValue(kind, Number(length)));
  else await login.enterPassword(fieldValue(kind, Number(length)));
});

When(/^the user pastes a (\d+)-character (username|password) into the (?:Username|Password) box$/, async function (this: CustomWorld, length: string, kind: string) {
  const { login } = authPages(this);
  note(this, 'lastField', kind);
  // `fill` sets the value at once, which is how a paste behaves (no per-key filtering by typing).
  if (kind === 'username') await login.enterUsername(fieldValue(kind, Number(length)));
  else await login.enterPassword(fieldValue(kind, Number(length)));
  await recordRetained(this);
});

async function recordRetained(world: CustomWorld): Promise<void> {
  const { login } = authPages(world);
  const field = noted<string>(world, 'lastField');
  note(world, 'retained', field === 'username' ? (await login.usernameValue()).length : (await login.passwordValue()).length);
}

When(exact('the user counts the characters retained in the box'), async function (this: CustomWorld) {
  await recordRetained(this);
});

Then(/^All (\d+) characters are accepted \(6\.2 F-(?:Username|Password) max \d+\)$/, function (this: CustomWorld, length: string) {
  expect(noted<number>(this, 'retained'), withTc(this, `all ${length} characters are retained`)).toBe(Number(length));
});

Then(/^The field restricts input to (\d+) characters \(6\.2 F-(?:Username|Password)\)$/, function (this: CustomWorld, limit: string) {
  const retained = noted<number>(this, 'retained');
  expect(retained, withTc(this, `the field keeps at most ${limit} characters`)).toBe(Number(limit));
  expect(Number(limit), withTc(this, 'the limit matches the FRD policy')).toBe(noted<string>(this, 'lastField') === 'username' ? POLICY.usernameMax : POLICY.passwordMax);
});

// ---------------------------------------------------------------------------
// TC_CP_012 / 164: Organization dropdown contents
// ---------------------------------------------------------------------------

When(exact('the user opens the Login page and observe the dropdown default'), async function (this: CustomWorld) {
  const { login } = authPages(this);
  await login.open();
  note(this, 'defaultText', await login.organizationText());
});

When(exact('the user expands the Organization dropdown'), async function (this: CustomWorld) {
  note(this, 'organizationOptions', await authPages(this).login.organizationOptions());
});

When(exact('the user opens the Organization dropdown'), async function (this: CustomWorld) {
  note(this, 'organizationOptions', await authPages(this).login.organizationOptions());
});

Then(exact("Default text is 'Select Organization'"), function (this: CustomWorld) {
  expect(noted<string>(this, 'defaultText'), withTc(this, 'the Organization dropdown default text')).toBe(ORGANIZATION_PLACEHOLDER);
});

Then(/^List order is (.+?); inactive '([^']*)' is not listed \(.*\)$/, function (this: CustomWorld, order: string, inactive: string) {
  const listed = (noted<string[]>(this, 'organizationOptions') ?? []).filter((name) => name !== ORGANIZATION_PLACEHOLDER);
  const expected = order.split(',').map((name) => name.trim());
  const positions = expected.map((name) => listed.indexOf(name));
  expect(positions.every((position) => position >= 0), withTc(this, `the active organizations are listed (listed: ${listed.join(', ')})`)).toBe(true);
  expect([...positions].sort((a, b) => a - b), withTc(this, 'the active organizations appear in the stated order')).toEqual(positions);
  expect(listed, withTc(this, 'the list is in alphabetical order')).toEqual([...listed].sort((a, b) => a.localeCompare(b)));
  expect(listed, withTc(this, `inactive '${inactive}' is not listed`)).not.toContain(inactive);
});

Then(/^'([^']*)' is not listed \(6\.2 F-Organization\)$/, function (this: CustomWorld, inactive: string) {
  expect(noted<string[]>(this, 'organizationOptions') ?? [], withTc(this, `'${inactive}' is not listed`)).not.toContain(inactive);
});

// ---------------------------------------------------------------------------
// TC_CP_014: links ("the user clicks '<link>'" itself is in common.steps.ts)
// ---------------------------------------------------------------------------

Then(exact("'Login Using OTP' opens the Login Using OTP screen"), function (this: CustomWorld) {
  expect(noted<boolean>(this, 'otpScreen'), withTc(this, 'the Login Using OTP screen opened')).toBe(true);
});

Then(exact("'Forgot Password' opens the Forgot Password screen (6.2 F-OTPLink, 6.2 F-ForgotLink)"), function (this: CustomWorld) {
  expect(noted<boolean>(this, 'forgotScreen'), withTc(this, 'the Forgot Password screen opened')).toBe(true);
});

// ---------------------------------------------------------------------------
// TC_CP_015: CAPTCHA refresh and letter case ("the user notes the CAPTCHA text" is recorded by the observe handler)
// ---------------------------------------------------------------------------

When(exact('the user clicks the refresh icon and note the new CAPTCHA'), async function (this: CustomWorld) {
  const { login } = authPages(this);
  const first = noted<string>(this, 'captchaFirst') ?? (await login.captchaFingerprint());
  await login.captchaRefreshIcon.click();
  await expect.poll(() => login.captchaFingerprint(), { timeout: 10000 }).not.toBe(first);
  note(this, 'captchaSecond', await login.captchaFingerprint());
});

When(
  exact('the user enters the new CAPTCHA in the opposite letter case with valid credentials and click Login'),
  async function (this: CustomWorld): Skippable {
    const gated = requireCaptcha(this);
    if (gated) return gated;
    const opposite = oppositeCase(authnConfig.captchaTestValue);
    if (!opposite) return skipBecause(this, 'the test CAPTCHA value has no letters, so its letter case cannot be inverted (set AUTHN_CAPTCHA_TEST_VALUE to a value with letters).');
    const credentials = credentialsOf(this, personaOf(this));
    if (typeof credentials === 'string') return credentials;
    await fillLogin(this, { ...credentials, organization: ORG(), captcha: opposite });
    await submitLogin(this);
    return undefined;
  },
);

Then(exact('A new CAPTCHA is generated on refresh'), function (this: CustomWorld) {
  expect(noted<string>(this, 'captchaSecond'), withTc(this, 'the CAPTCHA changed after the refresh icon was clicked')).not.toBe(noted<string>(this, 'captchaFirst'));
});

Then(exact('The CAPTCHA is accepted irrespective of case and login proceeds (6.2 F-CAPTCHA)'), async function (this: CustomWorld) {
  await expectSessionStarted(this);
});

// ---------------------------------------------------------------------------
// TC_CP_016 / 149: wrong credentials / wrong CAPTCHA
// ---------------------------------------------------------------------------

async function rememberBeforeSubmit(world: CustomWorld, username: string): Promise<void> {
  note(world, 'captchaBefore', await authPages(world).login.captchaFingerprint());
  note(world, 'counterBefore', await failedAttempts(world, username));
}

When(
  /^the user enters Username '([^']*)', wrong Password '([^']*)', Organization '([^']*)', valid CAPTCHA$/,
  async function (this: CustomWorld, user: string, wrong: string, organization: string): Skippable {
    const gated = requireCaptcha(this);
    if (gated) return gated;
    const credentials = credentialsOf(this, user);
    if (typeof credentials === 'string') return credentials;
    await fillLogin(this, { username: credentials.username, password: wrong, organization, captcha: authnConfig.captchaTestValue });
    note(this, 'typedUsername', credentials.username);
    note(this, 'typedOrganization', organization);
    await rememberBeforeSubmit(this, credentials.username);
    return undefined;
  },
);

Then(exact('Password and CAPTCHA fields are cleared; Username and Organization are retained; a new CAPTCHA is shown'), async function (this: CustomWorld) {
  const { login } = authPages(this);
  expect(await login.passwordValue(), withTc(this, 'Password is cleared')).toBe('');
  expect(await login.captchaValue(), withTc(this, 'CAPTCHA box is cleared')).toBe('');
  expect(await login.usernameValue(), withTc(this, 'Username is retained')).toBe(noted<string>(this, 'typedUsername'));
  expect(await login.organizationText(), withTc(this, 'Organization is retained')).toBe(noted<string>(this, 'typedOrganization'));
  expect(await login.captchaFingerprint(), withTc(this, 'a new CAPTCHA is shown')).not.toBe(noted<string>(this, 'captchaBefore'));
});

Then(/^Failed-attempt count is increased by 1 \(.*\)$/, async function (this: CustomWorld) {
  const before = noted<number>(this, 'counterBefore');
  const after = await failedAttempts(this, noted<string>(this, 'typedUsername') ?? '');
  if (before === undefined || after === undefined) return noteCounterUnavailable(this, 'the failed-attempt count increased by 1');
  expect(after, withTc(this, 'the failed-attempt count increased by 1')).toBe(before + 1);
  return undefined;
});

When(/^the user enters valid credentials and organization, wrong CAPTCHA '([^']*)'$/, async function (this: CustomWorld, wrongCaptcha: string): Skippable {
  const credentials = credentialsOf(this, personaOf(this));
  if (typeof credentials === 'string') return credentials;
  await fillLogin(this, { ...credentials, organization: ORG(), captcha: wrongCaptcha });
  await rememberBeforeSubmit(this, credentials.username);
  note(this, 'typedUsername', credentials.username);
  return undefined;
});

Then(
  exact("'Invalid CAPTCHA. Please try again.' is shown; CAPTCHA is refreshed; credentials are not checked and the failed count is not increased (US-1 AC-4, EX-02)"),
  async function (this: CustomWorld) {
    const attempt = lastAttempt(this);
    expectAttemptMessage(this, attempt, MESSAGES.invalidCaptcha);
    expect(await authPages(this).login.captchaFingerprint(), withTc(this, 'the CAPTCHA is refreshed')).not.toBe(noted<string>(this, 'captchaBefore'));
    await expectCounterUnchanged(this);
  },
);

async function expectCounterUnchanged(world: CustomWorld): Promise<void> {
  const before = noted<number>(world, 'counterBefore');
  const after = await failedAttempts(world, noted<string>(world, 'typedUsername') ?? '');
  if (before === undefined || after === undefined) return noteCounterUnavailable(world, 'the failed-attempt count is unchanged');
  expect(after, withTc(world, 'the failed-attempt count is unchanged')).toBe(before);
  return undefined;
}

// ---------------------------------------------------------------------------
// TC_CP_017 / 018 / 157: lockout (needs AUTHN_LOCKOUT_ENABLED, a disposable user and the test-support API)
// ---------------------------------------------------------------------------

/** Registers the idempotent clean-up that unlocks the user and resets the failed-attempt counter. */
async function registerUnlock(world: CustomWorld, persona: string): Promise<typeof import('./helpers').SKIPPED | undefined> {
  const credentials = credentialsOf(world, persona);
  if (typeof credentials === 'string') return credentials;
  const { api } = authPages(world);
  authScenario(world).cleanups.push(async () => {
    await api.unlockUser(credentials.username);
  });
  return undefined;
}

When(
  /^the user submits (\d+) consecutive logins for lock\.user with a wrong password and valid CAPTCHA$/,
  async function (this: CustomWorld, times: string): Skippable {
    const gated = requireLockout(this) ?? requireCaptcha(this) ?? (await registerUnlock(this, 'lock.user'));
    if (gated) return gated;
    return failLogins(this, 'lock.user', Number(times));
  },
);

When(exact('the user verifies the lock state in the admin user screen'), async function (this: CustomWorld): Skippable {
  const credentials = credentialsOf(this, 'lock.user');
  if (typeof credentials === 'string') return credentials;
  note(this, 'userState', await authPages(this).api.userState(credentials.username));
  return undefined;
});

Then(exact('Account is locked for 30 minutes (US-1 AC-5, 6.2 FB-5)'), function (this: CustomWorld) {
  const state = noted<{ locked: boolean } | undefined>(this, 'userState');
  expect(state?.locked, withTc(this, `the account is locked (for ${POLICY.lockMinutes} minutes)`)).toBe(true);
});

Then(exact('A lock notification email is sent to the registered email address'), async function (this: CustomWorld): Skippable {
  const gated = requireMailbox(this);
  if (gated) return gated;
  const email = personaEmail('lock.user');
  if (!email) return skipBecause(this, `${SKIP.email} (lock.user)`);
  expect(await authPages(this).api.hasMail(email, /lock/i), withTc(this, 'a lock notification e-mail reached the registered address')).toBe(true);
  return undefined;
});

Then(exact("'Account Locked' is audited with reason 'failed attempts'"), async function (this: CustomWorld): Skippable {
  const credentials = credentialsOf(this, 'lock.user');
  if (typeof credentials === 'string') return credentials;
  expect(await authPages(this).api.hasAuditEntry('Account Locked', credentials.username, 'failed attempts'), withTc(this, "'Account Locked' is audited with reason 'failed attempts'")).toBe(true);
  return undefined;
});

When(/^the user fails login (\d+) times? for ([a-z.]+)$/, async function (this: CustomWorld, times: string, persona: string): Skippable {
  const gated = requireLockout(this) ?? requireCaptcha(this) ?? (await registerUnlock(this, persona));
  if (gated) return gated;
  return failLogins(this, persona, Number(times));
});

When(/^the user logs in successfully for ([a-z.]+)$/, async function (this: CustomWorld, persona: string): Skippable {
  const skipped = await loginWithCredentials(this, persona, ORG());
  if (skipped) return skipped;
  await expectSessionStarted(this);
  return undefined;
});

When(/^the user logs out, then fail login (\d+) times for ([a-z.]+)$/, async function (this: CustomWorld, times: string, persona: string): Skippable {
  await authPages(this).header.logout();
  return failLogins(this, persona, Number(times));
});

Then(exact('After the successful login the counter is reset to 0, so 4 further failures do not lock the account (US-1 AC-7)'), async function (this: CustomWorld) {
  expect(noted<boolean>(this, 'lockedMessageSeen'), withTc(this, 'no locked message appeared after 4 further failures')).toBe(false);
  const persona = authScenario(this).persona ?? 'anita.desai';
  const credentials = credentialsOf(this, persona);
  if (typeof credentials === 'string') return;
  const count = await failedAttempts(this, credentials.username);
  if (count === undefined) return noteCounterUnavailable(this, 'the counter equals 4 (reset to 0, then 4 failures)');
  expect(count, withTc(this, 'the counter restarted from 0 after the successful login')).toBe(4);
  return undefined;
});

When(exact('the user logs in correctly'), async function (this: CustomWorld): Skippable {
  return loginWithCredentials(this, personaOf(this), ORG());
});

Then(exact('The account is not locked after 4 failures and the correct login succeeds (6.1 P-Lockout)'), async function (this: CustomWorld) {
  expect(
    authScenario(this).attempts.some((attempt) => attempt.messages.some((message) => message.includes(LOGIN_MESSAGES.locked))),
    withTc(this, 'no attempt showed the locked message'),
  ).toBe(false);
  await expectSessionStarted(this);
});

// ---------------------------------------------------------------------------
// TC_CP_019: offices and roles after login ("the user inspects the header and the Switch Role list" is recorded by the observe handler)
// ---------------------------------------------------------------------------

When(/^the user logs in as ([a-z.]+) with Organization '([^']*)'$/, async function (this: CustomWorld, persona: string, organization: string): Skippable {
  return loginWithCredentials(this, persona, organization);
});

Then(
  /^Active organization is '([^']*)', offices (.+) are loaded, and '([^']*)' is the active role \(.*\)$/,
  async function (this: CustomWorld, organization: string, offices: string, role: string) {
    const { header } = authPages(this);
    const text = noted<string>(this, 'headerText') ?? (await header.text());
    expect(text, withTc(this, `'${organization}' is the active organization`)).toContain(organization);
    expect(text, withTc(this, `'${role}' is the active role`)).toContain(role);
    for (const office of offices.split(/,| and /).map((name) => name.trim()).filter(Boolean)) {
      expect(await header.showsText(office), withTc(this, `office '${office}' is loaded`)).toBe(true);
    }
  },
);

// ---------------------------------------------------------------------------
// TC_CP_020 / 021 / 145 - 152: validation order, messages and account status
// ---------------------------------------------------------------------------

When(/^the user enters valid credentials for ([a-z.]+) but leave the failed-attempt counter noted at 0$/, async function (this: CustomWorld, persona: string): Skippable {
  const credentials = credentialsOf(this, persona);
  if (typeof credentials === 'string') return credentials;
  await fillLogin(this, credentials);
  note(this, 'typedUsername', credentials.username);
  note(this, 'counterBefore', await failedAttempts(this, credentials.username));
  return undefined;
});

When(exact('the user submits with a correct Organization but wrong CAPTCHA'), async function (this: CustomWorld) {
  const wrong = /'([^']+)'/.exec(authScenario(this).datum('CAPTCHA'))?.[1] ?? 'ZZZZ';
  await fillLogin(this, { organization: ORG(), captcha: wrong });
  await submitLogin(this);
});

When(exact('the user verifies the failed-attempt counter'), async function (this: CustomWorld) {
  note(this, 'counterAfter', await failedAttempts(this, noted<string>(this, 'typedUsername') ?? ''));
});

Then(
  exact("'Invalid CAPTCHA. Please try again.' is shown and the credentials are not checked, so the counter is unchanged (6.2 FB-1, EX-02)"),
  async function (this: CustomWorld) {
    expectAttemptMessage(this, lastAttempt(this), MESSAGES.invalidCaptcha);
    await expectCounterUnchanged(this);
  },
);

When(/^the user logs in as ([a-z.]+) with (correct|wrong) password$/, async function (this: CustomWorld, persona: string, kind: string): Skippable {
  const gated = requireCaptcha(this);
  if (gated) return gated;
  const credentials = credentialsOf(this, persona);
  if (typeof credentials === 'string') return credentials;
  await authPages(this).login.open();
  await fillLogin(this, {
    username: credentials.username,
    password: kind === 'correct' ? credentials.password : wrongPassword(this),
    organization: ORG(),
    captcha: authnConfig.captchaTestValue,
  });
  await submitLogin(this);
  return undefined;
});

Then(exact("Correct password shows 'Your account is inactive. Please contact your administrator.' (EX-04)"), function (this: CustomWorld) {
  expectAttemptMessage(this, authScenario(this).attempts[0]!, LOGIN_MESSAGES.inactive);
});

Then(exact("Wrong password shows only 'Invalid username or password.'; account status is not revealed (6.2 FB-2)"), function (this: CustomWorld) {
  expectAttemptShowsOnly(this, authScenario(this).attempts[1]!, LOGIN_MESSAGES.invalidCredentials, [LOGIN_MESSAGES.inactive, LOGIN_MESSAGES.locked]);
});

When(exact('the user enters valid Username, Password and CAPTCHA'), async function (this: CustomWorld): Skippable {
  const gated = requireCaptcha(this);
  if (gated) return gated;
  const credentials = credentialsOf(this, personaOf(this));
  if (typeof credentials === 'string') return credentials;
  await fillLogin(this, { ...credentials, captcha: authnConfig.captchaTestValue });
  note(this, 'typedUsername', credentials.username);
  return undefined;
});

When(exact("the user leaves Organization as 'Select Organization'"), async function (this: CustomWorld) {
  expect(await authPages(this).login.organizationText(), withTc(this, 'Organization is left unselected')).toBe(ORGANIZATION_PLACEHOLDER);
});

Then(
  /^'Organization is required\.' is shown; credentials are not checked and the failed-attempt count is unchanged \(.*\)$/,
  function (this: CustomWorld) {
    const attempt = lastAttempt(this);
    expectAttemptMessage(this, attempt, MESSAGES.organizationRequired);
    expect(attempt.authRequests, withTc(this, 'no authentication request was sent, so credentials were not checked')).toBe(0);
  },
);

When(/^the user leaves (Username|Password|CAPTCHA) empty; fill other fields; click Login$/, async function (this: CustomWorld, empty: string): Skippable {
  // The other fields are filled so that only the empty one can trigger a message; the CAPTCHA test value is needed unless CAPTCHA is the empty one.
  const gated = empty === 'CAPTCHA' ? undefined : requireCaptcha(this);
  if (gated) return gated;
  const credentials = credentialsOf(this, personaOf(this));
  if (typeof credentials === 'string') return credentials;
  await fillLogin(this, {
    username: empty === 'Username' ? undefined : credentials.username,
    password: empty === 'Password' ? undefined : credentials.password,
    organization: ORG(),
    captcha: empty === 'CAPTCHA' ? undefined : authnConfig.captchaTestValue,
  });
  await submitLogin(this);
  return undefined;
});

Then(
  /^'(Username is required\.|Password is required\.|CAPTCHA is required\.)' is displayed( and (?:no login is attempted|credentials are not checked))? \(.*\)$/,
  function (this: CustomWorld, message: string, noCheck?: string) {
    const attempt = lastAttempt(this);
    expectAttemptMessage(this, attempt, message);
    if (noCheck) expect(attempt.authRequests, withTc(this, 'no authentication request was sent')).toBe(0);
  },
);

When(/^the user logs in with unknown username '([^']*)' and a valid password$/, async function (this: CustomWorld, unknown: string): Skippable {
  const gated = requireCaptcha(this);
  if (gated) return gated;
  const credentials = credentialsOf(this, personaOf(this));
  if (typeof credentials === 'string') return credentials;
  await authPages(this).login.open();
  await fillLogin(this, { username: unknown, password: credentials.password, organization: ORG(), captcha: authnConfig.captchaTestValue });
  await submitLogin(this);
  return undefined;
});

When(exact('the user logs in with valid username and wrong password'), async function (this: CustomWorld): Skippable {
  const gated = requireCaptcha(this);
  if (gated) return gated;
  const credentials = credentialsOf(this, personaOf(this));
  if (typeof credentials === 'string') return credentials;
  await authPages(this).login.open();
  await fillLogin(this, { username: credentials.username, password: wrongPassword(this), organization: ORG(), captcha: authnConfig.captchaTestValue });
  await submitLogin(this);
  return undefined;
});

Then(
  exact("Both show 'Invalid username or password.' without revealing which field is wrong; CAPTCHA refreshed and count increased (US-1 AC-3, EX-01)"),
  function (this: CustomWorld) {
    for (const attempt of authScenario(this).attempts) {
      expectAttemptShowsOnly(this, attempt, LOGIN_MESSAGES.invalidCredentials, [LOGIN_MESSAGES.inactive, LOGIN_MESSAGES.locked, LOGIN_MESSAGES.notMapped]);
    }
    expect(authScenario(this).attempts.length, withTc(this, 'both attempts were made')).toBeGreaterThanOrEqual(2);
    this.log('Not verified here: "CAPTCHA refreshed and count increased" (asserted in TC_CP_016; the failed-attempt counter needs AUTHN_API_URL).');
  },
);

async function loginWithAlteredPassword(world: CustomWorld, alter: (valid: string) => string): Skippable {
  const gated = requireCaptcha(world);
  if (gated) return gated;
  const credentials = credentialsOf(world, personaOf(world));
  if (typeof credentials === 'string') return credentials;
  const password = alter(credentials.password);
  if (password === credentials.password) return skipBecause(world, 'the altered password equals the real one (e.g. it has no upper-case letter), so the check would be meaningless.');
  await authPages(world).login.open();
  await fillLogin(world, { username: credentials.username, password, organization: ORG(), captcha: authnConfig.captchaTestValue });
  await submitLogin(world);
  return undefined;
}

When(/^the user logs in with Password '([^']*)' \(lower case\)$/, async function (this: CustomWorld): Skippable {
  return loginWithAlteredPassword(this, (valid) => valid.toLowerCase());
});

When(/^the user logs in with Password '([^']*)' \(trailing space\)$/, async function (this: CustomWorld): Skippable {
  return loginWithAlteredPassword(this, (valid) => `${valid} `);
});

Then(exact("Login fails with 'Invalid username or password.' (6.2 BR-1)"), async function (this: CustomWorld) {
  expectAttemptMessage(this, lastAttempt(this), LOGIN_MESSAGES.invalidCredentials);
  await expectNoSession(this);
});

Then(exact('Login fails because spaces are part of the password (6.2 BR-1)'), async function (this: CustomWorld) {
  expectAttemptMessage(this, lastAttempt(this), LOGIN_MESSAGES.invalidCredentials);
  await expectNoSession(this);
});

// ---------------------------------------------------------------------------
// TC_CP_155 / 156 / 158 - 164: locked, inactive, unmapped and tampered logins
// ---------------------------------------------------------------------------

Given(exact('lock.user is locked'), async function (this: CustomWorld): Skippable {
  const gated = requireLockout(this) ?? (await registerUnlock(this, 'lock.user'));
  if (gated) return gated;
  const credentials = credentialsOf(this, 'lock.user');
  if (typeof credentials === 'string') return credentials;
  expect(await authPages(this).api.lockUser(credentials.username), withTc(this, 'lock.user was locked through the test-support API')).toBe(true);
  return undefined;
});

When(exact('the user logs in with the correct credentials and CAPTCHA'), async function (this: CustomWorld): Skippable {
  const organization = authScenario(this).datum('Organization') || ORG();
  return loginWithCredentials(this, personaOf(this), organization);
});

Then(
  /^'Your account is temporarily locked\. Please try again after 30 minutes or contact your administrator\.' is shown; no session \(.*\)$/,
  async function (this: CustomWorld) {
    expectAttemptMessage(this, lastAttempt(this), LOGIN_MESSAGES.locked);
    await expectNoSession(this);
  },
);

When(exact('the user logs in with a wrong password'), async function (this: CustomWorld): Skippable {
  return failLogins(this, personaOf(this), 1);
});

Then(/^Only 'Invalid username or password\.' is shown, so lock status is not disclosed \(.*\)$/, function (this: CustomWorld) {
  expectAttemptShowsOnly(this, lastAttempt(this), LOGIN_MESSAGES.invalidCredentials, [LOGIN_MESSAGES.locked, LOGIN_MESSAGES.inactive]);
});

When(/^the user logs in with ([a-z.]+) using correct credentials$/, async function (this: CustomWorld, persona: string): Skippable {
  return loginWithCredentials(this, persona, authScenario(this).datum('Organization') || ORG());
});

Then(
  /^'(Your account is inactive\. Please contact your administrator\.)' is shown and no session starts \(.*\)$/,
  async function (this: CustomWorld, message: string) {
    expectAttemptMessage(this, lastAttempt(this), message);
    await expectNoSession(this);
  },
);

Given(exact('lock.user is locked; inactive.user is inactive'), async function (this: CustomWorld): Skippable {
  // inactive.user is part of the environment baseline (workbook Summary); only lock.user is changed by the test.
  const gated = requireLockout(this) ?? (await registerUnlock(this, 'lock.user'));
  if (gated) return gated;
  const credentials = credentialsOf(this, 'lock.user');
  if (typeof credentials === 'string') return credentials;
  expect(await authPages(this).api.lockUser(credentials.username), withTc(this, 'lock.user was locked through the test-support API')).toBe(true);
  return undefined;
});

When(exact('the user requests OTP for each account and use any OTP'), async function (this: CustomWorld): Skippable {
  const gated = requireCaptcha(this) ?? requireMailbox(this);
  if (gated) return gated;
  if (!authnConfig.ssoEnabled) return skipBecause(this, SKIP.sso);
  const delivered: string[] = [];
  for (const persona of authScenario(this).datum('Users').split(',').map((name) => name.trim()).filter(Boolean)) {
    const email = personaEmail(persona);
    if (!email) return skipBecause(this, `${SKIP.email} (${persona})`);
    const { login, otp, api } = authPages(this);
    await login.open();
    await login.openLoginUsingOtp();
    await otp.requestOtp(email, authnConfig.captchaTestValue, ORG());
    if (await api.hasMail(email, /otp|one.?time/i)) delivered.push(persona);
  }
  note(this, 'otpDelivered', delivered);
  return undefined;
});

When(exact('the user tries an SSO token for each account'), function (this: CustomWorld): Skippable {
  return Promise.resolve(skipBecause(this, 'trying an SSO token needs an identity-provider test harness that this suite does not have yet.'));
});

Then(exact('No OTP is delivered and no authentication through any method is possible (6.2 BR-2)'), function (this: CustomWorld) {
  expect(noted<string[]>(this, 'otpDelivered') ?? [], withTc(this, 'no OTP was delivered to the locked or inactive account')).toEqual([]);
});

When(
  /^the user logs in as ([a-z.]+) with correct credentials selecting '([^']*)'(?: (\d+) times)?$/,
  async function (this: CustomWorld, persona: string, organization: string, times?: string): Skippable {
    for (let count = 0; count < Number(times ?? 1); count += 1) {
      const skipped = await loginWithCredentials(this, persona, organization);
      if (skipped) return skipped;
    }
    return undefined;
  },
);

When(/^the user repeats selecting '([^']*)'$/, async function (this: CustomWorld, organization: string): Skippable {
  return loginWithCredentials(this, personaOf(this), organization);
});

When(/^the user logs in with '([^']*)'$/, async function (this: CustomWorld, organization: string): Skippable {
  return loginWithCredentials(this, personaOf(this), organization);
});

Then(
  /^Each attempt shows '([^']*)'; failed count is not increased and the account is not locked \(.*\)$/,
  async function (this: CustomWorld, message: string) {
    const { attempts } = authScenario(this);
    const unmapped = attempts.slice(0, -1);
    expect(unmapped.length, withTc(this, 'at least one unmapped-organization attempt was made')).toBeGreaterThan(0);
    for (const attempt of unmapped) expectAttemptMessage(this, attempt, message);
    expect(
      attempts.some((attempt) => attempt.messages.some((text) => text.includes(LOGIN_MESSAGES.locked))),
      withTc(this, 'the account was not locked'),
    ).toBe(false);
    const credentials = credentialsOf(this, personaOf(this));
    if (typeof credentials === 'string') return;
    const count = await failedAttempts(this, credentials.username);
    if (count === undefined) return noteCounterUnavailable(this, 'the failed-attempt count was not increased');
    expect(count, withTc(this, 'the failed-attempt count was not increased')).toBe(0);
    return undefined;
  },
);

Then(
  /^'No organization is assigned to your account\. Please contact your administrator\.' is shown both times; no session \(.*\)$/,
  async function (this: CustomWorld) {
    const { attempts } = authScenario(this);
    expect(attempts.length, withTc(this, 'two attempts were made')).toBeGreaterThanOrEqual(2);
    for (const attempt of attempts.slice(-2)) expectAttemptMessage(this, attempt, LOGIN_MESSAGES.noOrganization);
    await expectNoSession(this);
  },
);

When(
  /^the user intercepts the login request for ([a-z.]+) and replace organizationId with that of '([^']*)'$/,
  async function (this: CustomWorld, persona: string, foreign: string): Skippable {
    const gated = requireCaptcha(this);
    if (gated) return gated;
    const credentials = credentialsOf(this, persona);
    if (typeof credentials === 'string') return credentials;
    const { login } = authPages(this);
    await login.open();
    const foreignId = await login.organizationOptionValue(foreign);
    if (!foreignId) return skipBecause(this, 'the Organization control is not a native <select>, so the id of another organization cannot be read (TODO(locator)).');

    let tampered = false;
    const page = this.page;
    // TODO(endpoint): the login URL pattern and the "organizationId" field name come from the workbook, not from the live API.
    await page.route(/login|signin|auth|token/i, async (route: Route) => {
      const request = route.request();
      const body = request.postData();
      if (request.method() !== 'POST' || !body || !/organi[sz]ationId/i.test(body)) return route.continue();
      tampered = true;
      const replaced = body.trim().startsWith('{')
        ? body.replace(/("organi[sz]ationId"\s*:\s*)("?)[^",}]*("?)/i, `$1"${foreignId}"`)
        : body.replace(/(organi[sz]ationId=)[^&]*/i, `$1${encodeURIComponent(foreignId)}`);
      return route.continue({ postData: replaced });
    });
    authScenario(this).cleanups.push(async () => {
      await page.unroute(/login|signin|auth|token/i).catch(() => undefined);
    });
    note(this, 'tamperedState', () => tampered);

    await fillLogin(this, { ...credentials, organization: ORG(), captcha: authnConfig.captchaTestValue });
    await submitLogin(this);
    return undefined;
  },
);

Then(exact('The server rejects the unmapped value; no session is started (6.5 BR-3)'), async function (this: CustomWorld) {
  const wasTampered = noted<() => boolean>(this, 'tamperedState');
  expect(wasTampered?.(), withTc(this, 'the login request was intercepted and its organizationId replaced')).toBe(true);
  await expectNoSession(this);
});
