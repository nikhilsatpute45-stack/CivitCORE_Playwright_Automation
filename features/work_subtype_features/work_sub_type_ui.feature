@WorkSubType @WorkSubTypeUi
Feature: Work Sub Type UI
  Automated scenarios for the "Work Sub Type UI" module of Work Sub Type.
  Source: CivitINFRA_WorkSubType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-006_CivitINFRA Configuration_Work Sub Type.pdf (PRD Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 BR-2
  @TC_WST_179 @UIVisual @High @Automation
  Scenario: Verify the Add/Edit/Delete options are not displayed to a View-only user
    Given Viewer_User1 (Work Sub Type: View only) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user inspects toolbar, Work Type rows and kebab menus
    Then No Add, Add Sub Work Type, Edit or Delete option is displayed
