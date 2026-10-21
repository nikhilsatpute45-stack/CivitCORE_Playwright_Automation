/**
 * Scenario-scoped state of the Location steps.
 *
 * Feature files name Locations in FRD terms (INDIA, Gujarat, Surat, ...) against a fictional 12-record
 * baseline; the scenario keeps the unique copies those names were turned into (see LocationTestData) and the
 * IDs the app gave them, so later steps can refer back to "the Location Gujarat" or "its parent".
 */
import type { ApiResult, LocationApiCall, SubmitOutcome } from '../pages/location';
import { LocationTestData, normalizeLocationText } from '../test-data/location.data';

export interface LocationFixture {
  id: number;
  /** FRD name the feature file used ("Gujarat"). */
  frd: string;
  /** Name / code as created (the app may normalise them; compare case-insensitively). */
  name: string;
  code: string;
  /** FRD name of the Location Category this fixture was created under. */
  categoryFrd: string;
  /** FRD name of the parent Location this fixture was created under, if any. */
  parentFrd?: string;
}

/** What the user typed into the open Add / Edit form, so the stored record can be compared with it. */
export interface EnteredValues {
  name?: string;
  code?: string;
  categoryFrd?: string;
  parentCategoryFrd?: string;
  parentFrd?: string;
}

export class LocationScenario {
  readonly data = new LocationTestData();
  private readonly byFrd = new Map<string, LocationFixture>();

  /** The Location the scenario is currently acting on. */
  target?: LocationFixture;
  /** Values entered into the currently open form, and the record it edits (if any). */
  entered: EnteredValues = {};
  editing?: LocationFixture;
  lastOutcome?: SubmitOutcome;
  lastDelete?: LocationApiCall;
  /** Result of the last request the scenario sent straight to the API. */
  apiResult?: ApiResult;
  /** Whether the last attempt to make a Location its own / its descendant's parent was possible in the UI. */
  parentOptionOffered?: boolean;
  /** Locations created via the UI by earlier steps of the scenario, in order. */
  readonly createdViaUi: LocationFixture[] = [];
  /** ID noted from the API before an action ("I note the Location ID of Nashik"). */
  notedId?: number;
  /** Master records snapshotted before an action, to prove "nothing changed". */
  snapshot?: Array<{ id: number; name: string; code: string; parentId: number | null }>;
  /** The grid has to be reloaded before the next UI step because fixtures were created through the API. */
  needsRefresh = false;
  /** Free-form values a feature's own steps hand to each other (see the step file that sets them). */
  readonly scratch: Record<string, unknown> = {};
  /** Search text last entered and the column it was applied to. */
  lastSearch?: { text: string; column: 'Location Name' | 'Loc Code' | 'Category' };

  remember(fixture: LocationFixture): LocationFixture {
    this.byFrd.set(normalizeLocationText(fixture.frd), fixture);
    this.target = fixture;
    return fixture;
  }

  fixture(frdName: string): LocationFixture | undefined {
    return this.byFrd.get(normalizeLocationText(frdName));
  }

  fixtures(): LocationFixture[] {
    return [...this.byFrd.values()];
  }

  /** Updates a fixture after the app changed it (rename, code change, new parent). */
  refresh(id: number, values: Partial<LocationFixture>): void {
    for (const fixture of [...this.byFrd.values(), ...this.createdViaUi]) {
      if (fixture.id === id) Object.assign(fixture, values);
    }
  }
}
