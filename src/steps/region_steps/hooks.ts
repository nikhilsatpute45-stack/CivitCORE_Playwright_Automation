/**
 * Region hooks.
 *
 * After: removes the test data a scenario created (same shape as src/steps/location_category_steps/hooks.ts),
 * so a scenario can be re-run once the Region module exists. In practice this is a no-op today: every Region
 * scenario's own login step (reused from src/steps/location_steps/common.steps.ts, or this module's
 * "I have API access as ..." / extended login steps) skips before any fixture is created, because no
 * MIDC_REGIONADMIN_* / MIDC_VIEWER_* etc. credential is required to exist for a module that is not built yet -
 * `api.hasSession()` stays false and the hook returns immediately. It is still defined so that, once the
 * module ships and these scenarios start actually creating Regions, clean-up is already wired in.
 */
import { After } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { regionPages, regionScenario } from '../../support/region-scenario';

const CLEANUP_BUDGET_MS = 90000;
const HOOK_TIMEOUT_MS = CLEANUP_BUDGET_MS + 30000;

After({ tags: '@region_management', name: 'Remove Region test data', timeout: HOOK_TIMEOUT_MS }, async function (this: CustomWorld) {
  if (!this.hasPage || this.page.isClosed()) return;
  const api = regionPages(this).api;
  if (!api.hasSession()) return;

  const leftovers: string[] = [];
  const deadline = Date.now() + CLEANUP_BUDGET_MS;
  try {
    await regionPages(this).dismissOverlays().catch(() => undefined);

    const owned = (await api.fetchMaster()).filter((record) => regionScenario(this).data.owns(record.name));
    for (const record of owned) {
      if (Date.now() > deadline) {
        leftovers.push(`#${record.id} "${record.name}" (clean-up budget exhausted)`);
        continue;
      }
      const result = await api.remove(record.id);
      if (result.status >= 300) leftovers.push(`#${record.id} "${record.name}": ${result.status} ${result.message}`);
    }
  } catch (error) {
    leftovers.push(`clean-up stopped: ${(error as Error).message}`);
  }

  if (leftovers.length > 0) {
    this.log(`Region test data left behind (filter the grid for "Bdd" to find it):\n${leftovers.join('\n')}`);
  }
});
