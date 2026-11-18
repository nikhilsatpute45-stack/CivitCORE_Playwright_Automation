/**
 * Miscellaneous Master run switches.
 *
 * PENDING MIGRATION: like src/support/audit-trail-config.ts, these belong in src/support/config.ts (CLAUDE.md: no `process.env`
 * elsewhere). That file is shared, so the move needs the project owner's sign-off; until then every Miscellaneous Master switch
 * is read here, in ONE place.
 *
 *   MM_BASELINE_SEEDED     "true" when the environment holds the feature files' baseline: the 18 default Titles in creation
 *                          order with their parent / Enum ID / Display values (and the Specialization Master mapping).
 *   MM_BULK_SEEDED         "true" when Pagination Dataset C (120 Titles) exists.
 *   MM_EXACT_COUNT_SEEDED  "true" when the environment can be put in the exact 50 / 51 Title states (Datasets A / B).
 *   MM_URL                 (optional) absolute URL of the Miscellaneous Master screen, for "open the URL directly".
 */
function flag(name: string): boolean {
  return /^(1|true|yes|on)$/i.test((process.env[name] ?? '').trim());
}

export const miscellaneousMasterConfig = {
  baselineSeeded: flag('MM_BASELINE_SEEDED'),
  bulkSeeded: flag('MM_BULK_SEEDED'),
  exactCountSeeded: flag('MM_EXACT_COUNT_SEEDED'),
  directUrl: (process.env.MM_URL ?? '').trim(),
} as const;
