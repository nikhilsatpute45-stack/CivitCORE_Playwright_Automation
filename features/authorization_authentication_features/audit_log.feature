@AuthNAuthZ @AuditLog
Feature: Audit Log
  Automated scenarios for the "Audit Log" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: 7.1 A-Login; US-10 AC-1
  @TC_CP_100 @Functional @High @Automation
  Scenario: Verify 'Login Success' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | Method | Password     |
      | User   | rahul.sharma |
    When the user logs in as rahul.sharma with the correct credentials and open the Audit Trail
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then 'Login Success' with user identifier, method Password and outcome Success. (US-10 AC-1)

  # Ref: 7.1 A-Login; US-10 AC-1
  @TC_CP_101 @Functional @High @Automation
  Scenario: Verify 'Login Failed' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | Method | Password          |
      | Reason | wrong credentials |
    When the user attempts login with a wrong password and open the Audit Trail
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then 'Login Failed' with user identifier, method, outcome Failed and reason 'wrong credentials'. (US-10 AC-1)

  # Ref: 7.1 A-Login; US-10 AC-1
  @TC_CP_102 @Functional @High @Automation
  Scenario: Verify 'Login Blocked - Locked / Inactive / Organization Not Mapped' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | Events | Login Blocked - Locked                  |
      | Data   | Login Blocked - Inactive                |
      | Data   | Login Blocked - Organization Not Mapped |
    When the user triggers login with lock.user, inactive.user and an unmapped organization
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then A separate 'Login Blocked' entry with matching reason for each case (EX-03, EX-04, EX-05a). (US-10 AC-1)

  # Ref: 7.1 A-Lock; US-10 AC-1
  @TC_CP_103 @Functional @High @Automation
  Scenario: Verify 'Account Locked' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | Reason | failed attempts |
    When the user locks lock.user through 5 failures and check the Audit Trail
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then 'Account Locked' with user and reason 'failed attempts'. (US-10 AC-1)

  # Ref: 7.1 A-OTP; US-10 AC-1
  @TC_CP_104 @Functional @High @Automation
  Scenario: Verify 'OTP Requested / Verified / Failed' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | Purpose | login |
    When the user requests an OTP, enter a wrong then the correct OTP and check the Audit Trail
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then 'OTP Requested', 'OTP Failed' and 'OTP Verified' with user, purpose and outcome. (US-10 AC-1)

  # Ref: 7.1 A-OTP; US-10 AC-1
  @TC_CP_105 @Functional @High @Automation
  Scenario: Verify 'OTP Delivery Failed' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | Purpose | login |
    When the user simulates mail failure and request an OTP
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then 'OTP Delivery Failed' with outcome Failed (EX-08). (US-10 AC-1)

  # Ref: 7.1 A-PwdReset; US-10 AC-1
  @TC_CP_106 @Functional @High @Automation
  Scenario: Verify 'Password Reset' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | User | rahul.sharma |
    When the user completes a password reset and check the Audit Trail
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then 'Password Reset' with user, outcome and number of sessions ended. (US-10 AC-1)

  # Ref: 7.1 A-Session; US-10 AC-1
  @TC_CP_107 @Functional @High @Automation
  Scenario: Verify 'Organization Selected / Logout / Session Expired' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | User | rahul.sharma    |
      | Org  | Alpha Infra Ltd |
    When the user logs in, logout, login and let the session expire
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then Entries for each event with user, organization, module and active role. (US-10 AC-1)

  # Ref: 7.1 A-Session; US-10 AC-1
  @TC_CP_108 @Functional @High @Automation
  Scenario: Verify 'Session Ended - Role Changed' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | Role | Project Manager |
    When the user removes the active role during a session and send a request
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then 'Session Ended - Role Changed' is audited (EX-16). (US-10 AC-1)

  # Ref: 7.1 A-Denied; US-10 AC-1
  @TC_CP_109 @Functional @High @Automation
  Scenario: Verify 'Access Denied / Organization Access Denied / Module Access Denied' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | Events | Access Denied              |
      | Data   | Organization Access Denied |
      | Data   | Module Access Denied       |
    When the user triggers a denied page, other-org record and unpermitted module
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then Entries with user, organization, requested item and reason. (US-10 AC-1)

  # Ref: 7.1 A-Mapping; US-10 AC-1
  @TC_CP_110 @Functional @High @Automation
  Scenario: Verify 'Mapping Changed' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | User | kiran.patil |
    When the user adds and remove an organization/office mapping for a user
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then 'Mapping Changed' with administrator, affected user and organization/office added or removed. (US-10 AC-1)

  # Ref: 7.1 A-Role; US-10 AC-1
  @TC_CP_111 @Functional @High @Automation
  Scenario: Verify 'Role Created / Updated / Activated / Deactivated' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | Role | Estimator |
    When the user creates, edit, deactivate and activate a role
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then Entries with administrator, role and previous/new values. (US-10 AC-1)

  # Ref: 7.1 A-Assign; US-10 AC-1
  @TC_CP_112 @Functional @High @Automation
  Scenario: Verify 'Roles Assigned / Removed' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | User | anita.desai |
    When the user assigns two roles and then remove one for a user
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then Entries with administrator, user, organization, roles and their order. (US-10 AC-1)

  # Ref: 7.1 A-Switch; US-10 AC-1
  @TC_CP_113 @Functional @High @Automation
  Scenario: Verify 'Role Switched' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | Previous | Project Manager |
      | New      | Finance Viewer  |
    When the user switches from Project Manager to Finance Viewer
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then 'Role Switched' with user, organization, previous and new role (6.8 SW-6). (US-10 AC-1)

  # Ref: 7.1 A-Perm; US-10 AC-1
  @TC_CP_114 @Functional @High @Automation
  Scenario: Verify 'Permissions Changed' is recorded in the Audit Trail with the required information
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And The triggering action is performed first
    And the following test data is used
      | Role | Project Manager  |
      | Node | Project Schedule |
    When the user changes an action and an Excluded flag for a role
    And the user opens the Audit Trail screen and filter Function 'Authentication & Authorization'
    Then 'Permissions Changed' with administrator, role, node, actions/Excluded flag and previous/new values. (US-10 AC-1)

  # Ref: 7.1 A-Fields
  @TC_CP_115 @Functional @Medium @Automation
  Scenario: Verify audit entry captures all standard fields and is read-only
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Entry | Login Success of rahul.sharma |
    When the user opens any authentication audit entry
    And the user checks fields and attempt to edit/delete it
    Then Entry contains Event ID, Timestamp, User, Event Type, Organization, affected user/role/permission, Action, Outcome, Reason, Client IP and Class Name under Function 'Authentication & Authorization'; entries cannot be edited or deleted (7.1)

  # Ref: US-10 AC-2; 6.11 SR-10
  @TC_CP_116 @Functional @High @Automation
  Scenario: Verify audit entries never contain passwords, OTPs, CAPTCHA answers, session tokens or reset tokens
    Given auditor.user (Audit Trail view access) is logged in
    And Baseline data (see Summary) is loaded
    And Login, OTP, reset flows have been executed
    And the following test data is used
      | Secrets | Rahul@2026x     |
      | Data    | OTP as received |
      | Data    | CAPTCHA text    |
      | Data    | cookie token    |
    When the user searches all audit entries for the used password, OTP, CAPTCHA text, session token and reset token
    Then No secret values appear in any entry (US-10 AC-2, 6.11 SR-10)
