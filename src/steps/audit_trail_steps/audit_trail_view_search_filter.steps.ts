/**
 * Steps of features/audit_trail_features/audit_trail_view_search_filter.feature (default filters, Search state, Function / date filtering,
 * grid content and read-only cells, API validation of the get-audit-entries request).
 * Assertions on exact rows need the workbook baseline (AUDIT_TRAIL_BASELINE_SEEDED); the scenarios skip without it.
 */
import { Then, When } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { auditPages, auditScenario } from '../../support/audit-trail-scenario';
import { AuditTrailApi, parseLogDateTime } from '../../pages/audit_trail_pages';
import type { AuditRow, EntryQuery } from '../../pages/audit_trail_pages';
import {
  AUDIT_COLUMNS,
  CONFIGURED_FUNCTIONS,
  DEFAULT_FUNCTION,
  DEFAULT_RANGE_DAYS,
  SKIP,
  addDays,
  makeDate,
  parseFeatureDate,
  shiftToRun,
  timedRefs,
} from '../../test-data/audit-trail.data';
import { expect } from '../../utils/assertions';
import { expectFunctionUnchanged } from './audit_trail_ui.steps';
import { describeRows, exact, readStore, rowIsAt, runIso, sameDate, skipBecause, stampOf, withTc, type Skippable } from './helpers';

const D = '(\\d{2}-[A-Za-z]{3}-\\d{4})';
const re = (pattern: string): RegExp => new RegExp(`^${pattern}$`);

/** Seconds since the epoch of a Log Date & Time stamp, for ordering checks. */
function secondsOf(row: AuditRow): number {
  const stamp = stampOf(row);
  return stamp ? stamp.date.getTime() / 1000 + stamp.hours * 3600 + stamp.minutes * 60 + stamp.seconds : Number.NaN;
}

// ---------------------------------------------------------------------------
// Default filters
// ---------------------------------------------------------------------------

Then(exact("Functions dropdown shows 'All' by default."), async function (this: CustomWorld) {
  expect(await auditPages(this).filters.selectedFunction(), withTc(this, 'default Function')).toBe(DEFAULT_FUNCTION);
});

Then(re(`To Date is set to today's date \\(${D}\\)\\.`), async function (this: CustomWorld) {
  const to = await auditPages(this).filters.toValue();
  expect(sameDate(to, auditScenario(this).today), withTc(this, `To Date is today (shown "${to}")`)).toBe(true);
});

Then(re(`From Date (?:is set to|remains) ${D}[,;] .*`), async function (this: CustomWorld) {
  const { filters } = auditPages(this);
  const today = auditScenario(this).today;
  const from = await filters.fromValue();
  expect(sameDate(from, addDays(today, -DEFAULT_RANGE_DAYS)), withTc(this, `From Date is ${DEFAULT_RANGE_DAYS} calendar days before today (shown "${from}")`)).toBe(true);
  expect(sameDate(await filters.toValue(), today), withTc(this, 'To Date is today')).toBe(true);
});

Then(re(`To Date = ${D} and From Date = ${D} \\(.*\\)\\.`), async function (this: CustomWorld, to: string, from: string) {
  const { filters } = auditPages(this);
  expect(sameDate(await filters.toValue(), parseFeatureDate(to)!), withTc(this, `To Date is ${to}`)).toBe(true);
  expect(sameDate(await filters.fromValue(), parseFeatureDate(from)!), withTc(this, `From Date is ${from}`)).toBe(true);
});

// ---------------------------------------------------------------------------
// Search state
// ---------------------------------------------------------------------------

Then(exact('Search action is inactive (disabled).'), async function (this: CustomWorld) {
  expect(await auditPages(this).filters.isSearchEnabled(), withTc(this, 'Search is disabled')).toBe(false);
});

Then(exact('Search action becomes active.'), async function (this: CustomWorld) {
  expect(await auditPages(this).filters.isSearchEnabled(), withTc(this, 'Search is enabled')).toBe(true);
});

Then(
  exact('Filter is applied; Search action is inactive again because the selection equals the currently applied values.'),
  async function (this: CustomWorld) {
    expect(await auditPages(this).filters.isSearchEnabled(), withTc(this, 'Search is disabled again after being applied')).toBe(false);
  },
);

// ---------------------------------------------------------------------------
// Functions dropdown
// ---------------------------------------------------------------------------

Then(
  exact("Dropdown lists 'All' plus only the Functions configured in the backend mapping; no unconfigured value is listed."),
  function (this: CustomWorld) {
    const options = (auditScenario(this).scratch.functionOptions as string[] | undefined) ?? [];
    expect([...options].sort(), withTc(this, "the dropdown lists 'All' and the configured Functions only")).toEqual(
      [DEFAULT_FUNCTION, ...CONFIGURED_FUNCTIONS].sort(),
    );
  },
);

Then(exact('Free text is not accepted; the control keeps its previous valid value.'), async function (this: CustomWorld) {
  await expectFunctionUnchanged(this);
});

Then(
  exact("No blank option is offered; Functions always holds 'All' or a configured Function (mandatory field)."),
  async function (this: CustomWorld) {
    const options = (auditScenario(this).scratch.functionOptions as string[] | undefined) ?? [];
    expect(options.every((option) => option.trim() !== ''), withTc(this, 'no blank option is offered')).toBe(true);
    expect([DEFAULT_FUNCTION, ...CONFIGURED_FUNCTIONS], withTc(this, 'the control holds All or a configured Function')).toContain(
      await auditPages(this).filters.selectedFunction(),
    );
  },
);

// ---------------------------------------------------------------------------
// Grid content
// ---------------------------------------------------------------------------

Then(
  /^Grid shows (?:exactly |only |all )?(\d+) ([A-Za-z&' ]*?)entries\b(.*)$/,
  async function (this: CustomWorld, count: string, word: string, rest: string) {
    const { list } = auditPages(this);
    await list.waitForListing();
    const rows = await list.rows();
    expect(rows, withTc(this, `the grid shows ${count} entries (${describeRows(rows)})`)).toHaveLength(Number(count));

    const functionName = word.trim();
    if ((CONFIGURED_FUNCTIONS as readonly string[]).includes(functionName)) {
      for (const row of rows) expect(row.functionName, withTc(this, `every row is a ${functionName} entry`)).toBe(functionName);
    }
    for (const ref of timedRefs(rest, auditScenario(this).today)) {
      expect(
        rows.some((row) => rowIsAt(row, ref)),
        withTc(this, `an entry at ${ref.date.toISOString().slice(0, 10)} ${ref.hours}:${ref.minutes} is listed (${describeRows(rows)})`),
      ).toBe(true);
    }
    if (/most recent first/i.test(rest)) {
      const seconds = rows.map(secondsOf);
      for (let index = 1; index < seconds.length; index += 1) {
        expect(seconds[index - 1] >= seconds[index], withTc(this, `rows are ordered most recent first (${describeRows(rows)})`)).toBe(true);
      }
    }
  },
);

Then(exact("Grid shows the 'No records found' state."), async function (this: CustomWorld) {
  await auditPages(this).list.waitForListing();
  expect(await auditPages(this).list.isNoRecordsShown(), withTc(this, 'the "No records found" state is displayed')).toBe(true);
});

Then(exact("'No records found' state is displayed and is not treated as an error."), async function (this: CustomWorld) {
  expect(await auditPages(this).list.isNoRecordsShown(), withTc(this, 'the "No records found" state is displayed')).toBe(true);
  expect(await auditPages(this).filters.validationMessages(), withTc(this, 'no error message is displayed')).toHaveLength(0);
});

Then(exact('No error message is displayed.'), async function (this: CustomWorld) {
  expect(await auditPages(this).filters.validationMessages(), withTc(this, 'no error message is displayed')).toHaveLength(0);
  expect(this.apiErrors, withTc(this, 'no failed API call')).toEqual([]);
});

Then(re(`No validation error; grid shows the 1 entry logged on ${D} \\(Office deleted, 11:45\\)\\.`), async function (this: CustomWorld, day: string) {
  expect(await auditPages(this).filters.validationMessages(), withTc(this, 'no validation error')).toHaveLength(0);
  const rows = await auditPages(this).list.rows();
  expect(rows, withTc(this, `one entry on ${day}`)).toHaveLength(1);
  expect(rows[0].functionName).toBe('Office');
});

Then(/^Both fields accept the new values; grid shows (\d+) entries from .+$/, async function (this: CustomWorld, count: string) {
  expect(await auditPages(this).list.rows(), withTc(this, `the grid shows ${count} entries`)).toHaveLength(Number(count));
});

Then(/^Previously displayed default-range results are replaced by the (\d+) entries of the new range\.$/, async function (this: CustomWorld, count: string) {
  const rows = await auditPages(this).list.rows();
  expect(rows, withTc(this, `the new range shows ${count} entries`)).toHaveLength(Number(count));
  expect(rows, withTc(this, 'the default-range results were replaced')).not.toEqual(auditScenario(this).snapshot);
});

Then(/^Grid also contains the older entries \(e\.g\., (.+)\)\.$/, async function (this: CustomWorld, list: string) {
  const rows = await auditPages(this).list.rows();
  const today = auditScenario(this).today;
  for (const match of list.matchAll(/(\d{2})-([A-Z][a-z]{2}) ([A-Za-z& ]+?)(?:,|$)/g)) {
    const date = makeDate(Number(match[1]), match[2], 2026);
    expect(date, withTc(this, `"${match[0]}" is a date`)).toBeTruthy();
    const shifted = shiftToRun(date!, today).getTime();
    const found = rows.some((row) => row.functionName === match[3].trim() && stampOf(row)?.date.getTime() === shifted);
    expect(found, withTc(this, `${match[3].trim()} entry of ${match[1]}-${match[2]} is listed (${describeRows(rows)})`)).toBe(true);
  }
});

Then(
  re(`Today's date is accepted; the entry logged on ${D} (\\d{2}:\\d{2}) is displayed\\.`),
  async function (this: CustomWorld, _day: string, time: string) {
    const rows = await auditPages(this).list.rows();
    const today = auditScenario(this).today.getTime();
    const [hours, minutes] = time.split(':').map(Number);
    const shown = rows.some((row) => {
      const stamp = stampOf(row);
      return stamp?.date.getTime() === today && stamp.hours === hours && stamp.minutes === minutes;
    });
    expect(shown, withTc(this, `the entry of today ${time} is displayed (${describeRows(rows)})`)).toBe(true);
  },
);

Then(re(`Entries dated before ${D} \\(e\\.g\\., .+\\) are not shown\\.`), async function (this: CustomWorld, from: string) {
  const floor = shiftToRun(parseFeatureDate(from)!, auditScenario(this).today).getTime();
  for (const row of await auditPages(this).list.rows()) {
    expect(stampOf(row)!.date.getTime(), withTc(this, `no entry before ${from} (shifted) is shown`)).toBeGreaterThanOrEqual(floor);
  }
});

Then(
  re(`Entry dated ${D} (\\d{2}):(\\d{2}):(\\d{2}) is (not )?displayed\\.`),
  async function (this: CustomWorld, day: string, h: string, m: string, s: string, negation?: string) {
    const date = shiftToRun(parseFeatureDate(day)!, auditScenario(this).today).getTime();
    const rows = await auditPages(this).list.rows();
    const shown = rows.some((row) => {
      const stamp = stampOf(row);
      return stamp?.date.getTime() === date && stamp.hours === Number(h) && stamp.minutes === Number(m) && stamp.seconds === Number(s);
    });
    expect(shown, withTc(this, `the entry dated ${day} ${h}:${m}:${s} is ${negation ? 'not ' : ''}displayed (${describeRows(rows)})`)).toBe(!negation);
  },
);

Then(exact('Entries outside the range are not displayed.'), async function (this: CustomWorld) {
  const { typedRange } = auditScenario(this);
  const from = typedRange.from ? parseLogDateTime(`${typedRange.from} 00:00`)?.date.getTime() : undefined;
  const to = typedRange.to ? parseLogDateTime(`${typedRange.to} 00:00`)?.date.getTime() : undefined;
  for (const row of await auditPages(this).list.rows()) {
    const day = stampOf(row)!.date.getTime();
    if (from !== undefined) expect(day, withTc(this, 'no entry before From Date')).toBeGreaterThanOrEqual(from);
    if (to !== undefined) expect(day, withTc(this, 'no entry after To Date')).toBeLessThanOrEqual(to);
  }
});

Then(exact('No entries of other Functions are displayed.'), async function (this: CustomWorld) {
  const selected = await auditPages(this).filters.selectedFunction();
  for (const row of await auditPages(this).list.rows()) {
    expect(row.functionName, withTc(this, `only ${selected} entries are displayed`)).toBe(selected);
  }
});

Then(
  exact('Sl No. shows 1 and 2 for the two displayed rows (renumbered for this result set, not carried over from the full list).'),
  async function (this: CustomWorld) {
    expect((await auditPages(this).list.rows()).map((row) => row.slNo), withTc(this, 'Sl No. is renumbered 1, 2')).toEqual(['1', '2']);
  },
);

Then(exact('Listing is displayed and the filter returns the 2 Office entries of the default range.'), async function (this: CustomWorld) {
  const rows = await auditPages(this).list.rows();
  expect(rows, withTc(this, 'two entries')).toHaveLength(2);
  for (const row of rows) expect(row.functionName, withTc(this, 'Office entries only')).toBe('Office');
});

// ---------------------------------------------------------------------------
// Cell contents ("Read the <column> of the <date> entry" stored the column and the timestamp)
// ---------------------------------------------------------------------------

async function readCell(world: CustomWorld): Promise<string> {
  const scenario = auditScenario(world);
  const column = String(scenario.scratch.readColumn ?? '');
  const refs = timedRefs(String(scenario.scratch.readEntryAt ?? ''), scenario.today);
  expect(refs.length, withTc(world, 'the entry to read was named by a "Read the <column> of the <date> entry" step')).toBeGreaterThan(0);
  const rows = await auditPages(world).list.rows();
  const row = rows.find((candidate) => rowIsAt(candidate, refs[0]));
  expect(row, withTc(world, `the entry is listed (${describeRows(rows)})`)).toBeTruthy();
  const keys: Record<string, keyof AuditRow> = {
    'Function Name': 'functionName',
    'Log Date & Time': 'logDateTime',
    'Class Name': 'className',
    'Client IP': 'clientIp',
    Message: 'message',
  };
  const key = keys[column];
  expect(key, withTc(world, `"${column}" is a grid column`)).toBeTruthy();
  return row![key];
}

Then(/^Function Name = '([^']*)'\.$/, async function (this: CustomWorld, expected: string) {
  expect(await readCell(this), withTc(this, 'Function Name')).toBe(expected);
});

Then(re(`Log Date & Time = ${D} (\\d{2}:\\d{2}) \\(matches the recorded timestamp\\)\\.`), async function (this: CustomWorld, _day: string, time: string) {
  expect(await readCell(this), withTc(this, 'Log Date & Time shows the recorded time')).toContain(time);
});

Then(exact("Class Name equals the Class Name configured in the backend for Function 'Office'."), async function (this: CustomWorld) {
  const value = await readCell(this);
  const configured = auditScenario(this).datum('Configured Class Name').replace(/\s*\(placeholder\)\s*$/i, '');
  expect(configured, withTc(this, 'the workbook names the configured Class Name (a placeholder until the backend mapping is known)')).toBeTruthy();
  expect(value, withTc(this, 'Class Name equals the backend-configured value')).toBe(configured);
});

Then(/^Client IP = (\S+)\.$/, async function (this: CustomWorld, expected: string) {
  expect(await readCell(this), withTc(this, 'Client IP')).toBe(expected);
});

Then(/^Message = '(.+)' \(backend-configured text for Updation\)\.$/, async function (this: CustomWorld, expected: string) {
  expect(await readCell(this), withTc(this, 'Message')).toBe(expected);
});

When(
  /^Click\/double-click each of Sl No\., Function Name, Log Date & Time, Class Name, Client IP and Message$/,
  async function (this: CustomWorld) {
    const { list } = auditPages(this);
    let editor = false;
    for (const column of AUDIT_COLUMNS) {
      await (await list.cell(0, column)).click();
      editor = (await list.editorOpensOnDoubleClick(0, column)) || editor;
    }
    auditScenario(this).scratch.editorOpened = editor;
  },
);

Then(
  exact('All six fields are rendered as plain read-only text; no input control, edit icon or inline editor appears.'),
  function (this: CustomWorld) {
    expect(auditScenario(this).scratch.editorOpened, withTc(this, 'no editor appeared in any of the six cells')).toBe(false);
  },
);

// ---------------------------------------------------------------------------
// Backend inventory (not reachable from here)
// ---------------------------------------------------------------------------

When(
  /^(?:Export the list of functions that perform Creation\/Updation\/Deletion|Export the Audit Trail Function\/Class Name\/Message mapping|Compare the listed values with the backend Function\/Class Name\/Message configuration)$/,
  async function (this: CustomWorld): Skippable {
    return skipBecause(this, SKIP.backendAccess);
  },
);

Then(
  exact('Every audit-eligible function has a Function, Class Name and Message mapping; no function is missing from the Audit Trail configuration.'),
  async function (this: CustomWorld): Skippable {
    return skipBecause(this, SKIP.backendAccess);
  },
);

// ---------------------------------------------------------------------------
// get-audit-entries API validation (FRD 6.3 rules enforced server-side)
// ---------------------------------------------------------------------------

/** Sends one get-audit-entries request exactly as the scenario describes it (a hostile value is sent verbatim). TODO(endpoint). */
async function sendEntries(world: CustomWorld, query: EntryQuery): Promise<void> {
  const scenario = auditScenario(world);
  const result = await auditPages(world).api.getEntries(query);
  scenario.lastApi = result;
  scenario.lastApis = [result];
  scenario.lastEntries = result.status < 300 ? AuditTrailApi.entriesOf(result) : [];
}

When(/^Send get-audit-entries with function='([^']*)', from=(\S+), to=(\S+)$/, async function (this: CustomWorld, fn: string, from: string, to: string) {
  await sendEntries(this, { function: fn, from: runIso(this, from), to: runIso(this, to) });
});

When(/^Send get-audit-entries with function="(.*)"$/, async function (this: CustomWorld, fn: string) {
  await sendEntries(this, { function: fn });
});

When(/^Send get-audit-entries with from="(.*)" and to=(\S+)$/, async function (this: CustomWorld, from: string, to: string) {
  await sendEntries(this, { from, to: runIso(this, to) });
});

When(/^Send get-audit-entries with from=(\S+) and to=(\S+)$/, async function (this: CustomWorld, from: string, to: string) {
  await sendEntries(this, { from: runIso(this, from), to: runIso(this, to) });
});

When(/^Send get-audit-entries with to=(\S+)$/, async function (this: CustomWorld, to: string) {
  await sendEntries(this, { to: runIso(this, to) });
});

/** A validation rejection: a 4xx answer (not a 5xx crash, not a 2xx acceptance) that returned no entries. */
function expectValidationRejection(world: CustomWorld): void {
  const scenario = auditScenario(world);
  const status = scenario.lastApi?.status ?? 0;
  expect(status, withTc(world, `the request is rejected with a client error (got ${status} ${scenario.lastApi?.message ?? ''})`)).toBeGreaterThanOrEqual(400);
  expect(status, withTc(world, 'the server did not crash on the value')).toBeLessThan(500);
  expect(scenario.lastEntries, withTc(world, 'no entries are returned')).toHaveLength(0);
}

Then(exact('Request is rejected (validation error); no entries are returned and the value is not processed.'), function (this: CustomWorld) {
  expectValidationRejection(this);
});

Then(exact('Request is rejected as an unconfigured Function; no data is leaked and no query manipulation occurs.'), async function (this: CustomWorld) {
  expectValidationRejection(this);
  await readStore(this);
});

Then(exact('Request is rejected as an invalid date; audit table is intact.'), async function (this: CustomWorld) {
  expectValidationRejection(this);
  expect((await readStore(this)).length, withTc(this, 'the audit table is intact and readable')).toBeGreaterThan(0);
});

Then(
  /^Request is rejected with a validation error(?:; no results returned \(server-side enforcement of the same rule\))?\.$/,
  function (this: CustomWorld) {
    expectValidationRejection(this);
  },
);
