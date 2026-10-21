/**
 * Office tab, as far as office_association.feature needs it to probe its premise.
 *
 * The FRD assumes Office creation references a Location (a lookup populated from the Location Master,
 * stored by Location ID). Confirmed live: the Add/Edit Office dialog's fields are Organization Name *,
 * Office *, Office Code *, Office Category *, Parent Category, Parent Office - the same shape as the
 * Add/Edit Location dialog, but for an entirely separate, parallel hierarchy with no Location field at all.
 * Office and Location are not associated anywhere in this build. `hasLocationField` is re-checked every run
 * so the gap is caught (and the office_association steps un-skipped) the moment it stops being true.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import type { MastersManagementPage } from '../department_pages/MastersManagementPage';
import type { LocationListPage } from './LocationListPage';

const LOCATION_FIELD_NAME = /\blocation\b/i;

export class LocationOfficePage {
  readonly tab: Locator;
  readonly addButton: Locator;
  readonly dialog: Locator;
  readonly cancelButton: Locator;

  constructor(
    private readonly page: Page,
    private readonly list: LocationListPage,
    private readonly organization: MastersManagementPage,
  ) {
    this.tab = page.locator('.task-tab-base').filter({ hasText: /^\s*Office\s*$/ });
    this.addButton = page.getByRole('button', { name: 'Add Office', exact: true });
    this.dialog = page.getByRole('dialog');
    this.cancelButton = this.dialog.getByRole('button', { name: 'Cancel', exact: true });
  }

  async isAvailable(): Promise<boolean> {
    return this.tab.isVisible().catch(() => false);
  }

  /**
   * See LocationListPage.open()'s doc comment: the module-selection page renders its cards asynchronously, so
   * this waits for whichever landing state actually shows up instead of trusting an instant visibility check.
   */
  async open(organizationName: string): Promise<void> {
    await expect(this.organization.mastersManagementLink.or(this.tab).or(this.list.organizationConfigurationIcon)).toBeVisible({
      timeout: 30000,
    });
    if (await this.organization.mastersManagementLink.isVisible().catch(() => false)) {
      await this.organization.openMastersManagement();
      await this.organization.expectAdminPortalLoaded();
    }
    if (!(await this.tab.isVisible().catch(() => false))) {
      await expect(this.list.organizationConfigurationIcon).toBeVisible({ timeout: 30000 });
      await this.list.organizationConfigurationIcon.click();
    }
    await this.tab.click();
    await expect(this.list.organizationPlaceholder.or(this.addButton)).toBeVisible({ timeout: 30000 });
    if (await this.list.organizationPlaceholder.isVisible()) await this.organization.selectOrganization(organizationName);
    await expect(this.addButton).toBeVisible({ timeout: 30000 });
  }

  /** Opens Add Office and reports whether any field in it references a Location, then closes it without saving. */
  async hasLocationField(): Promise<boolean> {
    await this.addButton.click();
    await expect(this.dialog.locator('label').first()).toBeVisible({ timeout: 20000 });
    const labels = (await this.dialog.locator('label').allInnerTexts()).map((label) => label.trim());
    const found = labels.some((label) => LOCATION_FIELD_NAME.test(label));
    await this.cancelButton.click({ timeout: 8000 }).catch(() => this.page.keyboard.press('Escape'));
    await expect(this.dialog).toBeHidden({ timeout: 20000 }).catch(() => undefined);
    return found;
  }
}
