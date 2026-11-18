/**
 * Miscellaneous Master Activity Log (feature: activity_audit_log.feature).
 *
 * TODO(verify-locator): the FRD assumes an Activity Log section reachable by an Auditor that records Title Created / Updated /
 * Display Changed / Deleted / Deletion Blocked entries with User, Date-Time, Enum ID, Field Title and per-field previous / new
 * values. Nothing about its entry point has been inspected, so this is an entry-point probe plus a tolerant reader.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';

const LOG = /activity\s*log|audit/i;

export class MiscellaneousMasterActivityLogPage {
  readonly entryPoint: Locator;
  readonly panel: Locator;
  readonly entries: Locator;

  constructor(page: Page) {
    this.entryPoint = page
      .getByRole('button', { name: LOG })
      .or(page.getByRole('tab', { name: LOG }))
      .or(page.getByRole('link', { name: LOG }))
      .or(page.getByRole('menuitem', { name: LOG }))
      .first();
    this.panel = page.getByRole('dialog').or(page.getByRole('region', { name: LOG })).first();
    this.entries = this.panel.locator('[role="row"], li, .activity-log-entry');
  }

  async isAvailable(): Promise<boolean> {
    return this.entryPoint.isVisible().catch(() => false);
  }

  async open(): Promise<void> {
    await expect(this.entryPoint, 'the Activity Log entry point is visible').toBeVisible({ timeout: 10000 });
    await this.entryPoint.click();
    await expect(this.entries.first(), 'the Activity Log lists entries').toBeVisible({ timeout: 15000 });
  }

  async entryTexts(): Promise<string[]> {
    return (await this.entries.allInnerTexts()).map((text) => text.replace(/\s+/g, ' ').trim()).filter(Boolean);
  }

  async count(): Promise<number> {
    return (await this.entryTexts()).length;
  }

  /** Entries whose text contains the event name ("Title Created"). */
  async entriesOf(event: string): Promise<string[]> {
    return (await this.entryTexts()).filter((text) => text.toLowerCase().includes(event.toLowerCase()));
  }

  async hasEditOrDeleteControls(): Promise<boolean> {
    return (await this.panel.getByRole('button', { name: /^(edit|delete)$/i }).count()) > 0;
  }
}
