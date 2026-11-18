/**
 * Steps of features/audit_trail_features/audit_logging.feature (automatic logging of Creation / Updation / Deletion / Deletion Blocked).
 *
 * The actions that PROVOKE an audit entry live in other modules (Department, Office, Organization, Post, Standards & Formats). Their
 * screens are not part of this module, so those steps skip with a clear reason (SKIP.sourceModule / failureInjection / multiClient /
 * backendAccess) instead of guessing at another module's UI. The Then steps are real assertions on the Audit Trail listing / store, ready
 * for the day the provoking steps are automated.
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { auditPages, auditScenario } from '../../support/audit-trail-scenario';
import { SKIP, auditMessage } from '../../test-data/audit-trail.data';
import { expect } from '../../utils/assertions';
import { describeRows, exact, isClearLogEntry, readStore, skipBecause, stampOf, withTc, type Skippable } from './helpers';

// ---------------------------------------------------------------------------
// Steps that act in another module (skipped with the reason)
// ---------------------------------------------------------------------------

const MODULES = 'Department|Office|Organization|Post|Standards & Formats';

When(
  new RegExp(
    `^(?:Open the (?:${MODULES}) module|Create a new record '[^']*' and save successfully|Edit Department '[^']*' \\(change description\\) and save successfully|Delete Office '[^']*' \\(no dependency\\) and confirm|Attempt to delete Post '[^']*'(?: \\(assigned to EMP-101\\) and get blocked| which is assigned to an employee)|Note the time, then create Department '[^']*' and save|Create (?:Department|Office|Post) '[^']*'(?: in the Department module)?|Record server time T[12].*|Update its address|Delete it|Open Department creation and submit with mandatory fields blank|Open the Office module and start deleting Office '[^']*'|Cancel at the confirmation|Compare the entry's Log Date & Time with the completion time|Attempt (?:to create Department '[^']*' and observe the failure|the update and observe the failure|the delete)|Open Audit Trail and read the new entry's Message)$`,
  ),
  async function (this: CustomWorld): Skippable {
    return skipBecause(this, SKIP.sourceModule);
  },
);

When(/^Simulate an unexpected .+$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.failureInjection);
});

When(/^From (?:a client|a second client) with IP \S+ create Department '[^']*'$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.multiClient);
});

When(/^Read the backend mapping row for Function '[^']*'$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.backendAccess);
});

When(/^Compare the new audit entry with the mapping row$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.backendAccess);
});

// ---------------------------------------------------------------------------
// Entry assertions on the listing
// ---------------------------------------------------------------------------

/** The newest listed entry of `fn` (rows are ordered most recent first). */
async function newestEntry(world: CustomWorld, fn: string) {
  const rows = await auditPages(world).list.rows();
  const row = rows.find((candidate) => candidate.functionName === fn);
  expect(row, withTc(world, `an entry for Function ${fn} is listed (${describeRows(rows)})`)).toBeTruthy();
  return row!;
}

Then(
  /^An entry is created automatically with Function Name '([^']*)', current Log Date & Time, backend-configured Class Name, Client IP and Message '([^']*)' \(format '[^']*'\)\.$/,
  async function (this: CustomWorld, fn: string, message: string) {
    const row = await newestEntry(this, fn);
    expect(row.message, withTc(this, 'Message')).toBe(message);
    expect(stampOf(row)?.date.getTime(), withTc(this, 'Log Date & Time is today')).toBe(auditScenario(this).today.getTime());
    expect(row.className, withTc(this, 'Class Name is filled in')).not.toBe('');
    expect(row.clientIp, withTc(this, 'Client IP is filled in')).not.toBe('');
  },
);

Then(
  /^An entry is created automatically with Function '([^']*)' and Message '([^']*)' \(format '[^']*'\)\.$/,
  async function (this: CustomWorld, fn: string, message: string) {
    expect((await newestEntry(this, fn)).message, withTc(this, 'Message')).toBe(message);
  },
);

Then(
  /^An Audit Trail entry is created for Function '([^']*)' with Message '([^']*)' \(format '[^']*'\)\.$/,
  async function (this: CustomWorld, fn: string, message: string) {
    expect((await newestEntry(this, fn)).message, withTc(this, 'Message')).toBe(message);
  },
);

Then(
  /^Entry Message is '([^']*)' and not '([^']*)'\.$/,
  async function (this: CustomWorld, expected: string, forbidden: string) {
    const row = await newestEntry(this, 'Post');
    expect(row.message, withTc(this, 'Message')).toBe(expected);
    expect(row.message, withTc(this, 'it is not logged as a successful deletion')).not.toBe(forbidden);
  },
);

Then(exact('No manual logging action was required.'), function () {
  // Documentation of the scenario's point: the listing assertion above already proved the entry exists without a manual step.
});

Then(
  exact(
    'Three separate entries exist (created, updated, deleted), each with its own Log Date & Time and Message, ordered most recent first.',
  ),
  async function (this: CustomWorld) {
    const rows = (await auditPages(this).list.rows()).filter((row) => row.functionName === 'Office');
    const expected = [auditMessage('Office', 'Deleted'), auditMessage('Office', 'Updated'), auditMessage('Office', 'Created')];
    expect(rows.slice(0, 3).map((row) => row.message), withTc(this, 'deleted, updated, created - most recent first')).toEqual(expected);
  },
);

Then(
  exact('Stored entry contains all five attributes: Function Name, Log Date & Time, Class Name, Client IP, Message.'),
  async function (this: CustomWorld) {
    const [newest] = await readStore(this, 'Post');
    expect(newest, withTc(this, 'a Post entry is stored')).toBeTruthy();
    for (const [name, value] of Object.entries({
      'Function Name': newest.functionName,
      'Log Date & Time': newest.logDateTime,
      'Class Name': newest.className,
      'Client IP': newest.clientIp,
      Message: newest.message,
    })) {
      expect(value, withTc(this, `${name} is stored`)).not.toBe('');
    }
  },
);

Then(
  exact('The old entry is still returned; entries are not removed automatically by any retention job.'),
  async function (this: CustomWorld) {
    const rows = await auditPages(this).list.rows();
    expect(rows.some((row) => row.functionName === 'Department'), withTc(this, `the old Department entry is returned (${describeRows(rows)})`)).toBe(true);
  },
);

Then(
  exact('No per-entry edit/delete exists; entries in the range are removed only through the Clear Log operation.'),
  function (this: CustomWorld) {
    const scenario = auditScenario(this);
    expect(scenario.scratch.rowActions, withTc(this, 'the grid has no per-entry action')).toBe(false);
    expect(scenario.clearOutcome, withTc(this, 'the range was removed through Clear Log')).toBe('confirmed');
  },
);

Then(
  /^An entry exists with User = (\S+), current Date\/Time, Selected Date Range \(From (\S+), To (\S+)\) and Message '([^']*)' \(system-generated; exact stored text to be confirmed\)\.$/,
  async function (this: CustomWorld, user: string, _from: string, _to: string, message: string) {
    const clearEntries = (await readStore(this)).filter(isClearLogEntry);
    expect(clearEntries.length, withTc(this, `a Clear Log entry by ${user} is stored`)).toBeGreaterThan(0);
    // FRD gap 6(d): the grid has no User / Range columns and the stored text is "to be confirmed", so the text is only reported.
    if (!clearEntries.some((entry) => entry.message.includes(message))) {
      this.log(`FRD gap: the stored Clear Log message was "${clearEntries[0].message}", not "${message}".`);
    }
  },
);

Then(exact('Entry count is unchanged; only Creation, Updation, Deletion, Deletion Blocked and Clear Log are auditable.'), function (this: CustomWorld) {
  const scenario = auditScenario(this);
  expect(scenario.scratch.recount, withTc(this, 'viewing and searching created no audit entry')).toBe(scenario.notedCount);
});

// ---------------------------------------------------------------------------
// Outcomes that only exist after another module's action (skipped with the reason)
// ---------------------------------------------------------------------------

Then(
  /^(?:Deletion is blocked by the source module\.|New entry for Function 'Department' is displayed at the top of the list without any manual record creation\.|Entry is available right after completion and its Log Date & Time matches the transaction completion time \(no later manual step needed\)\.|Log Date & Time is between T1 and T2 \(captured by the system, not editable by the user\)\.|A new entry for the creation is logged and displayed; Clear Log does not disable audit logging\.|No audit entry exists for the failed (?:attempt|update)\.|No audit entry is created (?:for this failure \(only dependency-blocked deletions are logged\)|for the rejected submission)\.|No entry is created because no deletion was completed or blocked\.)$/,
  async function (this: CustomWorld): Skippable {
    return skipBecause(this, SKIP.sourceModule);
  },
);

Then(/^Entry for '[^']*' shows Client IP \S+\.$/, async function (this: CustomWorld): Skippable {
  return skipBecause(this, SKIP.multiClient);
});

Then(
  exact('Function Name, Class Name and Message of the entry equal the values configured in the backend mapping; none is user-entered.'),
  async function (this: CustomWorld): Skippable {
    return skipBecause(this, SKIP.backendAccess);
  },
);

