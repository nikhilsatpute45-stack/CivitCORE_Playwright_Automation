@WorkSubType @ToasterMessages
Feature: Toaster Messages
  Automated scenarios for the "Toaster Messages" module of Work Sub Type.
  Source: CivitINFRA_WorkSubType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-006_CivitINFRA Configuration_Work Sub Type.pdf (PRD Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 7 T-AutoClose
  @TC_WST_155 @Functional @Medium @Automation
  Scenario: Verify all toaster messages close automatically after 5 seconds
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Toasters | added successfully / used in Works |
    When the user adds a valid Work Sub Type and start a timer when the success toaster appears
    And the user selects Delete for 'NH-BYP' and start a timer when the error toaster appears
    Then Each toaster (success and error) closes automatically after 5 seconds

  # Ref: FRD 7 T-Only; US-5 AC-5
  @TC_WST_156 @Functional @Medium @Automation
  Scenario: Verify toasters are displayed only for the events listed in the FRD
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Actions | View, Cancel, no-change Save, No, validation failure |
    When the user performs View, Cancel, no-change Save, No on delete dialog and a validation failure
    Then No toaster is displayed for any of these actions
