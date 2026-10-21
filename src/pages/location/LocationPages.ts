/**
 * All Location page objects of one browser page, wired to a single LocationApi so they share the same
 * master data and API history.
 *
 *   list         hierarchy list, search, pagination, row actions (initiation / search_view / permissions / ui)
 *   form         Add / Edit dialog (creation / update)
 *   deletion     delete confirmation (deletion)
 *   office       Office tab probe (office_association - confirmed to have no Location field, see LocationOfficePage)
 *   activityLog  entry-point probe (audit_log)
 *   api          getHierarchy / create / update / delete traffic and authenticated replay
 */
import type { Page } from '@playwright/test';
import type { MastersManagementPage } from '../department_pages/MastersManagementPage';
import { LocationActivityLogPage } from './LocationActivityLogPage';
import { LocationApi } from './LocationApi';
import { LocationDeletionPage } from './LocationDeletionPage';
import { LocationFormDialog } from './LocationFormDialog';
import { LocationListPage } from './LocationListPage';
import { LocationOfficePage } from './LocationOfficePage';

export class LocationPages {
  readonly api: LocationApi;
  readonly list: LocationListPage;
  readonly form: LocationFormDialog;
  readonly deletion: LocationDeletionPage;
  readonly office: LocationOfficePage;
  readonly activityLog: LocationActivityLogPage;

  constructor(
    private readonly page: Page,
    organization: MastersManagementPage,
  ) {
    this.api = new LocationApi(page);
    this.list = new LocationListPage(page, organization, this.api);
    this.form = new LocationFormDialog(page, this.api);
    this.deletion = new LocationDeletionPage(page, this.list, this.api);
    this.office = new LocationOfficePage(page, this.list, organization);
    this.activityLog = new LocationActivityLogPage(page);
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
