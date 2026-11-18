@AuthNAuthZ @OrganizationSessionLogout
Feature: Organization, Session & Logout
  Automated scenarios for the "Organization, Session & Logout" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: 6.5 FB-5; US-4 AC-4; 6.6 BR-2
  @TC_CP_043 @Functional @High @Automation
  Scenario: Verify header shows user name, active organization and active role with Switch Role and Logout and no organization switch
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Modules | CivitCORE, CivitINFRA |
    When the user observes the header in CivitCORE
    And the user looks for any organization-switching control in every module
    Then Header shows user name, 'Alpha Infra Ltd' and 'Project Manager', a Switch Role control and Logout; no organization-switching option exists (6.5 FB-5, US-4 AC-4)

  # Ref: 6.5 FB-6; US-5 AC-3
  @TC_CP_044 @Functional @High @Automation
  Scenario: Verify logout ends the session in all modules with the logout message
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And Session is also open in CivitINFRA
    And the following test data is used
      | Modules | CivitCORE, CivitINFRA |
    When the user clicks Logout in CivitCORE
    And the user observes the page
    And the user refreshes the CivitINFRA tab
    Then Login page shows 'You have been logged out successfully.'
    And CivitINFRA requires login on the next request (6.5 FB-6, US-5 AC-3)

  # Ref: 6.5 FB-7; US-5 AC-4; EX-13; 6.1 P-Idle
  @TC_CP_045 @Functional @High @Automation
  Scenario: Verify session expires after 30 minutes of inactivity with the expiry message
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Idle | 30 minutes |
    When the user stays idle for 30 minutes
    And the user clicks any menu item
    Then Redirected to Login with 'Your session has expired. Please log in again.'; unsaved data is not saved (6.5 FB-7, US-5 AC-4, EX-13)

  # Ref: 6.5 FB-7
  @TC_CP_046 @Functional @Medium @Automation
  Scenario: Verify unsaved data is not saved when the session expires
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role Name typed | Draft Role |
    When the user opens Add Role form (as role admin) and type unsaved data
    And the user stays idle 30 minutes and click Save
    Then Redirect to Login; the role 'Draft Role' is not created (6.5 FB-7)

  # Ref: 6.5 BR-1; US-7 AC-3
  @TC_CP_047 @Functional @High @Automation
  Scenario: Verify the active organization is fixed for the session and a different organization needs logout and re-login
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Org A | Alpha Infra Ltd    |
      | Org B | Beta Constructions |
    When the user checks the active organization in the header
    And the user logs out and login to 'Beta Constructions'
    And the user checks the header, role and Switch Role list
    Then Organization cannot change within the session; the new login shows 'Beta Constructions' with only 'Finance Viewer' (6.5 BR-1, US-7 AC-3)

  # Ref: 6.5 BR-4; EX-14
  @TC_CP_048 @Functional @High @Automation
  Scenario: Verify the session ends on next request when the user account is deactivated during the session
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded. admin.user can deactivate users
    And the following test data is used
      | User | rahul.sharma |
    When As admin.user deactivate rahul.sharma
    And As rahul.sharma perform any action
    Then Session ends in all modules; Login page shows 'Your account is inactive. Please contact your administrator.' (6.5 BR-4, EX-14)

  # Ref: 6.11 SR-5; 6.5 BR-5
  @TC_CP_049 @Functional @High @Automation
  Scenario: Verify session token cookie is Secure and HttpOnly, renewed at login and invalidated at logout
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Tokens | T1 (first), T2 (second) |
    When the user logs in and capture the session cookie attributes and token value T1
    And the user logs out, then login again and capture T2
    And the user replays a request using T1
    Then Cookie has Secure and HttpOnly flags; T2 differs from T1; the replay with T1 is rejected (6.11 SR-5, 6.5 BR-5)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: 6.5 BR-5; 6.11 SR-5
  @TC_CP_206 @Negative @High @Automation
  Scenario: Verify a logged-out session token is rejected by the server
    Given rahul.sharma logged out; the old token T1 was captured
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Token | T1 |
    When the user sends an authenticated API request with T1
    Then Request is rejected and requires login (6.5 BR-5, 6.11 SR-5)

  # Ref: EX-13; 6.5 BR-5
  @TC_CP_207 @Negative @High @Automation
  Scenario: Verify an expired session token is rejected
    Given Session expired by idle timeout
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Token | expired |
    When the user replays the expired token
    Then Rejected with redirect to Login and 'Your session has expired. Please log in again.' (EX-13, 6.5 BR-5)

  # Ref: US-4 AC-5; 6.5 BR-2; EX-12; 7.1 A-Denied
  @TC_CP_208 @Negative @High @Automation
  Scenario: Verify a request referring to another organization's data is rejected and audited (URL/API/token manipulation)
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Orgs | Alpha Infra Ltd -> Beta Constructions |
    When the user changes the organizationId parameter in an API call to Beta Constructions
    And the user edits the organization claim in the token
    And the user changes a record URL to another organization's record
    Then Server returns HTTP 403 with 'You do not have permission to access this record.'; 'Organization Access Denied' is audited (US-4 AC-5, 6.5 BR-2, EX-12)

  # Ref: US-6 AC-2; EX-12; 6.7 BR-2
  @TC_CP_209 @Negative @High @Automation
  Scenario: Verify access is denied for data of an unmapped office of the same organization
    Given pune.user (Pune Office only) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | PRJ-HO-01 |
    When the user opens Head Office record PRJ-HO-01 by URL and API
    Then HTTP 403 and 'You do not have permission to access this record.'; audit 'Organization Access Denied' (US-6 AC-2, EX-12)

  # Ref: 6.5 FB-7; 6.1 P-Absolute
  @TC_CP_210 @Negative @Medium @Automation
  Scenario: Verify absolute lifetime of 12 hours ends the session despite activity
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Lifetime | 12 hours |
    When the user stays active for 12 hours 1 minute
    Then Next request redirects to Login with the session-expired message (6.5 FB-7, 6.1 P-Absolute)

  # Ref: 6.1 P-Idle
  @TC_CP_211 @Negative @Medium @Automation
  Scenario: Verify the idle session does not expire at 29 minutes (boundary)
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Idle | 29 minutes |
    When the user stays idle for 29 minutes and send a request
    Then Session is still valid (6.1 P-Idle)
