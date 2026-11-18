/**
 * Test data of the Authorization & Authentication module (features/authorization_authentication_features).
 *
 * Maps FRD CC-F-002 (Ver 1.0) wording to what the steps assert, and holds every reason a scenario is skipped.
 * FRD-vs-live: the live Login UI has not been inspected, so every message below is the FRD / workbook text and may differ in the
 * app. Set STRICT_FRD_MESSAGES=true to assert the FRD wording verbatim; otherwise the matchers accept the FRD text case-insensitively
 * as a substring (the app may wrap it, e.g. "Error: Organization is required."). Add a live alias to `ALIASES` when one is found.
 * No credential, URL, token, OTP or e-mail lives here (see src/support/authn-authz-config.ts).
 */
import { config } from '../support/config';

export const MESSAGES = {
  organizationRequired: 'Organization is required.',
  usernameRequired: 'Username is required.',
  passwordRequired: 'Password is required.',
  captchaRequired: 'CAPTCHA is required.',
  invalidCaptcha: 'Invalid CAPTCHA. Please try again.',
  emailRequired: 'Email Address is required.',
  otpRequired: 'OTP is required.',
  passwordsDoNotMatch: 'Passwords do not match.',
  maxResend: 'Maximum resend limit reached. Please try again after 30 minutes.',
} as const;

/** Login outcomes (FRD Sec 8 toasters, EX-01 ... EX-05a). The live wording is unverified. */
export const LOGIN_MESSAGES = {
  success: 'Login successful.',
  invalidCredentials: 'Invalid username or password.',
  inactive: 'Your account is inactive. Please contact your administrator.',
  locked: 'Your account is temporarily locked. Please try again after 30 minutes or contact your administrator.',
  notMapped: 'You are not mapped to the selected organization. Please contact your administrator.',
  noOrganization: 'No organization is assigned to your account. Please contact your administrator.',
} as const;

/** Every message a "Toaster '...' is displayed" step of this module may name (kept narrow so other modules' toaster steps stay unambiguous). */
export const TOASTER_MESSAGES: string[] = Object.values(LOGIN_MESSAGES);

/** Live wording that differs from the FRD (TODO: fill in once the live UI is inspected). */
export const ALIASES: Record<string, string[]> = {};

/** Text the Organization dropdown shows before a choice is made (FRD 6.2 F-Organization). */
export const ORGANIZATION_PLACEHOLDER = 'Select Organization';

/** FRD numbers; the live app may be configured differently (FRD says the parameters are backend-configurable). */
export const POLICY = {
  passwordMin: 8,
  passwordMax: 64,
  passwordHistory: 3,
  usernameMax: 100,
  otpLength: 6,
  otpValiditySeconds: 5 * 60,
  resendAfterSeconds: 60,
  maxResends: 3,
  maxOtpAttempts: 5,
  maxLoginFailures: 5,
  lockMinutes: 30,
  idleTimeoutMinutes: 30,
  absoluteLifetimeHours: 12,
  resetAuthorizationMinutes: 10,
  otpRequestsPerUserPerHour: 5,
  otpRequestsPerIpPerHour: 20,
} as const;

/** Rules of the Reset Password checklist, in the order FRD 6.4 lists them (TODO(wording): confirm against the live checklist). */
export const PASSWORD_CHECKLIST = ['uppercase', 'lowercase', 'number', 'special', 'character'] as const;

/** Network profile names the features use -> Chromium DevTools emulation values (latency ms, bytes/s). */
export const NETWORK_PROFILES: Record<string, { latency: number; downloadThroughput: number; uploadThroughput: number }> = {
  'Slow 3G': { latency: 2000, downloadThroughput: (500 * 1024) / 8, uploadThroughput: (500 * 1024) / 8 },
};

/** Reasons a scenario is skipped. Each names the switch (src/support/authn-authz-config.ts) that enables it. */
export const SKIP = {
  sharedSession:
    'this module tests login and needs a clean, unauthenticated context; it cannot run inside a SHARED_SESSION (pre-logged-in) run.',
  captcha:
    'a CAPTCHA appears on this screen and the suite never reads, solves or bypasses one. Set AUTHN_CAPTCHA_TEST_VALUE to the answer a TEST environment accepts.',
  mailbox:
    'the OTP / reset link is delivered by e-mail. Set AUTHN_MAILBOX_URL and AUTHN_MAILBOX_TOKEN (a test-mailbox API) to read it.',
  email: 'no registered e-mail address is configured for this persona (AUTHN_<PERSONA>_EMAIL).',
  persona: 'no credentials are configured for this persona (MIDC_<PERSONA>_USERNAME / _PASSWORD).',
  chromium: 'network throttling uses the Chromium DevTools protocol; run with BROWSER=chromium.',
  clock: 'the scenario waits for a server-side timeout; set AUTHN_CLOCK_CONTROL=true on an environment that can move the server clock.',
  lockout: 'the scenario locks an account; set AUTHN_LOCKOUT_ENABLED=true and provide the disposable lock.user.',
  sso: 'the scenario needs an identity-provider test account; set AUTHN_SSO_ENABLED=true.',
  db: 'the scenario reads the credential store; set AUTHN_DB_ACCESS=true.',
  api: 'the scenario needs the portal API (seeding / token / audit reads); set AUTHN_API_URL.',
} as const;

/** True when the app text satisfies the expected message under the active matching mode. */
export function messageMatches(actual: string, expected: string): boolean {
  const normalise = (value: string): string => value.replace(/\s+/g, ' ').trim().toLowerCase();
  const got = normalise(actual);
  if (config.strictFrdMessages) return got === normalise(expected);
  return [expected, ...(ALIASES[expected] ?? [])].some((candidate) => got.includes(normalise(candidate)));
}
