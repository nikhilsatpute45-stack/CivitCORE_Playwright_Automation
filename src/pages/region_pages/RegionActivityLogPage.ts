/**
 * Region Activity / Audit Log (feature: region_audit_log.feature).
 *
 * TODO: Verify locator once the Region module is developed. The FRD (7.1) assumes a per-Region Activity Log
 * that an Auditor can open and that records Created / Updated / Deleted / Deletion Blocked / Assigned to
 * Office / Removed from Office entries with User, Date/Time, Region ID, Region Name and (where relevant) the
 * changed field and its previous/new value. None of this exists in the current build (no build has an Activity
 * Log entry point for any Setup master yet - see LocationCategoryActivityLogPage / LocationActivityLogPage,
 * both of which only probe for one), so this mirrors their "entry point probe" shape and additionally models
 * the richer, per-entry reading the FRD describes, entirely as placeholders.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';

const ACTIVITY_LOG_NAME = /activity\s*log|audit\s*(log|trail)/i;

export interface ActivityLogEntry {
  action: string;
  user: string;
  dateTime: string;
  regionId: string;
  regionName: string;
  fieldChanged?: string;
  previousValue?: string;
  newValue?: string;
  /** Office / Location name the entry names (e.g. the Office assigned / removed, or the blocking dependency). */
  reference?: string;
}

export class RegionActivityLogPage {
  readonly entryPoint: Locator;
  readonly panel: Locator;
  readonly entryRows: Locator;
  readonly editControls: Locator;
  readonly deleteControls: Locator;

  constructor(page: Page) {
    // TODO: Verify locator once the Region module is developed.
    this.entryPoint = page
      .getByRole('button', { name: ACTIVITY_LOG_NAME })
      .or(page.getByRole('tab', { name: ACTIVITY_LOG_NAME }))
      .or(page.getByRole('link', { name: ACTIVITY_LOG_NAME }))
      .or(page.locator('.task-tab-base, .menu-item').filter({ hasText: ACTIVITY_LOG_NAME }));
    this.panel = page.getByRole('dialog').or(page.getByRole('region', { name: ACTIVITY_LOG_NAME }));
    this.entryRows = this.panel.locator('[role="row"], .activity-log-entry');
    this.editControls = this.entryRows.getByRole('button', { name: /^Edit$/ });
    this.deleteControls = this.entryRows.getByRole('button', { name: /^Delete$/ });
  }

  async isAvailable(): Promise<boolean> {
    return (await this.entryPoint.count()) > 0;
  }

  /** Opens the log, scoped to one Region when its name is given (e.g. a per-record "History" action). */
  async open(regionName?: string): Promise<void> {
    await expect(this.entryPoint.first()).toBeVisible({ timeout: 10000 });
    await this.entryPoint.first().click();
    if (regionName) {
      const filter = this.panel.getByRole('textbox', { name: /region/i });
      if (await filter.isVisible().catch(() => false)) await filter.fill(regionName);
    }
    await expect(this.entryRows.first()).toBeVisible({ timeout: 15000 });
  }

  /** Entries as currently rendered, most recent first (per TC-REG-079). */
  async entries(): Promise<ActivityLogEntry[]> {
    return this.entryRows.evaluateAll((elements) =>
      elements.map((element) => {
        const text = (selector: string) => (element.querySelector(selector)?.textContent ?? '').trim();
        return {
          action: text('[col-id="action"], .action'),
          user: text('[col-id="user"], .user'),
          dateTime: text('[col-id="dateTime"], .date-time'),
          regionId: text('[col-id="regionId"], .region-id'),
          regionName: text('[col-id="regionName"], .region-name'),
          fieldChanged: text('[col-id="fieldChanged"], .field-changed') || undefined,
          previousValue: text('[col-id="previousValue"], .previous-value') || undefined,
          newValue: text('[col-id="newValue"], .new-value') || undefined,
          reference: text('[col-id="reference"], .reference') || undefined,
        };
      }),
    );
  }

  async hasEntry(action: string, regionName?: string): Promise<boolean> {
    const entries = await this.entries();
    return entries.some(
      (entry) => new RegExp(action, 'i').test(entry.action) && (!regionName || entry.regionName.toLowerCase().includes(regionName.toLowerCase())),
    );
  }

  async hasEditOrDeleteControls(): Promise<boolean> {
    return ((await this.editControls.count()) + (await this.deleteControls.count())) > 0;
  }
}
