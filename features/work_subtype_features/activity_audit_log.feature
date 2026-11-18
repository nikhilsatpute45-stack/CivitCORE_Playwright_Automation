@WorkSubType @ActivityAuditLog
Feature: Activity / Audit Log
  Automated scenarios for the "Activity / Audit Log" module of Work Sub Type.
  Source: CivitINFRA_WorkSubType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-006_CivitINFRA Configuration_Work Sub Type.pdf (PRD Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-8 AC-1; FRD 6.1 A-Created; FRD 6 FB-1; FRD 6 FB-3
  @TC_WST_144 @Functional @High @Automation
  Scenario: Verify an Activity Log entry 'Work Sub Type Created' is written with User, Date-Time, Code, Name, Parent Work, Added Under and Level
    Given Admin_User1 and Auditor_User1 exist
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | AUD-1                 |
      | Name        | Audit Created         |
      | Parent Work | Road                  |
      | Added Under | NH - National Highway |
      | Level       | 2                     |
    When As Admin_User1 add Code 'AUD-1', Name 'Audit Created', Parent Work 'Road' from kebab of 'NH - National Highway' (Added Under NH)
    And As Auditor_User1 open the Activity Log section
    Then A 'Work Sub Type Created' entry shows User Admin_User1, Date-Time, Code AUD-1, Name Audit Created, Parent Work Road, Added Under NH, Level 2

  # Ref: US-8 AC-1; US-8 AC-2; FRD 6.1 A-Updated; FRD 6 FB-3
  @TC_WST_145 @Functional @High @Automation
  Scenario: Verify an Activity Log entry 'Work Sub Type Updated' captures each changed field with previous and new value
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | SH -> SH-1                         |
      | Name | State Highway -> State Highway One |
    When the user edits 'SH - State Highway': change Code to 'SH-1' and Name to 'State Highway One'
    And the user opens the Activity Log section
    Then A 'Work Sub Type Updated' entry shows User, Date-Time, Code, Name, Parent Work and, for each changed field (Code, Name), Field Name, Previous Value and New Value

  # Ref: US-8 AC-2; FRD 6.1 A-Updated
  @TC_WST_146 @Functional @Medium @Automation
  Scenario: Verify the Updated entry lists only the field that was changed when one field is edited
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | State Highway -> State Highways |
    When the user edits 'SH - State Highway': change only Name to 'State Highways'
    And the user opens the Activity Log section
    Then The entry lists only Field Name 'Name' with Previous Value 'State Highway' and New Value 'State Highways'

  # Ref: US-8 AC-1; FRD 6.1 A-Deleted; FRD 5.7 FB-5
  @TC_WST_147 @Functional @High @Automation
  Scenario: Verify an Activity Log entry 'Work Sub Type Deleted' is written with User, Date-Time, Code, Name and Parent Work
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record      | SH - State Highway |
      | Parent Work | Road               |
    When the user deletes 'SH - State Highway' (Yes)
    And the user opens the Activity Log section
    Then A 'Work Sub Type Deleted' entry shows User Admin_User1, Date-Time, Code SH, Name State Highway, Parent Work Road

  # Ref: US-8 AC-1; FRD 6.1 A-Blocked; FRD 5.7 DR-1; FRD 5.7 FB-3
  @TC_WST_148 @Functional @High @Automation
  Scenario: Verify 'Work Sub Type Deletion Blocked' is logged with reason 'Work' when the Work Sub Type is used in a Work
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH-BYP |
    When the user selects Delete for 'NH-BYP' (used in WRK-001)
    And the user opens the Activity Log section
    Then A 'Work Sub Type Deletion Blocked' entry shows User, Date-Time, Code NH-BYP, Name, Parent Work Road and Reason 'Work'

  # Ref: FRD 6.1 A-Blocked; FRD 5.7 DR-2
  @TC_WST_149 @Functional @High @Automation
  Scenario: Verify 'Work Sub Type Deletion Blocked' is logged with reason 'Child Work Sub Type' when only children exist
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | RB |
    When the user selects Delete for 'RB - Residential Building'
    And the user opens the Activity Log section
    Then A 'Work Sub Type Deletion Blocked' entry shows Reason 'Child Work Sub Type'

  # Ref: FRD 5.7 DR-3; FRD 6.1 A-Blocked
  @TC_WST_150 @Functional @Medium @Automation
  Scenario: Verify the Deletion Blocked entry has reason 'Work' only when a record is used in Works and has children
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH-SEC |
    When the user selects Delete for 'NH-SEC' (used and has child)
    And the user opens the Activity Log section
    Then The entry shows Reason 'Work' only

  # Ref: FRD 6 FB-2; FRD 5.2 BR-14
  @TC_WST_151 @Functional @Medium @Automation
  Scenario: Verify each Activity Log entry is linked to the Work Sub Type's Internal ID
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH |
    When the user edits 'SH - State Highway' name and Save
    And the user inspects the Activity Log record in the database
    Then The entry stores the Internal ID of the Work Sub Type, not Code/Name as the reference

  # Ref: FRD 6 FB-4
  @TC_WST_152 @Functional @Medium @Automation
  Scenario: Verify Activity Log entries are displayed most recent first
    Given Auditor_User1 has access to the Activity Log section
    And Two or more entries exist for one Work Sub Type
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | AUD-2 |
    When the user performs an add and an update on 'AUD-2'
    And the user opens the Activity Log section
    Then The Updated entry is displayed above the Created entry (most recent first)

  # Ref: FRD 5.2 FB-6; FRD 6 FB-1
  @TC_WST_153 @Functional @Medium @Automation
  Scenario: Verify no Activity Log entry is written when Cancel is used on Add
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | AUD-C |
    When the user enters Code 'AUD-C', Name 'Audit Cancel', Parent Work 'Road'
    And the user clicks Cancel
    And the user opens the Activity Log section
    Then No entry exists for 'AUD-C'

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6 FB-4; US-8 AC-1
  @TC_WST_249 @Negative @High @Automation
  Scenario: Verify Activity Log entries cannot be edited by any user
    Given Auditor_User1 and Admin_User1 are logged in (separate sessions)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1 / Auditor_User1 |
    When the user opens the Activity Log section and look for edit options on a 'Work Sub Type Created' entry
    And the user sends an update request for the Activity Log record via API
    Then No edit option exists; the API request is rejected and the entry is unchanged

  # Ref: FRD 6 FB-4; US-8 AC-1
  @TC_WST_250 @Negative @High @Automation
  Scenario: Verify Activity Log entries cannot be deleted by any user
    Given Admin_User1 is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1 |
    When the user looks for delete options on an Activity Log entry
    And the user sends a delete request for the Activity Log record via API
    Then No delete option exists; the API request is rejected and the entry remains

  # Ref: FRD 5.7 DR-1; FRD 6.1 A-Deleted
  @TC_WST_251 @Negative @Medium @Automation
  Scenario: Verify no 'Work Sub Type Deleted' entry is written when the deletion is blocked
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH-BYP |
    When the user selects Delete for 'NH-BYP' (used in WRK-001)
    And the user opens the Activity Log
    Then Only a 'Work Sub Type Deletion Blocked' entry is written; no 'Work Sub Type Deleted' entry exists

  # Ref: US-5 AC-5; FRD 5.5 FB-5
  @TC_WST_252 @Negative @Medium @Automation
  Scenario: Verify no Activity Log entry is written for a Save with no change on Edit
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'SH - State Highway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH |
    When the user clicks Save without changes
    And the user opens the Activity Log
    Then No 'Work Sub Type Updated' entry is created

  # Ref: FRD 5.2 FB-3; FRD 6 FB-1
  @TC_WST_253 @Negative @Medium @Automation
  Scenario: Verify no Activity Log entry is written when a Create is rejected by validation
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | R B |
    When the user enters Code 'R B', Name 'Audit Reject', Parent Work 'Road'
    And the user clicks Save
    And the user opens the Activity Log
    Then No 'Work Sub Type Created' entry exists for this attempt
