@WorkType @WorkTypeCreation
Feature: Work Type Creation
  Automated scenarios for the "Work Type Creation" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.2 FB-1; FRD 5.2 FB-2
  @TC_WT_014 @Functional @High @Automation
  Scenario: Verify the Add Work Type pop-up opens with the two fields, Save and Cancel, and the cursor in Work Type Name
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Form | Add Work Type |
    When the user clicks 'Add'
    And the user observes the pop-up and the focused element
    Then 'Add Work Type' pop-up opens over the screen with the fields Work Type Name and Work Type and the buttons Save and Cancel
    And The cursor is placed in Work Type Name

  # Ref: US-2 AC-1; FRD 5.2 FB-5; Sec 7 T1
  @TC_WT_015 @Functional @High @Automation
  Scenario: Verify a Work Type is created with a unique name and the value Building
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | Building       |
    When the user enters Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    Then Pop-up closes and toaster 'Work Type added successfully.' is displayed
    And 'Cargo Terminal' / Building appears at the top of the list as Sl. No. 1 on page 1

  # Ref: US-2 AC-1; FRD 5.2 BR-6
  @TC_WT_016 @Functional @High @Automation
  Scenario: Verify a Work Type is created with the value Roads
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Service Road |
      | Work Type      | Roads        |
    When the user enters Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    Then Work Type is saved and appears at the top of the list as Sl. No. 1 with Work Type 'Roads'
    And Toaster 'Work Type added successfully.' is displayed

  # Ref: US-2 AC-1; FRD 5.2 BR-6
  @TC_WT_017 @Functional @High @Automation
  Scenario: Verify a Work Type is created with the value Other
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Water Tank |
      | Work Type      | Other      |
    When the user enters Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    Then Work Type is saved and appears at the top of the list as Sl. No. 1 with Work Type 'Other'

  # Ref: FRD 5.2 BR-7; FRD 5.2 FB-5
  @TC_WT_018 @Functional @High @Automation
  Scenario: Verify a unique Internal ID is generated on save and is never shown on screen
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | Building       |
    When the user enters Work Type Name and select Work Type
    And the user clicks 'Save'
    And the user queries the Work Type record in the database / API
    And the user inspects the list, View pop-up and Edit pop-up of the new record for any ID
    Then A unique Internal ID is stored for the record and differs from the Internal ID of every other Work Type
    And The Internal ID is not displayed on the list, View pop-up or Edit pop-up and cannot be entered

  # Ref: FRD 5.2 FB-5; FRD 5.4 FB-2
  @TC_WT_019 @Functional @High @Automation
  Scenario: Verify Created By and Created On are recorded on creation
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | Building       |
      | User           | Admin_User1    |
    When the user enters Work Type Name and select Work Type
    And the user clicks 'Save'
    And the user opens View for 'Cargo Terminal' from the kebab menu
    Then Created By shows Admin_User1 and Created On shows the current date-time of the save

  # Ref: FRD 5.2 FB-5; FRD 5.3 FB-7
  @TC_WT_020 @Functional @High @Automation
  Scenario: Verify after Add the list returns to page 1 with column search values cleared
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And The Name search 'Bulk' is applied and page 2 is selected
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | Building       |
      | Name search    | Bulk           |
    When the user clicks 'Add'
    And the user enters Work Type Name and select Work Type
    And the user clicks 'Save'
    Then List shows page 1 with both column search values cleared
    And 'Cargo Terminal' is visible at the top as Sl. No. 1

  # Ref: FRD 5.2 FB-5
  @TC_WT_021 @Functional @High @Automation
  Scenario: Verify adding the first Work Type replaces the empty state with the list
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and the empty state is displayed (no Work Type exists)
    And the following test data is used
      | Work Type Name | Runway |
      | Work Type      | Other  |
    When the user clicks 'Add' on the empty state
    And the user enters Work Type Name and select Work Type
    And the user clicks 'Save'
    Then Toaster 'Work Type added successfully.' is displayed
    And Empty state is replaced by the Work Type List showing 'Runway' as Sl. No. 1

  # Ref: FRD 5.2 BR-4
  @TC_WT_022 @Functional @Medium @Automation
  Scenario: Verify Work Type Name is saved with the letter case exactly as entered
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | AIRSIDE Road |
      | Work Type      | Roads        |
    When the user enters Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    And the user observes the list
    Then Name is shown in the list exactly as 'AIRSIDE Road' (no case conversion)

  # Ref: FRD 5.2 BR-2; FRD 5.2 F-Name
  @TC_WT_023 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces in Work Type Name are removed on save
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | ' Fire Station ' |
      | Work Type      | Building         |
    When the user enters Work Type Name including spaces
    And the user selects Work Type
    And the user clicks 'Save'
    And the user observes the list
    Then Name is saved and displayed as 'Fire Station' without leading or trailing spaces

  # Ref: FRD 5.2 BR-2; FRD 5.2 F-Name
  @TC_WT_024 @Functional @Medium @Automation
  Scenario: Verify a run of two or more internal spaces in Work Type Name is reduced to one space on save
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | 'Fire Station Block' |
      | Work Type      | Building             |
    When the user enters Work Type Name with repeated internal spaces
    And the user selects Work Type
    And the user clicks 'Save'
    And the user observes the list
    Then Name is saved and displayed as 'Fire Station Block'

  # Ref: US-2 AC-7; FRD 5.2 BR-5; FRD 5.2 BR-8
  @TC_WT_025 @Functional @High @Automation
  Scenario: Verify Work Type Name with special characters is saved exactly as entered and displayed as plain text
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Runway – Phase #2 (East) & <Apron> |
      | Work Type      | Other                              |
    When the user enters Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    And the user observes the list
    Then Work Type is saved exactly as entered and displayed as plain text in the list
    And No part of the name is interpreted as markup

  # Ref: FRD 5.2 BR-8
  @TC_WT_026 @Functional @High @Automation
  Scenario: Verify a script tag in Work Type Name is saved as text and never executed
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | <script>alert('x')</script> |
      | Work Type      | Other                       |
    When the user enters Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    And the user observes the list, View pop-up and delete confirmation dialog for this record
    Then Name is saved exactly as entered and shown as plain text wherever displayed (HTML-encoded)
    And No alert or script execution occurs

  # Ref: FRD 5.2 BR-8
  @TC_WT_027 @Functional @High @Automation
  Scenario: Verify a SQL-injection style Work Type Name is saved as plain text without side effects
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | x'; DROP TABLE WorkType;-- |
      | Work Type      | Other                      |
    When the user enters Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    And the user observes the list and verify the Work Type table in the database
    Then Name is saved exactly as entered; the Work Type table and all baseline records remain intact (parameterized queries)

  # Ref: FRD 5.2 F-Name (max 100)
  @TC_WT_028 @Functional @High @Automation
  Scenario: Verify Work Type Name of exactly 100 characters is accepted (Ref 5.2 F-Name (max 100))
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | 100 characters (e.g., 'Airport Apron Concrete Pavement Phase ' repeated/padded with 'A' to exactly 100) |
      | Work Type      | Roads                                                                                                   |
    When the user enters a 100-character Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    Then All 100 characters are accepted and the Work Type is saved with the full name
    And Toaster 'Work Type added successfully.' is displayed

  # Ref: FRD 5.2 F-Name (max 100)
  @TC_WT_029 @Functional @Medium @Automation
  Scenario: Verify Work Type Name of 99 characters is accepted (Ref 5.2 F-Name (max 100))
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | 99 'B' characters |
      | Work Type      | Roads             |
    When the user enters a 99-character Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    Then Work Type is saved with the full 99-character name

  # Ref: FRD 5.2 BR-1; FRD 5.2 F-Name
  @TC_WT_030 @Functional @Medium @Automation
  Scenario: Verify Work Type Name of 1 character (minimum) is accepted
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Z     |
      | Work Type      | Other |
    When the user enters a 1-character Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    Then Work Type 'Z' is saved; no minimum-length error other than the mandatory rule is shown

  # Ref: FRD 5.2 BR-5
  @TC_WT_031 @Functional @Medium @Automation
  Scenario: Verify Work Type Name with digits and mixed characters is accepted
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Hangar-3 / Bay 12 @ North_Side |
      | Work Type      | Building                       |
    When the user enters Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    Then Work Type is saved exactly as entered (any characters allowed)

  # Ref: US-2 AC-8; FRD 5.2 F-Type; FRD 5.6 BR-2; FRD 5.6 BR-4
  @TC_WT_032 @Functional @High @Automation
  Scenario: Verify the Work Type dropdown lists exactly the backend values in configured order with placeholder 'Select Work Type' and no 'None'
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Backend values (configured order) | Other, Building, Roads |
    When the user clicks the Work Type dropdown
    And the user observes the options
    Then Dropdown shows placeholder 'Select Work Type' followed by Other, Building, Roads in this order
    And No 'None' option is listed

  # Ref: FRD 5.2 FB-8; FRD 5.2 F-Save
  @TC_WT_033 @Functional @High @Automation
  Scenario: Verify Save is disabled while a save request is in progress so a double click creates only one record
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | Building       |
    When the user enters Work Type Name and select Work Type
    And the user double-clicks 'Save' rapidly (with network latency of 3 seconds)
    And the user observes the list
    Then Save is disabled while the request is in progress
    And Only one 'Cargo Terminal' record is created

  # Ref: FRD 5.2 BR-3
  @TC_WT_034 @Functional @Medium @Automation
  Scenario: Verify two Work Types with different names may share the same Work Type value
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Pump House |
      | Work Type      | Other      |
    When the user enters a new name
    And the user selects the same Work Type value as an existing record ('Other', used by 'Runway')
    And the user clicks 'Save'
    Then Work Type is saved because the name is unique; multiple records may share the same Work Type value

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-2; FRD 5.2 BR-1; Sec 7 FLE-1
  @TC_WT_154 @Negative @High @Automation
  Scenario: Verify error 'Work Type Name is required.' when Work Type Name is blank
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | (blank)  |
      | Work Type      | Building |
    When the user leaves Work Type Name blank
    And the user selects Work Type
    And the user clicks 'Save'
    Then Field-level error 'Work Type Name is required.' is displayed below Work Type Name; nothing is saved
    And No toaster is displayed

  # Ref: US-2 AC-2; FRD 5.2 F-Name
  @TC_WT_155 @Negative @High @Automation
  Scenario: Verify error 'Work Type Name is required.' when Work Type Name contains only spaces
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | ' '      |
      | Work Type      | Building |
    When the user enters spaces only in Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    Then Field-level error 'Work Type Name is required.' is displayed; nothing is saved

  # Ref: US-2 AC-3; FRD 5.2 BR-1; Sec 7 FLE-3
  @TC_WT_156 @Negative @High @Automation
  Scenario: Verify error 'Work Type is required.' when no Work Type value is selected
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | (none)         |
    When the user enters Work Type Name
    And the user leaves Work Type unselected
    And the user clicks 'Save'
    Then Field-level error 'Work Type is required.' is displayed below Work Type; nothing is saved

  # Ref: FRD 5.2 F-Type
  @TC_WT_157 @Negative @Medium @Automation
  Scenario: Verify the placeholder 'Select Work Type' does not satisfy the mandatory rule
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal                 |
      | Work Type      | Select Work Type (placeholder) |
    When the user enters Work Type Name
    And the user opens the dropdown and click 'Select Work Type'
    And the user clicks 'Save'
    Then Field-level error 'Work Type is required.' is displayed; nothing is saved

  # Ref: US-2 AC-4; FRD 5.2 FB-4
  @TC_WT_158 @Negative @High @Automation
  Scenario: Verify both field-level errors are displayed at the same time when both fields are empty
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | (blank) |
      | Work Type      | (none)  |
    When the user leaves both fields empty
    And the user clicks 'Save'
    Then Both 'Work Type Name is required.' and 'Work Type is required.' are displayed together; nothing is saved

  # Ref: FRD 5.2 FB-4
  @TC_WT_159 @Negative @Medium @Automation
  Scenario: Verify the pop-up stays open, entered values are retained and the cursor moves to the first failing field
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | (blank) |
      | Work Type      | (none)  |
    When the user leaves Work Type Name blank
    And the user leaves Work Type unselected
    And the user clicks 'Save'
    And the user observes the pop-up and the cursor
    Then Pop-up stays open and the cursor is placed in Work Type Name (first failing field)
    And No toaster is displayed

  # Ref: FRD 5.2 FB-4
  @TC_WT_160 @Negative @Medium @Automation
  Scenario: Verify entered Work Type Name is retained when only Work Type is missing
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | (none)         |
    When the user enters Work Type Name
    And the user leaves Work Type unselected
    And the user clicks 'Save'
    Then Pop-up stays open; 'Cargo Terminal' remains in Work Type Name; only the Work Type error is shown

  # Ref: FRD 5.2 FB-6; Sec 7 FLE-1
  @TC_WT_161 @Negative @Medium @Automation
  Scenario: Verify the Work Type Name error clears as soon as the user types a value
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
    When the user clicks 'Save' with both fields empty
    And the user types a value in Work Type Name
    Then 'Work Type Name is required.' disappears once a value is entered; the Work Type error remains

  # Ref: FRD 5.2 FB-6; Sec 7 FLE-3
  @TC_WT_162 @Negative @Medium @Automation
  Scenario: Verify the Work Type error clears as soon as the user selects a value
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Building |
    When the user clicks 'Save' with both fields empty
    And the user selects a Work Type value
    Then 'Work Type is required.' disappears once a value is selected

  # Ref: US-2 AC-5; FRD 5.2 BR-3
  @TC_WT_163 @Negative @High @Automation
  Scenario: Verify duplicate Work Type Name with different case and surrounding spaces is rejected
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | ' runway '               |
      | Work Type      | Other (existing: Runway) |
    When the user enters the name
    And the user selects Work Type
    And the user clicks 'Save'
    Then Field-level error 'A Work Type with this name already exists.' is displayed; nothing is saved; no toaster is displayed

  # Ref: FRD 5.2 BR-3; Sec 7 FLE-2
  @TC_WT_164 @Negative @High @Automation
  Scenario: Verify duplicate Work Type Name with identical case is rejected
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Runway |
      | Work Type      | Other  |
    When the user enters the name
    And the user selects Work Type
    And the user clicks 'Save'
    Then Field-level error 'A Work Type with this name already exists.' is displayed; nothing is saved

  # Ref: FRD 5.2 BR-3
  @TC_WT_165 @Negative @High @Automation
  Scenario: Verify duplicate Work Type Name in upper case is rejected
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | RUNWAY |
      | Work Type      | Other  |
    When the user enters the name
    And the user selects Work Type
    And the user clicks 'Save'
    Then Field-level error 'A Work Type with this name already exists.' is displayed

  # Ref: FRD 5.2 BR-2; FRD 5.2 BR-3
  @TC_WT_166 @Negative @High @Automation
  Scenario: Verify a name equal to an existing name after collapsing internal spaces is rejected
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | 'Terminal Building'                    |
      | Work Type      | Building (existing: Terminal Building) |
    When the user enters the name
    And the user selects Work Type
    And the user clicks 'Save'
    Then Field-level error 'A Work Type with this name already exists.' is displayed

  # Ref: US-2 AC-6; FRD 5.2 BR-3
  @TC_WT_167 @Negative @High @Automation
  Scenario: Verify an existing name is rejected even when a different Work Type value is selected
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Runway                                |
      | Work Type      | Building (existing Runway is 'Other') |
    When the user enters the name
    And the user selects a different Work Type value than the existing record
    And the user clicks 'Save'
    Then Field-level error 'A Work Type with this name already exists.' is displayed; nothing is saved

  # Ref: FRD 5.2 FB-3
  @TC_WT_168 @Negative @Medium @Automation
  Scenario: Verify the duplicate-name check runs after field-level checks (Work Type missing on a duplicate name shows only the required error)
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Runway |
      | Work Type      | (none) |
    When the user enters an existing name
    And the user leaves Work Type unselected
    And the user clicks 'Save'
    Then Only 'Work Type is required.' is displayed; the duplicate error is not displayed until field-level checks pass
    And After selecting a Work Type and clicking Save again, 'A Work Type with this name already exists.' is displayed

  # Ref: FRD 5.2 F-Name (max 100)
  @TC_WT_169 @Negative @High @Automation
  Scenario: Verify typing stops at 100 characters in Work Type Name (max+1) (Ref 5.2 F-Name (max 100))
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | 101 'D' characters |
    When the user types a 101-character name
    And the user observes the box content
    Then The box contains exactly 100 characters; the 101st is not accepted

  # Ref: FRD 5.2 F-Name (max 100)
  @TC_WT_170 @Negative @High @Automation
  Scenario: Verify pasted text longer than 100 characters is cut at 100 (Ref 5.2 F-Name (max 100))
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pasted text | 150 'E' characters |
      | Work Type   | Roads              |
    When the user pastes a 150-character text into Work Type Name
    And the user selects Work Type
    And the user clicks 'Save'
    And the user opens View for the saved record
    Then Pasted text is cut at 100 characters; the saved name is exactly 100 characters

  # Ref: FRD 5.2 BR-8; FRD 5.2 BR-1
  @TC_WT_171 @Negative @High @Automation
  Scenario: Verify the server rejects a create request with a blank Work Type Name
    Given API client is authenticated with the token of Admin_User1 (Work Type: View/Add/Edit/Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | {name:'', workType:'Building'} |
    When the user sends a create request with an empty name
    Then Request is rejected by the server validation; no Work Type is created

  # Ref: FRD 5.2 BR-6; FRD 5.2 BR-8
  @TC_WT_172 @Negative @High @Automation
  Scenario: Verify the server rejects a create request with a value not configured in the backend
    Given API client is authenticated with the token of Admin_User1 (Work Type: View/Add/Edit/Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | {name:'Cargo Terminal', workType:'Custom'} |
    When the user sends a create request with an unlisted Work Type value
    Then Request is rejected; no Work Type is created (free-text value not allowed)

  # Ref: FRD 5.2 BR-1; FRD 5.2 BR-8
  @TC_WT_173 @Negative @High @Automation
  Scenario: Verify the server rejects a create request with a missing Work Type value
    Given API client is authenticated with the token of Admin_User1 (Work Type: View/Add/Edit/Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | {name:'Cargo Terminal'} |
    When the user sends a create request without Work Type
    Then Request is rejected; no Work Type is created

  # Ref: FRD 5.2 BR-3; FRD 5.2 BR-8
  @TC_WT_174 @Negative @High @Automation
  Scenario: Verify the server rejects a duplicate name sent directly to the API
    Given API client is authenticated with the token of Admin_User1 (Work Type: View/Add/Edit/Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | {name:'RUNWAY ', workType:'Roads'} |
    When the user sends a create request with an existing name in different case
    Then Request is rejected by the server as duplicate; no second Runway is created

  # Ref: FRD 5.2 BR-8; FRD 5.2 F-Name (max 100)
  @TC_WT_175 @Negative @Medium @Automation
  Scenario: Verify the server does not store a Work Type Name longer than 100 characters (Ref 5.2 BR-8, 5.2 F-Name (max 100))
    Given API client is authenticated with the token of Admin_User1 (Work Type: View/Add/Edit/Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | {name:<101 'F' characters>, workType:'Roads'} |
    When the user sends a create request with a 101-character name
    And the user checks the stored record
    Then The 101-character name is not stored (see Assumption A-6 for the exact server response)

  # Ref: FRD 5.2 FB-7
  @TC_WT_176 @Negative @High @Automation
  Scenario: Verify Cancel closes the Add pop-up without saving and without an Activity Log entry
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | Building       |
    When the user enters Work Type Name and select Work Type
    And the user clicks 'Cancel'
    And the user checks the list and Activity Log
    Then Pop-up closes; no record and no Activity Log entry is created

  # Ref: FRD 5.2 FB-7
  @TC_WT_177 @Negative @High @Automation
  Scenario: Verify the close (X) icon closes the Add pop-up without saving
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | Building       |
    When the user enters Work Type Name and select Work Type
    And the user clicks the close (X) icon
    And the user checks the list
    Then Pop-up closes; no record is created

  # Ref: FRD 6.1 Work Type Created; FRD 5.2 FB-4
  @TC_WT_178 @Negative @Medium @Automation
  Scenario: Verify a failed validation creates no Activity Log entry
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | (blank), then Runway |
    When the user clicks 'Save' with both fields empty
    And the user clicks 'Save' with a duplicate name 'Runway' and Work Type 'Other'
    And the user checks the Activity Log
    Then No 'Work Type Created' entry is written for either failed attempt

  # Ref: FRD 5.2 FB-4; Sec 7
  @TC_WT_179 @Negative @Medium @Automation
  Scenario: Verify no toaster is shown for any create validation failure
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | (blank), then Runway |
    When the user clicks 'Save' with both fields empty
    And the user clicks 'Save' with a duplicate name
    Then Only field-level errors are displayed; no toaster appears in either case
