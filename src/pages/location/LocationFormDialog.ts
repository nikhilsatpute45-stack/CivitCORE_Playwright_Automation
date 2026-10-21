/**
 * Add / Edit Location dialog (features: location_creation / location_update / location_ui).
 *
 * FRD -> MIDC vocabulary: Name = "Location", Short Name = "Location Code" (live limit 20 characters, not the
 * FRD's 30), Parent Location Category = "Parent Category", Save = "Add / Update Location". There is no
 * separate "Region" field (see src/test-data/location.data.ts, NO_REGION_FIELD) and no "Location ID" field or
 * label anywhere in the dialog. Unlike Location Category's typed lookup, Parent Category and Parent Location
 * are plain native <select> elements that cascade: choosing a Parent Category narrows Parent Location's options
 * (TC-Loc-014); nothing else depends on the Location Category select.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { LocationApi, MUTATION_URL, SUBMIT_TIMEOUT, type LocationApiCall } from './LocationApi';

export type FormField = 'Location' | 'Location Code';

export type SubmitOutcome =
  | { kind: 'saved' | 'rejected'; call: LocationApiCall }
  | { kind: 'client-validation'; messages: string[] }
  | { kind: 'no-response' }
  | { kind: 'disabled' };

const LATE_REQUEST_GRACE_MS = 1500;

export class LocationFormDialog {
  readonly dialog: Locator;
  readonly title: Locator;
  readonly nameInput: Locator;
  readonly codeInput: Locator;
  readonly categorySelect: Locator;
  readonly parentCategorySelect: Locator;
  readonly parentLocationSelect: Locator;
  readonly submitButton: Locator;
  readonly cancelButton: Locator;
  readonly validationMessages: Locator;

  constructor(
    page: Page,
    private readonly api: LocationApi,
  ) {
    this.dialog = page.getByRole('dialog');
    this.title = this.dialog.getByText(/^\s*(Add|Edit) Location\s*$/).first();
    this.nameInput = this.dialog.locator('#LocationName');
    this.codeInput = this.dialog.locator('#LocationAbb');
    this.categorySelect = this.dialog.locator('#locCateg');
    this.parentCategorySelect = this.dialog.locator('#parentCateg');
    this.parentLocationSelect = this.dialog.locator('#parentLocation');
    this.submitButton = this.dialog.getByRole('button', { name: /^(Add|Update) Location$/ });
    this.cancelButton = this.dialog.getByRole('button', { name: 'Cancel', exact: true });
    this.validationMessages = this.dialog.getByText(/is required|cannot exceed|invalid|not allowed/i);
  }

  async isOpen(): Promise<boolean> {
    return this.nameInput.isVisible().catch(() => false);
  }

  async expectClosed(): Promise<void> {
    await expect(this.nameInput).toBeHidden({ timeout: 20000 });
  }

  async mode(): Promise<'add' | 'edit'> {
    return /edit/i.test(await this.title.innerText()) ? 'edit' : 'add';
  }

  input(field: FormField): Locator {
    return field === 'Location Code' ? this.codeInput : this.nameInput;
  }

  async currentValues(): Promise<string> {
    if (!(await this.isOpen())) return 'the form already closed';
    return [
      `name="${await this.nameInput.inputValue()}"`,
      `code="${await this.codeInput.inputValue()}"`,
      `category="${await this.categorySelect.inputValue()}"`,
      `parentCategory="${await this.parentCategorySelect.inputValue()}"`,
      `parentLocation="${await this.parentLocationSelect.inputValue()}"`,
    ].join(' ');
  }

  /** Visible labels of the form's fields (asterisk removed). */
  async fieldLabels(): Promise<string[]> {
    const labels = await this.dialog.locator('label').allInnerTexts();
    return labels.map((label) => label.replace(/\*/g, '').trim()).filter(Boolean);
  }

  message(pattern: RegExp): Locator {
    return this.dialog.getByText(pattern).first();
  }

  /**
   * Types the value key by key, as a user would. The app may filter keystrokes, and `fill` would
   * instead drop the whole value when one character is refused.
   */
  async type(field: FormField, value: string): Promise<void> {
    const input = this.input(field);
    await expect(input).toBeVisible({ timeout: 20000 });
    await input.fill('');
    if (value !== '') await input.pressSequentially(value);
  }

  async clear(field: FormField): Promise<void> {
    await this.type(field, '');
  }

  // ---------------------------------------------------------------------------
  // Dropdowns
  // ---------------------------------------------------------------------------

  /** Options of a <select>, placeholder removed, waiting until the option count has settled. */
  private async optionsOf(select: Locator): Promise<string[]> {
    let previous = -1;
    await expect
      .poll(
        async () => {
          const count = await select.locator('option').count();
          const settled = count > 0 && count === previous;
          previous = count;
          return settled;
        },
        { timeout: 20000, intervals: [500] },
      )
      .toBe(true);
    const options = await select.locator('option').allInnerTexts();
    return options.map((option) => option.trim()).filter((option) => option !== '' && !/^select\b/i.test(option));
  }

  async categoryOptions(): Promise<string[]> {
    return this.optionsOf(this.categorySelect);
  }

  async parentCategoryOptions(): Promise<string[]> {
    return this.optionsOf(this.parentCategorySelect);
  }

  async parentLocationOptions(): Promise<string[]> {
    return this.optionsOf(this.parentLocationSelect);
  }

  async selectCategory(label: string): Promise<void> {
    await this.categorySelect.selectOption({ label });
  }

  async selectParentCategory(label: string): Promise<void> {
    await this.parentCategorySelect.selectOption({ label });
  }

  async selectParentLocation(label: string): Promise<void> {
    // The field only lists Locations under the chosen Parent Category; give that select time to settle first.
    await expect.poll(() => this.parentLocationSelect.locator('option').count(), { timeout: 20000 }).toBeGreaterThan(1);
    await this.parentLocationSelect.selectOption({ label });
  }

  async clearParentCategory(): Promise<void> {
    await this.parentCategorySelect.selectOption({ index: 0 });
  }

  async clearParentLocation(): Promise<void> {
    await this.parentLocationSelect.selectOption({ index: 0 });
  }

  async parentCategoryValue(): Promise<string> {
    const value = await this.parentCategorySelect.inputValue();
    return value === '' ? '' : (await this.parentCategorySelect.locator('option:checked').innerText()).trim();
  }

  async parentLocationValue(): Promise<string> {
    const value = await this.parentLocationSelect.inputValue();
    return value === '' ? '' : (await this.parentLocationSelect.locator('option:checked').innerText()).trim();
  }

  // ---------------------------------------------------------------------------
  // Save / Cancel
  // ---------------------------------------------------------------------------

  /**
   * Clicks Add / Update Location and reports what happened: the API accepted or rejected the save, or
   * client-side validation stopped it before any request was sent.
   */
  async submit(): Promise<SubmitOutcome> {
    const masterVersion = this.api.masterVersion;
    const response = this.api.nextMutation();
    const enabled = await expect
      .poll(() => this.submitButton.isEnabled(), { timeout: 3000 })
      .toBe(true)
      .then(
        () => true,
        () => false,
      );
    if (!enabled) return { kind: 'disabled' };
    await this.submitButton.click({ timeout: 10000 });

    const clientValidation = this.validationMessages
      .first()
      .waitFor({ state: 'visible', timeout: SUBMIT_TIMEOUT })
      .then(() => 'client' as const)
      .catch(() => null);
    let first = await Promise.race([response, clientValidation]);
    if (first === 'client') {
      const late = await Promise.race([response, new Promise<null>((resolve) => setTimeout(resolve, LATE_REQUEST_GRACE_MS, null))]);
      if (late) first = late;
    }
    if (first === 'client') {
      return { kind: 'client-validation', messages: (await this.validationMessages.allInnerTexts()).map((m) => m.trim()) };
    }
    if (!first || !MUTATION_URL.test(first.url())) return { kind: 'no-response' };

    const call = await LocationApi.parseCall(first);
    if (call.status >= 300) return { kind: 'rejected', call };
    await this.api.waitForReloadAfter(masterVersion, 'the Location list reloaded after the save');
    return { kind: 'saved', call };
  }

  async cancel(): Promise<void> {
    await this.cancelButton.click({ timeout: 8000 }).catch(() => this.title.page().keyboard.press('Escape'));
    await this.expectClosed();
  }
}
