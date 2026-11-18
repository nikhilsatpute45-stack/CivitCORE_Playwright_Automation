/**
 * The common CivitCORE Login page (FRD 6.2): Username, Password, Organization, CAPTCHA, Login, Login Using OTP, Forgot Password.
 *
 * TODO(locator): the live UI was not inspected; every locator below is a guess and is centralised here.
 * Secrets: passwords and CAPTCHA values are typed, never logged or attached by this class.
 */
import { createHash } from 'node:crypto';
import type { Locator, Page, Request } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { config } from '../../support/config';
import { authnConfig } from '../../support/authn-authz-config';
import { DropdownField } from './DropdownField';

export class LoginPage {
  /** TODO(locator): confirm against live UI. */
  get usernameInput(): Locator {
    return this.page.getByLabel(/^\s*(user ?name|user id)\b/i).first();
  }

  /** TODO(locator): confirm against live UI. The label (not `type=password`) is used because show/hide flips the type to text. */
  get passwordInput(): Locator {
    return this.page.getByLabel(/^\s*password\s*\*?\s*$/i).first();
  }

  /** TODO(locator): confirm against live UI - the eye icon beside Password. */
  get showHideIcon(): Locator {
    return this.page.getByRole('button', { name: /show|hide|toggle password|eye/i }).first();
  }

  /** TODO(locator): confirm against live UI - native select or custom combobox. */
  get organizationControl(): Locator {
    return this.page.getByRole('combobox', { name: /organi[sz]ation/i }).or(this.page.getByLabel(/organi[sz]ation/i)).first();
  }

  readonly organization: DropdownField;

  /** TODO(locator): confirm against live UI. */
  get captchaInput(): Locator {
    return this.page.getByLabel(/captcha/i).or(this.page.getByPlaceholder(/captcha/i)).first();
  }

  /** TODO(locator): confirm against live UI - the CAPTCHA image / text the refresh icon replaces. */
  get captchaImage(): Locator {
    return this.page.locator('img[alt*="captcha" i], canvas, [class*="captcha" i] img').first();
  }

  /** TODO(locator): confirm against live UI. */
  get captchaRefreshIcon(): Locator {
    return this.page.getByRole('button', { name: /refresh|reload|new captcha/i }).first();
  }

  /** TODO(locator): confirm against live UI. */
  get loginButton(): Locator {
    return this.page.getByRole('button', { name: /^\s*login\s*$/i }).first();
  }

  /** TODO(locator): confirm against live UI - link or button. */
  get loginUsingOtpLink(): Locator {
    return this.page.getByRole('link', { name: /login using otp/i }).or(this.page.getByRole('button', { name: /login using otp/i })).first();
  }

  /** TODO(locator): confirm against live UI. */
  get forgotPasswordLink(): Locator {
    return this.page.getByRole('link', { name: /forgot password/i }).or(this.page.getByRole('button', { name: /forgot password/i })).first();
  }

  constructor(private readonly page: Page) {
    this.organization = new DropdownField(page, this.organizationControl);
  }

  /** Opens the Login page (AUTHN_LOGIN_URL, else the portal home) and waits for the Login button. */
  async open(): Promise<void> {
    await this.page.goto(authnConfig.loginUrl || config.homeUrl);
    await this.expectLoaded();
  }

  async expectLoaded(): Promise<void> {
    await expect(this.loginButton, 'the Login page (Login button)').toBeVisible({ timeout: config.navigationTimeoutMs });
  }

  async reload(): Promise<void> {
    await this.page.reload();
    await this.expectLoaded();
  }

  async enterUsername(value: string): Promise<void> {
    await this.usernameInput.fill(value);
  }

  async enterPassword(value: string): Promise<void> {
    await this.passwordInput.fill(value);
  }

  /** Types key by key (for "types ... in Password" steps that watch masking). */
  async typePassword(value: string): Promise<void> {
    await this.passwordInput.click();
    await this.passwordInput.pressSequentially(value);
  }

  async selectOrganization(name: string): Promise<void> {
    await this.organization.select(name);
  }

  /** The caller supplies the value a TEST environment accepts (AUTHN_CAPTCHA_TEST_VALUE); a CAPTCHA is never solved here. */
  async enterCaptcha(value: string): Promise<void> {
    await this.captchaInput.fill(value);
  }

  async clickLogin(options: { noWait?: boolean } = {}): Promise<void> {
    await this.loginButton.click({ noWaitAfter: options.noWait ?? false });
  }

  async clickShowHide(): Promise<void> {
    await this.showHideIcon.click();
  }

  /** The Password input's `type` attribute: "password" = masked, "text" = revealed. */
  async passwordInputType(): Promise<string> {
    return (await this.passwordInput.getAttribute('type')) ?? '';
  }

  async passwordValue(): Promise<string> {
    return this.passwordInput.inputValue();
  }

  async loginButtonEnabled(): Promise<boolean> {
    return this.loginButton.isEnabled();
  }

  async organizationText(): Promise<string> {
    return this.organization.selectedText();
  }

  async usernameValue(): Promise<string> {
    return this.usernameInput.inputValue();
  }

  async captchaValue(): Promise<string> {
    return this.captchaInput.inputValue();
  }

  /**
   * An opaque fingerprint of the CAPTCHA image (its `src`, else a screenshot hash). Used only to tell whether the CAPTCHA changed;
   * the CAPTCHA's content is never read or interpreted.
   */
  async captchaFingerprint(): Promise<string> {
    const source = await this.captchaImage.getAttribute('src').catch(() => null);
    if (source) return source;
    const shot = await this.captchaImage.screenshot().catch(() => Buffer.alloc(0));
    return createHash('sha1').update(shot).digest('hex');
  }

  /** Texts of inline validation / error messages on the page (the toaster is read through the World). TODO(locator). */
  async visibleMessages(): Promise<string[]> {
    const texts = await this.page
      .locator('[role="alert"], .invalid-feedback, .error, .error-message, [class*="error" i], [class*="invalid" i]')
      .allInnerTexts()
      .catch(() => [] as string[]);
    return texts.map((text) => text.replace(/\s+/g, ' ').trim()).filter(Boolean);
  }

  /** Counts the authentication requests (non-GET to a login / auth / token / session URL) sent until `stop` is called. TODO(endpoint): URL pattern is a guess. */
  watchAuthRequests(): { count: () => number; stop: () => void } {
    let total = 0;
    const listener = (request: Request): void => {
      if (request.method() !== 'GET' && /login|signin|sign-in|auth|token|session/i.test(request.url())) total += 1;
    };
    this.page.on('request', listener);
    return { count: () => total, stop: () => this.page.off('request', listener) };
  }

  /** `value` attribute of an Organization option (native <select> only), used to tamper with the login request. */
  async organizationOptionValue(label: string): Promise<string | undefined> {
    return this.organizationControl
      .locator('option', { hasText: label })
      .first()
      .getAttribute('value')
      .then((value) => value ?? undefined)
      .catch(() => undefined);
  }

  async organizationOptions(): Promise<string[]> {
    return this.organization.options();
  }

  async openLoginUsingOtp(): Promise<void> {
    await this.loginUsingOtpLink.click();
  }

  async openForgotPassword(): Promise<void> {
    await this.forgotPasswordLink.click();
  }
}
