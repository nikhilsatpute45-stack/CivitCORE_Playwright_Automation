/**
 * Audit Trail test data (features/audit_trail_features, FRD CC-F-005, workbook CivitCORE_AuditTrail_TestCases.xlsx).
 *
 * The product is in its design phase, so nothing here has been observed on a live build: wording is the FRD / workbook
 * Summary text (note 5) verbatim, and anything the FRD leaves open is marked (unconfirmed).
 *
 * DATES: the feature files are written around "Today (T) = 16-Nov-2026". Every date literal in a step or test-data table is
 * therefore converted to "the same number of days from T" relative to the REAL run date (see `shiftToRun`), so the baseline
 * the workbook describes (T-0, T-2, ...) can be re-seeded on any day without editing the features.
 */

// ---------------------------------------------------------------------------
// Users (Summary note 3) -> credential keys understood by getRoleCredentials()
// ---------------------------------------------------------------------------

export const AUDIT_USERS = {
  Admin_User1: { key: 'ADMIN', permissions: 'View Audit Trail + Clear Audit Log' },
  Viewer_User1: { key: 'VIEWER', permissions: 'View Audit Trail only' },
  ClearOnly_User1: { key: 'CLEARONLY', permissions: 'Clear Audit Log only' },
  NoAccess_User1: { key: 'NOACCESS', permissions: 'none' },
} as const;

export type AuditUserName = keyof typeof AUDIT_USERS;

/** "Viewer_User1" -> "VIEWER"; "Admin_User1" -> "ADMIN" (default MIDC_USERNAME); unknown users fall back to their own prefix. */
export function roleKeyOfUser(user: string): string {
  const known = AUDIT_USERS[user as AuditUserName];
  if (known) return known.key;
  return user.replace(/_User\d+$/i, '').replace(/[^A-Za-z]/g, '').toUpperCase();
}

// ---------------------------------------------------------------------------
// Vocabulary (FRD term -> UI wording)
// ---------------------------------------------------------------------------

/** Functions configured in the backend mapping (Summary: "Configured Functions (sample)"). */
export const CONFIGURED_FUNCTIONS = ['Department', 'Office', 'Organization', 'Post', 'Standards & Formats'] as const;
export const DEFAULT_FUNCTION = 'All';
/** Default From Date is this many calendar days before the To Date (FRD 6.3). */
export const DEFAULT_RANGE_DAYS = 30;

/** Columns of the Audit Log grid in FRD order (C-xxx). */
export const AUDIT_COLUMNS = ['Sl No.', 'Function Name', 'Log Date & Time', 'Class Name', 'Client IP', 'Message'] as const;
export type AuditColumn = (typeof AUDIT_COLUMNS)[number];

export const PERMISSIONS = { view: 'View Audit Trail', clear: 'Clear Audit Log' } as const;

/** Verbatim messages (Summary note 5). */
export const AUDIT_MESSAGES = {
  fromRequired: 'From Date is required',
  fromLater: 'From Date cannot be later than To Date',
  toRequired: 'To Date is required',
  toEarlier: 'To Date cannot be earlier than From Date',
  toFuture: 'To Date cannot be future Date',
  cleared: 'Audit log cleared successfully for the selected date range.',
} as const;

export const NO_RECORDS_PATTERN = /no\s+records?\s+found/i;

// ---------------------------------------------------------------------------
// Audit-entry messages (FRD 7.1)
// ---------------------------------------------------------------------------

export type AuditActivity = 'Created' | 'Updated' | 'Deleted' | 'Deletion Blocked';

export function auditMessage(entity: string, activity: AuditActivity): string {
  switch (activity) {
    case 'Created':
      return `${entity} created successfully.`;
    case 'Updated':
      return `${entity} updated successfully.`;
    case 'Deleted':
      return `${entity} deleted successfully.`;
    case 'Deletion Blocked':
      return `${entity} deletion blocked as its used in further processes.`;
  }
}

/** Whitespace- and case-insensitive text comparison used for every message / cell assertion. */
export function sameText(actual: string | undefined, expected: string): boolean {
  const norm = (value: string): string => value.replace(/\s+/g, ' ').trim().toLowerCase();
  return norm(actual ?? '') === norm(expected);
}

// ---------------------------------------------------------------------------
// Dates
// ---------------------------------------------------------------------------

const MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'] as const;
const DAY_MS = 24 * 60 * 60 * 1000;
const FEATURE_TODAY_UTC = Date.UTC(2026, 10, 16);

/** `DD-Mon-YYYY` anywhere in a string. */
export const FEATURE_DATE_PATTERN = /\b(\d{2})-([A-Z][a-z]{2})-(\d{4})\b/g;
/** `DD-Mon` (year omitted, as in "16-Nov 09:30") followed by a time; the year is that of the feature's T. */
export const FEATURE_DAY_TIME_PATTERN = /\b(\d{2})-([A-Z][a-z]{2})(?:-(\d{4}))?[ ,]+(\d{2}):(\d{2})(?::(\d{2}))?/g;

/** Today's calendar date as a UTC-midnight Date (time zone of the machine running the tests). */
export function runDate(now: Date = new Date()): Date {
  return new Date(Date.UTC(now.getFullYear(), now.getMonth(), now.getDate()));
}

export function makeDate(day: number, monthName: string, year: number): Date | undefined {
  const month = MONTHS.indexOf(monthName as (typeof MONTHS)[number]);
  if (month < 0) return undefined;
  const date = new Date(Date.UTC(year, month, day));
  // Rejects non-existent dates such as 31-Nov-2026 (Date would roll them over).
  return date.getUTCDate() === day && date.getUTCMonth() === month ? date : undefined;
}

/** "16-Nov-2026" -> Date; undefined when the text is not exactly one valid date. */
export function parseFeatureDate(text: string): Date | undefined {
  const match = /^(\d{2})-([A-Z][a-z]{2})-(\d{4})$/.exec(text.trim());
  return match ? makeDate(Number(match[1]), match[2], Number(match[3])) : undefined;
}

export function addDays(date: Date, days: number): Date {
  return new Date(date.getTime() + days * DAY_MS);
}

/** Whole calendar days a feature date lies from the feature's T (16-Nov-2026). */
export function offsetFromFeatureToday(featureDate: Date): number {
  return Math.round((featureDate.getTime() - FEATURE_TODAY_UTC) / DAY_MS);
}

/** The same distance from T, applied to the real run date. */
export function shiftToRun(featureDate: Date, today: Date): Date {
  return addDays(today, offsetFromFeatureToday(featureDate));
}

export function formatDate(date: Date): string {
  return `${String(date.getUTCDate()).padStart(2, '0')}-${MONTHS[date.getUTCMonth()]}-${date.getUTCFullYear()}`;
}

export function isoDate(date: Date): string {
  return date.toISOString().slice(0, 10);
}

/**
 * Replaces every valid `DD-Mon-YYYY` in `text` by its run-date equivalent. A non-existent date ("31-Nov-2026",
 * "30-Feb-2026") is left untouched on purpose: scenarios type it to prove the app rejects it.
 */
export function shiftText(text: string, today: Date): string {
  return text.replace(FEATURE_DATE_PATTERN, (whole, day: string, month: string, year: string) => {
    const date = makeDate(Number(day), month, Number(year));
    return date ? formatDate(shiftToRun(date, today)) : whole;
  });
}

/** "01-Sep-2026" -> "2026-09-01" (the API form); throws for anything that is not one valid date. */
export function featureDateToIso(literal: string): string {
  const date = parseFeatureDate(literal);
  if (!date) throw new Error(`"${literal}" is not a valid DD-Mon-YYYY date.`);
  return isoDate(date);
}

/** `YYYY-MM-DD` (API form) -> run-date equivalent; anything else (e.g. an injection string) is returned unchanged. */
export function shiftIso(text: string, today: Date): string {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(text.trim());
  if (!match) return text;
  const date = new Date(Date.UTC(Number(match[1]), Number(match[2]) - 1, Number(match[3])));
  return isoDate(shiftToRun(date, today));
}

export interface TimedEntryRef {
  /** Date relative to the run date. */
  date: Date;
  hours: number;
  minutes: number;
}

/** "16-Nov 09:30" / "14-Nov-2026 15:10" tokens found in a sentence, converted to run-date equivalents. */
export function timedRefs(sentence: string, today: Date): TimedEntryRef[] {
  const refs: TimedEntryRef[] = [];
  for (const match of sentence.matchAll(FEATURE_DAY_TIME_PATTERN)) {
    const date = makeDate(Number(match[1]), match[2], Number(match[3] ?? 2026));
    if (date) refs.push({ date: shiftToRun(date, today), hours: Number(match[4]), minutes: Number(match[5]) });
  }
  return refs;
}

// ---------------------------------------------------------------------------
// Baseline (workbook Summary, entries #1-#14)
// ---------------------------------------------------------------------------

export interface BaselineEntry {
  no: number;
  /** Date as written in the workbook (T = 16-Nov-2026); shift with `shiftToRun`. */
  featureDate: string;
  time: string;
  entity: string;
  activity: AuditActivity;
  clientIp?: string;
}

export const BASELINE: readonly BaselineEntry[] = [
  { no: 1, featureDate: '16-Nov-2026', time: '09:30:00', entity: 'Department', activity: 'Created', clientIp: '192.168.1.25' },
  { no: 2, featureDate: '14-Nov-2026', time: '15:10:00', entity: 'Post', activity: 'Deletion Blocked' },
  { no: 3, featureDate: '12-Nov-2026', time: '11:45:00', entity: 'Office', activity: 'Deleted' },
  { no: 4, featureDate: '10-Nov-2026', time: '16:20:00', entity: 'Department', activity: 'Updated' },
  { no: 5, featureDate: '01-Nov-2026', time: '10:05:00', entity: 'Office', activity: 'Created' },
  { no: 6, featureDate: '20-Oct-2026', time: '13:40:00', entity: 'Organization', activity: 'Created' },
  { no: 7, featureDate: '17-Oct-2026', time: '00:00:00', entity: 'Post', activity: 'Created' },
  { no: 8, featureDate: '16-Oct-2026', time: '23:59:59', entity: 'Post', activity: 'Updated' },
  { no: 9, featureDate: '25-Sep-2026', time: '11:00:00', entity: 'Office', activity: 'Created' },
  { no: 10, featureDate: '20-Sep-2026', time: '14:00:00', entity: 'Department', activity: 'Updated' },
  { no: 11, featureDate: '05-Sep-2026', time: '09:00:00', entity: 'Standards & Formats', activity: 'Created' },
  { no: 12, featureDate: '31-Aug-2026', time: '23:59:59', entity: 'Office', activity: 'Updated' },
  { no: 13, featureDate: '01-Oct-2026', time: '00:00:00', entity: 'Post', activity: 'Created' },
  { no: 14, featureDate: '01-Jan-2025', time: '08:00:00', entity: 'Department', activity: 'Created' },
] as const;

// ---------------------------------------------------------------------------
// Why a scenario skips (printed by the steps through world.log)
// ---------------------------------------------------------------------------

export const SKIP = {
  baseline:
    'the workbook baseline (entries #1-#14, dated relative to the run date) is not declared as seeded; seed it and set AUDIT_TRAIL_BASELINE_SEEDED=true.',
  customSeed: 'this scenario needs a bespoke audit-store state that no automation can create; seed it by hand and run the scenario manually.',
  destructive:
    'executing Clear Log permanently deletes audit entries; set AUDIT_TRAIL_ALLOW_DESTRUCTIVE=true only on a test environment you can re-seed.',
  sharedSession: 'a non-admin login needs its own browser session, which the shared-session run does not provide.',
  roleManagement:
    'Role Management / entitlement screens are not automated in this suite (changing live roles is not safe to do blindly); run this scenario manually.',
  sourceModule:
    'creating, updating or deleting records in the source module (Department / Office / Organization / Post / Standards & Formats) is not automated from this module; run this scenario manually or extend the source module\'s page objects.',
  backendAccess: 'the backend Function / Class Name / Message mapping is not reachable from the browser or API; compare it manually.',
  failureInjection: 'the product offers no way to force an unexpected server / database error from the browser; inject the fault manually.',
  multiClient: 'a second client with a different IP address cannot be simulated from one browser session; run this scenario manually.',
  systemClock: 'the server clock cannot be changed from the browser; only the browser clock is moved, so server-side defaults are not verified.',
  noEndpoint: 'no audit API endpoint is confirmed yet (see AuditTrailApi TODO(endpoint)).',
} as const;
