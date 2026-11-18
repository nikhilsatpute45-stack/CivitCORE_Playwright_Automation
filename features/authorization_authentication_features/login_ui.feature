@AuthNAuthZ @LoginUi
Feature: Login UI
  Automated scenarios for the "Login UI" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: 6.2 F-Password
  @TC_CP_123 @UIVisual @Medium @Automation
  Scenario: Verify Password box is masked, has a show/hide icon and is never pre-filled
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Password | Rahul@2026x |
    When the user types 'Rahul@2026x' in Password
    And the user clicks the show/hide icon twice
    And the user logs out/login again and reopen the page
    Then Characters are masked by default; the icon toggles visibility; the field is empty on every page load (6.2 F-Password)

  # Ref: 6.2 F-Organization
  @TC_CP_124 @UIVisual @Low @Automation
  Scenario: Verify Organization dropdown default text is 'Select Organization'
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Default | Select Organization |
    When the user opens the Login page and read the dropdown
    Then Dropdown displays 'Select Organization' by default (6.2 F-Organization)

  # Ref: 6.2 F-Login
  @TC_CP_125 @UIVisual @Low @Automation
  Scenario: Verify Login CTA is always enabled and disabled while a request is in progress
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Network | Slow 3G |
    When the user observes Login CTA on load
    And the user clicks Login with valid details and throttle the network
    And the user observes the CTA during the request
    Then Login CTA is enabled on load and disabled while the request is in progress (6.2 F-Login)
