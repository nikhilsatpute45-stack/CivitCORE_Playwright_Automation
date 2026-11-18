/**
 * Clear Audit Log confirmation dialog (FRD 6.4 FB-3 / FB-4). The FRD gives no exact text for it.
 *
 * TODO(locator): confirm against live UI - role, button captions and the close (X) control are guesses.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';

export class ClearAuditLogDialog {
  /** TODO(locator): confirm against live UI. */
  get dialog(): Locator {
    return this.page.getByRole('dialog').or(this.page.getByRole('alertdialog')).first();
  }

  /** TODO(locator): confirm against live UI - caption of the confirming button. */
  get confirmButton(): Locator {
    return this.dialog.getByRole('button', { name: /^\s*(Confirm|Yes|OK|Clear)\s*$/i }).first();
  }

  /** TODO(locator): confirm against live UI. */
  get cancelButton(): Locator {
    return this.dialog.getByRole('button', { name: /^\s*(Cancel|No)\s*$/i }).first();
  }

  /** TODO(locator): confirm against live UI - the close (X) icon. */
  get closeIcon(): Locator {
    return this.dialog.getByRole('button', { name: /close|×|✕/i }).or(this.dialog.locator('[aria-label="Close" i], .close, .btn-close')).first();
  }

  constructor(private readonly page: Page) {}

  async isOpen(timeoutMs = 3000): Promise<boolean> {
    return this.dialog
      .waitFor({ state: 'visible', timeout: timeoutMs })
      .then(() => true)
      .catch(() => false);
  }

  async expectOpen(): Promise<void> {
    await expect(this.dialog, 'the Clear Log confirmation dialog').toBeVisible();
  }

  async expectClosed(): Promise<void> {
    await expect(this.dialog, 'the Clear Log confirmation dialog').toBeHidden();
  }

  async text(): Promise<string> {
    return (await this.dialog.innerText()).replace(/\s+/g, ' ').trim();
  }

  async confirm(): Promise<void> {
    await this.confirmButton.click();
  }

  /** Two clicks in quick succession; the second may land on an already closed dialog, which is the point of the check. */
  async doubleClickConfirm(): Promise<void> {
    await this.confirmButton.dblclick();
  }

  async cancel(): Promise<void> {
    await this.cancelButton.click();
  }

  async closeWithIcon(): Promise<void> {
    await this.closeIcon.click();
  }

  async closeWithEscape(): Promise<void> {
    await this.page.keyboard.press('Escape');
  }

  /** Closes whatever dialog is open without confirming (used by the clean-up hook). */
  async dismiss(): Promise<void> {
    if (!(await this.isOpen(500))) return;
    await this.cancelButton.click({ timeout: 3000 }).catch(() => this.page.keyboard.press('Escape'));
    await this.dialog.waitFor({ state: 'hidden', timeout: 5000 }).catch(() => undefined);
  }
}
