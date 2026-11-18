/**
 * Form-input helpers of the Miscellaneous Master steps (no steps are registered here): what to type for "the user enters Field
 * Title with a script tag" and friends, and typing it into the Add / Edit pop-up while remembering it in the scenario.
 */
import type { CustomWorld } from '../../support/world';
import { mmPages, mmScenario } from '../../support/miscellaneous-master-scenario';
import { FIELD_LIMITS } from '../../test-data/miscellaneous-master.data';
import type { TextField } from '../../pages/miscellaneous_master_pages';
import { filler, testDatum, withTc } from './helpers';

export type { TextField };

/** Value for a descriptive phrase ("with a script tag", "in mixed case", ...) when the test data supplies none. */
export function phraseValue(field: TextField, phrase: string): string {
  const title = field === 'Field Title';
  if (/script tag/i.test(phrase)) return '<script>alert("mm")</script>';
  if (/SQL/i.test(phrase)) return "Title'; DROP TABLE MiscMaster;--";
  if (/special characters/i.test(phrase)) return 'Site/Plant #1 (Main) - <A&B>';
  if (/runs of internal spaces|repeated internal spaces/i.test(phrase)) return 'Contractor    Grade    Level';
  if (/mixed case/i.test(phrase)) return 'cOnTrAcToR cLaSs';
  if (/leading and trailing spaces|surrounded by spaces/i.test(phrase)) return title ? '  Contractor Grade  ' : '  501  ';
  if (/leading zeros/i.test(phrase)) return '0012';
  if (/10-digit/i.test(phrase)) return '1234567890';
  if (/decimal/i.test(phrase)) return '12.5';
  return title ? 'Contractor Grade' : '501';
}

/** The scenario's own value for the field: its test-data row when present, otherwise generated from the phrase. */
export function valueFor(world: CustomWorld, field: TextField, phrase = '', nth = 1): string {
  return testDatum(world, field, nth) ?? phraseValue(field, phrase);
}

export async function enterField(world: CustomWorld, field: TextField, value: string, mode: 'fill' | 'type' | 'paste' = 'fill'): Promise<void> {
  const { form } = mmPages(world);
  if (mode === 'type') await form.type(field, value);
  else if (mode === 'paste') await form.paste(field, value);
  else await form.fill(field, value);
  const entered = mmScenario(world).entered;
  if (field === 'Field Title') entered.fieldTitle = value;
  else entered.enumId = value;
}

export async function enterFromData(world: CustomWorld, field: TextField, phrase = '', nth = 1): Promise<void> {
  await enterField(world, field, valueFor(world, field, phrase, nth));
}

export async function selectParent(world: CustomWorld, name: string): Promise<void> {
  await mmPages(world).form.selectParent(name);
  mmScenario(world).entered.parentTitle = name;
}

export function repeatToLength(length: number): string {
  return filler(length, 'X');
}

export function limitOf(field: TextField): number {
  return field === 'Field Title' ? FIELD_LIMITS.fieldTitle : FIELD_LIMITS.enumIdDigits;
}

/** Swaps the case of every letter, for the "different letter case" scenarios. */
export function swapCase(value: string): string {
  return value.replace(/[A-Za-z]/g, (char) => (char === char.toUpperCase() ? char.toLowerCase() : char.toUpperCase()));
}

/** Fails with the scenario's TC id when a required test-data value is missing. */
export function mustHave(world: CustomWorld, value: string | undefined, what: string): string {
  if (value === undefined || value === '') throw new Error(withTc(world, `The scenario's test data has no value for ${what}.`));
  return value;
}
