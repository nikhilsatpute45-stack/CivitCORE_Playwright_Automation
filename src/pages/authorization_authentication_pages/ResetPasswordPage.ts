/**
 * Reset Password screen (FRD 6.4): New Password, Confirm New Password, password-policy checklist, Reset Password, Cancel.
 *
 * TODO(locator): the live UI was not inspected; every locator below is a guess. Passwords are typed only, never logged.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { config } from '../../support/config';

export interface ChecklistItem {
  text: string;
  /** Raw state marker read from the DOM (aria / class); compared before vs after, never interpreted as met / unmet. */
  state: string;
}

export class ResetPasswordPage {
  /** TODO(locator): confirm against live UI. */
  get newPasswordInput(): Locator {
    return this.page.getByLabel(/^\s*new password\s*\*?\s*$/i).first();
  }

  /** TODO(locator): confirm against live UI. */
  get confirmPasswordInput(): Locator {
    return this.page.getByLabel(/confirm( new)? password/i).first();
  }

  /** TODO(locator): confirm against live UI. */
  get resetButton(): Locator {
    return this.page.getByRole('button', { name: /^\s*reset password\s*$/i }).first();
  }

  /** TODO(locator): confirm against live UI. */
  get cancelButton(): Locator {
    return this.page.getByRole('button', { name: /^\s*cancel\s*$/i }).first();
  }

  /** TODO(locator): confirm against live UI - the container of the rule list (it mentions the rules by name). */
  get checklist(): Locator {
    return this.page.locator('ul, ol, [class*="checklist" i], [class*="policy" i]').filter({ hasText: /uppercase/i }).first();
  }

  /** TODO(locator): confirm against live UI. */
  get checklistItems(): Locator {
    return this.checklist.locator('li, [class*="item" i]');
  }

  constructor(private readonly page: Page) {}

  async expectLoaded(): Promise<void> {
    await expect(this.newPasswordInput, 'the Reset Password screen (New Password box)').toBeVisible({ timeout: config.navigationTimeoutMs });
  }

  async enterPasswords(newPassword: string, confirm: string): Promise<void> {
    await this.newPasswordInput.fill(newPassword);
    await this.confirmPasswordInput.fill(confirm);
  }

  /** Types key by key so the checklist reacts as it does for a person typing. */
  async typeNewPassword(value: string): Promise<void> {
    await this.newPasswordInput.click();
    await this.newPasswordInput.pressSequentially(value);
  }

  async items(): Promise<ChecklistItem[]> {
    return this.checklistItems.evaluateAll((elements) =>
      elements.map((element) => ({
        text: (element.textContent ?? '').replace(/\s+/g, ' ').trim(),
        state: [element.getAttribute('aria-checked'), element.getAttribute('data-state'), element.getAttribute('class')].join('|'),
      })),
    );
  }

  /** Number of editable controls (inputs, checkboxes, switches) inside the checklist. */
  async editableControlCount(): Promise<number> {
    return this.checklist.locator('input, select, textarea, [role="checkbox"], [role="switch"], [contenteditable="true"]').count();
  }

  /** Clicks every checklist item the way a user would (no forcing); an item that cannot be clicked is not an error. */
  async clickEachItem(): Promise<void> {
    const count = await this.checklistItems.count();
    for (let index = 0; index < count; index += 1) {
      await this.checklistItems.nth(index).click({ timeout: 2000 }).catch(() => undefined);
    }
  }
}
