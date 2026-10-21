/**
 * CivitBUILD / CivitINFRA Region consumption (feature: region_multi_product_consumption.feature).
 *
 * TODO: Verify locator / access path once the Region module (and CivitBUILD / CivitINFRA's consumption of it)
 * is developed. CivitBUILD and CivitINFRA are separate products this suite has never reached (CLAUDE.md notes
 * CivitBUILD/CivitINFRA reachability as one of the FRD-assumed surfaces the Location/Location Category suites
 * already found unreachable). Every method here is a placeholder "entry point probe" in the same spirit as
 * LocationCategoryActivityLogPage, scoped to whichever product the FRD names (6.5 BR... "Region - Multi-Product
 * Consumption").
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';

export type ConsumingProduct = 'CivitBUILD' | 'CivitINFRA';

export class RegionProductConsumptionPage {
  readonly productSwitcher: Locator;
  readonly regionSelect: Locator;
  readonly regionOptions: Locator;
  readonly regionDisplay: Locator;

  constructor(page: Page) {
    // TODO: Verify locator once CivitBUILD / CivitINFRA's Region screen is reachable from this portal.
    this.productSwitcher = page.getByRole('link', { name: /CivitBUILD|CivitINFRA/i });
    this.regionSelect = page.locator('#region, select[name="region"]');
    this.regionOptions = page.getByRole('option');
    this.regionDisplay = page.getByText(/^Region:/i);
  }

  async isReachable(product: ConsumingProduct): Promise<boolean> {
    return this.productSwitcher.filter({ hasText: product }).first().isVisible().catch(() => false);
  }

  /** Switches to `product` and opens whatever screen there offers a Region selection / display. */
  async openRegionSelection(product: ConsumingProduct): Promise<void> {
    await expect(this.productSwitcher.filter({ hasText: product }).first(), `${product} is reachable from this portal`).toBeVisible({
      timeout: 15000,
    });
    await this.productSwitcher.filter({ hasText: product }).first().click();
    await expect(this.regionSelect.or(this.regionDisplay)).toBeVisible({ timeout: 20000 });
  }

  async regionOptionNames(): Promise<string[]> {
    if (await this.regionSelect.isVisible().catch(() => false)) {
      return (await this.regionSelect.locator('option').allInnerTexts()).map((text) => text.trim()).filter(Boolean);
    }
    return (await this.regionOptions.allInnerTexts()).map((text) => text.trim()).filter(Boolean);
  }

  async displayedRegionName(): Promise<string> {
    return (await this.regionDisplay.innerText().catch(() => '')).replace(/^Region:\s*/i, '').trim();
  }
}
