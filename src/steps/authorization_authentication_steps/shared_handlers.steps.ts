/**
 * AuthN/AuthZ's handlers for the step phrases several modules' features share word for word. Those phrases are registered once, in
 * src/steps/shared_steps/shared.steps.ts, and routed by the scenario's module tag to the handlers registered below (see
 * src/support/shared-step-registry.ts). Phrases covered:
 *   "the following test data is used"                       -> stored for the scenario's steps
 *   "the user observes|inspects|notes|checks|queries|..."   -> records what the tester looks at (UI features) or is a no-op
 *   "<User>_User<N> is logged in", "API client authenticated ...", "Request is rejected (403); ..." -> not used by these features
 *
 * NOT covered here: "Baseline data (see Summary) is loaded" is a global step of the Miscellaneous Master module (it is not routed by
 * module tag), so this module's scenarios run with MM_BASELINE_SEEDED=true (the npm scripts set it); see authn-authz-config.ts.
 */
import type { DataTable } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { authPages, authScenario } from '../../support/authorization-authentication-scenario';
import { personaEmail } from '../../support/authn-authz-config';
import { registerSharedHandlers, type SharedResult } from '../../support/shared-step-registry';
import { LOGIN_MESSAGES } from '../../test-data/authorization-authentication.data';
import { skipBecause } from './helpers';

/** Strips one pair of wrapping single quotes ("'abc'" -> "abc"). */
export function unquote(value: string): string {
  return /^'.*'$/s.test(value) && value.length >= 2 ? value.slice(1, -1) : value;
}

async function testData(world: CustomWorld, table: DataTable): SharedResult {
  const scenario = authScenario(world);
  scenario.testRows = table.raw().map(([key, value]) => [(key ?? '').trim(), unquote((value ?? '').trim())]);
  scenario.testData = Object.fromEntries(scenario.testRows);
}

/** "the user observes ...": only describes where the tester looks, except for the observations a UI Then step needs recorded. */
async function observe(world: CustomWorld, verb: string, rest: string): SharedResult {
  const scenario = authScenario(world);
  const { login, header, api } = authPages(world);
  scenario.scratch[`${verb} ${rest}`.trim()] = true;
  if (verb === 'observes' && /^Login CTA on load$/i.test(rest)) {
    scenario.scratch.ctaEnabledOnLoad = await login.loginButtonEnabled();
  }
  if (verb === 'observes' && /^the CTA during the request$/i.test(rest)) {
    scenario.scratch.ctaEnabledDuringRequest = await login.loginButtonEnabled();
  }
  // The CAPTCHA is only fingerprinted (to tell whether it changed); its content is never read.
  if (verb === 'notes' && /CAPTCHA/i.test(rest)) {
    scenario.scratch.captchaFirst = await login.captchaFingerprint();
  }
  if (verb === 'inspects' && /^the header and the Switch Role list$/i.test(rest)) {
    scenario.scratch.headerText = await header.text();
    if (await header.switchRoleControl.isVisible().catch(() => false)) {
      await header.openSwitchRole();
      scenario.scratch.switchRoleOptions = await header.switchRoleOptions();
    }
  }
  if (verb === 'observes' && /^whether the account is locked$/i.test(rest)) {
    scenario.scratch.lockedMessageSeen = scenario.attempts.some((attempt) => attempt.messages.some((message) => message.includes(LOGIN_MESSAGES.locked)));
  }
  if (verb === 'checks' && /^the inbox of the registered email$/i.test(rest)) {
    const email = personaEmail('lock.user');
    scenario.scratch.lockMail = email && api.mailboxConfigured ? await api.hasMail(email, /lock/i) : undefined;
  }
}

registerSharedHandlers('@AuthNAuthZ', {
  testData,
  apiClient: async (world): SharedResult => skipBecause(world, 'the AuthN/AuthZ features do not use "API client authenticated ...".'),
  loggedIn: async (world, user): SharedResult => skipBecause(world, `"${user} is logged in" is not an AuthN/AuthZ persona phrase.`),
  observe,
  rejected: async (world, sentence): SharedResult => skipBecause(world, `"${sentence}" is not used by the AuthN/AuthZ features.`),
});
