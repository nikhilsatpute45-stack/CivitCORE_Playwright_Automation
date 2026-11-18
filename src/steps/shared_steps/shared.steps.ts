/**
 * Step phrases shared word for word by several modules' feature files (see src/support/shared-step-registry.ts). Each is
 * registered once, here, and routed to the handler of the scenario's own module. Keep this file byte-identical on every branch.
 */
import { Before, Given, Then, When, type DataTable } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { rememberScenarioTags, sharedHandlers, type SharedResult } from '../../support/shared-step-registry';

Before({ name: 'Record scenario tags for shared steps' }, async function (this: CustomWorld, { pickle }) {
  rememberScenarioTags(this, pickle.tags.map((tag) => tag.name));
});

Given(/^the following test data is used$/, async function (this: CustomWorld, table: DataTable): SharedResult {
  return sharedHandlers(this).testData(this, table);
});

Given(/^API client authenticated with the token of the user named in Test Data$/, async function (this: CustomWorld): SharedResult {
  return sharedHandlers(this).apiClient(this);
});

Given(/^([A-Za-z]+_User\d+)(?: \([^)]*\))? is logged in$/, async function (this: CustomWorld, user: string): SharedResult {
  return sharedHandlers(this).loggedIn(this, user);
});

When(
  /^the user (observes|inspects|notes|checks|queries|reads|compares|re-counts|exports) ?(.*)$/,
  async function (this: CustomWorld, verb: string, rest: string): SharedResult {
    return sharedHandlers(this).observe(this, verb, rest);
  },
);

Then(/^(Request is rejected \((403(?:\/405)?)\); (.+))$/, async function (this: CustomWorld, sentence: string, codes: string, rest: string): SharedResult {
  return sharedHandlers(this).rejected(this, sentence, codes, rest);
});
