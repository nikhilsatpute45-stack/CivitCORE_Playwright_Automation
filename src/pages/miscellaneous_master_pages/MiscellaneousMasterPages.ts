/**
 * Facade over the Miscellaneous Master page objects of one browser page (same shape as ContractCategoryPages / AuditTrailPages).
 *
 *   list         the Title List: navigation, grid, column search, Display filter / checkbox, pagination, kebab menu
 *   form         Add / Edit Title pop-up
 *   view         read-only View Title pop-up
 *   deletion     delete confirmation dialog
 *   activityLog  Activity Log reader
 *   api          authenticated replay (fixtures, clean-up, rejection scenarios)
 */
import type { Page } from '@playwright/test';
import { MiscellaneousMasterActivityLogPage } from './MiscellaneousMasterActivityLogPage';
import { MiscellaneousMasterApi } from './MiscellaneousMasterApi';
import { MiscellaneousMasterDeleteDialog, MiscellaneousMasterFormDialog, MiscellaneousMasterViewDialog } from './MiscellaneousMasterDialogs';
import { MiscellaneousMasterListPage } from './MiscellaneousMasterListPage';

export class MiscellaneousMasterPages {
  readonly api: MiscellaneousMasterApi;
  readonly list: MiscellaneousMasterListPage;
  readonly form: MiscellaneousMasterFormDialog;
  readonly view: MiscellaneousMasterViewDialog;
  readonly deletion: MiscellaneousMasterDeleteDialog;
  readonly activityLog: MiscellaneousMasterActivityLogPage;

  constructor(page: Page) {
    this.api = new MiscellaneousMasterApi(page);
    this.list = new MiscellaneousMasterListPage(page);
    this.form = new MiscellaneousMasterFormDialog(page);
    this.view = new MiscellaneousMasterViewDialog(page);
    this.deletion = new MiscellaneousMasterDeleteDialog(page);
    this.activityLog = new MiscellaneousMasterActivityLogPage(page);
  }

  /** Closes a pop-up / dialog a failed step may have left open, without saving or deleting anything. */
  async dismissOverlays(): Promise<void> {
    if (await this.deletion.isOpen()) await this.deletion.no().catch(() => undefined);
    if (await this.form.isOpen()) await this.form.cancel().catch(() => this.form.pressEscape());
    if (await this.view.isOpen()) await this.view.clickClose().catch(() => this.view.pressEscape());
  }
}
