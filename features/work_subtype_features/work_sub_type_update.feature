@WorkSubType @WorkSubTypeUpdate
Feature: Work Sub Type Update
  Automated scenarios for the "Work Sub Type Update" module of Work Sub Type.
  Source: CivitINFRA_WorkSubType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-006_CivitINFRA Configuration_Work Sub Type.pdf (PRD Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-1; FRD 5.5 FB-1; FRD 5.5 FB-2
  @TC_WST_100 @Functional @High @Automation
  Scenario: Verify the Edit pop-up opens pre-filled with Code and Name editable and Parent Work and Added Under disabled
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH-SEC - NH Sections (Level 2) |
    When the user clicks kebab (⋮) of 'NH-SEC - NH Sections'
    And the user selects Edit
    Then 'Edit Work Sub Type' pop-up opens pre-filled
    And Code and Name are editable
    And Parent Work and Added Under are shown but disabled

  # Ref: US-5 AC-2; FRD 5.5 FB-4; FRD 7 T-2
  @TC_WST_101 @Functional @High @Automation
  Scenario: Verify the Name of a Work Sub Type is updated, the pop-up closes and the success toaster is shown
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'SH - State Highway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | State Highways |
    When the user changes Name to 'State Highways'
    And the user clicks Save
    Then The pop-up closes
    And Toaster "Work Sub Type updated successfully." is displayed
    And The list shows the new Name

  # Ref: US-5 AC-2; FRD 5.5 FB-4
  @TC_WST_102 @Functional @High @Automation
  Scenario: Verify the Code of a Work Sub Type is updated
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'SH - State Highway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | SH-NEW |
    When the user changes Code to 'SH-NEW'
    And the user clicks Save
    Then Toaster "Work Sub Type updated successfully." is displayed and the list shows Code 'SH-NEW'

  # Ref: US-5 AC-2; FRD 5.5 FB-4
  @TC_WST_103 @Functional @Medium @Automation
  Scenario: Verify both Code and Name can be updated together
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'OB - Office Building'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | OFF-B        |
      | Name | Office Block |
    When the user changes Code to 'OFF-B'
    And the user changes Name to 'Office Block'
    And the user clicks Save
    Then Both values are updated and toaster "Work Sub Type updated successfully." is displayed

  # Ref: US-5 AC-2; FRD 5.3 FB-2
  @TC_WST_104 @Functional @High @Automation
  Scenario: Verify position and level are unchanged after an update
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-BYP - NH Bypass'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | NH Bypass Road |
    When the user changes Name to 'NH Bypass Road'
    And the user clicks Save
    And the user observes the row position and Sl. No
    Then 'NH-BYP' remains Level 2 under 'NH' at the same position (Sl. No. 2.2)

  # Ref: US-5 AC-2
  @TC_WST_105 @Functional @High @Automation
  Scenario: Verify an update is reflected in the 'Added Under' field of its children
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-SEC - NH Sections'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | NH Sections Revised |
    When the user changes Name to 'NH Sections Revised'
    And the user clicks Save
    And the user opens View for child 'NH-SEC-A'
    Then 'Added Under' of 'NH-SEC-A' shows "NH-SEC – NH Sections Revised (Level 2)"

  # Ref: US-5 AC-2; FRD 5.5 BR-3; FRD 5.6 FB-3; FRD 5.6 BR-1
  @TC_WST_106 @Functional @High @Automation
  Scenario: Verify an update is reflected in every Work that uses the Work Sub Type
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-BYP - NH Bypass' (used in WRK-001)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | NH Bypass Road |
      | Work | WRK-001        |
    When the user changes Name to 'NH Bypass Road'
    And the user clicks Save
    And the user opens Work WRK-001
    Then WRK-001 shows the Work Sub Type 'NH-BYP - NH Bypass Road'; the reference is intact

  # Ref: US-5 AC-4; FRD 5.5 BR-3
  @TC_WST_107 @Functional @High @Automation
  Scenario: Verify a Work Sub Type used in Works can be edited
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-SEC - NH Sections' (used in WRK-002)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | NH-SECT |
    When the user changes Code to 'NH-SECT'
    And the user clicks Save
    Then The update is allowed and toaster "Work Sub Type updated successfully." is displayed

  # Ref: US-5 AC-4; FRD 5.5 BR-3
  @TC_WST_108 @Functional @Medium @Automation
  Scenario: Verify a Work Sub Type that has children can be edited
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH - National Highway' (has children)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | National Highways |
    When the user changes Name to 'National Highways'
    And the user clicks Save
    Then The update is allowed and toaster "Work Sub Type updated successfully." is displayed

  # Ref: US-5 AC-3; FRD 5.5 BR-2
  @TC_WST_109 @Functional @High @Automation
  Scenario: Verify changing only the letter case of the record's own Code is allowed
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-BYP - NH Bypass'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | NH-BYP -> nh-byp |
    When the user changes Code from 'NH-BYP' to 'nh-byp'
    And the user clicks Save
    Then No duplicate error is shown; the record is saved with Code 'nh-byp' and toaster "Work Sub Type updated successfully." is displayed

  # Ref: US-5 AC-3; FRD 5.5 BR-2
  @TC_WST_110 @Functional @High @Automation
  Scenario: Verify changing only the letter case of the record's own Name is allowed
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'SH - State Highway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | State Highway -> STATE HIGHWAY |
    When the user changes Name from 'State Highway' to 'STATE HIGHWAY'
    And the user clicks Save
    Then No duplicate error is shown; the record is saved with Name 'STATE HIGHWAY'

  # Ref: FRD 5.5 BR-4; FRD 5.2 BR-2
  @TC_WST_111 @Functional @Medium @Automation
  Scenario: Verify leading/trailing spaces and repeated internal spaces are normalized on Edit
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'SH - State Highway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | ' SH-T '              |
      | Name | ' State Highway Two ' |
    When the user changes Name to ' State Highway Two '
    And the user changes Code to ' SH-T '
    And the user clicks Save
    Then Saved Code is 'SH-T' and saved Name is 'State Highway Two'

  # Ref: US-5 AC-5; FRD 5.5 FB-5
  @TC_WST_112 @Functional @High @Automation
  Scenario: Verify saving without any change closes the pop-up with no update, no toaster and no Activity Log entry
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'SH - State Highway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH - State Highway |
    When the user does not change any field
    And the user clicks Save
    Then The pop-up closes
    And No toaster is displayed
    And Last Modified By/On are unchanged and no Activity Log entry is created

  # Ref: US-5 AC-6; FRD 5.5 FB-6
  @TC_WST_113 @Functional @Medium @Automation
  Scenario: Verify Cancel on the Edit pop-up saves no change
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'SH - State Highway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | Unsaved Name |
    When the user changes Name to 'Unsaved Name'
    And the user clicks Cancel
    Then The pop-up closes and the record still shows 'State Highway'

  # Ref: US-5 AC-6; FRD 5.5 FB-6
  @TC_WST_114 @Functional @Medium @Automation
  Scenario: Verify the close (X) icon on the Edit pop-up saves no change
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'SH - State Highway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | SH-UNSAVED |
    When the user changes Code to 'SH-UNSAVED'
    And the user clicks the close (X) icon
    Then The pop-up closes and the record still shows Code 'SH'

  # Ref: FRD 5.5 BR-1; FRD 5.5 FB-2; FRD 5.2 F-Parent; FRD 5.2 F-AddedUnder
  @TC_WST_115 @Functional @High @Automation
  Scenario: Verify Parent Work and Added Under cannot be changed on the Edit pop-up
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-SEC - NH Sections'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH-SEC |
    When the user tries to change the Parent Work field
    And the user tries to change the Added Under field
    Then Both fields are disabled and cannot be changed

  # Ref: FRD 5.5 BR-4; FRD 5.5 FB-3; FRD 7 FE-1
  @TC_WST_116 @Functional @Medium @Automation
  Scenario: Verify the same field validations as creation apply on Edit (Code required)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'SH - State Highway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | (blank) |
    When the user clears the Code field
    And the user clicks Save
    Then "Code is required." is displayed below Code and the record is not updated

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-3; FRD 5.5 BR-2; FRD 7 FE-3
  @TC_WST_219 @Negative @High @Automation
  Scenario: Verify Edit is rejected when Code is changed to the Code of another Work Sub Type (case-insensitive)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-BYP - NH Bypass'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | sh (existing 'SH') |
    When the user changes Code to 'sh'
    And the user clicks Save
    Then Error "A Work Sub Type with this code already exists." is displayed below Code
    And The pop-up stays open and the record is not updated; no toaster is displayed

  # Ref: US-5 AC-3; FRD 5.5 BR-2; FRD 7 FE-5
  @TC_WST_220 @Negative @High @Automation
  Scenario: Verify Edit is rejected when Name is changed to the Name of another Work Sub Type (case-insensitive, trimmed)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-BYP - NH Bypass'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | state highway (existing 'State Highway') |
    When the user changes Name to ' state highway '
    And the user clicks Save
    Then Error "A Work Sub Type with this name already exists." is displayed below Name
    And The pop-up stays open and the record is not updated; no toaster is displayed

  # Ref: FRD 5.5 BR-4; FRD 7 FE-1
  @TC_WST_221 @Negative @Medium @Automation
  Scenario: Verify Edit is rejected when Code is blank
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-BYP - NH Bypass'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | (blank) |
    When the user clears Code
    And the user clicks Save
    Then Error "Code is required." is displayed below Code
    And The pop-up stays open and the record is not updated; no toaster is displayed

  # Ref: FRD 5.5 BR-4; FRD 7 FE-4
  @TC_WST_222 @Negative @Medium @Automation
  Scenario: Verify Edit is rejected when Name is blank
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-BYP - NH Bypass'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | (blank) |
    When the user clears Name
    And the user clicks Save
    Then Error "Name is required." is displayed below Name
    And The pop-up stays open and the record is not updated; no toaster is displayed

  # Ref: FRD 5.5 BR-4; FRD 7 FE-2
  @TC_WST_223 @Negative @Medium @Automation
  Scenario: Verify Edit is rejected when Code contains a space or invalid character
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-BYP - NH Bypass'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | NH BYP# |
    When the user changes Code to 'NH BYP#'
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open and the record is not updated; no toaster is displayed

  # Ref: FRD 5.5 BR-4; FRD 5.2 F-Code
  @TC_WST_224 @Negative @Medium @Automation
  Scenario: Verify Edit does not accept a Code longer than 20 characters
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-BYP - NH Bypass'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed | ABCDEFGHIJ1234567890X (21) |
    When the user types a 21-character Code in Code
    Then Typing stops at 20 characters
    And The pop-up stays open and the record is not updated; no toaster is displayed

  # Ref: FRD 5.5 BR-4; FRD 5.2 F-Name
  @TC_WST_225 @Negative @Medium @Automation
  Scenario: Verify Edit does not accept a Name longer than 100 characters
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Edit Work Sub Type' pop-up is open for 'NH-BYP - NH Bypass'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed | 'N' x 101 |
    When the user types a 101-character Name in Name
    Then Typing stops at 100 characters
    And The pop-up stays open and the record is not updated; no toaster is displayed

  # Ref: FRD 5.5 BR-1; FRD 5.2 BR-10
  @TC_WST_226 @Negative @High @Automation
  Scenario: Verify Parent Work and Level cannot be changed by an update request (API)
    Given API client authenticated with the token of Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record  | NH-BYP                                                  |
      | Payload | {parentWork: 'Building', level: 3, name: 'NH Bypass X'} |
    When the user sends an update request for 'NH-BYP' with a changed Parent Work (Building) and Level (3) along with Name 'NH Bypass X'
    And the user retrieves the record
    Then Parent Work remains 'Road' and Level remains 2 (only permitted fields change)
