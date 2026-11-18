/**
 * AuthN/AuthZ steps shared by more than one feature file in features/authorization_authentication_features. Cucumber step text is
 * global, so a step used by several features is defined once, here; steps used by a single feature live in that feature's own file.
 *
 * NOT redefined here:
 *  - "the following test data is used" / "the user observes ..."  -> shared registry (./shared_handlers.steps.ts)
 *  - "Baseline data (see Summary) is loaded"                      -> Miscellaneous Master's global step (see shared_handlers.steps.ts)
 */
import { Given, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { authPages } from '../../support/authorization-authentication-scenario';
import { exact, openLogin, openOtpScreen, openResetScreen, type Skippable } from './helpers';
import { note } from './login_flow';

// The three links of the Login page / OTP screen. The alternation is disjoint from Miscellaneous Master's "the user clicks (...)" step.
When(/^the user clicks '(Login Using OTP|Forgot Password|Back to Login)'$/, async function (this: CustomWorld, link: string) {
  const { login, otp, forgot } = authPages(this);
  if (link === 'Login Using OTP') {
    await login.openLoginUsingOtp();
    note(this, 'otpScreen', await otp.isRequestPanelVisible());
  } else if (link === 'Forgot Password') {
    await login.openForgotPassword();
    note(this, 'forgotScreen', await forgot.isLoaded());
  } else {
    await otp.backToLoginLink.click();
  }
});

When(exact("the user returns to Login and click 'Forgot Password'"), async function (this: CustomWorld) {
  const { login, otp, forgot } = authPages(this);
  if (await otp.backToLoginLink.isVisible().catch(() => false)) await otp.backToLoginLink.click();
  else await login.open();
  await login.openForgotPassword();
  note(this, 'forgotScreen', await forgot.isLoaded());
});

Given(exact('Civit Login page is displayed'), async function (this: CustomWorld) {
  await openLogin(this);
});

Given(exact('OTP Verification screen is open'), async function (this: CustomWorld): Skippable {
  return openOtpScreen(this);
});

Given(exact('Reset Password screen is open'), async function (this: CustomWorld): Skippable {
  return openResetScreen(this);
});
