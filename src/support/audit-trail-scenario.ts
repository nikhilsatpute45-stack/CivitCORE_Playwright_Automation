/**
 * Scenario-scoped state of the Audit Trail steps, plus the lazily-built AuditTrailPages of this scenario.
 *
 * Same wiring as src/support/region-scenario.ts: a WeakMap from the running CustomWorld to this module's own pages / state, so that
 * the shared CustomWorld class (src/support/world.ts) and src/pages/index.ts stay untouched. Cucumber creates one fresh CustomWorld per
 * scenario, so this is exactly as scenario-scoped as `world.location` etc.
 */
import type { CustomWorld } from './world';
import { AuditTrailPages } from '../pages/audit_trail_pages';
import type { ApiResult, AuditEntry, AuditRow } from '../pages/audit_trail_pages';
import { runDate } from '../test-data/audit-trail.data';

export type ClearOutcome = 'dialog-open' | 'confirmed' | 'cancelled' | 'blocked';

export interface DateRange {
  from: string;
  to: string;
}

export class AuditTrailScenario {
  /** "Today (T)" of the scenario: the REAL run date. Literal feature dates are shifted relative to it. */
  today = runDate();
  /** True after "System date is set to ...": the dates the feature then quotes are real calendar dates, not offsets from T. */
  literalDates = false;
  /** User of the scenario's own login step ("Viewer_User1"). */
  user?: string;
  testRows: string[][] = [];
  testData: Record<string, string> = {};
  /** "API client authenticated with the token of the user named in Test Data" was seen; the login happens once the table is read. */
  apiClientRequested = false;

  /** Last response of a request sent straight to the API, and the entries parsed from the last successful get-entries call. */
  lastApi?: ApiResult;
  lastEntries: AuditEntry[] = [];
  /** Responses of the several requests one step may send (kept so "rejected" can be asserted for all). */
  lastApis: ApiResult[] = [];

  /** Rows of the listing right after the screen was opened (for "Grid is unchanged" / "listing remains unchanged"). */
  initialRows?: AuditRow[];
  /** Grid snapshot noted before an action ("Note the currently displayed grid"). */
  snapshot?: AuditRow[];
  /** Entry count noted before an action ("Note the count of entries in the audit store"). */
  notedCount?: number;
  /** Date range the scenario typed into the filters, as typed. */
  typedRange: Partial<DateRange> = {};

  clearOutcome?: ClearOutcome;
  /** Result of "Inspect the navigation menu" / "Look for Audit Trail in the menu". */
  menuVisible?: boolean;
  /** Result of opening the screen URL directly. */
  directAccess?: { displayed: boolean };
  /** Browser-clock date set by "System date is set to ...". */
  clockDate?: Date;
  /** Free-form values one feature's own steps hand to each other. */
  readonly scratch: Record<string, unknown> = {};

  /** Value a "Read ..." step noted from the screen. */
  readValue?: string;

  /** Value of a test-data table key, '' when absent. */
  datum(key: string): string {
    return this.testData[key] ?? '';
  }
}

const pagesByWorld = new WeakMap<CustomWorld, AuditTrailPages>();
const scenarioByWorld = new WeakMap<CustomWorld, AuditTrailScenario>();

/** This scenario's AuditTrailPages, built the first time an Audit Trail step needs it (before any login, so the API sees the token). */
export function auditPages(world: CustomWorld): AuditTrailPages {
  let pages = pagesByWorld.get(world);
  if (!pages) {
    pages = new AuditTrailPages(world.page);
    pagesByWorld.set(world, pages);
  }
  return pages;
}

/** This scenario's Audit Trail bookkeeping, built the first time an Audit Trail step needs it. */
export function auditScenario(world: CustomWorld): AuditTrailScenario {
  let scenario = scenarioByWorld.get(world);
  if (!scenario) {
    scenario = new AuditTrailScenario();
    scenarioByWorld.set(world, scenario);
  }
  return scenario;
}
