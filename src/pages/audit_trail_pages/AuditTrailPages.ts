/**
 * All Audit Trail page objects of one browser page, wired together. TODO(locator): verify every locator once the Audit Trail screen exists.
 *
 *   list     listing screen: navigation, grid, read-only checks
 *   filters  Functions / From Date / To Date / Search / Clear Log
 *   dialog   Clear Audit Log confirmation dialog
 *   api      authenticated replay of get-entries / clear / modify requests
 */
import type { Page } from '@playwright/test';
import { AuditTrailApi } from './AuditTrailApi';
import { AuditTrailFilterPanel } from './AuditTrailFilterPanel';
import { AuditTrailListPage } from './AuditTrailListPage';
import { ClearAuditLogDialog } from './ClearAuditLogDialog';

export class AuditTrailPages {
  readonly list: AuditTrailListPage;
  readonly filters: AuditTrailFilterPanel;
  readonly dialog: ClearAuditLogDialog;
  readonly api: AuditTrailApi;

  constructor(page: Page) {
    this.api = new AuditTrailApi(page);
    this.list = new AuditTrailListPage(page);
    this.filters = new AuditTrailFilterPanel(page);
    this.dialog = new ClearAuditLogDialog(page);
  }
}
