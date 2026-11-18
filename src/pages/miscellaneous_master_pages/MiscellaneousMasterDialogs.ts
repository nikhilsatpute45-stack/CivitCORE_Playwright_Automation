/**
 * Miscellaneous Master pop-ups: the Add / Edit Title form, the read-only View pop-up and the Delete confirmation dialog.
 *
 * TODO(verify-locator): none of these has been inspected; locators are label-based guesses from the FRD wording.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { PARENT_PLACEHOLDER } from '../../test-data/miscellaneous-master.data';
import { exact } from './MiscellaneousMasterListPage';

export type TextField = 'Field Title' | 'Enum ID';
export type FormField = TextField | 'Parent Title' | 'Display';

/** Add / Edit Title pop-up. */
export class MiscellaneousMasterFormDialog {
  readonly dialog: Locator;
  readonly fieldTitle: Locator;
  readonly parentTitle: Locator;
  readonly enumId: Locator;
  readonly display: Locator;
  readonly saveButton: Locator;
  readonly cancelButton: Locator;
  readonly closeIcon: Locator;

  constructor(private readonly page: Page) {
    this.dialog = page.getByRole('dialog').first();
    this.fieldTitle = this.dialog.getByLabel(/Field\s*Title/i).or(this.dialog.getByRole('textbox', { name: /field\s*title/i })).first();
    this.parentTitle = this.dialog.getByLabel(/Parent\s*Title/i).or(this.dialog.getByRole('combobox', { name: /parent\s*title/i })).first();
    this.enumId = this.dialog.getByLabel(/Enum\s*ID/i).or(this.dialog.getByRole('textbox', { name: /enum\s*id/i })).first();
    this.display = this.dialog.getByRole('checkbox', { name: /display/i }).first();
    this.saveButton = this.dialog.getByRole('button', { name: exact('Save') });
    this.cancelButton = this.dialog.getByRole('button', { name: exact('Cancel') });
    this.closeIcon = this.dialog.getByRole('button', { name: /close|×|✕|^x$/i }).first();
  }

  async isOpen(): Promise<boolean> {
    return this.dialog.isVisible().catch(() => false);
  }

  async expectOpen(title?: RegExp): Promise<void> {
    await expect(this.dialog, 'the pop-up is open').toBeVisible({ timeout: 10000 });
    if (title) await expect(this.dialog).toContainText(title);
  }

  async expectClosed(): Promise<void> {
    await expect(this.dialog, 'the pop-up is closed').toBeHidden({ timeout: 15000 });
  }

  private field(name: FormField): Locator {
    return name === 'Field Title' ? this.fieldTitle : name === 'Enum ID' ? this.enumId : name === 'Parent Title' ? this.parentTitle : this.display;
  }

  /** Types `value` exactly as given (spaces / symbols preserved). */
  async fill(name: TextField, value: string): Promise<void> {
    const input = this.field(name);
    await input.click();
    await input.fill(value);
  }

  /** Types key by key, so a maxlength on the box applies (and a paste-sized value can be compared with what was kept). */
  async type(name: TextField, value: string): Promise<void> {
    const input = this.field(name);
    await input.click();
    await input.fill('');
    await input.pressSequentially(value);
  }

  /** Pastes `value` at once (clipboard-style), so the box's own limit applies to the pasted text. */
  async paste(name: TextField, value: string): Promise<void> {
    const input = this.field(name);
    await input.click();
    await input.evaluate((element, text) => {
      const box = element as HTMLInputElement;
      box.value = '';
      box.focus();
      const data = new DataTransfer();
      data.setData('text', text);
      box.dispatchEvent(new ClipboardEvent('paste', { clipboardData: data, bubbles: true, cancelable: true }));
    }, value);
    // Browsers insert pasted text themselves; when the synthetic event did nothing, fall back to typing the text in one go.
    if ((await input.inputValue()) === '') await input.pressSequentially(value, { delay: 0 });
  }

  async clear(name: TextField): Promise<void> {
    await this.field(name).fill('');
  }

  async value(name: FormField): Promise<string> {
    const input = this.field(name);
    return (await input.inputValue().catch(() => '')) || (await input.innerText().catch(() => ''));
  }

  async isEditable(name: FormField): Promise<boolean> {
    return this.field(name).isEditable().catch(() => false);
  }

  async selectParent(name: string): Promise<void> {
    await this.parentTitle.click();
    await this.page.getByRole('option', { name: exact(name) }).click();
  }

  async selectNoParent(): Promise<void> {
    await this.selectParent(PARENT_PLACEHOLDER);
  }

  async parentOptions(): Promise<string[]> {
    await this.parentTitle.click();
    const options = this.page.getByRole('option');
    await expect(options.first()).toBeVisible({ timeout: 10000 });
    const texts = (await options.allInnerTexts()).map((text) => text.trim());
    await this.page.keyboard.press('Escape');
    return texts;
  }

  async setDisplay(checked: boolean): Promise<void> {
    await this.display.setChecked(checked);
  }

  async isDisplayChecked(): Promise<boolean> {
    return this.display.isChecked().catch(() => false);
  }

  async hasFocus(name: FormField): Promise<boolean> {
    return this.field(name).evaluate((element) => element === document.activeElement).catch(() => false);
  }

  async save(clicks = 1): Promise<void> {
    await this.saveButton.click({ clickCount: clicks, delay: clicks > 1 ? 30 : 0 });
  }

  async isSaveEnabled(): Promise<boolean> {
    return this.saveButton.isEnabled().catch(() => false);
  }

  async cancel(): Promise<void> {
    await this.cancelButton.click();
  }

  async close(): Promise<void> {
    await this.closeIcon.click();
  }

  async pressEscape(): Promise<void> {
    await this.page.keyboard.press('Escape');
  }

  /** Inline error text (below a field, or anywhere in the pop-up). */
  errorText(pattern: RegExp): Locator {
    return this.dialog.getByText(pattern).first();
  }

  async hasRedBorder(name: FormField): Promise<boolean> {
    return this.field(name).evaluate((element) => {
      const color = getComputedStyle(element).borderColor;
      const match = /rgba?\((\d+),\s*(\d+),\s*(\d+)/.exec(color);
      return Boolean(match) && Number(match![1]) > 150 && Number(match![2]) < 100 && Number(match![3]) < 100;
    });
  }

  /** The pop-up's buttons by visible name. */
  async buttonNames(): Promise<string[]> {
    return (await this.dialog.getByRole('button').allInnerTexts()).map((text) => text.trim()).filter(Boolean);
  }

  async text(): Promise<string> {
    return (await this.dialog.innerText().catch(() => '')).replace(/\s+/g, ' ');
  }
}

/** Read-only View pop-up. */
export class MiscellaneousMasterViewDialog {
  readonly dialog: Locator;
  readonly editButton: Locator;
  readonly closeButton: Locator;
  readonly closeIcon: Locator;

  constructor(private readonly page: Page) {
    this.dialog = page.getByRole('dialog').first();
    this.editButton = this.dialog.getByRole('button', { name: exact('Edit') });
    this.closeButton = this.dialog.getByRole('button', { name: exact('Close') });
    this.closeIcon = this.dialog.getByRole('button', { name: /close|×|✕|^x$/i }).first();
  }

  async expectOpen(): Promise<void> {
    await expect(this.dialog).toBeVisible({ timeout: 10000 });
    await expect(this.dialog).toContainText(/View Title/i);
  }

  async isOpen(): Promise<boolean> {
    return this.dialog.isVisible().catch(() => false);
  }

  async text(): Promise<string> {
    return (await this.dialog.innerText()).replace(/\s+/g, ' ');
  }

  async hasEditableInputs(): Promise<boolean> {
    return (await this.dialog.locator('input:not([readonly]):not([disabled]), textarea:not([readonly]):not([disabled])').count()) > 0;
  }

  async clickEdit(): Promise<void> {
    await this.editButton.click();
  }

  async clickClose(): Promise<void> {
    await this.closeButton.click();
  }

  async clickCloseIcon(): Promise<void> {
    await this.closeIcon.click();
  }

  async pressEscape(): Promise<void> {
    await this.page.keyboard.press('Escape');
  }
}

/** Delete confirmation ('Are you sure you want to delete the title "Obsolete Field"?' with Yes / No). */
export class MiscellaneousMasterDeleteDialog {
  readonly dialog: Locator;
  readonly yesButton: Locator;
  readonly noButton: Locator;

  constructor(page: Page) {
    this.dialog = page.getByRole('alertdialog').or(page.getByRole('dialog')).first();
    this.yesButton = this.dialog.getByRole('button', { name: exact('Yes') });
    this.noButton = this.dialog.getByRole('button', { name: exact('No') });
  }

  async isOpen(): Promise<boolean> {
    return this.dialog.isVisible().catch(() => false);
  }

  async expectOpen(): Promise<void> {
    await expect(this.dialog, 'the delete confirmation is open').toBeVisible({ timeout: 10000 });
  }

  async expectClosed(): Promise<void> {
    await expect(this.dialog, 'the delete confirmation is closed').toBeHidden({ timeout: 15000 });
  }

  async text(): Promise<string> {
    return (await this.dialog.innerText()).replace(/\s+/g, ' ');
  }

  async yes(): Promise<void> {
    await this.yesButton.click();
  }

  async no(): Promise<void> {
    await this.noButton.click();
  }
}
