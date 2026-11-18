/**
 * Miscellaneous Master Title List (CivitINFRA > Admin > Configuration > Miscellaneous Master): navigation, grid, column search,
 * Display filter, Display checkbox, pagination and the kebab (row action) menu.
 *
 * TODO(verify-locator): the screen has not been inspected. Every locator is an accessibility-first guess built from the labels
 * the FRD uses; adjust them here, once, when the app is inspected.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { NO_RECORDS_PATTERN } from '../../test-data/miscellaneous-master.data';

export interface MmGridRow {
  slNo: string;
  enumId: string;
  title: string;
  parentTitle: string;
  /** 'Checked' | 'Unchecked' as the Display checkbox of the row shows. */
  display: 'Checked' | 'Unchecked';
}

export type PageControl = 'First' | 'Previous' | 'Next' | 'Last';
export type SearchColumn = 'Title' | 'Enum ID' | 'Parent Title';

export const exact = (text: string): RegExp => new RegExp(`^\\s*${text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}\\s*$`, 'i');

export class MiscellaneousMasterListPage {
  readonly navAdmin: Locator;
  readonly navConfiguration: Locator;
  readonly navMiscellaneousMaster: Locator;
  readonly addButton: Locator;
  readonly gridRows: Locator;
  readonly emptyState: Locator;
  readonly noRecords: Locator;
  readonly titleSearch: Locator;
  readonly enumIdSearch: Locator;
  readonly parentTitleSearch: Locator;
  readonly displayFilter: Locator;
  readonly pageIndicator: Locator;
  readonly menuItems: Locator;

  constructor(private readonly page: Page) {
    // TODO(verify-locator)
    this.navAdmin = page.getByRole('treeitem', { name: exact('Admin') }).or(page.getByText(exact('Admin'))).first();
    this.navConfiguration = page.getByRole('treeitem', { name: exact('Configuration') }).or(page.getByText(exact('Configuration'))).first();
    this.navMiscellaneousMaster = page
      .getByRole('treeitem', { name: exact('Miscellaneous Master') })
      .or(page.getByRole('link', { name: exact('Miscellaneous Master') }))
      .or(page.getByText(exact('Miscellaneous Master')))
      .first();
    this.addButton = page.getByRole('button', { name: exact('Add') }).first();
    this.gridRows = page.getByRole('row').filter({ has: page.getByRole('cell') });
    this.emptyState = page.getByText(/no\s+titles?\b/i).first();
    this.noRecords = page.getByText(NO_RECORDS_PATTERN).first();
    this.titleSearch = page.getByRole('textbox', { name: /^\s*title/i }).first();
    this.enumIdSearch = page.getByRole('textbox', { name: /enum\s*id/i }).first();
    this.parentTitleSearch = page.getByRole('textbox', { name: /parent\s*title/i }).first();
    this.displayFilter = page.getByRole('combobox', { name: /display/i }).first();
    this.pageIndicator = page.getByText(/^\s*\d+\s*\/\s*\d+\s*$/).first();
    this.menuItems = page.getByRole('menuitem');
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  async expandAdmin(): Promise<void> {
    await this.navAdmin.click();
  }

  async expandConfiguration(): Promise<void> {
    await this.navConfiguration.click();
  }

  async clickMiscellaneousMaster(): Promise<void> {
    await this.navMiscellaneousMaster.click();
  }

  /** True when "Miscellaneous Master" can be reached from the navigation tree (or the list is already shown). */
  async isModuleAvailable(): Promise<boolean> {
    if (await this.isListVisible()) return true;
    if (!(await this.navAdmin.isVisible().catch(() => false))) return false;
    await this.expandAdmin();
    if (await this.navConfiguration.isVisible().catch(() => false)) await this.expandConfiguration();
    return this.navMiscellaneousMaster.isVisible().catch(() => false);
  }

  async open(): Promise<void> {
    if (await this.isListVisible()) return;
    if (!(await this.navMiscellaneousMaster.isVisible().catch(() => false))) {
      await this.expandAdmin();
      await this.expandConfiguration();
    }
    await this.clickMiscellaneousMaster();
    await this.expectListVisible();
  }

  async isListVisible(): Promise<boolean> {
    return (await this.gridRows.first().isVisible().catch(() => false)) || (await this.emptyState.isVisible().catch(() => false));
  }

  async expectListVisible(): Promise<void> {
    await expect.poll(async () => this.isListVisible(), { timeout: 20000, message: 'the Title List (or its empty state) is shown' }).toBe(true);
  }

  async isNavEntryVisible(): Promise<boolean> {
    return this.navMiscellaneousMaster.isVisible().catch(() => false);
  }

  async openUrl(url: string): Promise<void> {
    await this.page.goto(url, { waitUntil: 'domcontentloaded' });
  }

  async refresh(): Promise<void> {
    await this.page.reload({ waitUntil: 'domcontentloaded' });
    await this.expectListVisible();
  }

  // ---------------------------------------------------------------------------
  // Grid
  // ---------------------------------------------------------------------------

  async rows(): Promise<MmGridRow[]> {
    const raw = await this.gridRows.evaluateAll((rows) =>
      rows.map((row) => {
        const cells = Array.from(row.querySelectorAll('[role="cell"], td'));
        const box = cells[4]?.querySelector('input[type="checkbox"], [role="checkbox"]') as HTMLInputElement | null;
        const checked = box ? (box.checked ?? box.getAttribute('aria-checked') === 'true') : /^(yes|checked|true)$/i.test((cells[4]?.textContent ?? '').trim());
        return { cells: cells.map((cell) => (cell.textContent ?? '').trim()), checked };
      }),
    );
    return raw.map(({ cells, checked }) => ({
      slNo: cells[0] ?? '',
      enumId: cells[1] ?? '',
      title: cells[2] ?? '',
      parentTitle: cells[3] ?? '',
      display: checked ? 'Checked' : 'Unchecked',
    }));
  }

  async rowCount(): Promise<number> {
    return this.gridRows.count();
  }

  async titles(): Promise<string[]> {
    return (await this.rows()).map((row) => row.title);
  }

  rowByTitle(title: string): Locator {
    return this.gridRows.filter({ has: this.page.getByRole('cell', { name: exact(title) }) }).first();
  }

  async rowOf(title: string): Promise<MmGridRow | undefined> {
    return (await this.rows()).find((row) => row.title === title);
  }

  async isEmptyStateShown(): Promise<boolean> {
    return (await this.rowCount()) === 0 && (await this.emptyState.isVisible().catch(() => false));
  }

  async hasNoRecordsState(): Promise<boolean> {
    return this.noRecords.isVisible().catch(() => false);
  }

  async columnNames(): Promise<string[]> {
    return (await this.page.getByRole('columnheader').allInnerTexts()).map((text) => text.trim()).filter(Boolean);
  }

  async isAddVisible(): Promise<boolean> {
    return this.addButton.isVisible().catch(() => false);
  }

  async clickAdd(): Promise<void> {
    await this.addButton.click();
  }

  // ---------------------------------------------------------------------------
  // Display checkbox (saved immediately, no Save button)
  // ---------------------------------------------------------------------------

  displayCheckbox(title: string): Locator {
    return this.rowByTitle(title).getByRole('checkbox').first();
  }

  async isDisplayChecked(title: string): Promise<boolean> {
    return this.displayCheckbox(title).isChecked().catch(() => false);
  }

  async isDisplayEnabled(title: string): Promise<boolean> {
    return this.displayCheckbox(title).isEnabled().catch(() => false);
  }

  async clickDisplay(title: string, clicks = 1): Promise<void> {
    await this.displayCheckbox(title).click({ clickCount: clicks, delay: clicks > 1 ? 30 : 0 });
  }

  // ---------------------------------------------------------------------------
  // Kebab (row action) menu
  // ---------------------------------------------------------------------------

  kebab(title: string): Locator {
    return this.rowByTitle(title).getByRole('button', { name: /actions?|menu|more|⋮|kebab/i }).last();
  }

  async openKebab(title: string): Promise<void> {
    await this.kebab(title).click();
  }

  async menuOptions(): Promise<string[]> {
    return (await this.menuItems.allInnerTexts()).map((text) => text.trim()).filter(Boolean);
  }

  async selectMenuItem(name: 'View' | 'Edit' | 'Delete'): Promise<void> {
    await this.page.getByRole('menuitem', { name: exact(name) }).click();
  }

  async closeMenusByClickingOutside(): Promise<void> {
    await this.page.mouse.click(2, 2);
  }

  async openMenuCount(): Promise<number> {
    return this.menuItems.evaluateAll((items) => new Set(items.map((item) => item.closest('[role="menu"]'))).size).catch(() => 0);
  }

  /** Number of rows (of the visible page) that show a kebab icon in the Actions column. */
  async kebabCount(): Promise<number> {
    return this.gridRows.getByRole('button', { name: /actions?|menu|more|⋮|kebab/i }).count();
  }

  // ---------------------------------------------------------------------------
  // Column search and Display filter
  // ---------------------------------------------------------------------------

  private searchBox(column: SearchColumn): Locator {
    return column === 'Title' ? this.titleSearch : column === 'Enum ID' ? this.enumIdSearch : this.parentTitleSearch;
  }

  /** Types `text` into a column search box; `keystrokes` types key by key so the list filters after each one. */
  async search(column: SearchColumn, text: string, keystrokes = false): Promise<void> {
    const box = this.searchBox(column);
    await box.click();
    if (keystrokes) {
      await box.fill('');
      await this.page.keyboard.type(text);
    } else {
      await box.fill(text);
    }
  }

  async clearSearch(column: SearchColumn): Promise<void> {
    await this.searchBox(column).fill('');
  }

  async searchValue(column: SearchColumn): Promise<string> {
    return this.searchBox(column).inputValue().catch(() => '');
  }

  /** True when a search box exists outside the column headers (the FRD has none above the grid). */
  async hasSeparateSearchBox(): Promise<boolean> {
    return (await this.page.getByRole('searchbox').count()) > 0;
  }

  async hasSearchBox(column: SearchColumn): Promise<boolean> {
    return this.searchBox(column).isVisible().catch(() => false);
  }

  async selectDisplayFilter(name: 'All' | 'Checked' | 'Unchecked'): Promise<void> {
    await this.displayFilter.click();
    await this.page.getByRole('option', { name: exact(name) }).click();
  }

  async displayFilterOptions(): Promise<string[]> {
    await this.displayFilter.click();
    const options = this.page.getByRole('option');
    await expect(options.first()).toBeVisible({ timeout: 10000 });
    const texts = (await options.allInnerTexts()).map((text) => text.trim());
    await this.page.keyboard.press('Escape');
    return texts;
  }

  async displayFilterValue(): Promise<string> {
    return ((await this.displayFilter.inputValue().catch(() => '')) || (await this.displayFilter.innerText().catch(() => ''))).trim();
  }

  async displayFilterAcceptsFreeText(): Promise<boolean> {
    const role = await this.displayFilter.getAttribute('role').catch(() => null);
    return (await this.displayFilter.isEditable().catch(() => false)) && role !== 'combobox';
  }

  // ---------------------------------------------------------------------------
  // Pagination
  // ---------------------------------------------------------------------------

  private control(name: PageControl): Locator {
    return this.page.getByRole('button', { name: exact(name) }).first();
  }

  async clickControl(name: PageControl): Promise<void> {
    await this.control(name).click();
  }

  async isControlEnabled(name: PageControl): Promise<boolean> {
    return this.control(name).isEnabled().catch(() => false);
  }

  async arePaginationControlsVisible(): Promise<boolean> {
    return this.control('Next').isVisible().catch(() => false);
  }

  async goToPage(n: number): Promise<void> {
    await this.page.getByRole('button', { name: exact(String(n)) }).first().click();
  }

  async indicator(): Promise<string> {
    return ((await this.pageIndicator.innerText().catch(() => '')) || '').replace(/\s+/g, '');
  }
}
