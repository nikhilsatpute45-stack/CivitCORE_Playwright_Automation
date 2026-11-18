/**
 * Steps of features/authorization_authentication_features/login_using_otp_ui.feature (@LoginUsingOtpUi, TC_CP_131).
 * "OTP Verification screen is open" is in common.steps.ts.
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { authPages, authScenario } from '../../support/authorization-authentication-scenario';
import { expect } from '../../utils/assertions';
import { exact, withTc } from './helpers';

When(/^the user types '([^']*)' in the OTP box$/, async function (this: CustomWorld, value: string) {
  authScenario(this).scratch.typedOtp = value;
  await authPages(this).otp.typeOtp(value);
});

Then(exact("Only digits '12' are accepted; letters and symbols are not accepted (6.3 F-OTP)"), async function (this: CustomWorld) {
  const typed = String(authScenario(this).scratch.typedOtp ?? '');
  expect(await authPages(this).otp.otpValue(), withTc(this, `the OTP box keeps only the digits of the typed text (${typed.length} characters typed)`)).toBe(
    typed.replace(/\D/g, ''),
  );
});
