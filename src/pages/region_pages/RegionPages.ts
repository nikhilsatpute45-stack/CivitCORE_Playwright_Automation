/**
 * All Region page objects of one browser page, wired to a single RegionApi so they share the same master
 * data and API history. TODO: Verify every locator once the Region module is developed (see each page
 * object's own doc comment for the specific gap it stands in for).
 *
 *   list         Region List - navigation, search, columns, row actions (initiation / search_view / ui)
 *   form         Add / Edit Region dialog (creation / update)
 *   deletion     delete confirmation and Office / Location dependency check (deletion)
 *   office       Office Management: Region lookup, Assigned With Offices (office_location_association)
 *   location     Location Management: Region lookup, Region display (office_location_association)
 *   products     CivitBUILD / CivitINFRA Region consumption (multi_product_consumption)
 *   activityLog  Region Activity Log (audit_log)
 *   api          create / update / delete traffic and authenticated replay
 */
import type { Page } from '@playwright/test';
import type { MastersManagementPage } from '../department_pages/MastersManagementPage';
import { RegionActivityLogPage } from './RegionActivityLogPage';
import { RegionApi } from './RegionApi';
import { RegionDeletionPage } from './RegionDeletionPage';
import { RegionFormDialog } from './RegionFormDialog';
import { RegionListPage } from './RegionListPage';
import { RegionLocationPage } from './RegionLocationPage';
import { RegionOfficePage } from './RegionOfficePage';
import { RegionProductConsumptionPage } from './RegionProductConsumptionPage';

export class RegionPages {
  readonly api: RegionApi;
  readonly list: RegionListPage;
  readonly form: RegionFormDialog;
  readonly deletion: RegionDeletionPage;
  readonly office: RegionOfficePage;
  readonly location: RegionLocationPage;
  readonly products: RegionProductConsumptionPage;
  readonly activityLog: RegionActivityLogPage;

  constructor(
    private readonly page: Page,
    organization: MastersManagementPage,
  ) {
    this.api = new RegionApi(page);
    this.list = new RegionListPage(page, organization, this.api);
    this.form = new RegionFormDialog(page, this.api);
    this.deletion = new RegionDeletionPage(page, this.list, this.api);
    this.office = new RegionOfficePage(page, this.list, organization);
    this.location = new RegionLocationPage(page, this.list, organization);
    this.products = new RegionProductConsumptionPage(page);
    this.activityLog = new RegionActivityLogPage(page);
  }

  /** Closes whatever dialog or menu a failed step may have left open, without saving or deleting anything. */
  async dismissOverlays(): Promise<void> {
    if (await this.deletion.isConfirmationOpen()) await this.deletion.cancel().catch(() => undefined);
    if (await this.form.isOpen()) await this.form.cancel().catch(() => undefined);
    await this.list.closeRowMenu();
    const otherDialog = this.page.getByRole('dialog');
    if (await otherDialog.isVisible().catch(() => false)) {
      const dismiss = otherDialog.getByRole('button', { name: /^\s*(Cancel|Close)\s*$/ }).first();
      await dismiss.click({ timeout: 5000 }).catch(() => this.page.keyboard.press('Escape'));
      await otherDialog.waitFor({ state: 'hidden', timeout: 10000 }).catch(() => undefined);
    }
  }
}
