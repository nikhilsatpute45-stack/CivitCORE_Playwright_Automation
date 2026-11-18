/**
 * Authorization & Authentication (AuthN/AuthZ) run switches.
 *
 * PENDING MIGRATION: like src/support/miscellaneous-master-config.ts, these belong in src/support/config.ts (CLAUDE.md: no `process.env`
 * elsewhere). That file is shared and carries other in-progress changes, so every AuthN/AuthZ switch is read here, in ONE place.
 * Persona credentials are NOT read here: they come from `getRoleCredentials(persona)` (src/support/config.ts), i.e.
 * MIDC_<PERSONA>_USERNAME / _PASSWORD with the persona's letters only, upper-cased ("rahul.sharma" -> MIDC_RAHULSHARMA_*).
 *
 * Every switch is opt-in; a scenario whose switch is missing is SKIPPED with the reason (never silently passed).
 *
 *   AUTHN_LOGIN_URL           absolute URL of the common CivitCORE Login page (default: MIDC_HOME_URL / BASE_URL).
 *   AUTHN_ORGANIZATION        organization the personas log in to (workbook baseline: "Alpha Infra Ltd").
 *   AUTHN_<PERSONA>_EMAIL     registered e-mail address of a persona (RAHULSHARMA, ANITADESAI, LOCKUSER, INACTIVEUSER, ...).
 *   AUTHN_CAPTCHA_TEST_VALUE  CAPTCHA answer a TEST environment accepts. The suite never reads, solves or bypasses a CAPTCHA image.
 *   AUTHN_MAILBOX_URL         base URL of a test-mailbox API that returns the latest OTP / reset mail of an address.
 *   AUTHN_MAILBOX_TOKEN       access token of that API.
 *   AUTHN_API_URL             base URL of the portal API used for seeding, token checks and audit reads.
 *   AUTHN_API_TOKEN           access token of that API (an administrator / test-support token).
 *   AUTHN_CLOCK_CONTROL      "true" when the environment lets the tests move the SERVER clock (expiry / lock-timeout scenarios).
 *   AUTHN_LOCKOUT_ENABLED     "true" when a disposable lock.user exists that the tests may lock and unlock.
 *   AUTHN_SSO_ENABLED         "true" when an identity-provider test account is available.
 *   AUTHN_DB_ACCESS           "true" when the tests may read the credential store.
 */
function flag(name: string): boolean {
  return /^(1|true|yes|on)$/i.test((process.env[name] ?? '').trim());
}

function text(name: string): string {
  return (process.env[name] ?? '').trim();
}

export const authnConfig = {
  loginUrl: text('AUTHN_LOGIN_URL'),
  organization: text('AUTHN_ORGANIZATION') || 'Alpha Infra Ltd',
  captchaTestValue: text('AUTHN_CAPTCHA_TEST_VALUE'),
  mailboxUrl: text('AUTHN_MAILBOX_URL').replace(/\/+$/, ''),
  apiUrl: text('AUTHN_API_URL').replace(/\/+$/, ''),
  clockControl: flag('AUTHN_CLOCK_CONTROL'),
  lockoutEnabled: flag('AUTHN_LOCKOUT_ENABLED'),
  ssoEnabled: flag('AUTHN_SSO_ENABLED'),
  dbAccess: flag('AUTHN_DB_ACCESS'),
} as const;

/** The mailbox token is read on demand so it is never held in a long-lived object that could be logged. */
export function mailboxToken(): string {
  return text('AUTHN_MAILBOX_TOKEN');
}

/** Token of the portal API (AUTHN_API_TOKEN), read on demand like the mailbox token. */
export function apiToken(): string {
  return text('AUTHN_API_TOKEN');
}

/** Registered e-mail address of a persona ("rahul.sharma" -> AUTHN_RAHULSHARMA_EMAIL), or undefined. */
export function personaEmail(persona: string): string | undefined {
  const key = persona.trim().toUpperCase().replace(/[^A-Z]/g, '');
  return text(`AUTHN_${key}_EMAIL`) || undefined;
}
