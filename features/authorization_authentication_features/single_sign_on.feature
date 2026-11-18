@AuthNAuthZ @SingleSignOn
Feature: Single Sign-On
  Automated scenarios for the "Single Sign-On" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-1; 6.6 FB-1; 6.6 FB-3
  @TC_CP_050 @Functional @High @Automation
  Scenario: Verify opening another authorized module opens without login in same organization and role
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | From | CivitCORE  |
      | To   | CivitINFRA |
    When the user opens CivitINFRA from the module menu
    And the user checks header organization and role
    Then CivitINFRA opens without login prompt and shows 'Alpha Infra Ltd' and 'Project Manager' (US-5 AC-1, 6.6 FB-1, 6.6 FB-3)

  # Ref: 6.6 FB-2; US-5 AC-2
  @TC_CP_051 @Functional @High @Automation
  Scenario: Verify module menu lists only modules with at least one permission for the active role
    Given anita.desai is logged in (Site Engineer) with permission only in CivitCORE. Baseline data (see Summary) is loaded
    And the following test data is used
      | User          | anita.desai            |
      | Permitted     | CivitCORE              |
      | Not permitted | CivitINFRA, CivitBUILD |
    When the user opens the module menu
    Then Only CivitCORE is listed (6.6 FB-2, US-5 AC-2)

  # Ref: 6.6 FB-5
  @TC_CP_052 @Functional @Medium @Automation
  Scenario: Verify activity in any module keeps the shared session alive
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And Session open in CivitCORE and CivitINFRA
    And the following test data is used
      | Idle timeout | 30 minutes (shared) |
    When the user idles in CivitCORE for 20 minutes
    And the user performs an action in CivitINFRA at minute 20
    And the user performs an action in CivitCORE at minute 40
    Then The session stays alive because activity in any module resets the shared idle timer (6.6 FB-5)

  # Ref: 6.6 BR-1
  @TC_CP_053 @Functional @High @Automation
  Scenario: Verify SSO grants identity and session only; permissions are checked by each module
    Given anita.desai is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | anita.desai |
      | Module | CivitINFRA  |
    When the user opens CivitINFRA via direct URL
    Then No login prompt, but access is denied because the permission check fails (6.6 BR-1)

  # Ref: 6.6 BR-3
  @TC_CP_054 @Functional @High @Automation
  Scenario: Verify session ends in all modules on password reset, deactivation, mapping removal and role removal
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And Session open in CivitINFRA
    And the following test data is used
      | Events | password reset      |
      | Data   | deactivation        |
      | Data   | mapping removal     |
      | Data   | active role removal |
    When the user performs each event in turn from admin.user: password reset, deactivation, removal of Alpha mapping, removal of active role (re-login between)
    And the user sends a request in CivitINFRA after each event
    Then The session ends in all modules after each event (6.6 BR-3)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-2; 6.6 FB-4; EX-10; 7.1 A-Denied
  @TC_CP_212 @Negative @High @Automation
  Scenario: Verify opening a module without permission by URL shows the module-denied message and audits it
    Given anita.desai is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Module | CivitBUILD |
    When the user opens the CivitBUILD URL directly
    Then 'You do not have permission to access this module.' is shown; 'Module Access Denied' is audited (US-5 AC-2, 6.6 FB-4, EX-10)

  # Ref: 6.6 BR-2; 6.5 BR-2
  @TC_CP_213 @Negative @High @Automation
  Scenario: Verify no module accepts a different organization than the session's active organization
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | orgId | Beta |
    When the user opens CivitINFRA with the orgId parameter set to Beta Constructions
    Then The request is rejected with 403 (6.6 BR-2, 6.5 BR-2)

  # Ref: 6.6 FB-2; 6.8 SW-3
  @TC_CP_214 @Negative @Medium @Automation
  Scenario: Verify a module not permitted for the active role is hidden after switching role
    Given rahul.sharma active role Project Manager has CivitINFRA; Finance Viewer has none
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Finance Viewer |
    When the user switches to Finance Viewer
    And the user opens the module menu
    Then CivitINFRA is not listed (6.6 FB-2, 6.8 SW-3)
