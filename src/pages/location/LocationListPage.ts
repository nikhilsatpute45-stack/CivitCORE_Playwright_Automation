/**
 * Location List (hierarchy) - landing screen of Location Management (features: location_management_initiation /
 * location_search_view / location_permissions / location_ui).
 *
 * Location tab of Masters Management > Organization Configuration (the tab strip also has Department,
 * Designation, Location Category, Office Category, Office, Position, Industrial Area). Confirmed live:
 *  - treegrid columns: Location Name (col-id "ag-Grid-AutoColumn"), Loc Code (col-id "code"), Category
 *    (col-id "locCategoryName"), Hierarchy (col-id "addLocation"), Actions (col-id "action").
 *  - floating filters: "Location Name Filter Input", "Loc Code Filter Input", "Category Filter Input".
 *  - row menu (.menu-item): Edit, Delete only - no separate View action.
 *  - ~2,700 real Locations exist live; there is no 12-record baseline (see location.data.ts).
 */
import type { Locator, Page } from '@playwright/test';
import { escapeRegExp, expect } from '../../utils/assertions';
import type { MastersManagementPage } from '../department_pages/MastersManagementPage';
import type { LocationApi } from './LocationApi';

export type RowAction = 'Edit' | 'Delete';
export type FilterColumn = 'Location Name' | 'Loc Code' | 'Category';

export interface GridRow {
  rowIndex: number;
  name: string;
  code: string;
  category: string;
  level: number;
  isGroup: boolean;
}

export interface PagingSummary {
  from: number;
  to: number;
  total: number;
  page: number;
  pages: number;
}

export function exactText(text: string): RegExp {
  return new RegExp(`^\\s*${escapeRegExp(text.trim())}\\s*$`, 'i');
}

export class LocationListPage {
  readonly organizationConfigurationIcon: Locator;
  readonly locationTab: Locator;
  readonly organizationPlaceholder: Locator;

  readonly grid: Locator;
  readonly dataRows: Locator;
  readonly addButton: Locator;
  readonly nameFilter: Locator;
  readonly codeFilter: Locator;
  readonly categoryFilter: Locator;
  readonly pagingPanel: Locator;
  readonly nextPageButton: Locator;
  readonly noRowsOverlay: Locator;
  readonly rowMenuItems: Locator;
  readonly dialog: Locator;

  constructor(
    private readonly page: Page,
    private readonly organization: MastersManagementPage,
    readonly api: LocationApi,
  ) {
    this.organizationConfigurationIcon = page.getByTestId('BusinessOutlinedIcon');
    this.locationTab = page.locator('.task-tab-base').filter({ hasText: /^\s*Location\s*$/ });
    this.organizationPlaceholder = page.getByText('Select Organization Name');

    this.grid = page.getByRole('treegrid').filter({ has: page.getByRole('columnheader', { name: 'Loc Code' }) });
    this.dataRows = this.grid.locator('.ag-center-cols-container [role="row"]');
    this.addButton = page.getByRole('button', { name: 'Add Location', exact: true });
    this.nameFilter = page.getByRole('textbox', { name: 'Location Name Filter Input' });
    this.codeFilter = page.getByRole('textbox', { name: 'Loc Code Filter Input' });
    this.categoryFilter = page.getByRole('textbox', { name: 'Category Filter Input' });
    this.pagingPanel = page.locator('.ag-paging-panel');
    this.nextPageButton = page.getByRole('button', { name: 'Next Page' });
    this.noRowsOverlay = page.getByText('No Rows To Show');
    this.rowMenuItems = page.locator('.menu-item').filter({ hasText: /\S/ });
    this.dialog = page.getByRole('dialog');
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /**
   * Opens the Location tab for `organizationName` from the portal landing page or anywhere in the Admin Portal.
   *
   * Right after login the portal's module-selection page ("Where would you like to go today?") renders its
   * module cards asynchronously, so an immediate (non-waiting) visibility check for "Masters Management" can
   * false-negative while the page is still loading, making this method assume it is already past that step and
   * then time out waiting for the Admin Portal icon that a click would have revealed. Waiting for whichever of
   * the three possible landing states actually shows up first avoids that race.
   */
  async open(organizationName: string): Promise<void> {
    await expect(this.organization.mastersManagementLink.or(this.locationTab).or(this.organizationConfigurationIcon)).toBeVisible({
      timeout: 30000,
    });
    if (await this.organization.mastersManagementLink.isVisible().catch(() => false)) {
      await this.organization.openMastersManagement();
      await this.organization.expectAdminPortalLoaded();
    }
    if (!(await this.locationTab.isVisible().catch(() => false))) {
      await expect(this.organizationConfigurationIcon).toBeVisible({ timeout: 30000 });
      await this.organizationConfigurationIcon.click();
    }
    await this.locationTab.click();
    await expect(this.organizationPlaceholder.or(this.dataRows.first())).toBeVisible({ timeout: 30000 });
    if (await this.organizationPlaceholder.isVisible()) {
      await this.organization.selectOrganization(organizationName);
    }
    await this.expectListVisible();
  }

  /** Reloads the tab so the grid and the Parent Location lookup show records created through the API. */
  async refresh(organizationName: string): Promise<void> {
    await this.page.reload();
    await this.open(organizationName);
  }

  async expectListVisible(): Promise<void> {
    await expect(this.grid).toBeVisible({ timeout: 30000 });
    await expect(this.pagingPanel).toBeVisible({ timeout: 30000 });
    await this.api.expectMasterLoaded();
  }

  async isListVisible(): Promise<boolean> {
    return (await this.grid.isVisible().catch(() => false)) && !(await this.dialog.isVisible().catch(() => false));
  }

  async isModuleAvailable(): Promise<boolean> {
    return this.locationTab.isVisible().catch(() => false);
  }

  // ---------------------------------------------------------------------------
  // Rows and columns
  // ---------------------------------------------------------------------------

  nameCell(row: Locator): Locator {
    return row.locator('[col-id="ag-Grid-AutoColumn"]');
  }

  codeCell(row: Locator): Locator {
    return row.locator('[col-id="code"]');
  }

  categoryCell(row: Locator): Locator {
    return row.locator('[col-id="locCategoryName"]');
  }

  /** Data row whose Location Name is exactly `name` (case-insensitive). */
  row(name: string): Locator {
    const nameValue = this.page.locator('[col-id="ag-Grid-AutoColumn"] .ag-group-value', { hasText: exactText(name) });
    return this.dataRows.filter({ has: nameValue }).first();
  }

  columnHeader(name: string): Locator {
    return this.grid.getByRole('columnheader', { name, exact: true });
  }

  /** Visible data rows in on-screen order (AG Grid positions rows absolutely, so DOM order is not reliable). */
  async gridRows(): Promise<GridRow[]> {
    const rows = await this.dataRows.evaluateAll((elements) =>
      elements.map((element) => {
        const text = (selector: string) => (element.querySelector(selector)?.textContent ?? '').trim();
        const level = /ag-row-level-(\d+)/.exec(element.className);
        return {
          rowIndex: Number(element.getAttribute('row-index') ?? '0'),
          name: text('[col-id="ag-Grid-AutoColumn"] .ag-group-value') || text('[col-id="ag-Grid-AutoColumn"]'),
          code: text('[col-id="code"]'),
          category: text('[col-id="locCategoryName"]'),
          level: level ? Number(level[1]) : 0,
          isGroup: element.classList.contains('ag-row-group'),
        };
      }),
    );
    return rows.filter((row) => row.name !== '').sort((a, b) => a.rowIndex - b.rowIndex);
  }

  /** Expands every collapsed tree node currently rendered (repeats because expanding renders more nodes). */
  async expandAll(): Promise<void> {
    const collapsed = this.grid.locator('.ag-group-contracted:not(.ag-hidden)');
    for (let pass = 0; pass < 12 && (await collapsed.count()) > 0; pass++) {
      await collapsed.first().click();
      await this.page.waitForTimeout(150);
    }
  }

  /** Name of the row's parent as the grid draws it: the nearest row above with one level less. */
  async parentOnScreen(name: string): Promise<string | null> {
    const rows = await this.gridRows();
    const index = rows.findIndex((row) => row.name.toLowerCase() === name.trim().toLowerCase());
    if (index < 0) throw new Error(`"${name}" is not displayed in the Location grid.`);
    if (rows[index].level === 0) return null;
    for (let i = index - 1; i >= 0; i--) if (rows[i].level < rows[index].level) return rows[i].name;
    return null;
  }

  // ---------------------------------------------------------------------------
  // Search (floating column filters)
  // ---------------------------------------------------------------------------

  private filterLocator(column: FilterColumn): Locator {
    if (column === 'Loc Code') return this.codeFilter;
    if (column === 'Category') return this.categoryFilter;
    return this.nameFilter;
  }

  /**
   * Types into a floating column filter and waits until the grid shows the filtered result: either no rows,
   * or only rows that match (plus their tree ancestors / descendants).
   */
  async filterBy(column: FilterColumn, text: string): Promise<void> {
    const filter = this.filterLocator(column);
    await expect(filter).toBeVisible({ timeout: 20000 });
    await filter.fill(text);
    const needle = text.trim().toLowerCase();
    if (needle === '') {
      await expect(this.dataRows.first().or(this.noRowsOverlay.first())).toBeVisible({ timeout: 20000 });
      return;
    }
    await expect
      .poll(
        async () => {
          const rows = await this.gridRows();
          const matches = (row: GridRow) => {
            const field = column === 'Loc Code' ? row.code : column === 'Category' ? row.category : row.name;
            return field.toLowerCase().includes(needle);
          };
          return rows.length === 0 || (rows.some(matches) && rows.every((row) => matches(row) || row.isGroup || row.level > 0));
        },
        { timeout: 20000, message: `grid filtered by ${column} "${text}"` },
      )
      .toBe(true);
  }

  async clearFilters(): Promise<void> {
    for (const filter of [this.nameFilter, this.codeFilter, this.categoryFilter]) {
      if ((await filter.inputValue().catch(() => '')) !== '') await filter.fill('');
    }
    await expect(this.dataRows.first().or(this.noRowsOverlay.first())).toBeVisible({ timeout: 20000 });
  }

  /** Filters by name and confirms the row has been rendered. */
  async showRow(name: string): Promise<Locator> {
    await this.clearFilters();
    await this.filterBy('Location Name', name);
    const row = this.row(name);
    await expect(row, `Location "${name}" is listed`).toBeVisible({ timeout: 20000 });
    return row;
  }

  /** Filters by name and confirms no row is rendered, re-checking so a transient re-render cannot pass. */
  async expectAbsent(name: string): Promise<void> {
    await this.clearFilters();
    await this.filterBy('Location Name', name);
    await expect(this.row(name), `Location "${name}" is not listed`).toHaveCount(0, { timeout: 20000 });
    await this.nameFilter.fill('');
    await this.filterBy('Location Name', name);
    await expect(this.row(name)).toHaveCount(0);
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
  // Pagination
  // ---------------------------------------------------------------------------

  async pagingSummary(): Promise<PagingSummary> {
    const text = (await this.pagingPanel.innerText()).replace(/,/g, '').replace(/\s+/g, ' ');
    const range = /(\d+)\s+to\s+(\d+)\s+of\s+(\d+)/i.exec(text);
    const pages = /Page\s+(\d+)\s+of\s+(\d+)/i.exec(text);
    if (!range || !pages) throw new Error(`Could not read the pagination summary from "${text}".`);
    return { from: Number(range[1]), to: Number(range[2]), total: Number(range[3]), page: Number(pages[1]), pages: Number(pages[2]) };
  }

  async goToNextPage(): Promise<void> {
    const before = (await this.pagingSummary()).page;
    await this.nextPageButton.click();
    await expect.poll(async () => (await this.pagingSummary()).page, { timeout: 15000 }).toBe(before + 1);
  }

  async pageSize(): Promise<number> {
    const text = (await this.pagingPanel.innerText()).replace(/\s+/g, ' ');
    const shown = /Page Size:\s*(\d+)/i.exec(text);
    return shown ? Number(shown[1]) : 0;
  }

  async useLargestPageSize(): Promise<void> {
    const picker = this.page.getByRole('combobox', { name: 'Page Size' });
    if ((await picker.count()) === 0) return;
    await picker.click();
    const options = this.page.getByRole('option');
    const sizes = (await options.allInnerTexts()).map((text) => Number(text.trim())).filter((size) => size > 0);
    if (sizes.length === 0) {
      await this.page.keyboard.press('Escape');
      return;
    }
    const largest = Math.max(...sizes);
    await options.filter({ hasText: exactText(String(largest)) }).first().click();
    await expect.poll(() => this.pageSize(), { timeout: 10000 }).toBe(largest);
  }

  // ---------------------------------------------------------------------------
  // Row action menu (Edit / Delete)
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
