/**
 * Scenario-scoped state of the AuthN/AuthZ steps, plus the lazily-built AuthPages of this scenario.
 *
 * Same wiring as src/support/audit-trail-scenario.ts: a WeakMap from the running CustomWorld to this module's own pages / state, so
 * src/support/world.ts and src/pages/index.ts stay untouched. Cucumber creates one fresh CustomWorld per scenario.
 */
import type { CustomWorld } from './world';
import { AuthPages } from '../pages/authorization_authentication_pages';

export type Cleanup = () => Promise<void>;

/** What one click on Login produced: the messages the screen showed and how many authentication requests it sent. */
export interface AttemptRecord {
  persona?: string;
  messages: string[];
  authRequests: number;
}

export class AuthScenario {
  /** Persona the scenario signed in as ("rahul.sharma"), if any. */
  persona?: string;
  testRows: string[][] = [];
  testData: Record<string, string> = {};
  /** Every Login click of the scenario, oldest first. */
  readonly attempts: AttemptRecord[] = [];
  /** Idempotent undo actions (restore a password, unlock a user, remove a seeded mapping). Run by the After hook, newest first. */
  readonly cleanups: Cleanup[] = [];
  /** Free-form values one feature's own steps hand to each other (observations of the screen, noted values). */
  readonly scratch: Record<string, unknown> = {};

  /** Value of a test-data table key, '' when absent. */
  datum(key: string): string {
    return this.testData[key] ?? '';
  }
}

const pagesByWorld = new WeakMap<CustomWorld, AuthPages>();
const scenarioByWorld = new WeakMap<CustomWorld, AuthScenario>();

/** This scenario's AuthPages, built the first time an AuthN/AuthZ step needs it. */
export function authPages(world: CustomWorld): AuthPages {
  let pages = pagesByWorld.get(world);
  if (!pages) {
    pages = new AuthPages(world.page);
    pagesByWorld.set(world, pages);
  }
  return pages;
}

/** This scenario's AuthN/AuthZ bookkeeping, built the first time an AuthN/AuthZ step needs it. */
export function authScenario(world: CustomWorld): AuthScenario {
  let scenario = scenarioByWorld.get(world);
  if (!scenario) {
    scenario = new AuthScenario();
    scenarioByWorld.set(world, scenario);
  }
  return scenario;
}
