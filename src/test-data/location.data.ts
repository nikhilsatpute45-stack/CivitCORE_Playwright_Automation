/**
 * Location Management test data.
 *
 * The feature files (features/location_features) are written against an FRD spec that assumes:
 *  - A 12-record baseline (INDIA > Gujarat/Maharashtra/Bihar > districts > 2 cities) as if it were the whole
 *    Location Master. The live MIDC build holds ~2,700 real Locations under organization "MIDC", none of
 *    which are this baseline. Scenarios therefore get their own uniquely-suffixed copy of every baseline
 *    name they use (see ensureLocation in src/steps/location_steps/helpers.ts), created through the API and
 *    removed afterwards, exactly like location-category.data.ts does for Location Category.
 *  - A category named "State/Territory". The live Location Category master has "State", not "State/Territory"
 *    (confirmed live: City, Country, External Department, MIDC, Industrial Area, State, District, Taluka,
 *    Block, Village, Zip Code, Head Office, Zone, Regional Office, Fire Station, MDO1, Circle, Division
 *    Office, Sub Division Office, Ware House, Pune QC, Zone1, Region). FRD -> live names are mapped below.
 *  - A standalone "Region" dropdown (Northern / Western / Southern / Eastern Region) on the Add/Edit Location
 *    form. Confirmed live: no such field exists. "Region" is only one more value inside the Location Category
 *    select, unrelated to the FRD's Region concept. Every Region-only scenario is skipped (no field to test);
 *    "I select Region ..." inside an otherwise-real scenario is logged as a no-op, not asserted.
 *  - Office creation references a Location (lookup / Location ID). Confirmed live: the Add/Edit Office dialog
 *    (Office *, Office Code *, Office Category *, Parent Category, Parent Office) has no Location field at
 *    all; Office and Location are independent hierarchies in this build. Every office_association.feature
 *    scenario is skipped for this reason (see locationOfficeAssociationGap below).
 *  - CivitBUILD / CivitINFRA screens reachable from this portal. Confirmed live: zero references to either
 *    product anywhere in the portal (no link, menu, or URL). product_consumption.feature is skipped entirely.
 *  - An Activity / Audit Log screen. The Location Category module (same Organization Configuration tab strip:
 *    Department, Designation, Location Category, Location, Office Category, Office, Position, Industrial
 *    Area) already confirmed it has none; audit_log.feature is skipped on the same probe-and-fail-loudly
 *    pattern as src/steps/location_category_steps/hooks.ts.
 *
 * Confirmed live field ids (Add/Edit Location dialog, shared with the Location tab nested inside Location
 * Category): #LocationName ("Location *"), #LocationAbb ("Location Code *", max 20 characters - the FRD calls
 * this field "Short Name" with a 30-character limit; both the name and the limit are translated here),
 * #locCateg ("Location Category *"), #parentCateg ("Parent Category" - the FRD's "Parent Location Category"),
 * #parentLocation ("Parent Location"). Submit button: "Add Location" / "Update Location". Grid columns:
 * Location Name, Loc Code, Category, Hierarchy, Actions (treegrid, same AG Grid engine as Location Category).
 * Row menu: Edit, Delete only (no separate View action - resolves the FRD's own "confirm" note in
 * location_ui.feature TC-Loc-057).
 *
 * Set STRICT_FRD_MESSAGES=true to assert the FRD message copy verbatim instead of the app's copy.
 */
import { config } from '../support/config';
import { escapeRegExp } from '../utils/assertions';

export interface BaselineLocation {
  name: string;
  /** FRD name of the Location Category this node is created under. */
  category: string;
  code: string;
  parent?: string;
}

/** FRD baseline hierarchy: INDIA (Country) > Gujarat/Maharashtra/Bihar (State) > districts > 2 cities. */
export const baselineLocations: readonly BaselineLocation[] = [
  { name: 'INDIA', category: 'Country', code: 'IND' },
  { name: 'Gujarat', category: 'State/Territory', code: 'GJ', parent: 'INDIA' },
  { name: 'Maharashtra', category: 'State/Territory', code: 'MH', parent: 'INDIA' },
  { name: 'Bihar', category: 'State/Territory', code: 'BR', parent: 'INDIA' },
  { name: 'Ahmedabad', category: 'District', code: 'AHM', parent: 'Gujarat' },
  { name: 'Surat', category: 'District', code: 'SRT', parent: 'Gujarat' },
  { name: 'Mumbai', category: 'District', code: 'MUM', parent: 'Maharashtra' },
  { name: 'Pune', category: 'District', code: 'PUN', parent: 'Maharashtra' },
  { name: 'Nashik', category: 'District', code: 'NSK', parent: 'Maharashtra' },
  { name: 'Patna', category: 'District', code: 'PTN', parent: 'Bihar' },
  { name: 'Ahmedabad City', category: 'City', code: 'AHMC', parent: 'Ahmedabad' },
  { name: 'Pune City', category: 'City', code: 'PUNC', parent: 'Pune' },
];

export const baselineNames: readonly string[] = baselineLocations.map((location) => location.name);

export function baselineLocation(name: string): BaselineLocation | undefined {
  const key = normalizeLocationText(name);
  return baselineLocations.find((location) => normalizeLocationText(location.name) === key);
}

/** FRD Location Category wording -> the live Location Category Master value. Identical except "State/Territory". */
export const locationCategoryAliases: Record<string, string> = {
  'State/Territory': 'State',
};

export function liveLocationCategory(frdName: string): string {
  return locationCategoryAliases[frdName] ?? frdName;
}

/** Organization the Location tab is opened for. */
export const API_ORG_ID = 1;

/** The live Add/Edit Office form has no field that references a Location (confirmed live, see file header). */
export const LOCATION_OFFICE_ASSOCIATION_GAP =
  'the Add/Edit Office form (Office *, Office Code *, Office Category *, Parent Category, Parent Office) has ' +
  'no Location field in this build; Office and Location are independent hierarchies with no association to test.';

/** The live Add/Edit Location form has no Region field (confirmed live, see file header). */
export const NO_REGION_FIELD = 'the Add/Edit Location form has no Region field in this build (only a Location Category select, whose values do not include a region list).';

/** No product named CivitBUILD or CivitINFRA is reachable from this portal (confirmed live, see file header). */
export const NO_PRODUCT_CONSUMERS =
  'CivitBUILD and CivitINFRA are not reachable from this portal: no link, menu entry or URL for either product exists here, and no credentials for them are configured.';

export const locationMessages = {
  deleteConfirmation: /permanently delete/i,
} as const;

/**
 * FRD message -> what the MIDC build shows for the same outcome (strings or patterns). Entries marked
 * (unconfirmed) were not observed on the live build yet; they use a tolerant pattern and should be
 * tightened once the real run has shown the actual text (see location-category.data.ts for precedent).
 */
export const locationMessageAliases: Record<string, Array<string | RegExp>> = {
  'Location created successfully.': [/location (added|created) successfully/i],
  'Location updated successfully.': [/location (updated|edited|modified) successfully/i],
  'Location deleted successfully.': [/location deleted successfully/i],
  'Name is required': [/location (name )?is required/i],
  'Short Name is required': [/location code is required/i],
  'Location Category is required': [/location category is required/i],
  'Parent Location is required': [/parent location is required/i],
  'Name already exists': [/^(?=.*location)(?=.*(already exists|same|duplicate))/i],
  'Short Name already exists': [/^(?=.*(code|short))(?=.*(already exists|same|duplicate))/i],
  'Invalid Parent Location': [/^(?=.*parent)(?=.*(not found|invalid|does not exist))/i],
  'Invalid Region': [/^(?=.*region)(?=.*(not found|invalid|does not exist))/i],
};

export const DELETION_BLOCKED_PATTERN = /(cannot|can't|unable to|not allowed).{0,40}delet|delet.{0,80}(because|since|associated|child|office|location)/i;

export function normalizeLocationText(value: string): string {
  return value.trim().replace(/\s+/g, ' ').toLowerCase();
}

function messageCore(message: string): string {
  const core = message.trim().replace(/[.!]+$/, '');
  return escapeRegExp(core).replace(/\s+/g, '\\s+');
}

/** Pattern for an FRD message: the FRD copy itself, or (unless strict) the app's copy for it. */
export function locationMessagePattern(message: string): RegExp {
  const aliases = config.strictFrdMessages ? [] : (locationMessageAliases[message.trim()] ?? []);
  const alternatives = [messageCore(message), ...aliases.map((alias) => (typeof alias === 'string' ? messageCore(alias) : alias.source))];
  return new RegExp(alternatives.join('|'), 'i');
}

/** The Location Code field's confirmed live limit (the FRD calls the field "Short Name" and gives it 30). */
const LOCATION_CODE_MAX_LENGTH = 20;

/**
 * Per-scenario unique test data. Every Name / Location Code taken from a feature file gets the scenario's
 * suffix, so scenarios never collide with each other or with the ~2,700 real Locations, while the
 * relationships the scenario is about survive ("Surat" and "SURAT" still differ only by case). The fixed
 * "Bdd" marker makes leftovers easy to find: filter the Location grid's Location Name column for "Bdd".
 */
export class LocationTestData {
  readonly suffix: string;
  readonly shortSuffix: string;

  constructor(now: number = Date.now(), random: number = Math.random()) {
    const digits = `${now % 10_000_000}`.padStart(7, '0') + Math.floor(random * 10);
    this.suffix = `Bdd${digits}`;
    this.shortSuffix = digits.slice(-4);
  }

  /** "Gujarat" -> "Gujarat Bdd12345678"; blank / whitespace-only values are kept. */
  name(value: string): string {
    return this.decorate(value, (core) => `${core} ${this.suffix}`);
  }

  /**
   * "GJ" -> "GJ1234" within the live 20-character limit. A value with no room left for the suffix is kept as
   * it is; the record is still found by its suffixed Name.
   */
  code(value: string): string {
    return this.decorate(value, (core) => (core.length + this.shortSuffix.length > LOCATION_CODE_MAX_LENGTH ? core : `${core}${this.shortSuffix}`));
  }

  /** True when a stored Name belongs to this scenario's data (every name the scenario creates carries the suffix). */
  owns(name: string): boolean {
    return name.toLowerCase().includes(this.suffix.toLowerCase());
  }

  private decorate(value: string, transform: (core: string) => string): string {
    if (value.trim() === '') return value;
    const [, lead, core, trail] = /^(\s*)(.*?)(\s*)$/s.exec(value)!;
    return `${lead}${transform(core)}${trail}`;
  }
}
