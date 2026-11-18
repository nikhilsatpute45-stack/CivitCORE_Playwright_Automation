/**
 * A dropdown that may be a native <select> or a custom combobox; the live control has not been inspected.
 * TODO(locator): confirm against live UI which of the two the portal uses.
 */
import type { Locator, Page } from '@playwright/test';

export class DropdownField {
  constructor(
    private readonly page: Page,
    readonly control: Locator,
  ) {}

  private async isNativeSelect(): Promise<boolean> {
    return this.control.evaluate((element) => element.tagName.toLowerCase() === 'select').catch(() => false);
  }

  /** The text the control currently shows (selected option, or the combobox text / value). */
  async selectedText(): Promise<string> {
    if (await this.isNativeSelect()) {
      return (await this.control.evaluate((element) => {
        const select = element as HTMLSelectElement;
        return select.selectedOptions[0]?.textContent ?? '';
      })).trim();
    }
    const value = await this.control.inputValue().catch(() => '');
    return (value || (await this.control.innerText().catch(() => ''))).replace(/\s+/g, ' ').trim();
  }

  async select(label: string): Promise<void> {
    if (await this.isNativeSelect()) {
      await this.control.selectOption({ label });
      return;
    }
    await this.control.click();
    await this.page.getByRole('option', { name: label, exact: true }).first().click();
  }

  /** The labels offered by the control (opens a custom combobox to read them and closes it again). */
  async options(): Promise<string[]> {
    if (await this.isNativeSelect()) {
      return (await this.control.locator('option').allInnerTexts()).map((text) => text.trim());
    }
    await this.control.click();
    const texts = (await this.page.getByRole('option').allInnerTexts()).map((text) => text.trim());
    await this.page.keyboard.press('Escape');
    return texts;
  }
}
