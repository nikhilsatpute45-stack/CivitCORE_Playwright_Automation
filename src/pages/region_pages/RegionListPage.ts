/**
 * Region List - landing screen of Region Management (features: region_initiation / region_search_view /
 * region_ui.feature).
 *
 * TODO: Verify locator once the Region module is developed. The Region module does not exist yet in the live
 * build (Organization Configuration currently offers Department, Designation, Location Category, Location,
 * Office Category, Office, Position, Industrial Area tabs - no "Region" tab). Every locator below is a
 * placeholder guessed from the sibling masters' conventions (see LocationCategoryListPage / LocationListPage):
 *  - the module would be reached via the Masters Management > Organization Configuration icon, as a tab;
 *  - the FRD's "System Configuration > Region" menu path is translated the same way location.data.ts /
 *    location-category.data.ts already translate their own FRD menu paths (NO_REGION_MENU_PATH, logged, not asserted);
 *  - AG Grid cells are addressed by a guessed col-id, the row action menu by the shared `.menu-item` markup.
 */
import type { Locator, Page } from '@playwright/test';
import { escapeRegExp, expect } from '../../utils/assertions';
import type { MastersManagementPage } from '../department_pages/MastersManagementPage';
import type { RegionApi } from './RegionApi';

export type RowAction = 'View' | 'Edit' | 'Delete';

export interface GridRow {
  rowIndex: number;
  regionId: string;
  name: string;
  assignedOffices: string;
  createdBy: string;
  createdDate: string;
}

export function exactText(text: string): RegExp {
  return new RegExp(`^\\s*${escapeRegExp(text.trim())}\\s*$`, 'i');
}

/** FRD column order (region_ui.feature TC-REG-087). */
export const REGION_COLUMN_ORDER = ['Region ID', 'Region Name', 'Assigned With Offices', 'Created By', 'Created Date', 'Actions'] as const;

export class RegionListPage {
  readonly organizationConfigurationIcon: Locator;
  readonly regionTab: Locator;
  readonly organizationPlaceholder: Locator;

  readonly grid: Locator;
  readonly dataRows: Locator;
  readonly addButton: Locator;
  readonly nameFilter: Locator;
  readonly pagingPanel: Locator;
  readonly noRowsOverlay: Locator;
  readonly rowMenuItems: Locator;
  /** Any open dialog (Add / Edit form, delete confirmation); the list is not "visible" behind one. */
  readonly dialog: Locator;

  constructor(
    private readonly page: Page,
    private readonly organization: MastersManagementPage,
    readonly api: RegionApi,
  ) {
    // TODO: Verify locator once the Region module is developed.
    this.organizationConfigurationIcon = page.getByTestId('BusinessOutlinedIcon');
    this.regionTab = page.locator('.task-tab-base').filter({ hasText: /^\s*Region\s*$/ });
    this.organizationPlaceholder = page.getByText('Select Organization Name');

    this.grid = page.getByRole('treegrid').filter({ has: page.getByRole('columnheader', { name: 'Region ID' }) });
    this.dataRows = this.grid.locator('.ag-center-cols-container [role="row"]');
    this.addButton = page.getByRole('button', { name: 'Add', exact: true });
    this.nameFilter = page.getByRole('textbox', { name: /Region.*Filter Input|Search/i });
    this.pagingPanel = page.locator('.ag-paging-panel');
    this.noRowsOverlay = page.getByText('No Rows To Show');
    this.rowMenuItems = page.locator('.menu-item').filter({ hasText: /\S/ });
    this.dialog = page.getByRole('dialog');
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /** Opens the Region tab for `organizationName` from the portal landing page or anywhere in the Admin Portal. */
  async open(organizationName: string): Promise<void> {
    if (await this.organization.mastersManagementLink.isVisible().catch(() => false)) {
      await this.organization.openMastersManagement();
      await this.organization.expectAdminPortalLoaded();
    }
    if (!(await this.regionTab.isVisible().catch(() => false))) {
      await expect(this.organizationConfigurationIcon).toBeVisible({ timeout: 30000 });
      await this.organizationConfigurationIcon.click();
    }
    await this.regionTab.click();
    await expect(this.organizationPlaceholder.or(this.dataRows.first())).toBeVisible({ timeout: 30000 });
    if (await this.organizationPlaceholder.isVisible()) {
      await this.organization.selectOrganization(organizationName);
    }
    await this.expectListVisible();
  }

  /** Reloads the tab so the grid and the lookups elsewhere (Office / Location Add forms) show new records. */
  async refresh(organizationName: string): Promise<void> {
    await this.page.reload();
    await this.open(organizationName);
  }

  async expectListVisible(): Promise<void> {
    await expect(this.grid).toBeVisible({ timeout: 30000 });
    await expect(this.dataRows.first()).toBeVisible({ timeout: 30000 });
    await this.api.expectMasterLoaded();
  }

  async isListVisible(): Promise<boolean> {
    return (await this.grid.isVisible().catch(() => false)) && !(await this.dialog.isVisible().catch(() => false));
  }

  async isModuleAvailable(): Promise<boolean> {
    return this.regionTab.isVisible().catch(() => false);
  }

  // ---------------------------------------------------------------------------
  // Rows and columns
  // ---------------------------------------------------------------------------

  idCell(row: Locator): Locator {
    return row.locator('[col-id="regionId"]');
  }

  nameCell(row: Locator): Locator {
    return row.locator('[col-id="regionName"]');
  }

  assignedOfficesCell(row: Locator): Locator {
    return row.locator('[col-id="assignedOffices"]');
  }

  createdByCell(row: Locator): Locator {
    return row.locator('[col-id="createdBy"]');
  }

  createdDateCell(row: Locator): Locator {
    return row.locator('[col-id="createdDate"]');
  }

  /** Data row whose Region Name is exactly `name` (case-insensitive). */
  row(name: string): Locator {
    return this.dataRows.filter({ has: this.page.locator('[col-id="regionName"]', { hasText: exactText(name) }) }).first();
  }

  columnHeader(name: string): Locator {
    return this.grid.getByRole('columnheader', { name, exact: true });
  }

  /** Column headers left to right, for the region_ui.feature column-order scenario. */
  async columnHeaders(): Promise<string[]> {
    return (await this.grid.getByRole('columnheader').allInnerTexts()).map((text) => text.trim()).filter(Boolean);
  }

  async gridRows(): Promise<GridRow[]> {
    const rows = await this.dataRows.evaluateAll((elements) =>
      elements.map((element) => {
        const text = (selector: string) => (element.querySelector(selector)?.textContent ?? '').trim();
        return {
          rowIndex: Number(element.getAttribute('row-index') ?? '0'),
          regionId: text('[col-id="regionId"]'),
          name: text('[col-id="regionName"]'),
          assignedOffices: text('[col-id="assignedOffices"]'),
          createdBy: text('[col-id="createdBy"]'),
          createdDate: text('[col-id="createdDate"]'),
        };
      }),
    );
    return rows.filter((row) => row.name !== '').sort((a, b) => a.rowIndex - b.rowIndex);
  }

  // ---------------------------------------------------------------------------
  // Search
  // ---------------------------------------------------------------------------

  async search(text: string): Promise<void> {
    await expect(this.nameFilter).toBeVisible({ timeout: 20000 });
    await this.nameFilter.fill(text);
    const needle = text.trim().toLowerCase();
    if (needle === '') {
      await expect(this.dataRows.first()).toBeVisible({ timeout: 20000 });
      return;
    }
    await expect
      .poll(
        async () => {
          const rows = await this.gridRows();
          return rows.length === 0 || rows.every((row) => row.name.toLowerCase().includes(needle));
        },
        { timeout: 20000, message: `grid filtered by Region Name "${text}"` },
      )
      .toBe(true);
  }

  async clearSearch(): Promise<void> {
    if ((await this.nameFilter.inputValue().catch(() => '')) !== '') await this.nameFilter.fill('');
    await expect(this.dataRows.first()).toBeVisible({ timeout: 20000 });
  }

  /** Filters by name and confirms the row has been rendered. */
  async showRow(name: string): Promise<Locator> {
    await this.clearSearch();
    await this.search(name);
    const row = this.row(name);
    await expect(row, `Region "${name}" is listed`).toBeVisible({ timeout: 20000 });
    return row;
  }

  /** Filters by name and confirms no row is rendered. */
  async expectAbsent(name: string): Promise<void> {
    await this.clearSearch();
    await this.search(name);
    await expect(this.row(name), `Region "${name}" is not listed`).toHaveCount(0, { timeout: 20000 });
  }

  async expectEmptyState(): Promise<void> {
    await expect(this.dataRows).toHaveCount(0, { timeout: 15000 });
    await expect(this.noRowsOverlay.first().or(this.pagingPanel.getByText(/0\s+to\s+0\s+of\s+0/)).first()).toBeVisible();
  }

  async expectUsable(): Promise<void> {
    await expect(this.grid).toBeVisible();
    await expect(this.nameFilter).toBeEditable();
  }

  // ---------------------------------------------------------------------------
  // Row action menu (View / Edit / Delete)
  // ---------------------------------------------------------------------------

  async openRowMenu(name: string): Promise<void> {
    const row = await this.showRow(name);
    await row.locator('[col-id="action"] button').click();
    await expect(this.rowMenuItems.first()).toBeVisible({ timeout: 10000 });
  }

  async rowMenuLabels(): Promise<string[]> {
    return (await this.rowMenuItems.allInnerTexts()).map((label) => label.trim()).filter(Boolean);
  }

  rowMenuItem(action: RowAction): Locator {
    return this.rowMenuItems.filter({ hasText: exactText(action) }).first();
  }

  async hasRowAction(action: string): Promise<boolean> {
    return (await this.rowMenuItems.filter({ hasText: exactText(action) }).count()) > 0;
  }

  async chooseRowAction(name: string, action: RowAction): Promise<void> {
    await this.openRowMenu(name);
    const item = this.rowMenuItem(action);
    if ((await item.count()) === 0) {
      const available = await this.rowMenuLabels();
      await this.page.keyboard.press('Escape');
      throw new Error(`The row action menu of "${name}" offers [${available.join(', ')}]; it has no "${action}" action.`);
    }
    await item.click();
  }

  async closeRowMenu(): Promise<void> {
    if (await this.rowMenuItems.first().isVisible().catch(() => false)) await this.page.keyboard.press('Escape');
  }
}
