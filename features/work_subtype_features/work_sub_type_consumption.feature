@WorkSubType @WorkSubTypeConsumption
Feature: Work Sub Type Consumption
  Automated scenarios for the "Work Sub Type Consumption" module of Work Sub Type.
  Source: CivitINFRA_WorkSubType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-006_CivitINFRA Configuration_Work Sub Type.pdf (PRD Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.6 FB-1
  @TC_WST_140 @Functional @High @Automation
  Scenario: Verify the Create Work form offers only Work Sub Types belonging to the selected Work Type
    Given Admin_User1 is logged in and on the Create Work form
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Road |
    When the user selects Work Type 'Road'
    And the user opens the Work Sub Type selection
    Then Only SH, NH, NH-SEC, NH-SEC-A, NH-SEC-A1 and NH-BYP are offered; no Building or Water Supply Work Sub Types are listed

  # Ref: FRD 5.6 FB-2
  @TC_WST_142 @Functional @High @Automation
  Scenario: Verify a newly created Work Sub Type is available on the Create Work form without extra configuration
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | NEW-1              |
      | Name | New Available Type |
    When the user adds Code 'NEW-1', Name 'New Available Type', Parent Work 'Building'
    And the user opens the Create Work form and select Work Type 'Building'
    Then 'NEW-1 - New Available Type' is offered in the Work Sub Type selection

  # Ref: FRD 5.6 BR-1; FRD 5.2 BR-14
  @TC_WST_143 @Functional @High @Automation
  Scenario: Verify Works refer to the Work Sub Type by its Internal ID so Code/Name edits do not break the reference
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH-BYP -> NHB-2 |
    When the user edits 'NH-BYP' Code to 'NHB-2' and Name to 'NH Bypass Two'
    And the user checks WRK-001 data reference
    Then WRK-001 still links to the same Work Sub Type via its Internal ID and displays the new Code/Name
