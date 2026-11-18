/**
 * Scenario-scoped state of the Miscellaneous Master steps, plus the lazily-built MiscellaneousMasterPages of this scenario.
 *
 * Same wiring as Audit Trail / Contractor Category: a WeakMap from the running CustomWorld to this module's own objects, so
 * neither CustomWorld nor src/pages/index.ts has to change. Cucumber creates one World per scenario.
 */
import type { CustomWorld } from './world';
import { MiscellaneousMasterPages } from '../pages/miscellaneous_master_pages';
import type { MmApiResult } from '../pages/miscellaneous_master_pages';

export interface OriginalTitle {
  id?: number;
  fieldTitle: string;
  parentTitle: string;
  enumId: string;
  display: boolean;
}

export class MiscellaneousMasterScenario {
  /** Rows of the scenario's "the following test data is used" table (first column -> second column). */
  testData: Record<string, string> = {};
  /** The full rows of that table (every column). */
  testRows: string[][] = [];
  /** Tags of the running scenario, for feature checks (the TC id itself comes from the shared registry). */
  tags: string[] = [];
  /** User the scenario signed in as (e.g. "Viewer_User1"). */
  user?: string;
  /** What the Given asked to be open once the test data is known ("edit" pop-up for the Title named in Test Data). */
  deferredOpen?: 'edit';
  /** Values typed into the open Add / Edit form. */
  entered: { fieldTitle?: string; parentTitle?: string; enumId?: string; display?: boolean } = {};
  /** Field Titles this scenario created (removed by the After hook). */
  readonly created: string[] = [];
  /** Original values of Titles this scenario edited (restored by the After hook). */
  readonly originals = new Map<string, OriginalTitle>();
  /** Field Title of the row the scenario is acting on. */
  target?: string;
  /** Sl. No. noted per Field Title before an action. */
  notedSlNos: Record<string, string> = {};
  notedTitles: string[] = [];
  notedCount?: number;
  notedInternalId?: number;
  lastApi?: MmApiResult;
  lastApis: MmApiResult[] = [];
  /** Free-form values a feature's own steps hand to each other. */
  readonly scratch: Record<string, unknown> = {};
}

const pagesByWorld = new WeakMap<CustomWorld, MiscellaneousMasterPages>();
const scenarioByWorld = new WeakMap<CustomWorld, MiscellaneousMasterScenario>();

/** This scenario's Miscellaneous Master page objects, built the first time a step needs them. */
export function mmPages(world: CustomWorld): MiscellaneousMasterPages {
  let pages = pagesByWorld.get(world);
  if (!pages) {
    pages = new MiscellaneousMasterPages(world.page);
    pagesByWorld.set(world, pages);
  }
  return pages;
}

/** This scenario's Miscellaneous Master bookkeeping. */
export function mmScenario(world: CustomWorld): MiscellaneousMasterScenario {
  let scenario = scenarioByWorld.get(world);
  if (!scenario) {
    scenario = new MiscellaneousMasterScenario();
    scenarioByWorld.set(world, scenario);
  }
  return scenario;
}
