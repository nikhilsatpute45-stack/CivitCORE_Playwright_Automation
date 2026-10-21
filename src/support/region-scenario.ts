/**
 * Scenario-scoped state of the Region steps, plus the lazily-built RegionPages instance of this scenario.
 *
 * SCOPE NOTE: the Region module is intentionally wired without touching CustomWorld (src/support/world.ts) or
 * src/pages/index.ts - both are shared files this module's brief asks to leave alone (any change there would
 * need the project owner's sign-off first). Every other module exposes its page objects as `world.pages.<module>`
 * and its scenario state as `world.<module>`, which requires editing the CustomWorld class itself; Region instead
 * keeps a WeakMap from the running CustomWorld instance to its own RegionPages / RegionScenario, built on first
 * use from fields CustomWorld already exposes (`world.page`, `world.pages.mastersManagementPage`). Cucumber
 * creates one fresh CustomWorld per scenario, so this is exactly as scenario-scoped as `world.location` etc.
 *
 * Feature files name Regions directly ("Delhi", "Central Region") rather than FRD-vs-baseline vocabulary (the
 * Region module has no FRD baseline hierarchy the way Location Category does), so `frd` below is simply the
 * name the feature file used, kept distinct from the unique `name` the scenario actually typed/stored.
 */
import type { CustomWorld } from './world';
import { RegionPages } from '../pages/region_pages';
import type { ApiResult, RegionApiCall } from '../pages/region_pages';
import type { SubmitOutcome } from '../pages/region_pages/RegionFormDialog';
import { RegionTestData } from '../test-data/region.data';

export interface RegionFixture {
  id: number;
  /** Name the feature file used ("Delhi", "Central Region"). */
  frd: string;
  /** Name as created (the app may normalise it; compare case-insensitively). */
  name: string;
}

export interface OfficeFixture {
  name: string;
  regionFrd?: string;
  id?: number;
}

export interface LocationFixture {
  name: string;
  regionFrd?: string;
  id?: number;
}

/** What the user typed into the open Add / Edit form, so the stored record can be compared with it. */
export interface EnteredValues {
  name?: string;
}

export class RegionScenario {
  readonly data = new RegionTestData();
  private readonly byFrd = new Map<string, RegionFixture>();

  /** The Region the scenario is currently acting on. */
  target?: RegionFixture;
  entered: EnteredValues = {};
  editing?: RegionFixture;
  lastOutcome?: SubmitOutcome;
  lastDelete?: RegionApiCall;
  /** Result of the last request the scenario sent straight to the API. */
  apiResult?: ApiResult;
  /** Role used by this scenario's own login steps (see ./helpers.ts logInAs); the generic Location-module
   *  login step the bare "Given I am logged in as ..." phrase resolves to does not record it here. */
  role?: string;
  /** ID / count noted before an action ("I note the Region ID of ... and the total Region count of 5"). */
  notedId?: number;
  notedCount?: number;
  /** Master records snapshotted before an action, to prove "nothing changed". */
  snapshot?: Array<{ id: number; name: string }>;
  /** Regions created through the form in this scenario, in order. */
  readonly createdViaUi: RegionFixture[] = [];
  /** Office / Location fixtures the scenario created in support of an association scenario. */
  readonly offices: OfficeFixture[] = [];
  readonly locations: LocationFixture[] = [];
  /** Free-form values a feature's own steps hand to each other (see the step file that sets them). */
  readonly scratch: Record<string, unknown> = {};

  remember(fixture: RegionFixture): RegionFixture {
    this.byFrd.set(normalizeKey(fixture.frd), fixture);
    this.target = fixture;
    return fixture;
  }

  fixture(frdName: string): RegionFixture | undefined {
    return this.byFrd.get(normalizeKey(frdName));
  }

  fixtures(): RegionFixture[] {
    return [...this.byFrd.values()];
  }

  /** Updates a fixture after the app changed it (rename). */
  refresh(id: number, values: Partial<RegionFixture>): void {
    for (const fixture of [...this.byFrd.values(), ...this.createdViaUi]) {
      if (fixture.id === id) Object.assign(fixture, values);
    }
  }
}

function normalizeKey(value: string): string {
  return value.trim().replace(/\s+/g, ' ').toLowerCase();
}

const pagesByWorld = new WeakMap<CustomWorld, RegionPages>();
const scenarioByWorld = new WeakMap<CustomWorld, RegionScenario>();

/** This scenario's RegionPages, built the first time a Region step needs it. */
export function regionPages(world: CustomWorld): RegionPages {
  let pages = pagesByWorld.get(world);
  if (!pages) {
    pages = new RegionPages(world.page, world.pages.mastersManagementPage);
    pagesByWorld.set(world, pages);
  }
  return pages;
}

/** This scenario's Region bookkeeping, built the first time a Region step needs it. */
export function regionScenario(world: CustomWorld): RegionScenario {
  let scenario = scenarioByWorld.get(world);
  if (!scenario) {
    scenario = new RegionScenario();
    scenarioByWorld.set(world, scenario);
  }
  return scenario;
}
