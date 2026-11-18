/**
 * AuthN/AuthZ hooks.
 *
 * Before: records the scenario's tags (so `withTc` and the shared-step registry work even if the shared Before hook is absent), and
 * skips the scenario in a SHARED_SESSION run: this module tests login and needs a clean, unauthenticated context.
 * After:  runs the scenario's registered clean-ups (restore a password, unlock a user, remove a seeded mapping), newest first. Each is
 *         idempotent, failures are reported without a secret and never mask the scenario result, and nothing here touches a record the
 *         scenario did not create.
 */
import { After, Before, type ITestCaseHookParameter } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { authScenario } from '../../support/authorization-authentication-scenario';
import { config } from '../../support/config';
import { rememberScenarioTags } from '../../support/shared-step-registry';
import { SKIP } from '../../test-data/authorization-authentication.data';

Before({ tags: '@AuthNAuthZ', name: 'AuthN/AuthZ: remember tags, refuse a shared session' }, function (this: CustomWorld, { pickle }: ITestCaseHookParameter) {
  rememberScenarioTags(this, pickle.tags.map((tag) => tag.name));
  if (config.sharedSession) {
    this.log(`Skipped: ${SKIP.sharedSession}`);
    return 'skipped';
  }
  return undefined;
});

After({ tags: '@AuthNAuthZ', name: 'AuthN/AuthZ: run clean-ups' }, async function (this: CustomWorld) {
  const cleanups = authScenario(this).cleanups;
  while (cleanups.length > 0) {
    const cleanup = cleanups.pop()!;
    try {
      await cleanup();
    } catch (error) {
      this.log(`AuthN/AuthZ clean-up failed: ${(error as Error).message}`);
    }
  }
});
