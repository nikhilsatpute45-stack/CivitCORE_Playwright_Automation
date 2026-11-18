/**
 * Forgot Password request screen (FRD 6.4): registered e-mail, CAPTCHA, Send OTP.
 *
 * TODO(locator): the live UI was not inspected; every locator below is a guess.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { config } from '../../support/config';

export class ForgotPasswordPage {
  /** TODO(locator): confirm against live UI. */
  get emailInput(): Locator {
    return this.page.getByLabel(/e-?mail/i).or(this.page.getByPlaceholder(/e-?mail/i)).first();
  }

  /** TODO(locator): confirm against live UI. */
  get captchaInput(): Locator {
    return this.page.getByLabel(/captcha/i).or(this.page.getByPlaceholder(/captcha/i)).first();
  }

  /** TODO(locator): confirm against live UI - the caption may be "Send OTP" or "Submit". */
  get submitButton(): Locator {
    return this.page.getByRole('button', { name: /send otp|submit/i }).first();
  }

  constructor(private readonly page: Page) {}

  async isLoaded(timeoutMs = 5000): Promise<boolean> {
    return this.submitButton
      .waitFor({ state: 'visible', timeout: timeoutMs })
      .then(() => true)
      .catch(() => false);
  }

  async expectLoaded(): Promise<void> {
    await expect(this.submitButton, 'the Forgot Password screen (submit button)').toBeVisible({ timeout: config.navigationTimeoutMs });
  }

  async submit(email: string, captcha: string): Promise<void> {
    await this.emailInput.fill(email);
    await this.captchaInput.fill(captcha);
    await this.submitButton.click();
  }
}
