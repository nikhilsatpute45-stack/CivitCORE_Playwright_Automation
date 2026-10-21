/**
 * Region deletion (feature: region_deletion.feature).
 *
 * TODO: Verify locator once the Region module is developed. Modelled on LocationCategoryDeletionPage: the
 * confirmation is assumed to be the same `role="dialog"` container as the Add / Edit form, told apart by its
 * "Delete" button. The FRD (6.5 / Figure 3) checks Office association before Location association and blocks
 * deletion with a dependency message before any confirmation prompt when either exists.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { REGION_DELETION_BLOCKED_PATTERN } from '../../test-data/region.data';
import { RegionApi, type RegionApiCall } from './RegionApi';
import type { RegionListPage } from './RegionListPage';

const CONFIRM_CLICK_TIMEOUT = 10000;
const DELETE_ATTEMPTS = 3;

export class RegionDeletionPage {
  readonly dialog: Locator;
  readonly confirmButton: Locator;
  readonly cancelButton: Locator;
  readonly blockedMessage: Locator;

  constructor(
    page: Page,
    private readonly list: RegionListPage,
    private readonly api: RegionApi,
  ) {
    this.dialog = page.getByRole('dialog');
    this.confirmButton = this.dialog.getByRole('button', { name: 'Delete', exact: true });
    this.cancelButton = this.dialog.getByRole('button', { name: 'Cancel', exact: true });
    this.blockedMessage = page.getByText(REGION_DELETION_BLOCKED_PATTERN).first();
  }

  /** Clicks the row's Delete action; what follows (confirmation or a block) is up to the app. */
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

  /** The confirmation is shown and asks to confirm a permanent delete. */
  async expectConfirmationPrompt(): Promise<void> {
    await this.expectConfirmationOpen();
  }

  /** Waits for the reaction to a Delete click and returns the confirmation text, or null when no confirmation opened. */
  async confirmationAfterDeleteClick(): Promise<string | null> {
    await expect(this.confirmButton.or(this.blockedMessage).first()).toBeVisible({ timeout: 15000 });
    if (!(await this.isConfirmationOpen())) return null;
    return (await this.dialog.innerText()).replace(/\s+/g, ' ').trim();
  }

  /** Confirms the open delete dialog and returns the delete API result. */
  async confirm(): Promise<RegionApiCall> {
    const response = this.api.nextDelete();
    response.catch(() => undefined);
    await this.confirmButton.click({ timeout: CONFIRM_CLICK_TIMEOUT });
    return RegionApi.parseCall(await response);
  }

  async cancel(): Promise<void> {
    await this.cancelButton.click({ timeout: 8000 });
    await expect(this.confirmButton).toBeHidden({ timeout: 20000 });
  }

  /** Deletes a Region through the UI and waits for the grid to drop it (same retry shape as LocationCategoryDeletionPage). */
  async deleteRegion(name: string): Promise<RegionApiCall> {
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
