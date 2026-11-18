/**
 * Steps of title_list_view_column_search.feature (and the pagination / Display-filter sentences of title_list_ui.feature):
 * typing into the Title / Enum ID / Parent Title search boxes, the Display filter and pagination. "clicks First / Last / Next /
 * Previous / page number N" are shared with Contractor Category (shared_with_contract_category.steps.ts). Scenarios that need
 * more than one page skip unless the matching dataset is seeded (MM_BULK_SEEDED / MM_EXACT_COUNT_SEEDED).
 */
import { When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import type { SearchColumn } from '../../pages/miscellaneous_master_pages';
import { requireBulk, testDatum, type Skippable } from './helpers';

const COLUMN = '(Title|Enum ID|Parent Title)';

async function settle(world: CustomWorld): Promise<void> {
  await world.page.waitForLoadState('networkidle', { timeout: 5000 }).catch(() => undefined);
}

/** Search text for a sentence without a literal: the scenario's own "Title search" / "Search" / "Parent Title search" datum. */
function searchText(world: CustomWorld, column: SearchColumn): string {
  const keys = column === 'Title' ? ['Title search', 'Search', 'Typed text'] : column === 'Enum ID' ? ['Enum ID search', 'Search'] : ['Parent Title search', 'Search'];
  for (const key of keys) {
    const value = testDatum(world, key);
    if (value !== undefined) return value;
  }
  return '';
}

When(
  new RegExp(`^the user types (?:'([^']*)' in (?:the )?${COLUMN} (?:column )?search(?: box)?(?: and observe)?|SQL-like text in the Title search box)$`),
  async function (this: CustomWorld, literal: string | undefined, column: SearchColumn | undefined): Promise<void> {
    const { list } = mmPages(this);
    if (literal === undefined) {
      await list.search('Title', testDatum(this, 'Title search') ?? "x'; DROP TABLE Titles;--");
    } else {
      // Keystroke by keystroke: the list filters after each one (the scenarios compare the intermediate results).
      await list.search(column ?? 'Title', literal, true);
    }
    await settle(this);
  },
);

When(/^the user types 'firm' in Title search and select 'Checked' in Display$/, async function (this: CustomWorld): Promise<void> {
  const { list } = mmPages(this);
  await list.search('Title', 'firm', true);
  await list.selectDisplayFilter('Checked');
  await settle(this);
});

When(/^the user continues typing to '([^']*)' without pressing Enter$/, async function (this: CustomWorld, text: string): Promise<void> {
  await this.page.keyboard.type(text);
  await settle(this);
});

When(
  /^the user scrolls through the list and use the column search on Title with '([^']*)'$/,
  async function (this: CustomWorld, text: string): Promise<void> {
    await this.page.mouse.wheel(0, 2000);
    await mmPages(this).list.search('Title', text, true);
    await settle(this);
  },
);

When(/^the user waits for completion and search the list$/, async function (this: CustomWorld): Promise<void> {
  await settle(this);
  const { list } = mmPages(this);
  const text = mmScenario(this).entered.fieldTitle?.trim() ?? searchText(this, 'Title');
  if (text) await list.search('Title', text);
  await settle(this);
});

When(/^the user clears the Title search box and select All in Display$/, async function (this: CustomWorld): Promise<void> {
  const { list } = mmPages(this);
  await list.clearSearch('Title');
  await list.selectDisplayFilter('All');
  await settle(this);
});

When(/^the user selects '(Checked|Unchecked)' in the Display (?:column )?dropdown$/, async function (this: CustomWorld, value: 'Checked' | 'Unchecked'): Promise<void> {
  await mmPages(this).list.selectDisplayFilter(value);
  await settle(this);
});

When(/^the user selects Checked, then select All$/, async function (this: CustomWorld): Promise<void> {
  const { list } = mmPages(this);
  await list.selectDisplayFilter('Checked');
  await list.selectDisplayFilter('All');
  await settle(this);
});

When(/^the user opens the Display search dropdown$/, async function (this: CustomWorld): Promise<void> {
  mmScenario(this).scratch.options = await mmPages(this).list.displayFilterOptions();
});

When(/^the user looks above the grid for any separate search box$/, async function (this: CustomWorld): Promise<void> {
  const { list } = mmPages(this);
  mmScenario(this).scratch.separateSearch = await list.hasSeparateSearchBox();
});

When(/^the user looks for the Title '([^']*)' \(no Enum ID\)$/, async function (this: CustomWorld, title: string): Promise<void> {
  mmScenario(this).target = title;
  await mmPages(this).list.search('Title', title);
  await settle(this);
});

// --- pagination ------------------------------------------------------------------------------------------------------

When(
  /^the user (?:goes to page (\d+)(?: \(single row, Sl\. No\. \d+\)| of the list)|opens page (\d+)|clicks Next to open page (\d+)|goes to the last page and observe the last row)$/,
  async function (this: CustomWorld, goTo?: string, opens?: string, next?: string): Promise<void> {
    const { list } = mmPages(this);
    if (next) await list.clickControl('Next');
    else if (goTo || opens) await list.goToPage(Number(goTo ?? opens));
    else await list.clickControl('Last');
    await settle(this);
  },
);

When(/^On the Dataset C list type 'Bulk' in Title search and open page 2$/, async function (this: CustomWorld): Skippable {
  const skipped = requireBulk(this);
  if (skipped) return skipped;
  const { list } = mmPages(this);
  await list.search('Title', 'Bulk', true);
  await settle(this);
  await list.goToPage(2);
  return undefined;
});
