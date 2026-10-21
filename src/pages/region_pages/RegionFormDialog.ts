/**
 * Add / Edit Region dialog (features: region_creation / region_update / region_ui.feature).
 *
 * TODO: Verify locator once the Region module is developed. Per the FRD (region_ui.feature TC-REG-091 /
 * TC-REG-095) the Add form has only one user-entered field (Region Name) and the Edit form additionally shows
 * a read-only, system-generated Region ID; both are guessed here as a plain text input and a disabled input,
 * the same shape LocationCategoryFormDialog / LocationFormDialog use for their own name field.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { RegionApi, MUTATION_URL, SUBMIT_TIMEOUT, type RegionApiCall } from './RegionApi';

export type SubmitOutcome =
  | { kind: 'saved' | 'rejected'; call: RegionApiCall }
  | { kind: 'client-validation'; messages: string[] }
  | { kind: 'no-response' }
  /** The app may keep Update disabled until a field changes, as every sibling module's Edit form does. */
  | { kind: 'disabled' };

/** Time allowed for a request to follow a client-side validation message before "no request" is concluded. */
const LATE_REQUEST_GRACE_MS = 1500;

export class RegionFormDialog {
  readonly dialog: Locator;
  readonly title: Locator;
  readonly nameInput: Locator;
  readonly idInput: Locator;
  readonly submitButton: Locator;
  readonly cancelButton: Locator;
  readonly closeButton: Locator;
  readonly validationMessages: Locator;

  constructor(
    page: Page,
    private readonly api: RegionApi,
  ) {
    // TODO: Verify locator once the Region module is developed.
    this.dialog = page.getByRole('dialog');
    this.title = this.dialog.getByText(/^\s*(Add|Edit) Region\s*$/).first();
    this.nameInput = this.dialog.locator('#regionName, input[name="regionName"]');
    this.idInput = this.dialog.locator('#regionId, input[name="regionId"]');
    this.submitButton = this.dialog.getByRole('button', { name: /^(Add|Update|Save) Region$/ });
    this.cancelButton = this.dialog.getByRole('button', { name: 'Cancel', exact: true });
    this.closeButton = this.dialog.getByRole('button', { name: 'Close', exact: true });
    this.validationMessages = this.dialog.getByText(/is required|cannot exceed|invalid|not allowed|already exists/i);
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

  /** Current field values, for diagnostics. */
  async currentValues(): Promise<string> {
    if (!(await this.isOpen())) return 'the form already closed';
    return `name="${await this.nameInput.inputValue()}"`;
  }

  /** Visible labels of the form's fields, to check that only Region Name (and, in Edit, the read-only ID) is offered. */
  async fieldLabels(): Promise<string[]> {
    const labels = await this.dialog.locator('label').allInnerTexts();
    return labels.map((label) => label.replace(/\*/g, '').trim()).filter(Boolean);
  }

  /** Inline or toast message that matches `pattern`. */
  message(pattern: RegExp): Locator {
    return this.dialog.getByText(pattern).first();
  }

  /**
   * Types the value key by key, as a user would. The app may filter keystrokes, and `fill` would
   * instead drop the whole value when one character is refused.
   */
  async type(value: string): Promise<void> {
    await expect(this.nameInput).toBeVisible({ timeout: 20000 });
    await this.nameInput.fill('');
    if (value !== '') await this.nameInput.pressSequentially(value);
  }

  async clear(): Promise<void> {
    await this.type('');
  }

  // ---------------------------------------------------------------------------
  // Region ID (Edit only, read-only)
  // ---------------------------------------------------------------------------

  async idValue(): Promise<string> {
    return (await this.idInput.inputValue().catch(() => this.idInput.innerText().catch(() => ''))).trim();
  }

  async isIdReadOnly(): Promise<boolean> {
    const disabled = await this.idInput.isDisabled().catch(() => false);
    const readOnly = await this.idInput.getAttribute('readonly').catch(() => null);
    return disabled || readOnly !== null;
  }

  /** Attempts to type into the Region ID control; a read-only / disabled control keeps its value unchanged. */
  async tryTypeId(value: string): Promise<void> {
    await this.idInput.pressSequentially(value, { timeout: 3000 }).catch(() => undefined);
  }

  // ---------------------------------------------------------------------------
  // Save / Cancel / Close
  // ---------------------------------------------------------------------------

  /**
   * Clicks Add / Update Region and reports what happened: the API accepted or rejected the save, or
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

    const call = await RegionApi.parseCall(first);
    if (call.status >= 300) return { kind: 'rejected', call };
    await this.api.waitForReloadAfter(masterVersion, 'the Region list reloaded after the save');
    return { kind: 'saved', call };
  }

  /** Cancel (FRD: Close / Cancel without saving). */
  async cancel(): Promise<void> {
    await this.cancelButton.click({ timeout: 8000 }).catch(() => this.title.page().keyboard.press('Escape'));
    await this.expectClosed();
  }

  /** Header close button. */
  async close(): Promise<void> {
    await this.dialog.locator('button.btn-close, button[aria-label="Close"]').first().click();
    await this.expectClosed();
  }
}
