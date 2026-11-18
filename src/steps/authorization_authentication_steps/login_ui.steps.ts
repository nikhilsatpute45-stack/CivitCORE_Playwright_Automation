/**
 * Steps of features/authorization_authentication_features/login_ui.feature (@LoginUi, TC_CP_123 - TC_CP_125).
 * "Civit Login page is displayed" is in common.steps.ts; "the user observes ..." is routed through shared_handlers.steps.ts.
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { authPages, authScenario } from '../../support/authorization-authentication-scenario';
import { authnConfig } from '../../support/authn-authz-config';
import { NETWORK_PROFILES, ORGANIZATION_PLACEHOLDER } from '../../test-data/authorization-authentication.data';
import { expect } from '../../utils/assertions';
import { exact, openLogin, personaCredentials, requireCaptcha, requireChromium, skipBecause, withTc, type Skippable } from './helpers';

// ---- TC_CP_123: Password box masking ------------------------------------------------------------------------------------

When(/^the user types '([^']*)' in Password$/, async function (this: CustomWorld, value: string) {
  const { login } = authPages(this);
  const scenario = authScenario(this);
  scenario.scratch.passwordOnFirstLoad = await login.passwordValue();
  await login.typePassword(value);
  scenario.scratch.typeAfterTyping = await login.passwordInputType();
});

When(exact('the user clicks the show/hide icon twice'), async function (this: CustomWorld) {
  const { login } = authPages(this);
  const scenario = authScenario(this);
  await login.clickShowHide();
  scenario.scratch.typeAfterFirstClick = await login.passwordInputType();
  await login.clickShowHide();
  scenario.scratch.typeAfterSecondClick = await login.passwordInputType();
});

/**
 * "logs out/login again": the password typed in this scenario is test text, not a real credential, so no sign-in is performed;
 * what the Then step checks is that a fresh page load of the Login page never carries the typed value, which a reload shows.
 */
When(exact('the user logs out/login again and reopen the page'), async function (this: CustomWorld) {
  const { login } = authPages(this);
  await login.reload();
  authScenario(this).scratch.passwordAfterReload = await login.passwordValue();
  await openLogin(this);
  authScenario(this).scratch.passwordAfterReopen = await login.passwordValue();
});

Then(
  exact('Characters are masked by default; the icon toggles visibility; the field is empty on every page load (6.2 F-Password)'),
  function (this: CustomWorld) {
    const { scratch } = authScenario(this);
    expect(scratch.typeAfterTyping, withTc(this, 'Password is masked (type=password) by default')).toBe('password');
    expect(scratch.typeAfterFirstClick, withTc(this, 'the first click on the icon reveals the characters')).toBe('text');
    expect(scratch.typeAfterSecondClick, withTc(this, 'the second click on the icon masks the characters again')).toBe('password');
    expect(scratch.passwordOnFirstLoad, withTc(this, 'Password is empty on the first page load')).toBe('');
    expect(scratch.passwordAfterReload, withTc(this, 'Password is empty after a reload')).toBe('');
    expect(scratch.passwordAfterReopen, withTc(this, 'Password is empty after reopening the page')).toBe('');
  },
);

// ---- TC_CP_124: Organization placeholder --------------------------------------------------------------------------------

When(exact('the user opens the Login page and read the dropdown'), async function (this: CustomWorld) {
  await openLogin(this);
  authScenario(this).scratch.organizationText = await authPages(this).login.organizationText();
});

Then(exact("Dropdown displays 'Select Organization' by default (6.2 F-Organization)"), function (this: CustomWorld) {
  expect(authScenario(this).scratch.organizationText, withTc(this, 'the Organization dropdown default text')).toBe(ORGANIZATION_PLACEHOLDER);
});

// ---- TC_CP_125: Login CTA state during a request -------------------------------------------------------------------------
// "the user observes Login CTA on load" / "the user observes the CTA during the request" are recorded by the observe handler.

When(exact('the user clicks Login with valid details and throttle the network'), async function (this: CustomWorld): Skippable {
  const gated = requireChromium(this) ?? requireCaptcha(this);
  if (gated) return gated;
  const credentials = personaCredentials(this, 'rahul.sharma');
  if (typeof credentials === 'string') return credentials;

  const profileName = authScenario(this).datum('Network') || 'Slow 3G';
  const profile = NETWORK_PROFILES[profileName];
  if (!profile) return skipBecause(this, `no network profile named "${profileName}" is defined (NETWORK_PROFILES).`);

  const { login } = authPages(this);
  await login.enterUsername(credentials.username);
  await login.enterPassword(credentials.password);
  await login.selectOrganization(authnConfig.organization);
  await login.enterCaptcha(authnConfig.captchaTestValue);

  const session = await this.context!.newCDPSession(this.page);
  await session.send('Network.enable');
  await session.send('Network.emulateNetworkConditions', { offline: false, ...profile });
  // Do not wait for navigation: the next step reads the button WHILE the request is in flight.
  await login.clickLogin({ noWait: true });
  return undefined;
});

Then(exact('Login CTA is enabled on load and disabled while the request is in progress (6.2 F-Login)'), function (this: CustomWorld) {
  const { scratch } = authScenario(this);
  expect(scratch.ctaEnabledOnLoad, withTc(this, 'the Login CTA is enabled on load')).toBe(true);
  expect(scratch.ctaEnabledDuringRequest, withTc(this, 'the Login CTA is disabled while the request is in progress')).toBe(false);
});
