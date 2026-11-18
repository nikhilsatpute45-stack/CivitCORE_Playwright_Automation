/**
 * Steps of title_deletion.feature: kebab menu selections ("clicks the kebab on 'X' and select Delete"), "selects Delete ... so the
 * confirmation dialog is displayed" and "deletes 'X' and click Yes". The bare "selects Delete on 'X'", "clicks 'Yes'" / "'No'" and Esc
 * are in shared_with_contract_category.steps.ts. A blocked delete shows an error toaster instead of the confirmation dialog, so the
 * toaster is captured whether or not the dialog opens. Dependency preconditions (Parent Title / Specialization Master mapping /
 * transaction) come from the baseline data and skip without MM_BASELINE_SEEDED.
 */
import { When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { openRowMenuAndSelect, rememberGrid, withToast, withTc } from './helpers';

When(
  /^the user selects Delete on '([^']*)' so the confirmation dialog is displayed$/,
  async function (this: CustomWorld, title: string): Promise<void> {
    await rememberGrid(this);
    await withToast(this, () => openRowMenuAndSelect(this, title, 'Delete'), 4000);
    await mmPages(this).deletion.expectOpen();
  },
);

When(
  /^the user clicks the kebab on '([^']*)' and select (Delete|Edit|View)$/,
  async function (this: CustomWorld, title: string, item: 'Delete' | 'Edit' | 'View'): Promise<void> {
    await rememberGrid(this);
    if (item === 'Delete') await withToast(this, () => openRowMenuAndSelect(this, title, 'Delete'), 4000);
    else await openRowMenuAndSelect(this, title, item);
  },
);

When(
  /^the user deletes (?:'([^']*)'(?: \([^)]*\))?|that row) and (?:click|confirm) Yes$/,
  async function (this: CustomWorld, title?: string): Promise<void> {
    const { deletion } = mmPages(this);
    const row = title ?? mmScenario(this).target ?? mmScenario(this).created.at(-1);
    if (!row) throw new Error(withTc(this, 'There is no row to delete.'));
    await rememberGrid(this);
    await withToast(this, () => openRowMenuAndSelect(this, row, 'Delete'), 4000);
    // A blocked delete shows the error toaster and no dialog; the Then step asserts which.
    if (await deletion.isOpen()) {
      await withToast(this, () => deletion.yes(), 8000);
      await deletion.expectClosed();
    }
  },
);
