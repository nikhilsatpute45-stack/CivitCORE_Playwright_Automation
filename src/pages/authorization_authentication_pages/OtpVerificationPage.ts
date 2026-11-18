/**
 * "Login Using OTP" request panel (e-mail, organization, CAPTCHA, Send OTP) and the OTP Verification screen (FRD 6.3).
 *
 * TODO(locator): the live UI was not inspected; every locator below is a guess. OTP values are typed only; they are never logged.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { config } from '../../support/config';
import { DropdownField } from './DropdownField';

export class OtpVerificationPage {
  // ---- request panel ------------------------------------------------------------------------------------------------

  /** TODO(locator): confirm against live UI. */
  get emailInput(): Locator {
    return this.page.getByLabel(/e-?mail/i).or(this.page.getByPlaceholder(/e-?mail/i)).first();
  }

  /** TODO(locator): confirm against live UI. */
  get organizationControl(): Locator {
    return this.page.getByRole('combobox', { name: /organi[sz]ation/i }).or(this.page.getByLabel(/organi[sz]ation/i)).first();
  }

  readonly organization: DropdownField;

  /** TODO(locator): confirm against live UI. */
  get captchaInput(): Locator {
    return this.page.getByLabel(/captcha/i).or(this.page.getByPlaceholder(/captcha/i)).first();
  }

  /** TODO(locator): confirm against live UI. */
  get sendOtpButton(): Locator {
    return this.page.getByRole('button', { name: /send otp/i }).first();
  }

  // ---- verification screen ------------------------------------------------------------------------------------------

  /** TODO(locator): confirm against live UI - one input or six single-digit boxes; the single input is assumed. */
  get otpInput(): Locator {
    return this.page.getByLabel(/^\s*(enter )?otp\b/i).or(this.page.getByPlaceholder(/otp/i)).first();
  }

  /** TODO(locator): confirm against live UI. */
  get verifyButton(): Locator {
    return this.page.getByRole('button', { name: /^\s*verify( otp)?\s*$/i }).first();
  }

  /** TODO(locator): confirm against live UI. */
  get resendButton(): Locator {
    return this.page.getByRole('button', { name: /resend otp/i }).or(this.page.getByRole('link', { name: /resend otp/i })).first();
  }

  /** TODO(locator): confirm against live UI. */
  get backToLoginLink(): Locator {
    return this.page.getByRole('link', { name: /back to login/i }).or(this.page.getByRole('button', { name: /back to login/i })).first();
  }

  constructor(private readonly page: Page) {
    this.organization = new DropdownField(page, this.organizationControl);
  }

  async expectRequestPanelLoaded(): Promise<void> {
    await expect(this.sendOtpButton, 'the Login Using OTP panel (Send OTP button)').toBeVisible({ timeout: config.navigationTimeoutMs });
  }

  async isRequestPanelVisible(timeoutMs = 5000): Promise<boolean> {
    return this.sendOtpButton
      .waitFor({ state: 'visible', timeout: timeoutMs })
      .then(() => true)
      .catch(() => false);
  }

  async expectVerificationLoaded(): Promise<void> {
    await expect(this.otpInput, 'the OTP Verification screen (OTP box)').toBeVisible({ timeout: config.navigationTimeoutMs });
  }

  async requestOtp(email: string, captcha: string, organization?: string): Promise<void> {
    await this.emailInput.fill(email);
    if (organization) await this.organization.select(organization);
    await this.captchaInput.fill(captcha);
    await this.sendOtpButton.click();
  }

  /** Types key by key so the box's input filtering (digits only, length limit) is exercised. */
  async typeOtp(value: string): Promise<void> {
    await this.otpInput.click();
    await this.otpInput.pressSequentially(value);
  }

  async enterOtp(value: string): Promise<void> {
    await this.otpInput.fill(value);
  }

  async otpValue(): Promise<string> {
    return this.otpInput.inputValue();
  }

  async verify(): Promise<void> {
    await this.verifyButton.click();
  }
}
