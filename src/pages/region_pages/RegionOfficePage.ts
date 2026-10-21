/**
 * Office Management, as far as the Region feature files need it (region_creation / region_update /
 * region_deletion / region_search_view / region_audit_log / region_office_location_association / region_ui).
 *
 * TODO: Verify locator once the Region module (and its Office integration) is developed. This codebase has no
 * Office module of its own yet: the only existing Office reference is LocationOfficePage, a narrow probe that
 * confirms the live Add/Edit Office dialog (Organization Name, Office, Office Code, Office Category, Parent
 * Category, Parent Office) has no Location field. The FRD additionally expects a Region lookup on that same
 * dialog (stored by Region ID) and an "Assigned With Offices" reflection on the Region List; neither exists
 * today, so every locator here is a placeholder guessed from the sibling modules' conventions.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import type { MastersManagementPage } from '../department_pages/MastersManagementPage';
import type { RegionListPage } from './RegionListPage';

export interface OfficeSaveResult {
  status: number;
  message: string;
  id?: number;
}

export class RegionOfficePage {
  readonly tab: Locator;
  readonly addButton: Locator;
  readonly dialog: Locator;
  readonly nameInput: Locator;
  readonly regionSelect: Locator;
  readonly regionInput: Locator;
  readonly regionOptions: Locator;
  readonly clearRegionButton: Locator;
  readonly submitButton: Locator;
  readonly cancelButton: Locator;
  readonly dataRows: Locator;

  constructor(
    private readonly page: Page,
    private readonly list: RegionListPage,
    private readonly organization: MastersManagementPage,
  ) {
    // TODO: Verify locator once the Region module is developed.
    this.tab = page.locator('.task-tab-base').filter({ hasText: /^\s*Office\s*$/ });
    this.addButton = page.getByRole('button', { name: 'Add Office', exact: true });
    this.dialog = page.getByRole('dialog');
    this.nameInput = this.dialog.locator('#OfficeName, input[name="officeName"]');
    this.regionSelect = this.dialog.locator('#region, select[name="region"]');
    this.regionInput = this.dialog.getByRole('combobox', { name: /^Region$/i });
    this.regionOptions = this.page.getByRole('option');
    this.clearRegionButton = this.dialog.locator('[aria-label="Clear Region"], .region-clear');
    this.submitButton = this.dialog.getByRole('button', { name: /^(Add|Update) Office$/ });
    this.cancelButton = this.dialog.getByRole('button', { name: 'Cancel', exact: true });
    this.dataRows = page.locator('.ag-center-cols-container [role="row"]');
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
  // Region lookup (TC-REG-013, 044, 099)
  // ---------------------------------------------------------------------------

  async openRegionLookup(): Promise<void> {
    await expect(this.regionInput.or(this.regionSelect)).toBeVisible({ timeout: 20000 });
    if (await this.regionInput.isVisible().catch(() => false)) await this.regionInput.click();
  }

  /** Region names the lookup currently offers. */
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

  /** Free text typed into the Region field; a selection-only control never offers it back as an option. */
  async tryTypeRegion(text: string): Promise<void> {
    await this.openRegionLookup();
    await this.regionInput.pressSequentially(text, { delay: 5 }).catch(() => undefined);
  }

  async clearRegion(): Promise<void> {
    await this.clearRegionButton.click({ timeout: 5000 }).catch(() => undefined);
  }

  async currentRegion(): Promise<string> {
    if (await this.regionSelect.isVisible().catch(() => false)) return (await this.regionSelect.inputValue()).trim();
    return (await this.regionInput.inputValue().catch(() => this.regionInput.innerText().catch(() => ''))).trim();
  }

  // ---------------------------------------------------------------------------
  // Save / Edit
  // ---------------------------------------------------------------------------

  async fill(name: string): Promise<void> {
    await expect(this.nameInput).toBeVisible({ timeout: 20000 });
    await this.nameInput.fill(name);
  }

  async save(): Promise<OfficeSaveResult> {
    // TODO: Verify endpoint once the Region / Office integration is developed.
    const response = this.page
      .waitForResponse((candidate) => /\/office\/3\.0\/(create|update)/i.test(candidate.url()), { timeout: 20000 })
      .catch(() => null);
    await this.submitButton.click({ timeout: 10000 });
    const result = await response;
    if (!result) return { status: 0, message: 'no response observed' };
    const body: unknown = await result.json().catch(() => ({}));
    const data = (body as { data?: unknown })?.data;
    return { status: result.status(), message: (body as { message?: string })?.message ?? '', id: typeof data === 'number' ? data : undefined };
  }

  async cancel(): Promise<void> {
    await this.cancelButton.click({ timeout: 8000 }).catch(() => this.page.keyboard.press('Escape'));
  }

  /** Opens the row action menu of `officeName` and chooses Edit (list row actions are the same shared markup as Region's). */
  async startEdit(officeName: string): Promise<void> {
    const row = this.dataRows.filter({ hasText: officeName }).first();
    await expect(row, `Office "${officeName}" is listed`).toBeVisible({ timeout: 20000 });
    await row.locator('[col-id="action"] button').click();
    await this.page.locator('.menu-item').filter({ hasText: /^\s*Edit\s*$/ }).first().click();
    await expect(this.nameInput).toBeVisible({ timeout: 20000 });
  }

  // ---------------------------------------------------------------------------
  // List (Assigned With Offices reflects here, F_0046 / F_0050)
  // ---------------------------------------------------------------------------

  async regionCell(officeName: string): Promise<string> {
    const row = this.dataRows.filter({ hasText: officeName }).first();
    return (await row.locator('[col-id="region"]').innerText().catch(() => '')).trim();
  }
}
