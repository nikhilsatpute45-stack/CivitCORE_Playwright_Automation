/**
 * Miscellaneous Master (Title) test data (features/miscellaneous_master_features, FRD CIC-F-003; CIC-F-001 = Specialization Master).
 *
 * FRD vs live app: the Miscellaneous Master screen (CivitINFRA > Admin > Configuration > Miscellaneous Master) has not been
 * inspected - every message is the FRD text with a tolerant alias pattern, marked (unconfirmed). STRICT_FRD_MESSAGES=true asserts
 * the FRD copy verbatim. The features assert literal Field Titles ('List of Operator', 'Obsolete Field'), so scenarios use those
 * literal names (no Bdd suffix) and the After hook removes / restores them; see hooks.ts.
 */
import { config } from '../support/config';
import { escapeRegExp } from '../utils/assertions';

export const ROLE_PERMISSIONS = {
  Admin: 'View/Add/Edit/Delete',
  Adder: 'View/Add',
  Editor: 'View/Edit',
  Deleter: 'View/Delete',
  Viewer: 'View only',
  NoAccess: 'none',
  Auditor: 'Activity Log section access',
} as const;

/** Columns of the Title List (FRD 6.1), in order. */
export const MM_COLUMNS = ['Sl. No.', 'Enum ID', 'Title', 'Parent Title', 'Display', 'Actions'] as const;

export const FIELD_LIMITS = { fieldTitle: 100, enumIdDigits: 10 } as const;
export const PAGE_SIZE = 50;
export const PARENT_PLACEHOLDER = '-- Select Parent Title --';
export const DISPLAY_FILTER_OPTIONS = ['All', 'Checked', 'Unchecked'] as const;

/** The 18 baseline Titles in creation order (Sl. No. 1..18); Display is checked for the first five. */
export const BASELINE_TITLES = [
  'List of Title',
  'List of Firm Type',
  'List of Operator',
  'Zone Type',
  'Material Group',
] as const;

export const NO_RECORDS_PATTERN = /no\s+records?\s+found/i;

/** FRD message -> tolerant alternative wording (unconfirmed; every alias starts as the FRD text). */
const messageAliases: Record<string, Array<string | RegExp>> = {
  'Field Title is required.': [/(field\s*)?title.*(required|mandatory|cannot be (blank|empty))/i],
  'A title with this name already exists.': [/title.*(already exists|duplicate)/i],
  'Enum ID already exists.': [/enum\s*id.*(already exists|duplicate)/i],
  'Enum ID must be a whole number greater than 0.': [/enum\s*id.*(whole number|greater than 0|positive|numeric)/i],
  'Selected Parent Title creates a circular hierarchy.': [/circular/i],
  'Title added successfully.': [/title.*(added|created).*successfully/i],
  'Title updated successfully.': [/title.*updated.*successfully/i],
  'Title deleted successfully.': [/title.*deleted.*successfully/i],
  'Display setting updated successfully.': [/display.*(setting)?.*updated.*successfully/i],
  'This title is used in one or more transactions and cannot be deleted.': [/used in .*transaction.*cannot be deleted|transaction/i],
  'This title is set as Parent Title for one or more titles and cannot be deleted.': [/parent title.*cannot be deleted|set as parent/i],
  'This title is mapped in Specialization Master and cannot be deleted.': [/mapped in specialization master|specialization master.*cannot be deleted/i],
};

/** Messages shown inline, next to a field in the pop-up (the others are toasters). */
export const INLINE_MESSAGES = [
  'Field Title is required.',
  'A title with this name already exists.',
  'Enum ID already exists.',
  'Enum ID must be a whole number greater than 0.',
  'Selected Parent Title creates a circular hierarchy.',
] as const;

function messageCore(message: string): string {
  return escapeRegExp(message.trim().replace(/[.!]+$/, '')).replace(/\s+/g, '\\s+');
}

/** Pattern for an FRD message: the FRD copy itself, or (unless strict) its alias patterns. */
export function mmMessagePattern(message: string): RegExp {
  const aliases = config.strictFrdMessages ? [] : (messageAliases[message.trim()] ?? []);
  const alternatives = [messageCore(message), ...aliases.map((alias) => (typeof alias === 'string' ? messageCore(alias) : alias.source))];
  return new RegExp(alternatives.join('|'), 'i');
}

export function normalizeText(value: string): string {
  return value.trim().replace(/\s+/g, ' ').toLowerCase();
}

/** Users named in the features: "Admin_User1" -> the role key getRoleCredentials understands. */
export function roleKeyOfUser(user: string): 'ADMIN' | string {
  const role = user.trim().replace(/_?User\d*$/i, '');
  return /^admin$/i.test(role) ? 'ADMIN' : role;
}

/** Reasons a step cannot run in this environment (used with skipBecause; they double as the @fixme proposals). */
export const SKIP = {
  moduleMissing:
    'the Miscellaneous Master screen (CivitINFRA > Admin > Configuration > Miscellaneous Master) is not reachable in this environment; ' +
    'the scenario is scaffolding until the module is available (see src/pages/miscellaneous_master_pages).',
  baseline: 'it needs the 18 baseline Titles (List of Title, List of Firm Type, List of Operator, ... with their hierarchy); set MM_BASELINE_SEEDED=true on an environment that holds them.',
  bulk: 'it needs Pagination Dataset C (120 Titles); set MM_BULK_SEEDED=true on an environment that holds them.',
  exactCount: 'it needs the master to hold exactly 50 / 51 Titles (Datasets A / B); set MM_EXACT_COUNT_SEEDED=true on a dedicated, disposable environment.',
  crossModule:
    'it needs another module (Specialization Master CIC-F-001, Vendor / Contractor Registration, a transaction such as TXN-0001) that has no page object here yet.',
  secondSession: 'it needs a second, independent user session acting at the same time (Session A / Session B / another session).',
  serviceFailure: 'it needs a service forced to fail or throttled (Display update API, save API), which a test cannot do against a real environment.',
  roleManagement: 'it edits roles in Role Management (Infra Admin) and re-logs in two users; there is no page object for it and real entitlements must not be changed by this suite.',
  role: 'the role user is not configured; set MIDC_<ROLE>_USERNAME and MIDC_<ROLE>_PASSWORD (see the .env.example proposal).',
  activityLog: 'the Activity Log has no confirmed entry point in this build (see MiscellaneousMasterActivityLogPage).',
  sharedSession: 'a non-Admin login cannot run inside the shared Admin session; run it without SHARED_SESSION.',
} as const;
