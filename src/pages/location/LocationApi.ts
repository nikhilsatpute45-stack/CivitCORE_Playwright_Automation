/**
 * Location API: records the traffic of one browser page and replays authenticated requests.
 *
 * The tab loads the whole tree with POST /setup/api/location/3.0/getHierarchy and saves with
 * create / update/<id> / delete/<id>. Confirmed live (see src/test-data/location.data.ts header) create
 * payload: {locName, locCode, locCatID, locIdnCode, locParentID, orgID} -> {data: <id>, message: "Location
 * Created Successfully"}; delete -> {message: "Location Deleted Successfully"}. "Parent Category" is a
 * client-side filter only: it narrows the Parent Location dropdown but is never itself sent - only the
 * chosen Parent Location's id goes in locParentID.
 *
 * `send` re-uses the headers (bearer token) of the page's own requests, which is how scenarios submit the
 * tampered / direct requests the FRD's "via API" / "UI bypassed" scenarios ask for. One instance exists per
 * page and is shared by every Location page object (same pattern as LocationCategoryApi).
 */
import type { Page, Response } from '@playwright/test';
import { expect } from '../../utils/assertions';
import { API_ORG_ID } from '../../test-data/location.data';

export interface LocationRecord {
  id: number;
  name: string;
  code: string;
  /** Name / code exactly as stored (not trimmed), to prove the app trims what users type. */
  rawName: string;
  rawCode: string;
  categoryId: number | null;
  categoryName: string;
  /** Id of the Location this one is nested under, or null for a top-level (L1) record. */
  parentId: number | null;
  /** 0 for a top-level record. */
  depth: number;
}

export type LocationOperation = 'Create' | 'Update' | 'Delete';

export interface LocationApiCall {
  operation: LocationOperation;
  status: number;
  /** Created id (Create) or the id in the request URL (Update / Delete). */
  id?: number;
  message: string;
  method: string;
  url: string;
  requestBody?: string;
}

export interface ApiResult {
  status: number;
  message: string;
  body: unknown;
}

export interface CreatePayload {
  locName: string;
  locCode: string;
  locCatID?: number | string | null;
  locIdnCode?: string;
  locParentID?: number | string | null;
  orgID?: number;
  [extra: string]: unknown;
}

export const MUTATION_URL = /\/location\/3\.0\/(create|update|delete)\b(?:\/(\d+))?/i;
const HIERARCHY_URL = /\/location\/3\.0\/getHierarchy/i;
const API_PATH = /\/setup\/api\//i;
const API_BASE = /^(.*\/setup\/api\/)/i;
export const SUBMIT_TIMEOUT = 20000;

interface HierarchyNode {
  id: number;
  displayName?: string;
  locCode?: string | null;
  locCatId?: number | null;
  locCategoryName?: string | null;
  location?: HierarchyNode[];
}

/** Request headers the replay must not copy (the browser sets them, or the cookie jar supplies them). */
const SKIPPED_HEADERS = /^(host|content-length|content-type|cookie|connection|accept-encoding|origin|referer|user-agent|sec-|priority|:)/i;

export function operationOf(value: string): LocationOperation {
  const lower = value.toLowerCase();
  return lower === 'create' ? 'Create' : lower === 'update' ? 'Update' : 'Delete';
}

export class LocationApi {
  /** Every create / update / delete response seen on this page, oldest first. */
  readonly apiCalls: LocationApiCall[] = [];
  /** Every delete request sent from this page (recorded synchronously, before any response). */
  readonly deleteRequests: number[] = [];
  /** Ids of records the test created / deleted with direct API calls (the page also sees those responses). */
  readonly directIds = new Set<number>();
  private master: LocationRecord[] = [];
  private version = 0;
  private headers: Record<string, string> = {};
  private apiBase?: string;
  /** Set when the grid's own getHierarchy call itself fails server-side, so a stuck expectMasterLoaded() can
   *  report the real cause instead of a generic "stayed at 0" timeout. Cleared on the next successful call. */
  private hierarchyError?: string;

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

  get masterVersion(): number {
    return this.version;
  }

  records(): LocationRecord[] {
    return [...this.master];
  }

  recordById(id: number): LocationRecord | undefined {
    return this.master.find((record) => record.id === id);
  }

  recordsNamed(name: string): LocationRecord[] {
    const expected = normalize(name);
    return this.master.filter((record) => normalize(record.name) === expected);
  }

  childrenOf(id: number): LocationRecord[] {
    return this.master.filter((record) => record.parentId === id);
  }

  async expectMasterLoaded(): Promise<void> {
    await expect
      .poll(
        () => {
          if (this.master.length === 0 && this.hierarchyError) {
            throw new Error(`the Location Master failed to load: ${this.hierarchyError}`);
          }
          return this.master.length;
        },
        { timeout: 30000, message: 'Location master was loaded' },
      )
      .toBeGreaterThan(0);
  }

  async waitForMaster(predicate: (records: LocationRecord[]) => boolean, message: string): Promise<void> {
    await expect.poll(() => predicate(this.master), { timeout: SUBMIT_TIMEOUT, message }).toBe(true);
  }

  async waitForReloadAfter(version: number, message = 'the Location list reloaded'): Promise<void> {
    await expect.poll(() => this.version, { timeout: SUBMIT_TIMEOUT, message }).toBeGreaterThan(version);
  }

  nextMutation(): Promise<Response | null> {
    return this.page
      .waitForResponse((candidate) => MUTATION_URL.test(candidate.url()) && candidate.request().method() !== 'GET', { timeout: SUBMIT_TIMEOUT })
      .catch(() => null);
  }

  nextDelete(): Promise<Response> {
    return this.page.waitForResponse((candidate) => /\/location\/3\.0\/delete\b/i.test(candidate.url()), { timeout: SUBMIT_TIMEOUT });
  }

  createdIds(): number[] {
    return [...new Set(this.apiCalls.filter((call) => call.operation === 'Create' && call.status < 300 && call.id).map((call) => call.id!))];
  }

  lastCall(operation?: LocationOperation): LocationApiCall | undefined {
    return [...this.apiCalls].reverse().find((call) => !operation || call.operation === operation);
  }

  // ---------------------------------------------------------------------------
  // Authenticated requests made from the test (fixtures, "via API" / "UI bypassed" scenarios)
  // ---------------------------------------------------------------------------

  hasSession(): boolean {
    return Boolean(this.headers.authorization) && Boolean(this.apiBase);
  }

  /** `path` is relative to the setup API ("location/3.0/create") or an absolute URL. */
  async send(method: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE', path: string, data?: unknown): Promise<ApiResult> {
    await expect.poll(() => this.hasSession(), { timeout: 30000, message: 'an authenticated Location API request was observed' }).toBe(true);
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

  /** Reads the whole master straight from the API (independent of what the grid has loaded; ~2,700 rows live). */
  async fetchMaster(): Promise<LocationRecord[]> {
    const result = await this.send('POST', 'location/3.0/getHierarchy', { specifiedOrgOnly: false, orgID: API_ORG_ID });
    if (result.status >= 300 || !Array.isArray(result.body)) {
      throw new Error(`getHierarchy failed: ${result.status} ${result.message}`);
    }
    return LocationApi.flatten(result.body as HierarchyNode[]);
  }

  async create(payload: CreatePayload): Promise<ApiResult & { id?: number }> {
    const result = await this.send('POST', 'location/3.0/create', {
      locIdnCode: '',
      locParentID: null,
      orgID: API_ORG_ID,
      ...payload,
    });
    const id = typeof (result.body as { data?: unknown })?.data === 'number' ? ((result.body as { data: number }).data) : undefined;
    if (id !== undefined) this.directIds.add(id);
    return { ...result, id };
  }

  async remove(id: number): Promise<ApiResult> {
    return this.send('DELETE', `location/3.0/delete/${id}`);
  }

  // ---------------------------------------------------------------------------

  static async parseCall(response: Response): Promise<LocationApiCall> {
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
    if (HIERARCHY_URL.test(url)) {
      const base = /^(.*\/setup\/api\/)location\//i.exec(url);
      if (base) this.apiBase = base[1];
      if (!response.ok()) {
        const request = response.request().postData() ?? '';
        response
          .text()
          .then((text) => {
            let body: unknown = text;
            try {
              body = JSON.parse(text);
            } catch {
              // Non-JSON error body: the text itself is the message.
            }
            this.hierarchyError = `${response.status()} ${messageOf(body)} (request: ${request})`;
          })
          .catch(() => undefined);
        return;
      }
      response
        .json()
        .then((body: unknown) => {
          if (!Array.isArray(body)) return;
          const request = response.request().postData() ?? '';
          if (body.length === 0 && /specifiedOrgOnly":\s*true/i.test(request)) return;
          this.hierarchyError = undefined;
          this.master = LocationApi.flatten(body as HierarchyNode[]);
          this.version += 1;
        })
        .catch(() => undefined);
      return;
    }
    if (!MUTATION_URL.test(url) || response.request().method() === 'GET') return;
    LocationApi.parseCall(response)
      .then((call) => this.apiCalls.push(call))
      .catch(() => undefined);
  }

  static flatten(nodes: HierarchyNode[], parentId: number | null = null, depth = 0): LocationRecord[] {
    return nodes.flatMap((node) => [
      {
        id: node.id,
        name: (node.displayName ?? '').trim(),
        code: (node.locCode ?? '').trim(),
        rawName: node.displayName ?? '',
        rawCode: node.locCode ?? '',
        categoryId: node.locCatId ?? null,
        categoryName: (node.locCategoryName ?? '').trim(),
        parentId,
        depth,
      },
      ...LocationApi.flatten(node.location ?? [], node.id, depth + 1),
    ]);
  }
}

function normalize(value: string): string {
  return value.trim().replace(/\s+/g, ' ').toLowerCase();
}

function messageOf(body: unknown): string {
  if (typeof body === 'string') return body.slice(0, 500);
  const value = body as { message?: string; error?: { message?: string }; errors?: Record<string, string[]> } | null;
  const validation = value?.errors ? Object.values(value.errors).flat().join(' ') : '';
  return value?.message ?? value?.error?.message ?? validation;
}
