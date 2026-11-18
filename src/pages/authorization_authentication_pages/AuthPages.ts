/**
 * All AuthN/AuthZ page objects of one browser page, wired together (built lazily by src/support/authorization-authentication-scenario.ts).
 *
 *   login     common CivitCORE Login page
 *   otp       Login Using OTP request panel + OTP Verification screen
 *   forgot    Forgot Password request screen
 *   reset     Reset Password screen
 *   header    header of the signed-in portal (session, organization, role, Logout)
 *   api       test mailbox and the portal's test-support / audit calls
 */
import type { Page } from '@playwright/test';
import { AuthApi } from './AuthApi';
import { ForgotPasswordPage } from './ForgotPasswordPage';
import { LoginPage } from './LoginPage';
import { OtpVerificationPage } from './OtpVerificationPage';
import { ResetPasswordPage } from './ResetPasswordPage';
import { SessionHeader } from './SessionHeader';

export class AuthPages {
  readonly login: LoginPage;
  readonly otp: OtpVerificationPage;
  readonly forgot: ForgotPasswordPage;
  readonly reset: ResetPasswordPage;
  readonly api: AuthApi;
  readonly header: SessionHeader;

  constructor(page: Page) {
    this.header = new SessionHeader(page);
    this.login = new LoginPage(page);
    this.otp = new OtpVerificationPage(page);
    this.forgot = new ForgotPasswordPage(page);
    this.reset = new ResetPasswordPage(page);
    this.api = new AuthApi(page);
  }
}
