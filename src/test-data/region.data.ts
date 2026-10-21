/**
 * Region Management test data.
 *
 * The Region module (features/region_management_features) does not exist yet in the live MIDC build
 * (no "Region" tab under Organization Configuration, no Region API). Everything here mirrors the
 * vocabulary conventions of the completed modules (see location-category.data.ts / location.data.ts)
 * so the step definitions read the same way, but the message aliases and endpoint-shaped constants
 * are necessarily guesses, marked (unconfirmed), to be corrected once the module is built.
 *
 * Set STRICT_FRD_MESSAGES=true to assert the FRD message copy verbatim instead of the alias list.
 */
import { config } from '../support/config';
import { escapeRegExp } from '../utils/assertions';

export const regionMessages = {
  deleteConfirmation: /permanently delete|delete.*region/i,
} as const;

/**
 * FRD message -> tolerant alternative wording. No live build exists to confirm alternate copy against,
 * so every alias is the FRD text itself; the patterns stay deliberately loose (case-insensitive, the
 * FRD punctuation optional) so a close-but-not-identical real message still matches once the screen exists.
 */
export const regionMessageAliases: Record<string, Array<string | RegExp>> = {
  'Region Name is required': [/region\s*name.*(required|mandatory|cannot be (blank|empty))/i],
  'A Region with this name already exists.': [/region.*(already exists|duplicate)/i],
};

export function normalizeRegionText(value: string): string {
  return value.trim().replace(/\s+/g, ' ').toLowerCase();
}

function messageCore(message: string): string {
  const core = message.trim().replace(/[.!]+$/, '');
  return escapeRegExp(core).replace(/\s+/g, '\\s+');
}

/** Pattern for an FRD message: the FRD copy itself, or (unless strict) its alias patterns. */
export function regionMessagePattern(message: string): RegExp {
  const aliases = config.strictFrdMessages ? [] : (regionMessageAliases[message.trim()] ?? []);
  const alternatives = [messageCore(message), ...aliases.map((alias) => (typeof alias === 'string' ? messageCore(alias) : alias.source))];
  return new RegExp(alternatives.join('|'), 'i');
}

/** Text of any message that explains why a Region cannot be deleted (Office / Location dependency). */
export const REGION_DELETION_BLOCKED_PATTERN =
  /(cannot|can't|unable to|not allowed).{0,40}delet|delet.{0,80}(because|since|associated|office|location|in use)/i;

/** Organization the Region tab would be opened for, same convention as every other Setup module. */
export const API_ORG_ID = 1;

/**
 * Per-scenario unique test data, same shape as LocationCategoryTestData / LocationTestData: every
 * Region / Office / Location name a scenario types gets this scenario's suffix so it never collides
 * with another scenario or with real data, and leftovers are easy to find (filter for "Bdd").
 */
export class RegionTestData {
  readonly suffix: string;
  private readonly digits: string;
  private codeCounter = 0;

  constructor(now: number = Date.now(), random: number = Math.random()) {
    const digits = `${now % 10_000_000}`.padStart(7, '0') + Math.floor(random * 10);
    this.digits = digits;
    this.suffix = `Bdd${digits}`;
  }

  /** "Central Region" -> "Central Region Bdd12345678"; blank / whitespace-only values are kept as typed. */
  name(value: string): string {
    return this.decorate(value, (core) => `${core} ${this.suffix}`);
  }

  /** Unique code for placeholder Office / Location fixtures created in support of a Region scenario. */
  code(): string {
    this.codeCounter += 1;
    return `R${this.digits.slice(-6)}${this.codeCounter}`;
  }

  /** True when a stored name belongs to this scenario's data (every name it creates carries the suffix). */
  owns(name: string): boolean {
    return name.toLowerCase().includes(this.suffix.toLowerCase());
  }

  private decorate(value: string, transform: (core: string) => string): string {
    if (value.trim() === '') return value;
    const [, lead, core, trail] = /^(\s*)(.*?)(\s*)$/s.exec(value)!;
    return `${lead}${transform(core)}${trail}`;
  }
}
