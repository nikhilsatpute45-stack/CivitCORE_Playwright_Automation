/**
 * Audit Trail listing screen: navigation, the Audit Log grid and its read-only behaviour (FRD 6.1, 6.2 BR-6, 6.3).
 *
 * TODO(locator): confirm against live UI. The FRD does not state the menu path, the date format or the grid technology, so the menu
 * entry, grid and cell locators are guesses, all declared in the "Locators" block, and `parseLogDateTime` accepts the likely formats.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { AUDIT_COLUMNS, NO_RECORDS_PATTERN, makeDate, type AuditColumn } from '../../test-data/audit-trail.data';

export interface AuditRow {
  slNo: string;
  functionName: string;
  logDateTime: string;
  className: string;
  clientIp: string;
  message: string;
}

export interface LogStamp {
  /** UTC-midnight date part. */
  date: Date;
  hours: number;
  minutes: number;
  seconds: number;
}

const MONTH_NAMES = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];

/** Reads "16-Nov-2026 09:30[:00]", "16/11/2026 09:30", "2026-11-16 09:30" or "16 Nov 2026 9:30 AM"; undefined when no date + time is found. */
export function parseLogDateTime(text: string): LogStamp | undefined {
  const time = /(\d{1,2}):(\d{2})(?::(\d{2}))?\s*(AM|PM)?/i.exec(text);
  if (!time) return undefined;
  let hours = Number(time[1]);
  if (time[4]) hours = (hours % 12) + (time[4].toUpperCase() === 'PM' ? 12 : 0);

  let date: Date | undefined;
  const named = /(\d{1,2})[-\s/]([A-Za-z]{3})[A-Za-z]*[-\s/,]+(\d{4})/.exec(text);
  const numeric = /(\d{1,2})[-/](\d{1,2})[-/](\d{4})/.exec(text);
  const iso = /(\d{4})-(\d{2})-(\d{2})/.exec(text);
  if (named) {
    const month = MONTH_NAMES.indexOf(named[2].toLowerCase());
    if (month >= 0) date = makeDate(Number(named[1]), ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month], Number(named[3]));
  } else if (iso) {
    date = new Date(Date.UTC(Number(iso[1]), Number(iso[2]) - 1, Number(iso[3])));
  } else if (numeric) {
    date = new Date(Date.UTC(Number(numeric[3]), Number(numeric[2]) - 1, Number(numeric[1])));
  }
  return date ? { date, hours, minutes: Number(time[2]), seconds: Number(time[3] ?? 0) } : undefined;
}

export class AuditTrailListPage {
  // ---------------------------------------------------------------------------
  // Locators
  // ---------------------------------------------------------------------------

  /** TODO(locator): confirm against live UI - the "Audit Trail" menu entry (FRD does not state the menu path). */
  get menuEntry(): Locator {
    return this.page
      .getByRole('link', { name: /^\s*Audit Trail\s*$/i })
      .or(this.page.getByRole('menuitem', { name: /^\s*Audit Trail\s*$/i }))
      .or(this.page.getByRole('tab', { name: /^\s*Audit Trail\s*$/i }))
      .first();
  }

  /** TODO(locator): confirm against live UI. */
  get heading(): Locator {
    return this.page.getByRole('heading', { name: /Audit Trail/i }).first();
  }

  /** TODO(locator): confirm against live UI - the Audit Log grid. */
  get grid(): Locator {
    return this.page.getByRole('grid').or(this.page.getByRole('table')).first();
  }

  private get headerCells(): Locator {
    return this.grid.getByRole('columnheader');
  }

  /** Body rows (rows that own data cells). */
  private get bodyRows(): Locator {
    return this.grid.getByRole('row').filter({ has: this.page.getByRole('gridcell').or(this.page.getByRole('cell')) });
  }

  private get noRecords(): Locator {
    return this.page.getByText(NO_RECORDS_PATTERN).first();
  }

  constructor(private readonly page: Page) {}

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  async isMenuEntryVisible(): Promise<boolean> {
    return this.menuEntry.isVisible().catch(() => false);
  }

  /** Opens the screen from the menu, or from `directUrl` when one is configured. */
  async open(directUrl?: string): Promise<void> {
    if (directUrl) {
      await this.page.goto(directUrl);
    } else {
      await this.menuEntry.click();
    }
    await this.expectLoaded();
  }

  async openUrl(url: string): Promise<void> {
    await this.page.goto(url);
  }

  async expectLoaded(): Promise<void> {
    await expect(this.heading.or(this.grid), 'the Audit Trail screen').toBeVisible({ timeout: 30000 });
  }

  /** True when the listing (heading or grid) is on screen. */
  async isScreenDisplayed(timeoutMs = 5000): Promise<boolean> {
    return this.heading
      .or(this.grid)
      .first()
      .waitFor({ state: 'visible', timeout: timeoutMs })
      .then(() => true)
      .catch(() => false);
  }

  /** Waits for the grid to settle on rows or on the "No records found" state. */
  async waitForListing(): Promise<void> {
    await expect
      .poll(async () => (await this.bodyRows.count()) > 0 || (await this.noRecords.isVisible().catch(() => false)), {
        timeout: 30000,
        message: 'the Audit Log grid shows rows or the "No records found" state',
      })
      .toBe(true);
  }

  // ---------------------------------------------------------------------------
  // Grid content
  // ---------------------------------------------------------------------------

  async columnNames(): Promise<string[]> {
    return (await this.headerCells.allInnerTexts()).map((text) => text.replace(/\s+/g, ' ').trim()).filter(Boolean);
  }

  async rowCount(): Promise<number> {
    return this.bodyRows.count();
  }

  async isNoRecordsShown(): Promise<boolean> {
    return this.noRecords.isVisible().catch(() => false);
  }

  /** Every displayed row, cells mapped by column header (FRD order is the fallback). */
  async rows(): Promise<AuditRow[]> {
    const headers = await this.columnNames();
    const indexOf = (column: AuditColumn): number => {
      const found = headers.findIndex((name) => name.toLowerCase().replace(/[^a-z]/g, '') === column.toLowerCase().replace(/[^a-z]/g, ''));
      return found >= 0 ? found : AUDIT_COLUMNS.indexOf(column);
    };
    const count = await this.bodyRows.count();
    const result: AuditRow[] = [];
    for (let position = 0; position < count; position += 1) {
      const cells = (await this.bodyRows.nth(position).getByRole('gridcell').or(this.bodyRows.nth(position).getByRole('cell')).allInnerTexts()).map((text) =>
        text.replace(/\s+/g, ' ').trim(),
      );
      const at = (column: AuditColumn): string => cells[indexOf(column)] ?? '';
      result.push({
        slNo: at('Sl No.'),
        functionName: at('Function Name'),
        logDateTime: at('Log Date & Time'),
        className: at('Class Name'),
        clientIp: at('Client IP'),
        message: at('Message'),
      });
    }
    return result;
  }

  // ---------------------------------------------------------------------------
  // Read-only behaviour (FRD 6.2 BR-6)
  // ---------------------------------------------------------------------------

  /** The cell of `column` in body row `rowIndex` (0-based). */
  async cell(rowIndex: number, column: AuditColumn): Promise<Locator> {
    const headers = await this.columnNames();
    const index = Math.max(
      headers.findIndex((name) => name.toLowerCase().replace(/[^a-z]/g, '') === column.toLowerCase().replace(/[^a-z]/g, '')),
      0,
    );
    const row = this.bodyRows.nth(rowIndex);
    return row.getByRole('gridcell').or(row.getByRole('cell')).nth(index);
  }

  /** Double-clicks the cell and reports whether an input / editor appeared in it. */
  async editorOpensOnDoubleClick(rowIndex: number, column: AuditColumn): Promise<boolean> {
    const cell = await this.cell(rowIndex, column);
    await cell.dblclick();
    return (await cell.locator('input, textarea, select, [contenteditable="true"]').count()) > 0;
  }

  /** Types into the focused cell like a user would and reports whether an editor took the text. */
  async acceptsTypingIn(rowIndex: number, column: AuditColumn, text: string): Promise<boolean> {
    const cell = await this.cell(rowIndex, column);
    await cell.click();
    await this.page.keyboard.type(text);
    return (await cell.locator('input, textarea, select, [contenteditable="true"]').count()) > 0;
  }

  /** True when the grid offers any edit / delete / actions control (an Actions column, row buttons, a context menu). */
  async hasRowActions(): Promise<boolean> {
    if ((await this.columnNames()).some((name) => /action/i.test(name))) return true;
    if ((await this.bodyRows.count()) === 0) return false;
    const first = this.bodyRows.first();
    await first.hover();
    if ((await first.locator('button, [role="button"], [role="menuitem"], a[href], svg[class*="edit" i], svg[class*="delete" i]').count()) > 0) return true;
    await first.click({ button: 'right' });
    const menuShown = await this.page.getByRole('menu').isVisible().catch(() => false);
    await this.page.keyboard.press('Escape');
    return menuShown;
  }
}
