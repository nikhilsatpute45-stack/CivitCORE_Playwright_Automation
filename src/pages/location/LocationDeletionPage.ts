/**
 * Location deletion (feature: location_deletion.feature).
 *
 * The delete confirmation is the same `role="dialog"` container as the Add / Edit form, told apart by its
 * "Delete" button (same convention as Department, Designation and Location Category). The app deletes
 * permanently (hard delete) after confirmation. Whether a Location with a child, or one the FRD says is
 * "associated with an Office", actually gets blocked is left to the real app: this project confirmed the
 * live Add/Edit Office form has no Location field (see LOCATION_OFFICE_ASSOCIATION_GAP), so the
 * Office-dependency scenarios are skipped at their precondition rather than asserted either way; the
 * child-dependency (hierarchy) scenarios run for real.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { DELETION_BLOCKED_PATTERN, locationMessages } from '../../test-data/location.data';
import { LocationApi, type LocationApiCall } from './LocationApi';
import type { LocationListPage } from './LocationListPage';

const CONFIRM_CLICK_TIMEOUT = 10000;
const DELETE_ATTEMPTS = 3;

export class LocationDeletionPage {
  readonly dialog: Locator;
  readonly confirmButton: Locator;
  readonly cancelButton: Locator;
  readonly blockedMessage: Locator;

  constructor(
    page: Page,
    private readonly list: LocationListPage,
    private readonly api: LocationApi,
  ) {
    this.dialog = page.getByRole('dialog');
    this.confirmButton = this.dialog.getByRole('button', { name: 'Delete', exact: true });
    this.cancelButton = this.dialog.getByRole('button', { name: 'Cancel', exact: true });
    this.blockedMessage = page.getByText(DELETION_BLOCKED_PATTERN).first();
  }

  async requestDelete(name: string): Promise<void> {
    await this.list.chooseRowAction(name, 'Delete');
  }

  async isConfirmationOpen(): Promise<boolean> {
    return this.confirmButton.isVisible().catch(() => false);
  }

  async expectConfirmationOpen(): Promise<void> {
    await expect(this.confirmButton).toBeVisible({ timeout: 20000 });
  }

  async expectNoConfirmation(): Promise<void> {
    await expect(this.confirmButton).toBeHidden();
  }

  async expectConfirmationPrompt(): Promise<void> {
    await this.expectConfirmationOpen();
    await expect(this.dialog).toContainText(locationMessages.deleteConfirmation);
  }

  /** Waits for the reaction to a Delete click and returns the confirmation text, or null when no confirmation opened. */
  async confirmationAfterDeleteClick(): Promise<string | null> {
    await expect(this.confirmButton.or(this.blockedMessage).first()).toBeVisible({ timeout: 15000 });
    if (!(await this.isConfirmationOpen())) return null;
    return (await this.dialog.innerText()).replace(/\s+/g, ' ').trim();
  }

  async confirm(): Promise<LocationApiCall> {
    const response = this.api.nextDelete();
    response.catch(() => undefined);
    await this.confirmButton.click({ timeout: CONFIRM_CLICK_TIMEOUT });
    return LocationApi.parseCall(await response);
  }

  async cancel(): Promise<void> {
    await this.cancelButton.click({ timeout: 8000 });
    await expect(this.confirmButton).toBeHidden({ timeout: 20000 });
  }

  /**
   * Deletes a Location through the UI and waits for the grid to drop it. A grid reload that lands after a
   * save re-renders the list and closes an open confirmation; the delete is then requested again instead of
   * waiting forever. A delete request is never sent twice.
   */
  async deleteLocation(name: string): Promise<LocationApiCall> {
    for (let attempt = 1; ; attempt++) {
      await this.requestDelete(name);
      await this.expectConfirmationOpen();
      const version = this.api.masterVersion;
      const requestsBefore = this.api.deleteRequests.length;
      try {
        const call = await this.confirm();
        if (call.status < 300) await this.api.waitForReloadAfter(version);
        return call;
      } catch (error) {
        const closedUnsent = !(await this.isConfirmationOpen()) && this.api.deleteRequests.length === requestsBefore;
        if (attempt >= DELETE_ATTEMPTS || !closedUnsent) throw error;
      }
    }
  }

  wasDeleteRequested(id: number): boolean {
    return this.api.deleteRequests.includes(id);
  }
}
