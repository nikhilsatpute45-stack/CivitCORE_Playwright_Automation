/**
 * Location Management, as far as the Region feature files need it (region_creation / region_deletion /
 * region_office_location_association / region_ui).
 *
 * TODO: Verify locator once the Region module (and its Location integration) is developed. The real Location
 * module (src/pages/location) is confirmed to have no Region field at all (see src/test-data/location.data.ts,
 * NO_REGION_FIELD) - the FRD's Region lookup on the Add/Edit Location dialog is a gap the Location module's own
 * suite already reports. This is a self-contained placeholder for that future field and for the Location
 * view / list surfaces that would show the selected Region; it deliberately does not reach into the real
 * LocationFormDialog / LocationListPage (out of this module's scope - see CLAUDE.md on src/pages/location).
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import type { MastersManagementPage } from '../department_pages/MastersManagementPage';
import type { RegionListPage } from './RegionListPage';

export interface LocationSaveResult {
  status: number;
  message: string;
  id?: number;
}

export class RegionLocationPage {
  readonly tab: Locator;
  readonly addButton: Locator;
  readonly dialog: Locator;
  readonly nameInput: Locator;
  readonly regionSelect: Locator;
  readonly regionInput: Locator;
  readonly regionOptions: Locator;
  readonly submitButton: Locator;
  readonly cancelButton: Locator;
  readonly dataRows: Locator;
  readonly viewRegionField: Locator;

  constructor(
    private readonly page: Page,
    private readonly list: RegionListPage,
    private readonly organization: MastersManagementPage,
  ) {
    // TODO: Verify locator once the Region module is developed.
    this.tab = page.locator('.task-tab-base').filter({ hasText: /^\s*Location\s*$/ });
    this.addButton = page.getByRole('button', { name: 'Add Location', exact: true });
    this.dialog = page.getByRole('dialog');
    this.nameInput = this.dialog.locator('#LocationName');
    this.regionSelect = this.dialog.locator('#region, select[name="region"]');
    this.regionInput = this.dialog.getByRole('combobox', { name: /^Region$/i });
    this.regionOptions = this.page.getByRole('option');
    this.submitButton = this.dialog.getByRole('button', { name: /^(Add|Update) Location$/ });
    this.cancelButton = this.dialog.getByRole('button', { name: 'Cancel', exact: true });
    this.dataRows = page.locator('.ag-center-cols-container [role="row"]');
    this.viewRegionField = page.getByText(/^Region:/i);
  }

  async isAvailable(): Promise<boolean> {
    return this.tab.isVisible().catch(() => false);
  }

  async open(organizationName: string): Promise<void> {
    await expect(this.organization.mastersManagementLink.or(this.tab).or(this.list.organizationConfigurationIcon)).toBeVisible({ timeout: 30000 });
    if (await this.organization.mastersManagementLink.isVisible().catch(() => false)) {
      await this.organization.openMastersManagement();
      await this.organization.expectAdminPortalLoaded();
    }
    if (!(await this.tab.isVisible().catch(() => false))) {
      await expect(this.list.organizationConfigurationIcon).toBeVisible({ timeout: 30000 });
      await this.list.organizationConfigurationIcon.click();
    }
    await this.tab.click();
    await expect(this.list.organizationPlaceholder.or(this.addButton)).toBeVisible({ timeout: 30000 });
    if (await this.list.organizationPlaceholder.isVisible()) await this.organization.selectOrganization(organizationName);
    await expect(this.addButton).toBeVisible({ timeout: 30000 });
  }

  async openAddForm(): Promise<void> {
    await this.addButton.click();
    await expect(this.nameInput).toBeVisible({ timeout: 20000 });
  }

  async isFormOpen(): Promise<boolean> {
    return this.nameInput.isVisible().catch(() => false);
  }

  // ---------------------------------------------------------------------------
  // Region lookup (TC-REG-014, 047, 100)
  // ---------------------------------------------------------------------------

  async openRegionLookup(): Promise<void> {
    await expect(this.regionInput.or(this.regionSelect)).toBeVisible({ timeout: 20000 });
    if (await this.regionInput.isVisible().catch(() => false)) await this.regionInput.click();
  }

  async regionOptionNames(): Promise<string[]> {
    if (await this.regionSelect.isVisible().catch(() => false)) {
      return (await this.regionSelect.locator('option').allInnerTexts()).map((text) => text.trim()).filter(Boolean);
    }
    return (await this.regionOptions.allInnerTexts()).map((text) => text.trim()).filter(Boolean);
  }

  async selectRegion(name: string): Promise<void> {
    if (await this.regionSelect.isVisible().catch(() => false)) {
      await this.regionSelect.selectOption({ label: name });
      return;
    }
    await this.openRegionLookup();
    await this.regionOptions.filter({ hasText: name }).first().click();
  }

  async tryTypeRegion(text: string): Promise<void> {
    await this.openRegionLookup();
    await this.regionInput.pressSequentially(text, { delay: 5 }).catch(() => undefined);
  }

  // ---------------------------------------------------------------------------
  // Save / Edit / View
  // ---------------------------------------------------------------------------

  async fill(name: string): Promise<void> {
    await expect(this.nameInput).toBeVisible({ timeout: 20000 });
    await this.nameInput.fill(name);
  }

  async save(): Promise<LocationSaveResult> {
    // TODO: Verify endpoint once the Region / Location integration is developed.
    const response = this.page
      .waitForResponse((candidate) => /\/location\/3\.0\/(create|update)/i.test(candidate.url()), { timeout: 20000 })
      .catch(() => null);
    await this.submitButton.click({ timeout: 10000 });
    const result = await response;
    if (!result) return { status: 0, message: 'no response observed' };
    const body: unknown = await result.json().catch(() => ({}));
    const data = (body as { data?: unknown })?.data;
    return { status: result.status(), message: (body as { message?: string })?.message ?? '', id: typeof data === 'number' ? data : undefined };
  }

  async startEdit(locationName: string): Promise<void> {
    const row = this.dataRows.filter({ hasText: locationName }).first();
    await expect(row, `Location "${locationName}" is listed`).toBeVisible({ timeout: 20000 });
    await row.locator('[col-id="action"] button').click();
    await this.page.locator('.menu-item').filter({ hasText: /^\s*Edit\s*$/ }).first().click();
    await expect(this.nameInput).toBeVisible({ timeout: 20000 });
  }

  async viewRow(locationName: string): Promise<void> {
    const row = this.dataRows.filter({ hasText: locationName }).first();
    await expect(row, `Location "${locationName}" is listed`).toBeVisible({ timeout: 20000 });
    await row.locator('[col-id="action"] button').click();
    await this.page.locator('.menu-item').filter({ hasText: /^\s*View\s*$/ }).first().click();
  }

  async regionShownOnView(): Promise<string> {
    return (await this.viewRegionField.innerText().catch(() => '')).replace(/^Region:\s*/i, '').trim();
  }

  async regionCell(locationName: string): Promise<string> {
    const row = this.dataRows.filter({ hasText: locationName }).first();
    return (await row.locator('[col-id="region"]').innerText().catch(() => '')).trim();
  }
}
