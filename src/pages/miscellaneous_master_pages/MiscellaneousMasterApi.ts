/**
 * Miscellaneous Master API: replays the authenticated requests the page itself makes (same mechanism as ContractCategoryApi /
 * AuditTrailApi) for fixtures, clean-up and the "UI bypassed" rejection scenarios.
 *
 * TODO(verify-locator): paths and payload field names are guesses modelled on the sibling masters ("<module>/3.0/<verb>"); none
 * was observed on a live build. Adjust MM_PATHS once the traffic has been inspected. The bearer token is read from the page's
 * own requests and is never logged.
 */
import type { Page } from '@playwright/test';

export interface MmApiResult {
  status: number;
  message: string;
  body: unknown;
}

export interface MmRecord {
  /** Internal ID (system generated; never shown on any screen). */
  id: number;
  fieldTitle: string;
  parentTitleId?: number;
  parentTitle: string;
  enumId: string;
  display: boolean;
}

export interface MmPayload {
  fieldTitle?: string;
  parentTitleId?: number | string | null;
  enumId?: string | number | null;
  display?: boolean;
  [extra: string]: unknown;
}

/** TODO(verify-locator): confirm against the real traffic. */
export const MM_PATHS = {
  list: 'miscellaneousMaster/3.0/getList',
  create: 'miscellaneousMaster/3.0/create',
  update: (id: number): string => `miscellaneousMaster/3.0/update/${id}`,
  remove: (id: number): string => `miscellaneousMaster/3.0/delete/${id}`,
  display: (id: number): string => `miscellaneousMaster/3.0/updateDisplay/${id}`,
  detail: (id: number): string => `miscellaneousMaster/3.0/get/${id}`,
  activityEntry: (id: string | number): string => `miscellaneousMaster/3.0/activityLog/${id}`,
} as const;

const API_PATH = /\/setup\/api\//i;
const API_BASE = /^(.*\/setup\/api\/)/i;
const SKIPPED_HEADERS = /^(host|content-length|content-type|cookie|connection|accept-encoding|origin|referer|user-agent|sec-|priority|:)/i;

function messageOf(body: unknown): string {
  if (typeof body === 'string') return body.slice(0, 500);
  const candidate = body as { message?: unknown; title?: unknown; error?: unknown } | null;
  const text = candidate?.message ?? candidate?.title ?? candidate?.error;
  return typeof text === 'string' ? text : '';
}

export class MiscellaneousMasterApi {
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

  hasSession(): boolean {
    return Boolean(this.headers.authorization) && Boolean(this.apiBase);
  }

  /** `path` is relative to the setup API or an absolute URL. Sent from inside the page so the token never reaches the log. */
  async send(method: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE', path: string, data?: unknown): Promise<MmApiResult> {
    if (!this.hasSession()) throw new Error('No authenticated API request has been observed on this page yet; open the Title List first.');
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

  /** Whole master in creation order. TODO(verify-locator): response shape. */
  async fetchAll(): Promise<MmRecord[]> {
    const result = await this.send('POST', MM_PATHS.list, {});
    const rows = Array.isArray(result.body) ? result.body : ((result.body as { data?: unknown })?.data as unknown[] | undefined);
    if (result.status >= 300 || !Array.isArray(rows)) throw new Error(`Title list failed: ${result.status} ${result.message}`);
    return (rows as Array<Record<string, unknown>>).map((row) => ({
      id: Number(row.id),
      fieldTitle: String(row.fieldTitle ?? ''),
      parentTitleId: row.parentTitleId === undefined || row.parentTitleId === null ? undefined : Number(row.parentTitleId),
      parentTitle: String(row.parentTitle ?? ''),
      enumId: row.enumId === undefined || row.enumId === null ? '' : String(row.enumId),
      display: Boolean(row.display),
    }));
  }

  list(): Promise<MmApiResult> {
    return this.send('POST', MM_PATHS.list, {});
  }

  create(payload: MmPayload): Promise<MmApiResult> {
    return this.send('POST', MM_PATHS.create, payload);
  }

  update(id: number, payload: MmPayload): Promise<MmApiResult> {
    return this.send('PUT', MM_PATHS.update(id), { id, ...payload });
  }

  remove(id: number): Promise<MmApiResult> {
    return this.send('DELETE', MM_PATHS.remove(id));
  }

  setDisplay(id: number, display: boolean): Promise<MmApiResult> {
    return this.send('PUT', MM_PATHS.display(id), { id, display });
  }

  /** The consuming-screen read interface (Vendor Registration etc.): the Title with its parent referenced by Internal ID. */
  detail(id: number): Promise<MmApiResult> {
    return this.send('GET', MM_PATHS.detail(id));
  }

  tryModifyActivityEntry(id: string | number): Promise<MmApiResult> {
    return this.send('PUT', MM_PATHS.activityEntry(id), { message: 'Tampered' });
  }

  tryDeleteActivityEntry(id: string | number): Promise<MmApiResult> {
    return this.send('DELETE', MM_PATHS.activityEntry(id));
  }
}
