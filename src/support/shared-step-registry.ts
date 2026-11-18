/**
 * Registry for step phrases that more than one module's feature files use word for word.
 *
 * Cucumber step text is global: two modules that each register "the following test data is used" make that step ambiguous
 * as soon as both are loaded. Those phrases are therefore registered ONCE, in src/steps/shared_steps/shared.steps.ts, which
 * routes each call to the handler the scenario's own module registered here (chosen by the module tag on the scenario).
 *
 * THIS FILE AND src/steps/shared_steps/shared.steps.ts MUST STAY BYTE-IDENTICAL ON EVERY BRANCH THAT CONTAINS THEM: identical
 * added files merge without conflict. A new module just calls `registerSharedHandlers('@ItsTag', ...)` from one of its own step files.
 */
import type { DataTable } from '@cucumber/cucumber';
import type { CustomWorld } from './world';

/** The module's feature-level tag, e.g. '@AuditTrail'. Any '@...' tag works, so a new module needs no edit to this file. */
export type ModuleTag = `@${string}`;

export type SharedResult = Promise<'skipped' | undefined | void>;

export interface SharedHandlers {
  /** "the following test data is used" */
  testData: (world: CustomWorld, table: DataTable) => SharedResult;
  /** "API client authenticated with the token of the user named in Test Data" */
  apiClient: (world: CustomWorld) => SharedResult;
  /** "<User> is logged in" and "<User> (<permissions>) is logged in" */
  loggedIn: (world: CustomWorld, user: string) => SharedResult;
  /** "the user observes|inspects|notes|checks|queries|reads|compares|re-counts|exports ..." */
  observe: (world: CustomWorld, verb: string, rest: string) => SharedResult;
  /** "Request is rejected (403[/405]); ..." - the whole sentence, plus the status codes it names. */
  rejected: (world: CustomWorld, sentence: string, codes: string, rest: string) => SharedResult;
}

const handlersByModule = new Map<ModuleTag, SharedHandlers>();
const tagsByWorld = new WeakMap<CustomWorld, string[]>();

export function registerSharedHandlers(module: ModuleTag, handlers: SharedHandlers): void {
  handlersByModule.set(module, handlers);
}

/** Called by the shared Before hook with the running scenario's tags. */
export function rememberScenarioTags(world: CustomWorld, tags: string[]): void {
  tagsByWorld.set(world, tags);
}

/** All tags of the running scenario (empty before the Before hook ran). */
export function scenarioTags(world: CustomWorld): string[] {
  return tagsByWorld.get(world) ?? [];
}

/** "@TC_CP_017" / "@TC-CC-001" for the running scenario, or '' when untagged. */
export function testCaseTag(world: CustomWorld): string {
  return scenarioTags(world).find((tag) => /^@TC[-_]/.test(tag)) ?? '';
}

export function sharedHandlers(world: CustomWorld): SharedHandlers {
  const tags = scenarioTags(world);
  for (const [module, handlers] of handlersByModule) {
    if (tags.includes(module)) return handlers;
  }
  throw new Error(
    `No module registered a handler for this scenario's tags (${tags.join(' ') || 'none'}); ` +
      `expected one of: ${[...handlersByModule.keys()].join(', ') || 'no module loaded'}.`,
  );
}
