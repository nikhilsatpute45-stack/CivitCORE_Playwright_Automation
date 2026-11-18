@AuthNAuthZ @SecurityRequirements
Feature: Security Requirements
  Automated scenarios for the "Security Requirements" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: 6.11 SR-4
  @TC_CP_117 @Functional @High @Automation
  Scenario: Verify Login, OTP and Forgot Password responses are identical for existing and non-existing identities
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Emails | rahul.sharma@example.com |
      | Data   | unknown@example.com      |
    When the user requests OTP for rahul.sharma@example.com and for unknown@example.com
    And the user compares toaster, response time and body
    Then Responses are identical, revealing no account existence (6.11 SR-4)

  # Ref: 6.1 P-RateLimit; 6.11 SR-3
  @TC_CP_118 @Functional @High @Automation
  Scenario: Verify OTP rate limits: 5 requests per user and 20 per IP address per hour
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Limits | 5 per user |
      | Data   | 20 per IP  |
    When the user requests OTP 5 times for rahul.sharma within an hour (with resends spaced)
    And the user requests a 6th time
    And From one IP request OTP for 21 different users
    Then The 6th request for one user and the 21st for one IP are blocked (6.1 P-RateLimit, 6.11 SR-3)

  # Ref: 6.11 SR-9
  @TC_CP_119 @Functional @High @Automation
  Scenario: Verify all authentication pages and APIs are served over HTTPS only
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | URL | http://<host>/login |
    When the user requests the login page and login API over http://
    Then Request is redirected to HTTPS or refused; no credentials are accepted over HTTP (6.11 SR-9)

  # Ref: 6.11 SR-6; 6.11 SR-7
  @TC_CP_120 @Functional @High @Automation
  Scenario: Verify every request is authorized on the server using session, organization, office, role and permission
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Calls | GET /schedules (role changed), GET /projects/PRJ-HO-01 |
    When the user replays a Project Schedule API call with Finance Viewer role context and with another office's record ID
    Then Server denies unauthorized requests irrespective of UI (6.11 SR-6, 6.11 SR-7)

  # Ref: 6.11 SR-8; 6.4 FB-3
  @TC_CP_121 @Functional @High @Automation
  Scenario: Verify reset authorization is single-use and expires after 10 minutes
    Given Reset Password screen reached at T. Baseline data (see Summary) is loaded
    And the following test data is used
      | Validity | 10 minutes |
    When the user submits a successful reset
    And the user reuses the same reset URL/token
    And the user opens a new flow and submit after 11 minutes
    Then Reuse and expired submission are rejected and the user must restart (6.11 SR-8, 6.4 FB-3)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-10 AC-2; 6.11 SR-10
  @TC_CP_240 @Negative @High @Automation
  Scenario: Verify audit entries do not store the wrong password entered at login
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And A failed login with 'Wrong@123' was performed
    And the following test data is used
      | Password | Wrong@123 |
    When the user searches audit entries for 'Wrong@123'
    Then No entry contains the password (US-10 AC-2, 6.11 SR-10)

  # Ref: 6.11 SR-3
  @TC_CP_241 @Negative @High @Automation
  Scenario: Verify brute-force protection: repeated wrong OTP and password attempts cannot bypass CAPTCHA/lockout
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attempts | 20     |
      | CAPTCHA  | reused |
    When the user automates 20 login attempts with a script reusing a solved CAPTCHA
    Then Reused CAPTCHA is rejected and the account locks at 5 failures (6.11 SR-3)

  # Ref: EX-11
  @TC_CP_242 @Negative @High @Automation
  Scenario: Verify unauthorized API call returns HTTP 403 without data
    Given anita.desai token is used
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | API | GET /invoices |
    When the user calls an API of a page she has no permission for
    Then HTTP 403, no data in body and 'Access Denied' audited (EX-11)
