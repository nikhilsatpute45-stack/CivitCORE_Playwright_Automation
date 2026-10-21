/**
 * Region API: records the traffic of one browser page and replays authenticated requests.
 *
 * TODO: Verify endpoint once the Region module is developed. Modelled on LocationCategoryApi (the pattern every
 * other Setup master in this build follows: POST .../3.0/getHierarchy or getList to load, create / update/<id> /
 * delete/<id> to save), guessing the Region module keeps the same `/setup/api/<module>/3.0/...` shape under the
 * module name "region". None of these paths have been observed on the live build; the Region tab does not exist
 * yet under Organization Configuration, so `fetchMaster` / `create` / `remove` / `send` cannot be exercised today.
 *
 * `send` re-uses the headers (bearer token) of the page's own requests, exactly like LocationCategoryApi; that
 * part of the mechanism is generic (it reads whatever `/setup/api/` request the page has already made) and does
 * not depend on the Region endpoint existing.
 */
import type { Page, Response } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { API_ORG_ID, normalizeRegionText } from '../../test-data/region.data';

export interface RegionRecord {
  id: number;
  name: string;
  /** Name exactly as stored (not trimmed), to prove the app trims what users type. */
  rawName: string;
  createdBy?: string;
  createdDate?: string;
}

export type RegionOperation = 'Create' | 'Update' | 'Delete';

export interface RegionApiCall {
  operation: RegionOperation;
  status: number;
  /** Created id (Create) or the id in the request URL (Update / Delete). */
  id?: number;
  message: string;
  method: string;
  url: string;
  /** Request body the page sent (JSON text), when there was one. */
  requestBody?: string;
}

export interface ApiResult {
  status: number;
  message: string;
  body: unknown;
}

export interface CreatePayload {
  /** TODO: Verify field name once the Region module is developed (guessed from the sibling masters' "catName" / "displayName" pattern). */
  regionName: string;
  regionId?: string | number;
  orgID?: number;
  [extra: string]: unknown;
}

// TODO: Verify endpoint once the Region module is developed.
export const MUTATION_URL = /\/region\/3\.0\/(create|update|delete)\b(?:\/(\d+))?/i;
const LIST_URL = /\/region\/3\.0\/(getHierarchy|getList|get)\b/i;
const API_PATH = /\/setup\/api\//i;
const API_BASE = /^(.*\/setup\/api\/)/i;
export const SUBMIT_TIMEOUT = 20000;

/** Request headers the replay must not copy (the browser sets them, or the cookie jar supplies them). */
const SKIPPED_HEADERS = /^(host|content-length|content-type|cookie|connection|accept-encoding|origin|referer|user-agent|sec-|priority|:)/i;

export function operationOf(value: string): RegionOperation {
  const lower = value.toLowerCase();
  return lower === 'create' ? 'Create' : lower === 'update' ? 'Update' : 'Delete';
}

export class RegionApi {
  /** Every create / update / delete response seen on this page, oldest first. */
  readonly apiCalls: RegionApiCall[] = [];
  /** Every delete request sent from this page (recorded synchronously, before any response). */
  readonly deleteRequests: number[] = [];
  /** Ids of records the test created / deleted with direct API calls (the page also sees those responses). */
  readonly directIds = new Set<number>();
  private master: RegionRecord[] = [];
  private version = 0;
  private headers: Record<string, string> = {};
  private apiBase?: string;

  constructor(private readonly page: Page) {
    page.on('request', (request) => {
      const url = request.url();
      const match = MUTATION_URL.exec(url);
      if (match && operationOf(match[1]) === 'Delete' && match[2]) this.deleteRequests.push(Number(match[2]));
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
    page.on('response', (response) => this.record(response));
  }

  // ---------------------------------------------------------------------------
  // Master data as the grid loaded it
  // ---------------------------------------------------------------------------

  /** Incremented on every list reload; the grid is expected to reload the master after every save. */
  get masterVersion(): number {
    return this.version;
  }

  records(): RegionRecord[] {
    return [...this.master];
  }

  recordById(id: number): RegionRecord | undefined {
    return this.master.find((record) => record.id === id);
  }

  recordsNamed(name: string): RegionRecord[] {
    const expected = normalizeRegionText(name);
    return this.master.filter((record) => normalizeRegionText(record.name) === expected);
  }

  async expectMasterLoaded(): Promise<void> {
    await expect.poll(() => this.master.length, { timeout: 30000, message: 'the Region master was loaded' }).toBeGreaterThan(0);
  }

  /** Waits for the grid's next master reload that satisfies `predicate`. */
  async waitForMaster(predicate: (records: RegionRecord[]) => boolean, message: string): Promise<void> {
    await expect.poll(() => predicate(this.master), { timeout: SUBMIT_TIMEOUT, message }).toBe(true);
  }

  /** Waits until the master has been reloaded since `version` was read. */
  async waitForReloadAfter(version: number, message = 'the Region list reloaded'): Promise<void> {
    await expect.poll(() => this.version, { timeout: SUBMIT_TIMEOUT, message }).toBeGreaterThan(version);
  }

  /** The next create / update / delete response, or null when none arrives in time. */
  nextMutation(): Promise<Response | null> {
    return this.page
      .waitForResponse((candidate) => MUTATION_URL.test(candidate.url()) && candidate.request().method() !== 'GET', { timeout: SUBMIT_TIMEOUT })
      .catch(() => null);
  }

  /** The next delete response; rejects when none arrives in time. */
  nextDelete(): Promise<Response> {
    return this.page.waitForResponse((candidate) => /\/region\/3\.0\/delete\b/i.test(candidate.url()), { timeout: SUBMIT_TIMEOUT });
  }

  /** Most recent save (create / update) of the page. */
  lastCall(operation?: RegionOperation): RegionApiCall | undefined {
    return [...this.apiCalls].reverse().find((call) => !operation || call.operation === operation);
  }

  // ---------------------------------------------------------------------------
  // Authenticated requests made from the test (fixtures, "UI bypassed" scenarios)
  // ---------------------------------------------------------------------------

  /** True once the page has made an authenticated API request whose headers can be replayed. */
  hasSession(): boolean {
    return Boolean(this.headers.authorization) && Boolean(this.apiBase);
  }

  /** `path` is relative to the setup API ("region/3.0/create") or an absolute URL. */
  async send(method: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE', path: string, data?: unknown): Promise<ApiResult> {
    await expect.poll(() => this.hasSession(), { timeout: 30000, message: 'an authenticated Region API request was observed' }).toBe(true);
    // Sent from inside the page: the browser (unlike Node) trusts the portal's certificate chain, the portal's
    // CORS rules already allow these headers, and a failure never echoes the bearer token into the test log.
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
    const text = response.text;
    let body: unknown = text;
    try {
      body = JSON.parse(text);
    } catch {
      // Non-JSON body (e.g. an empty 403): the text itself is the body.
    }
    return { status: response.status, message: messageOf(body), body };
  }

  /** Reads the whole master straight from the API (independent of what the grid has loaded). TODO: Verify endpoint once the Region module is developed. */
  async fetchMaster(): Promise<RegionRecord[]> {
    const result = await this.send('POST', 'region/3.0/getList', { orgID: API_ORG_ID });
    if (result.status >= 300 || !Array.isArray(result.body)) {
      throw new Error(`Region getList failed: ${result.status} ${result.message}`);
    }
    return RegionApi.parseList(result.body as Array<Record<string, unknown>>);
  }

  async create(payload: CreatePayload): Promise<ApiResult & { id?: number }> {
    const result = await this.send('POST', 'region/3.0/create', { orgID: API_ORG_ID, ...payload });
    const id = typeof (result.body as { data?: unknown })?.data === 'number' ? ((result.body as { data: number }).data) : undefined;
    if (id !== undefined) this.directIds.add(id);
    return { ...result, id };
  }

  async update(id: number, payload: CreatePayload): Promise<ApiResult> {
    return this.send('PUT', `region/3.0/update/${id}`, { id, ...payload });
  }

  async remove(id: number): Promise<ApiResult> {
    return this.send('DELETE', `region/3.0/delete/${id}`);
  }

  // ---------------------------------------------------------------------------

  static async parseCall(response: Response): Promise<RegionApiCall> {
    const match = MUTATION_URL.exec(response.url());
    const operation = operationOf(match?.[1] ?? 'Delete');
    const urlId = match?.[2];
    const body: unknown = await response.json().catch(() => ({}));
    const data = (body as { data?: unknown }).data;
    return {
      operation,
      status: response.status(),
      id: operation === 'Create' ? (typeof data === 'number' ? data : undefined) : urlId ? Number(urlId) : undefined,
      message: messageOf(body),
      method: response.request().method(),
      url: response.url(),
      requestBody: response.request().postData() ?? undefined,
    };
  }

  private record(response: Response): void {
    const url = response.url();
    if (LIST_URL.test(url)) {
      const base = /^(.*\/setup\/api\/)region\//i.exec(url);
      if (base) this.apiBase = base[1];
      response
        .json()
        .then((body: unknown) => {
          if (!Array.isArray(body)) return;
          this.master = RegionApi.parseList(body as Array<Record<string, unknown>>);
          this.version += 1;
        })
        .catch(() => undefined);
      return;
    }
    if (!MUTATION_URL.test(url) || response.request().method() === 'GET') return;
    RegionApi.parseCall(response)
      .then((call) => this.apiCalls.push(call))
      .catch(() => undefined);
  }

  /** TODO: Verify the response shape once the Region module is developed; guessed as a flat list (no hierarchy). */
  static parseList(nodes: Array<Record<string, unknown>>): RegionRecord[] {
    return nodes.map((node) => ({
      id: Number(node.id ?? node.regionId ?? 0),
      name: String(node.displayName ?? node.regionName ?? node.name ?? '').trim(),
      rawName: String(node.displayName ?? node.regionName ?? node.name ?? ''),
      createdBy: node.createdBy === undefined ? undefined : String(node.createdBy),
      createdDate: node.createdDate === undefined ? undefined : String(node.createdDate),
    }));
  }
}

function messageOf(body: unknown): string {
  if (typeof body === 'string') return body.slice(0, 500);
  const value = body as { message?: string; error?: { message?: string }; errors?: Record<string, string[]> } | null;
  const validation = value?.errors ? Object.values(value.errors).flat().join(' ') : '';
  return value?.message ?? value?.error?.message ?? validation;
}
