/**
 * Out-of-band helpers: the test mailbox (OTP / reset mail) and, later, seeding / token / audit-log calls of the portal API.
 *
 * TODO(endpoint): neither the mailbox API nor the portal's auth API is documented. Paths and response shapes below are
 * ASSUMPTIONS, centralised here, and gated by AUTHN_MAILBOX_URL / AUTHN_API_URL. Nothing here logs OTPs, tokens or passwords.
 */
import type { Page } from '@playwright/test';
import { apiToken, authnConfig, mailboxToken } from '../../support/authn-authz-config';

export interface ApiResult {
  status: number;
  body: unknown;
}

export interface UserState {
  failedAttempts: number;
  locked: boolean;
  status: string;
}

export class AuthApi {
  constructor(private readonly page: Page) {}

  get mailboxConfigured(): boolean {
    return authnConfig.mailboxUrl !== '' && mailboxToken() !== '';
  }

  get apiConfigured(): boolean {
    return authnConfig.apiUrl !== '' && apiToken() !== '';
  }

  /** TODO(endpoint): the portal's test-support API is not documented; every path below is an assumption. */
  private async call(method: 'GET' | 'POST', path: string, data?: unknown): Promise<ApiResult> {
    const response = await this.page.request.fetch(`${authnConfig.apiUrl}${path}`, {
      method,
      data,
      headers: { Authorization: `Bearer ${apiToken()}` },
      failOnStatusCode: false,
    });
    return { status: response.status(), body: await response.json().catch(() => undefined) };
  }

  /** Failed-attempt counter, lock flag and status of a user. TODO(endpoint): assumed `GET /test-support/users/<username>/state`. */
  async userState(username: string): Promise<UserState | undefined> {
    const result = await this.call('GET', `/test-support/users/${encodeURIComponent(username)}/state`);
    if (result.status >= 300 || typeof result.body !== 'object' || result.body === null) return undefined;
    const body = result.body as Partial<UserState>;
    return { failedAttempts: Number(body.failedAttempts ?? 0), locked: Boolean(body.locked), status: String(body.status ?? '') };
  }

  /** TODO(endpoint): assumed `POST /test-support/users/<username>/lock`. Returns true when the call succeeded. */
  async lockUser(username: string): Promise<boolean> {
    return (await this.call('POST', `/test-support/users/${encodeURIComponent(username)}/lock`)).status < 300;
  }

  /** TODO(endpoint): assumed `POST /test-support/users/<username>/unlock` (also resets the failed-attempt counter). Idempotent. */
  async unlockUser(username: string): Promise<boolean> {
    return (await this.call('POST', `/test-support/users/${encodeURIComponent(username)}/unlock`)).status < 300;
  }

  /** True when an audit entry of `event` exists for `username`. TODO(endpoint): assumed `GET /test-support/audit?event=&user=`. */
  async hasAuditEntry(event: string, username: string, reason?: string): Promise<boolean> {
    const result = await this.call('GET', `/test-support/audit?event=${encodeURIComponent(event)}&user=${encodeURIComponent(username)}`);
    if (result.status >= 300 || !Array.isArray(result.body)) return false;
    return (result.body as Array<{ reason?: string }>).some((entry) => !reason || (entry.reason ?? '').toLowerCase().includes(reason.toLowerCase()));
  }

  /** True when the mailbox holds a mail to `email` whose subject matches. TODO(endpoint): assumed `GET <mailbox>/messages?to=`. */
  async hasMail(email: string, subject: RegExp): Promise<boolean> {
    const response = await this.page.request.get(`${authnConfig.mailboxUrl}/messages`, {
      params: { to: email },
      headers: { Authorization: `Bearer ${mailboxToken()}` },
      failOnStatusCode: false,
    });
    if (!response.ok()) return false;
    const body = (await response.json().catch(() => [])) as Array<{ subject?: string }>;
    return Array.isArray(body) && body.some((mail) => subject.test(mail.subject ?? ''));
  }

  /**
   * Latest 6-digit OTP the mailbox received for `email`, polling until `timeoutMs`.
   * TODO(endpoint): assumed `GET <mailbox>/messages/latest?to=<email>` answering `{ "otp": "123456" }`.
   */
  async latestOtp(email: string, timeoutMs = 30000): Promise<string> {
    const deadline = Date.now() + timeoutMs;
    do {
      const response = await this.page.request.get(`${authnConfig.mailboxUrl}/messages/latest`, {
        params: { to: email },
        headers: { Authorization: `Bearer ${mailboxToken()}` },
        failOnStatusCode: false,
      });
      if (response.ok()) {
        const body = (await response.json().catch(() => ({}))) as { otp?: string };
        if (body.otp && /^\d{6}$/.test(body.otp)) return body.otp;
      }
      // Polling an external mailbox: a short sleep between requests is intended (there is no page state to wait on).
      await new Promise((resolve) => setTimeout(resolve, 1000));
    } while (Date.now() < deadline);
    throw new Error('The test mailbox returned no OTP for the persona within the timeout.');
  }
}
