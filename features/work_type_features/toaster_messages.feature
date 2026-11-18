@WorkType @ToasterMessages
Feature: Toaster Messages
  Automated scenarios for the "Toaster Messages" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: Sec 7 (5 seconds)
  @TC_WT_118 @Functional @Medium @Automation
  Scenario: Verify the success toaster closes automatically after 5 seconds (Ref Sec 7 (5 seconds))
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | Building       |
    When the user creates a Work Type
    And the user starts a timer when the toaster 'Work Type added successfully.' appears
    And the user does not interact
    Then Toaster closes automatically after 5 seconds

  # Ref: Sec 7 (5 seconds); Sec 7 T4
  @TC_WT_119 @Functional @Medium @Automation
  Scenario: Verify the error toaster closes automatically after 5 seconds (Ref Sec 7 (5 seconds), Sec 7 T4)
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Terminal Building |
    When the user selects Delete on 'Terminal Building'
    And the user starts a timer when the error toaster appears
    And the user does not interact
    Then Toaster 'This Work Type is used in one or more Works and cannot be deleted.' closes automatically after 5 seconds
