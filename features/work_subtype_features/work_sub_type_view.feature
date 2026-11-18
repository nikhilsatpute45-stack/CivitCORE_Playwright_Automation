@WorkSubType @WorkSubTypeView
Feature: Work Sub Type View
  Automated scenarios for the "Work Sub Type View" module of Work Sub Type.
  Source: CivitINFRA_WorkSubType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-006_CivitINFRA Configuration_Work Sub Type.pdf (PRD Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-4 AC-1; FRD 5.4 FB-1; FRD 5.4 FB-2
  @TC_WST_090 @Functional @High @Automation
  Scenario: Verify the View pop-up shows Code, Name, Parent Work, Added Under, Level, Created By, Created On, Last Modified By and Last Modified On in read-only mode
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH-SEC - NH Sections (Level 2) |
    When the user clicks kebab (⋮) of 'NH-SEC - NH Sections'
    And the user selects View
    Then 'View Work Sub Type' pop-up shows Code NH-SEC, Name NH Sections, Parent Work Road, Added Under "NH – National Highway", Level 2, Created By/On and Last Modified By/On
    And All values are read-only

  # Ref: US-4 AC-1; FRD 5.4 FB-2
  @TC_WST_091 @Functional @Medium @Automation
  Scenario: Verify 'Added Under' shows '-' for a Level 1 Work Sub Type in the View pop-up
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH - State Highway (Level 1) |
    When the user opens View for 'SH - State Highway'
    Then Added Under shows "-" and Level shows 1

  # Ref: FRD 5.4 FB-2
  @TC_WST_092 @Functional @Medium @Automation
  Scenario: Verify Last Modified By and Last Modified On show '-' for a record never modified
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH - State Highway (never edited) |
    When the user opens View for a never-modified record 'SH - State Highway'
    Then Last Modified By and Last Modified On both display "-"

  # Ref: FRD 5.5 FB-4; FRD 5.4 FB-2
  @TC_WST_093 @Functional @High @Automation
  Scenario: Verify Last Modified By and Last Modified On are populated after a record is edited
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New Name | State Highways |
    When the user edits 'SH - State Highway' Name to 'State Highways' and Save
    And the user opens View for the record
    Then Last Modified By shows Admin_User1 and Last Modified On shows the update date-time

  # Ref: US-4 AC-2
  @TC_WST_094 @Functional @High @Automation
  Scenario: Verify no field is editable on the View pop-up
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH |
    When the user opens View for 'NH - National Highway'
    And the user clicks/try typing in each field
    Then No field can be edited

  # Ref: FRD 5.4 FB-3; FRD 5.5 FB-1
  @TC_WST_095 @Functional @Medium @Automation
  Scenario: Verify the 'Edit' button on the View pop-up opens the Edit pop-up for the same record
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH - State Highway |
    When the user opens View for 'SH - State Highway'
    And the user clicks 'Edit'
    Then The 'Edit Work Sub Type' pop-up opens pre-filled for 'SH - State Highway'

  # Ref: US-4 AC-2; FRD 5.4 FB-4
  @TC_WST_096 @Functional @Medium @Automation
  Scenario: Verify 'Close' returns to the list with the same expanded/collapsed state and search values
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search    | NH       |
      | Collapsed | Building |
    When the user collapses 'Building'
    And the user types 'NH' in the Code column search
    And the user opens View for 'NH-BYP' and click Close
    Then The list is shown with the same search value and 'Building' still collapsed

  # Ref: FRD 5.4 FB-4
  @TC_WST_097 @Functional @Medium @Automation
  Scenario: Verify the close (X) icon returns to the list with the same expanded/collapsed state and search values
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search    | NH       |
      | Collapsed | Building |
    When the user collapses 'Building'
    And the user types 'NH' in the Code column search
    And the user opens View for 'NH-BYP' and click the close (X) icon
    Then The list is shown with the same search value and 'Building' still collapsed

  # Ref: FRD 5.4 BR-1
  @TC_WST_098 @Functional @High @Automation
  Scenario: Verify View does not change data or create an Activity Log entry
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH |
    When the user notes the record values and the Activity Log entry count
    And the user opens View for 'SH - State Highway' and close it
    And the user compares values and Activity Log
    Then Record data is unchanged and no Activity Log entry is created

  # Ref: FRD 5.4 BR-2
  @TC_WST_099 @Functional @Medium @Automation
  Scenario: Verify the list is refreshed without a toaster when the record was deleted by another user before View is opened
    Given Admin_User1 is logged in (Session A); Admin_User2 (Delete permission) is logged in (Session B)
    And Both are on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH - State Highway |
    When In Session B delete 'SH - State Highway'
    And In Session A click kebab of 'SH' and select View
    Then The list is refreshed and 'SH' is no longer shown
    And No toaster message is displayed
