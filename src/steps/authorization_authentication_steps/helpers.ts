/**
 * Shared building blocks of the AuthN/AuthZ step definitions (no steps are registered here).
 *
 * Skipping convention (same as Audit Trail / Miscellaneous Master): a step returns SKIPPED, with the reason logged, when the scenario
 * cannot run in this environment (no CAPTCHA test value, no mailbox, persona not configured, ...). Cucumber then reports the rest of
 * the scenario as skipped, never silently passed. Reasons live in test-data/authorization-authentication.data.ts (SKIP).
 *
 * Traceability: every failure message carries the scenario's @TC_CP_* id (see `withTc`).
 * Secrets: passwords, OTPs and CAPTCHA values are never logged or put in a message.
 */
import type { CustomWorld } from '../../support/world';
import { authPages, authScenario } from '../../support/authorization-authentication-scenario';
import { authnConfig, personaEmail } from '../../support/authn-authz-config';
import { testCaseTag } from '../../support/shared-step-registry';
import { SKIP } from '../../test-data/authorization-authentication.data';
import { config, getRoleCredentials } from '../../support/config';
import { escapeRegExp } from '../../utils/assertions';

export const SKIPPED = 'skipped' as const;
export type Skippable = Promise<typeof SKIPPED | undefined>;

export function skipBecause(world: CustomWorld, reason: string): typeof SKIPPED {
  world.log(`Skipped: ${reason}`);
  return SKIPPED;
}

/** "@TC_CP_123" prefix for failure messages. */
export function withTc(world: CustomWorld, message: string): string {
  const tc = testCaseTag(world);
  return tc ? `[${tc}] ${message}` : message;
}

/** A RegExp that matches `text` literally, start to end (for the long prose sentences the features use as steps). */
export function exact(text: string): RegExp {
  return new RegExp(`^${escapeRegExp(text)}$`);
}

// ---------------------------------------------------------------------------
// Run gates (each returns SKIPPED, or undefined when the scenario may go on)
// ---------------------------------------------------------------------------

export function requireCaptcha(world: CustomWorld): typeof SKIPPED | undefined {
  return authnConfig.captchaTestValue ? undefined : skipBecause(world, SKIP.captcha);
}

export function requireMailbox(world: CustomWorld): typeof SKIPPED | undefined {
  return authPages(world).api.mailboxConfigured ? undefined : skipBecause(world, SKIP.mailbox);
}

export function requireChromium(world: CustomWorld): typeof SKIPPED | undefined {
  return config.browser === 'chromium' ? undefined : skipBecause(world, SKIP.chromium);
}

/** Credentials of a persona from MIDC_<PERSONA>_USERNAME / _PASSWORD, or SKIPPED. Never logged. */
export function personaCredentials(world: CustomWorld, persona: string): { username: string; password: string } | typeof SKIPPED {
  const credentials = getRoleCredentials(persona);
  return credentials ?? skipBecause(world, `${SKIP.persona} (${persona})`);
}

// ---------------------------------------------------------------------------
// Screens
// ---------------------------------------------------------------------------

/** Opens the Login page in this scenario's clean context. */
export async function openLogin(world: CustomWorld): Promise<void> {
  await authPages(world).login.open();
}

/** Persona whose registered e-mail the OTP / reset flows use when a feature does not name one. */
export const DEFAULT_PERSONA = 'rahul.sharma';

/** Login page -> Login Using OTP -> Send OTP for the persona -> OTP Verification screen. */
export async function openOtpScreen(world: CustomWorld, persona = DEFAULT_PERSONA): Skippable {
  const gated = requireCaptcha(world);
  if (gated) return gated;
  const email = personaEmail(persona);
  if (!email) return skipBecause(world, `${SKIP.email} (${persona})`);
  const { login, otp } = authPages(world);
  authScenario(world).persona = persona;
  await login.open();
  await login.openLoginUsingOtp();
  await otp.expectRequestPanelLoaded();
  await otp.requestOtp(email, authnConfig.captchaTestValue, authnConfig.organization);
  await otp.expectVerificationLoaded();
  return undefined;
}

/** Login page -> Forgot Password -> OTP from the test mailbox -> Reset Password screen. */
export async function openResetScreen(world: CustomWorld, persona = DEFAULT_PERSONA): Skippable {
  const gated = requireCaptcha(world) ?? requireMailbox(world);
  if (gated) return gated;
  const email = personaEmail(persona);
  if (!email) return skipBecause(world, `${SKIP.email} (${persona})`);
  const { login, forgot, otp, reset, api } = authPages(world);
  authScenario(world).persona = persona;
  await login.open();
  await login.openForgotPassword();
  await forgot.expectLoaded();
  await forgot.submit(email, authnConfig.captchaTestValue);
  await otp.expectVerificationLoaded();
  await otp.enterOtp(await api.latestOtp(email));
  await otp.verify();
  await reset.expectLoaded();
  return undefined;
}
