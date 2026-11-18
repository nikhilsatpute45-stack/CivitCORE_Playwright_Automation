/**
 * Audit Trail filter / action bar: Functions dropdown, From Date, To Date, Search and Clear Log (FRD 6.3, 6.4).
 *
 * TODO(locator): confirm against live UI. The Audit Trail screen has not been built yet (FRD Section 9 screens are images), so every
 * locator below is a guess from the field names the FRD uses. They are all declared in the "Locators" block so that one edit fixes
 * every step once the real DOM is known.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';

export type ClearLogState = 'absent' | 'disabled' | 'enabled';

export class AuditTrailFilterPanel {
  // ---------------------------------------------------------------------------
  // Locators
  // ---------------------------------------------------------------------------

  /** TODO(locator): confirm against live UI - a native <select> or a custom combobox labelled "Functions". */
  get functions(): Locator {
    return this.page.getByLabel(/^\s*Functions?\s*$/i).or(this.page.getByRole('combobox', { name: /Functions?/i })).first();
  }

  /** TODO(locator): confirm against live UI. */
  get fromDate(): Locator {
    return this.page.getByLabel(/From Date/i).first();
  }

  /** TODO(locator): confirm against live UI. */
  get toDate(): Locator {
    return this.page.getByLabel(/To Date/i).first();
  }

  /** TODO(locator): confirm against live UI. */
  get searchButton(): Locator {
    return this.page.getByRole('button', { name: /^\s*Search\s*$/i }).first();
  }

  /** TODO(locator): confirm against live UI (FRD 6.5 FB-2 allows the control to be hidden OR disabled for a view-only user). */
  get clearLogButton(): Locator {
    return this.page.getByRole('button', { name: /Clear\s*Log/i }).or(this.page.getByRole('link', { name: /Clear\s*Log/i })).first();
  }

  /** TODO(locator): confirm against live UI - where the field validation messages are rendered. */
  private get validationTexts(): Locator {
    return this.page.locator('[role="alert"], [class*="error" i], [class*="invalid" i], [class*="validation" i], .mat-error');
  }

  constructor(private readonly page: Page) {}

  // ---------------------------------------------------------------------------
  // Presence
  // ---------------------------------------------------------------------------

  async hasAllControls(): Promise<Record<'Functions' | 'From Date' | 'To Date' | 'Search' | 'Clear Log', boolean>> {
    return {
      Functions: await this.functions.isVisible().catch(() => false),
      'From Date': await this.fromDate.isVisible().catch(() => false),
      'To Date': await this.toDate.isVisible().catch(() => false),
      Search: await this.searchButton.isVisible().catch(() => false),
      'Clear Log': await this.clearLogButton.isVisible().catch(() => false),
    };
  }

  // ---------------------------------------------------------------------------
  // Functions
  // ---------------------------------------------------------------------------

  private async isNativeSelect(): Promise<boolean> {
    return (await this.functions.evaluate((element) => element.tagName.toLowerCase())) === 'select';
  }

  /** The option texts, opening (and closing again) a custom dropdown when needed. */
  async functionOptions(): Promise<string[]> {
    if (await this.isNativeSelect()) {
      return (await this.functions.locator('option').allInnerTexts()).map((text) => text.trim()).filter(Boolean);
    }
    await this.functions.click();
    const options = this.page.getByRole('option');
    await options.first().waitFor({ state: 'visible' });
    const texts = (await options.allInnerTexts()).map((text) => text.trim()).filter(Boolean);
    await this.page.keyboard.press('Escape');
    return texts;
  }

  async selectFunction(name: string): Promise<void> {
    if (await this.isNativeSelect()) {
      await this.functions.selectOption({ label: name });
      return;
    }
    await this.functions.click();
    await this.page.getByRole('option', { name, exact: true }).click();
  }

  async selectedFunction(): Promise<string> {
    if (await this.isNativeSelect()) {
      return (await this.functions.evaluate((element) => (element as HTMLSelectElement).selectedOptions[0]?.textContent ?? '')).trim();
    }
    const value = await this.functions.inputValue().catch(() => '');
    return (value || (await this.functions.innerText())).trim();
  }

  /** Focuses the control and types like a user would; the caller then checks the value did not change. */
  async typeIntoFunctions(text: string, pressEnter = false): Promise<void> {
    await this.functions.click();
    await this.page.keyboard.type(text);
    if (pressEnter) await this.page.keyboard.press('Enter');
  }

  // ---------------------------------------------------------------------------
  // Dates (typed, because the FRD scenarios type invalid / incomplete / non-date text)
  // ---------------------------------------------------------------------------

  async setFromDate(text: string): Promise<void> {
    await this.type(this.fromDate, text);
  }

  async setToDate(text: string): Promise<void> {
    await this.type(this.toDate, text);
  }

  async clearFromDate(): Promise<void> {
    await this.type(this.fromDate, '');
  }

  async clearToDate(): Promise<void> {
    await this.type(this.toDate, '');
  }

  async fromValue(): Promise<string> {
    return (await this.fromDate.inputValue()).trim();
  }

  async toValue(): Promise<string> {
    return (await this.toDate.inputValue()).trim();
  }

  /** Select-all + type (so an existing value is replaced) then Tab to commit / blur. TODO(locator): a read-only date picker needs its calendar instead. */
  private async type(field: Locator, text: string): Promise<void> {
    await field.click();
    await field.fill(text);
    await field.press('Tab');
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  async search(): Promise<void> {
    await this.searchButton.click();
  }

  async isSearchEnabled(): Promise<boolean> {
    return this.searchButton.isEnabled();
  }

  async clickClearLog(): Promise<void> {
    await this.clearLogButton.click();
  }

  async clearLogState(): Promise<ClearLogState> {
    if (!(await this.clearLogButton.isVisible().catch(() => false))) return 'absent';
    return (await this.clearLogButton.isEnabled()) ? 'enabled' : 'disabled';
  }

  /** Tries to activate Clear Log the ways a determined user would (click, focus + Enter / Space); true when anything was invoked. */
  async tryActivateClearLog(): Promise<boolean> {
    if ((await this.clearLogState()) === 'absent') return false;
    await this.clearLogButton.click({ force: true, timeout: 3000 }).catch(() => undefined);
    await this.clearLogButton.focus({ timeout: 3000 }).catch(() => undefined);
    await this.page.keyboard.press('Enter');
    await this.page.keyboard.press('Space');
    return true;
  }

  // ---------------------------------------------------------------------------
  // Validation messages
  // ---------------------------------------------------------------------------

  async messageIsVisible(text: string): Promise<boolean> {
    return this.page.getByText(text, { exact: false }).first().isVisible().catch(() => false);
  }

  async expectMessage(text: string): Promise<void> {
    await expect(this.page.getByText(text, { exact: false }).first(), `validation message "${text}"`).toBeVisible();
  }

  async validationMessages(): Promise<string[]> {
    return (await this.validationTexts.allInnerTexts()).map((text) => text.trim()).filter(Boolean);
  }
}
