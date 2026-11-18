/**
 * Header of the signed-in portal (FRD 6.5 / 6.8): user name, active organization, active role, Switch Role, Logout, offices.
 *
 * TODO(locator): the live UI was not inspected; every locator below is a guess.
 */
import type { Locator, Page } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { config } from '../../support/config';

export class SessionHeader {
  /** TODO(locator): confirm against live UI. */
  get header(): Locator {
    return this.page.getByRole('banner').first();
  }

  /** TODO(locator): confirm against live UI - a signed-in session is recognised by its Logout control. */
  get logoutControl(): Locator {
    return this.page.getByRole('button', { name: /log ?out/i }).or(this.page.getByRole('link', { name: /log ?out/i })).first();
  }

  /** TODO(locator): confirm against live UI. */
  get switchRoleControl(): Locator {
    return this.page.getByRole('button', { name: /switch role/i }).or(this.page.getByRole('link', { name: /switch role/i })).first();
  }

  constructor(private readonly page: Page) {}

  async isSessionVisible(timeoutMs: number): Promise<boolean> {
    return this.logoutControl
      .waitFor({ state: 'visible', timeout: timeoutMs })
      .then(() => true)
      .catch(() => false);
  }

  async expectSession(): Promise<void> {
    await expect(this.logoutControl, 'a signed-in session (Logout control)').toBeVisible({ timeout: config.navigationTimeoutMs });
  }

  async expectNoSession(): Promise<void> {
    await expect(this.logoutControl, 'no session (Logout control)').toBeHidden();
  }

  /** The header's text, whitespace-collapsed (organization, role and user name are read from it). */
  async text(): Promise<string> {
    return (await this.header.innerText()).replace(/\s+/g, ' ').trim();
  }

  async logout(): Promise<void> {
    await this.logoutControl.click();
  }

  async openSwitchRole(): Promise<void> {
    await this.switchRoleControl.click();
  }

  /** Texts of the Switch Role list (call after `openSwitchRole`). TODO(locator): menu / listbox / dialog is unknown. */
  async switchRoleOptions(): Promise<string[]> {
    const items = this.page.getByRole('menuitem').or(this.page.getByRole('option')).or(this.page.getByRole('listitem'));
    return (await items.allInnerTexts()).map((text) => text.replace(/\s+/g, ' ').trim()).filter(Boolean);
  }

  /** True when `text` is visible anywhere on the page (offices, roles ... the FRD gives no fixed place for them). */
  async showsText(text: string): Promise<boolean> {
    return this.page.getByText(text, { exact: false }).first().isVisible().catch(() => false);
  }
}
