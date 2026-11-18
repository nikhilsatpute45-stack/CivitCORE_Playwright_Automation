/**
 * Steps of features/authorization_authentication_features/reset_password_ui.feature (@ResetPasswordUi, TC_CP_135).
 * "Reset Password screen is open" is in common.steps.ts.
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { authPages, authScenario } from '../../support/authorization-authentication-scenario';
import { expect } from '../../utils/assertions';
import { exact, withTc } from './helpers';

When(exact('the user tries clicking the checklist items'), async function (this: CustomWorld) {
  const { reset } = authPages(this);
  const scenario = authScenario(this);
  scenario.scratch.checklistBefore = await reset.items();
  await reset.clickEachItem();
  scenario.scratch.checklistAfter = await reset.items();
});

Then(exact('Checklist cannot be edited and changes only through typing in New Password (6.4 F-Checklist)'), async function (this: CustomWorld) {
  const { reset } = authPages(this);
  const { scratch } = authScenario(this);
  expect((scratch.checklistBefore as unknown[]).length, withTc(this, 'the checklist lists the password rules')).toBeGreaterThan(0);
  expect(await reset.editableControlCount(), withTc(this, 'the checklist contains no input control')).toBe(0);
  expect(scratch.checklistAfter, withTc(this, 'clicking the checklist items changes nothing')).toEqual(scratch.checklistBefore);

  // The checklist DOES react to typing in New Password (a value that meets every rule changes at least one item's state).
  await reset.typeNewPassword('Abcdefg1!x');
  expect(await reset.items(), withTc(this, 'typing in New Password updates the checklist')).not.toEqual(scratch.checklistBefore);
});
