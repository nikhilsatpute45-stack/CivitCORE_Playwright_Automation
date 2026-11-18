@AuthNAuthZ @ResetPasswordUi
Feature: Reset Password UI
  Automated scenarios for the "Reset Password UI" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: 6.4 F-Checklist
  @TC_CP_135 @UIVisual @Low @Automation
  Scenario: Verify the checklist is read-only and not a user input
    Given Reset Password screen is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Data | Checklist items |
    When the user tries clicking the checklist items
    Then Checklist cannot be edited and changes only through typing in New Password (6.4 F-Checklist)
