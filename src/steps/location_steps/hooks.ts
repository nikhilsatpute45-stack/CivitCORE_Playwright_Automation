/**
 * Location hooks.
 *
 * - After: removes the test data a scenario created (deepest-first, so a child is removed before its
 *   parent), so every scenario can be re-run. Defined under src/steps on purpose: Cucumber runs After hooks
 *   in reverse definition order, and src/support is loaded first, so this hook runs while the scenario's
 *   browser context is still open. Only records carrying the scenario's unique suffix are touched.
 * - Before @audit_log: the MIDC build has no Activity Log screen for Location Management (confirmed via the
 *   same tab strip as Location Category, which already established this), so those scenarios are skipped;
 *   once an entry point appears the hook fails instead, so the log steps get automated.
 * - Before @office_association: the live Add/Edit Office form has no Location field (confirmed live), so
 *   those scenarios are skipped; once a Location field appears the hook fails instead.
 * - Before @product_consumption: CivitBUILD and CivitINFRA are not reachable from this portal (confirmed
 *   live: no link, menu entry or URL for either product anywhere), so those scenarios are skipped.
 */
import { After, Before } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { LOCATION_OFFICE_ASSOCIATION_GAP, NO_PRODUCT_CONSUMERS } from '../../test-data/location.data';
import { midcTestData } from '../../test-data/midc.data';
import { ensureOnList, skipBecause } from './helpers';

const CLEANUP_BUDGET_MS = 90000;
const HOOK_TIMEOUT_MS = CLEANUP_BUDGET_MS + 30000;

After({ tags: '@location', name: 'Remove Location test data', timeout: HOOK_TIMEOUT_MS }, async function (this: CustomWorld) {
  if (!this.hasPage || this.page.isClosed()) return;
  const { api } = this.pages.location;
  if (!api.hasSession()) return;

  const leftovers: string[] = [];
  const deadline = Date.now() + CLEANUP_BUDGET_MS;
  try {
    await this.pages.location.dismissOverlays().catch(() => undefined);

    const owned = (await api.fetchMaster()).filter((record) => this.location.data.owns(record.name));
    for (const record of owned.sort((a, b) => b.depth - a.depth)) {
      if (Date.now() > deadline) {
        leftovers.push(`#${record.id} "${record.name}" (clean-up budget exhausted)`);
        continue;
      }
      const result = await api.remove(record.id);
      if (result.status >= 300) leftovers.push(`#${record.id} "${record.name}": ${result.status} ${result.message}`);
    }

    const remaining = (await api.fetchMaster()).filter((record) => this.location.data.owns(record.name));
    for (const record of remaining) {
      const text = `#${record.id} "${record.name}" is still in the master`;
      if (!leftovers.some((entry) => entry.startsWith(`#${record.id} `))) leftovers.push(text);
    }
  } catch (error) {
    leftovers.push(`clean-up stopped: ${(error as Error).message}`);
  }

  if (leftovers.length > 0) {
    this.log(`Location test data left behind (filter the grid's Location Name column for "Bdd" to find it):\n${leftovers.join('\n')}`);
  }
});

let activityLogAvailable: boolean | undefined;

Before({ tags: '@location and @audit_log', name: 'Skip Location Activity Log scenarios while the build has no Activity Log' }, async function (this: CustomWorld) {
  if (activityLogAvailable === undefined) {
    await ensureOnList(this);
    activityLogAvailable = await this.pages.location.activityLog.isAvailable();
  }
  if (activityLogAvailable) {
    throw new Error(
      'An Activity / Audit Log entry point is now present on the Location screen; ' +
        'automate the audit log steps (src/steps/location_steps/audit-log.steps.ts) against it.',
    );
  }
  return skipBecause(this, 'the MIDC build has no Activity / Audit Log screen for Location Management.');
});

let officeHasLocationField: boolean | undefined;

Before({ tags: '@location and @office_association', name: 'Skip Office<->Location association scenarios while Office has no Location field' }, async function (this: CustomWorld) {
  if (officeHasLocationField === undefined) {
    await ensureOnList(this);
    await this.pages.location.office.open(midcTestData.organizationName);
    officeHasLocationField = await this.pages.location.office.hasLocationField();
  }
  if (officeHasLocationField) {
    throw new Error(
      'The Add Office form now has a field referencing Location; automate the office_association steps ' +
        '(src/steps/location_steps/office-association.steps.ts) against it.',
    );
  }
  return skipBecause(this, LOCATION_OFFICE_ASSOCIATION_GAP);
});

Before({ tags: '@location and @product_consumption' }, function (this: CustomWorld) {
  return skipBecause(this, NO_PRODUCT_CONSUMERS);
});
