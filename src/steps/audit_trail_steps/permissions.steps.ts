/**
 * Steps of features/audit_trail_features/permissions.feature (View Audit Trail / Clear Audit Log as separate rights; role users; API access).
 * The Role Management steps are skipped (SKIP.roleManagement): changing live roles is not safe to automate blindly.
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { auditPages, auditScenario } from '../../support/audit-trail-scenario';
import { AUDIT_MESSAGES, SKIP, featureDateToIso } from '../../test-data/audit-trail.data';
import { expect } from '../../utils/assertions';
import { AuditTrailApi } from '../../pages/audit_trail_pages';
import { exact, readStore, requireDestructive, runIso, skipBecause, withTc, type Skippable } from './helpers';

// ---------------------------------------------------------------------------
// Role Management (not automated)
// ---------------------------------------------------------------------------

When(
  /^(?:Open a role in the CivitCORE role\/entitlement configuration|Locate the Audit Trail rights|Assign only 'View Audit Trail', save, then reopen the role|Assign 'View Audit Trail' to NoAccess_User1's role and save|Login as NoAccess_User1 \(fresh session\))$/,
  async function (this: CustomWorld): Skippable {
    return skipBecause(this, SKIP.roleManagement);
  },
);

Then(
  /^(?:'View Audit Trail' and 'Clear Audit Log' are listed as separate rights and can be saved independently\.|Audit Trail listing is displayed after the right is granted through the existing role\/entitlement framework\.|Request is denied and listing data is not returned once the permission is revoked\.)$/,
  async function (this: CustomWorld): Skippable {
    return skipBecause(this, SKIP.roleManagement);
  },
);

// ---------------------------------------------------------------------------
// UI access
// ---------------------------------------------------------------------------

Then(exact('Listing is viewable and filtering works.'), async function (this: CustomWorld) {
  const { list, filters } = auditPages(this);
  await list.expectLoaded();
  const selected = await filters.selectedFunction();
  const rows = await list.rows();
  expect(rows.length > 0 || (await list.isNoRecordsShown()), withTc(this, 'the grid shows rows or the "No records found" state')).toBe(true);
  if (selected !== 'All') {
    for (const row of rows) expect(row.functionName, withTc(this, `every row belongs to Function ${selected}`)).toBe(selected);
  }
});

Then(exact('Clear Log is not displayed (or is disabled) and cannot be executed.'), async function (this: CustomWorld) {
  expect(['absent', 'disabled'], withTc(this, 'Clear Log is hidden or disabled')).toContain(await auditPages(this).filters.clearLogState());
});

When(/^Look for Clear Log and try to activate it \(including via keyboard\/DOM interaction\)$/, async function (this: CustomWorld) {
  const { list, filters, dialog } = auditPages(this);
  auditScenario(this).scratch.rowsBefore = await list.rowCount();
  auditScenario(this).scratch.activated = await filters.tryActivateClearLog();
  auditScenario(this).scratch.dialogOpened = await dialog.isOpen(1500);
});

Then(exact('Clear Log cannot be executed; no confirmation dialog appears and no entry is removed.'), async function (this: CustomWorld) {
  const scenario = auditScenario(this);
  expect(scenario.scratch.dialogOpened, withTc(this, 'no confirmation dialog appears')).toBe(false);
  expect(await auditPages(this).list.rowCount(), withTc(this, 'no entry is removed')).toBe(scenario.scratch.rowsBefore);
});

Then(exact('User can view the listing and execute Clear Log successfully.'), async function (this: CustomWorld) {
  await auditPages(this).list.expectLoaded();
  expect(auditScenario(this).clearOutcome, withTc(this, 'Clear Log was confirmed')).toBe('confirmed');
  expect(await this.sawMessage(AUDIT_MESSAGES.cleared, 10000), withTc(this, `the toaster "${AUDIT_MESSAGES.cleared}" appeared`)).toBe(true);
});

Then(exact('Audit Trail entry is not displayed.'), function (this: CustomWorld) {
  expect(auditScenario(this).menuVisible, withTc(this, 'the Audit Trail menu entry is not displayed')).toBe(false);
});

Then(
  exact('Audit Trail listing screen is not displayed and no audit data is exposed (access denied / redirected).'),
  async function (this: CustomWorld) {
    const access = auditScenario(this).directAccess;
    expect(access, withTc(this, 'the screen URL was opened directly')).toBeTruthy();
    expect(access!.displayed, withTc(this, 'the Audit Trail listing is not displayed')).toBe(false);
    expect(await auditPages(this).list.rowCount(), withTc(this, 'no audit rows are exposed')).toBe(0);
  },
);

Then(
  exact('Audit Trail screen is not displayed; Clear Audit Log does not imply View Audit Trail (permissions are independent).'),
  function (this: CustomWorld) {
    const scenario = auditScenario(this);
    expect(scenario.menuVisible, withTc(this, 'the Audit Trail menu entry is not displayed')).toBe(false);
    if (scenario.directAccess) expect(scenario.directAccess.displayed, withTc(this, 'the screen is not displayed')).toBe(false);
  },
);

// ---------------------------------------------------------------------------
// API access
// ---------------------------------------------------------------------------

When(
  /^Send the get-audit-entries request \(Function All, (\d{2}-[A-Za-z]{3}-\d{4}) to (\d{2}-[A-Za-z]{3}-\d{4})\)$/,
  async function (this: CustomWorld, from: string, to: string) {
    const scenario = auditScenario(this);
    const result = await auditPages(this).api.getEntries({
      function: 'All',
      from: runIso(this, featureDateToIso(from)),
      to: runIso(this, featureDateToIso(to)),
    });
    scenario.lastApi = result;
    scenario.lastApis = [result];
    scenario.lastEntries = result.status < 300 ? AuditTrailApi.entriesOf(result) : [];
  },
);

When(
  /^Send the clear-audit-log request for (\d{2}-[A-Za-z]{3}-\d{4}) to (\d{2}-[A-Za-z]{3}-\d{4})$/,
  async function (this: CustomWorld, from: string, to: string): Skippable {
    // The request is expected to be rejected, but if the server wrongly accepted it, it would delete audit data.
    const skipped = requireDestructive(this);
    if (skipped) return skipped;
    const scenario = auditScenario(this);
    scenario.notedCount = (await readStore(this)).length;
    const result = await auditPages(this).api.clearLog(runIso(this, featureDateToIso(from)), runIso(this, featureDateToIso(to)));
    scenario.lastApi = result;
    scenario.lastApis = [result];
    return undefined;
  },
);
