/**
 * Outcome ("Then") steps of the Miscellaneous Master features: every sentence in OUTCOME_SENTENCES (outcome_sentences.ts) is routed
 * to ONE step; verifyOutcome (./outcomes.ts) reads every fact in the sentence and skips, with a reason, one it cannot verify.
 * "Request is rejected (403[/405]); ..." is routed through the shared registry (shared_handlers.steps.ts).
 */
import { Then } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { OUTCOME_SENTENCES } from './outcome_sentences';
import { verifyOutcome } from './outcomes';
import type { Skippable } from './helpers';

Then(new RegExp(`^(${OUTCOME_SENTENCES.join('|')})$`), async function (this: CustomWorld, text: string): Skippable {
  return verifyOutcome(this, text);
});
