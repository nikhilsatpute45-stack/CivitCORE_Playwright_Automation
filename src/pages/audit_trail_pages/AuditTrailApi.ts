/**
 * Audit Trail API: replays authenticated requests from inside the browser page, using the bearer token the page's own requests carry
 * (same mechanism as RegionApi / LocationCategoryApi). No role token is ever read from the environment or logged.
 *
 * TODO(endpoint): confirm against the real build. The Audit Trail service does not exist yet; the paths and body field names below are
 * modelled on the sibling masters' "/setup/api/<module>/3.0/..." shape and have NEVER been observed. Nothing here seeds or back-dates
 * audit entries (the system writes them), so the workbook baseline must be provided by the environment.
 */
import type { Page } from '@playwright/test';
import { expect } from '../../utils/assertions';

export interface ApiResult {
  status: number;
  message: string;
  body: unknown;
}

export interface AuditEntry {
  id?: number | string;
  functionName: string;
  logDateTime: string;
  className: string;
  clientIp: string;
  message: string;
}

export interface EntryQuery {
  /** 'All' or a configured Function; sent verbatim (a scenario may send an unconfigured value on purpose). */
  function?: string;
  from?: string;
  to?: string;
}

// TODO(endpoint): confirm against the real build.
const PATHS = {
  list: 'auditTrail/3.0/getList',
  clear: 'auditTrail/3.0/clear',
  entry: (id: number | string): string => `auditTrail/3.0/entry/${encodeURIComponent(String(id))}`,
} as const;

const API_PATH = /\/setup\/api\//i;
const API_BASE = /^(.*\/setup\/api\/)/i;
/** Request headers the replay must not copy (the browser sets them, or the cookie jar supplies them). */
const SKIPPED_HEADERS = /^(host|content-length|content-type|cookie|connection|accept-encoding|origin|referer|user-agent|sec-|priority|:)/i;
const SESSION_TIMEOUT_MS = 30000;

type Method = 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE';

function messageOf(body: unknown): string {
  if (typeof body === 'string') return body.slice(0, 300);
  if (body && typeof body === 'object') {
    const record = body as Record<string, unknown>;
    for (const key of ['message', 'Message', 'error', 'title', 'detail']) {
      if (typeof record[key] === 'string') return record[key] as string;
    }
  }
  return '';
}

function text(value: unknown): string {
  return typeof value === 'string' || typeof value === 'number' ? String(value) : '';
}

function pick(record: Record<string, unknown>, ...keys: string[]): string {
  for (const key of keys) {
    if (record[key] !== undefined && record[key] !== null) return text(record[key]);
  }
  return '';
}

export class AuditTrailApi {
  private headers: Record<string, string> = {};
  private apiBase?: string;

  constructor(private readonly page: Page) {
    page.on('request', (request) => {
      const url = request.url();
      const base = API_BASE.exec(url);
      if (base) this.apiBase = base[1];
      if (API_PATH.test(url)) {
        request
          .allHeaders()
          .then((all) => {
            if (all.authorization) this.headers = Object.fromEntries(Object.entries(all).filter(([name]) => !SKIPPED_HEADERS.test(name)));
          })
          .catch(() => undefined);
      }
    });
  }

  /** True once the page has made an authenticated API request whose headers can be replayed. */
  hasSession(): boolean {
    return Boolean(this.headers.authorization) && Boolean(this.apiBase);
  }

  /** Waits for the page's own traffic to reveal a replayable session; throws a clear error when none appears. */
  async ensureSession(): Promise<void> {
    await expect
      .poll(() => this.hasSession(), { timeout: SESSION_TIMEOUT_MS, message: 'an authenticated /setup/api request was observed on the page' })
      .toBe(true);
  }

  /** `path` is relative to the setup API or an absolute URL. Sent from inside the page, so a failure never echoes the bearer token. */
  async send(method: Method, path: string, data?: unknown): Promise<ApiResult> {
    await this.ensureSession();
    const url = /^https?:/i.test(path) ? path : `${this.apiBase}${path}`;
    const response = await this.page.evaluate(
      async ({ url, method, headers, body }) => {
        const reply = await fetch(url, {
          method,
          headers: { ...headers, 'content-type': 'application/json' },
          body: body === undefined ? undefined : JSON.stringify(body),
        });
        return { status: reply.status, text: await reply.text() };
      },
      { url, method, headers: this.headers, body: data },
    );
    let body: unknown = response.text;
    try {
      body = JSON.parse(response.text);
    } catch {
      // Non-JSON body (e.g. an empty 403): the text itself is the body.
    }
    return { status: response.status, message: messageOf(body), body };
  }

  // ---------------------------------------------------------------------------
  // Operations
  // ---------------------------------------------------------------------------

  /** TODO(endpoint): body field names (function / fromDate / toDate) are guesses. */
  getEntries(query: EntryQuery): Promise<ApiResult> {
    return this.send('POST', PATHS.list, { function: query.function ?? 'All', fromDate: query.from, toDate: query.to });
  }

  /** TODO(endpoint): destructive; callers must have passed the AUDIT_TRAIL_ALLOW_DESTRUCTIVE gate. */
  clearLog(from: string, to: string): Promise<ApiResult> {
    return this.send('POST', PATHS.clear, { fromDate: from, toDate: to });
  }

  /** TODO(endpoint): an audit entry must NOT be editable; the request is expected to be rejected (403 / 405). */
  updateEntry(id: number | string, message: string): Promise<ApiResult> {
    return this.send('PUT', PATHS.entry(id), { message });
  }

  /** TODO(endpoint): a single audit entry must NOT be deletable; the request is expected to be rejected (403 / 405). */
  deleteEntry(id: number | string): Promise<ApiResult> {
    return this.send('DELETE', PATHS.entry(id));
  }

  /** The entries a successful response carries (a bare array or a `data` / `entries` array); empty for any other body. */
  static entriesOf(result: ApiResult): AuditEntry[] {
    const body = result.body as unknown;
    const list = Array.isArray(body)
      ? body
      : body && typeof body === 'object'
        ? ((body as Record<string, unknown>).data ?? (body as Record<string, unknown>).entries ?? (body as Record<string, unknown>).items)
        : undefined;
    if (!Array.isArray(list)) return [];
    return (list as Array<Record<string, unknown>>).map((record) => ({
      id: record.id as number | string | undefined,
      functionName: pick(record, 'functionName', 'function', 'FunctionName'),
      logDateTime: pick(record, 'logDateTime', 'logDate', 'LogDateTime', 'createdDate'),
      className: pick(record, 'className', 'ClassName'),
      clientIp: pick(record, 'clientIp', 'clientIP', 'ClientIP', 'ipAddress'),
      message: pick(record, 'message', 'Message'),
    }));
  }
}
