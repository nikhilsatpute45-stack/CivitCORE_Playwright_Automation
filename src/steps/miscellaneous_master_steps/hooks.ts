/**
 * Miscellaneous Master hooks.
 *
 * After (tag @MiscellaneousMaster):
 *   1. closes a pop-up / dialog a failed step left open (it only cancels / closes, never saves or deletes);
 *   2. deletes the Titles this scenario created (the features assert literal Field Titles such as 'Contractor Category', so the
 *      Bdd<digits> suffix used by other modules cannot be applied here; the scenario's own `created` list is what is removed -
 *      children before parents, so a parent that is still referenced is never deleted first);
 *   3. restores the original Parent Title / Enum ID / Display of baseline Titles the scenario edited.
 * Everything goes through the API of the scenario's own session; when that session never made an authenticated request (the
 * usual case while the module is not reachable) the hook returns at once. Anything that could not be cleaned up is logged.
 */
import { After, Before } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';

const CLEANUP_BUDGET_MS = 60000;

Before({ tags: '@MiscellaneousMaster', name: 'Record Miscellaneous Master scenario tags' }, async function (this: CustomWorld, { pickle }) {
  mmScenario(this).tags = pickle.tags.map((tag) => tag.name);
});

After({ tags: '@MiscellaneousMaster', name: 'Remove Miscellaneous Master test data', timeout: CLEANUP_BUDGET_MS + 30000 }, async function (this: CustomWorld) {
  if (!this.hasPage || this.page.isClosed()) return;
  const pages = mmPages(this);
  await pages.dismissOverlays().catch(() => undefined);
  const scenario = mmScenario(this);
  if (!pages.api.hasSession()) return;
  if (scenario.created.length === 0 && scenario.originals.size === 0) return;

  const leftovers: string[] = [];
  const deadline = Date.now() + CLEANUP_BUDGET_MS;
  try {
    const all = await pages.api.fetchAll();
    const names = new Set(scenario.created.map((title) => title.trim().toLowerCase()));
    const owned = all.filter((record) => names.has(record.fieldTitle.trim().toLowerCase()));
    // Children first: a record whose parent is also being removed goes before that parent.
    const ownedIds = new Set(owned.map((record) => record.id));
    const depth = (record: (typeof owned)[number]): number => {
      let count = 0;
      let parent = record.parentTitleId;
      while (parent !== undefined && ownedIds.has(parent) && count < 20) {
        count += 1;
        parent = owned.find((candidate) => candidate.id === parent)?.parentTitleId;
      }
      return count;
    };
    for (const record of [...owned].sort((a, b) => depth(b) - depth(a))) {
      if (Date.now() > deadline) {
        leftovers.push(`"${record.fieldTitle}" (clean-up budget exhausted)`);
        continue;
      }
      const result = await pages.api.remove(record.id);
      if (result.status >= 300) leftovers.push(`"${record.fieldTitle}": ${result.status} ${result.message}`);
    }
    for (const original of scenario.originals.values()) {
      const record = all.find((candidate) => candidate.fieldTitle === original.fieldTitle) ?? all.find((candidate) => candidate.id === original.id);
      if (!record) continue;
      const parent = original.parentTitle ? all.find((candidate) => candidate.fieldTitle === original.parentTitle) : undefined;
      if (record.enumId !== original.enumId || record.display !== original.display || record.parentTitle !== original.parentTitle) {
        const result = await pages.api.update(record.id, {
          fieldTitle: original.fieldTitle,
          parentTitleId: parent?.id ?? null,
          enumId: original.enumId || null,
          display: original.display,
        });
        if (result.status >= 300) leftovers.push(`restore "${original.fieldTitle}": ${result.status} ${result.message}`);
      }
    }
  } catch (error) {
    leftovers.push(`clean-up stopped: ${(error as Error).message}`);
  }
  if (leftovers.length > 0) this.log(`Miscellaneous Master test data left behind:\n${leftovers.join('\n')}`);
});
