@WorkSubType @WorkSubTypeCreation
Feature: Work Sub Type Creation
  Automated scenarios for the "Work Sub Type Creation" module of Work Sub Type.
  Source: CivitINFRA_WorkSubType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-006_CivitINFRA Configuration_Work Sub Type.pdf (PRD Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-1; FRD 5.2 FB-1; FRD 5.2 EP-1; FRD 5.2 F-Parent
  @TC_WST_044 @Functional @High @Automation
  Scenario: Verify the 'Add Work Sub Type' pop-up opens with empty Code and Name, 'Select Parent Work' placeholder, editable Parent Work and no 'Added Under' field
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Button | Add |
    When the user clicks 'Add'
    Then 'Add Work Sub Type' pop-up opens
    And Code and Name are empty
    And Parent Work shows the placeholder "Select Parent Work" and is editable
    And 'Added Under' is not shown
    And 'Save' and 'Cancel' buttons are present

  # Ref: FRD 5.2 FB-1
  @TC_WST_045 @Functional @Low @Automation
  Scenario: Verify the cursor is placed in the Code field when the Add pop-up opens
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Button | Add |
    When the user clicks 'Add'
    Then The cursor/focus is in the Code field

  # Ref: US-2 AC-2; FRD 5.2 F-Parent
  @TC_WST_046 @Functional @High @Automation
  Scenario: Verify the Parent Work dropdown lists only Work Types in the Work Type screen order (newest first)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Expected options | Bridge, Water Supply, Road, Building |
    When the user opens the Parent Work dropdown
    Then Only Work Type names are listed in the order Bridge, Water Supply, Road, Building
    And No Work Sub Type (e.g., RB, NH) is listed

  # Ref: US-2 AC-3; FRD 5.2 FB-4; FRD 7 T-1; FRD 5.2 BR-10; FRD 5.2 EP-1; FRD Fig 1
  @TC_WST_047 @Functional @High @Automation
  Scenario: Verify a Work Sub Type is created at Level 1 under the selected Work Type and the success toaster is shown
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | MDR                 |
      | Name        | Major District Road |
      | Parent Work | Road                |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then The pop-up closes
    And Toaster "Work Sub Type added successfully." is displayed
    And 'MDR - Major District Road' is created at Level 1 directly under 'Road'

  # Ref: US-2 AC-3; FRD 5.2 FB-4; FRD 5.3 FB-2
  @TC_WST_048 @Functional @High @Automation
  Scenario: Verify the newly created Work Sub Type is shown first under its Work Type with the Work Type row expanded
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | MDR2                |
      | Name        | Minor District Road |
      | Parent Work | Road                |
    When the user collapses 'Road'
    And the user adds Code 'MDR2', Name 'Minor District Road', Parent Work 'Road' via 'Add' and click Save
    Then The 'Road' row is expanded and the new row is scrolled into view
    And 'MDR2' is the first Level 1 row under 'Road' with Sl. No. 1 and the other Level 1 rows renumbered

  # Ref: FRD 5.2 BR-14; FRD 5.2 FB-4
  @TC_WST_049 @Functional @High @Automation
  Scenario: Verify the system generates a unique Internal ID that is not shown on any screen
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Records | ID-1, ID-2 |
    When the user creates Code 'ID-1', Name 'Internal Id Check One', Parent Work 'Building'
    And the user creates Code 'ID-2', Name 'Internal Id Check Two', Parent Work 'Building'
    And the user checks the database records and inspect the list, View and Edit pop-ups
    Then Each record has its own unique system-generated Internal ID in the database
    And The Internal ID is not displayed on the list, View or Edit pop-up and cannot be entered or edited

  # Ref: FRD 5.2 FB-4; FRD 5.4 FB-2
  @TC_WST_050 @Functional @High @Automation
  Scenario: Verify Created By and Created On are recorded when a Work Sub Type is created
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | CR-1             |
      | Name        | Created By Check |
      | Parent Work | Road             |
    When the user creates Code 'CR-1', Name 'Created By Check', Parent Work 'Road'
    And the user opens View for 'CR-1'
    Then Created By shows Admin_User1 and Created On shows the date-time of creation

  # Ref: US-2 AC-6; FRD 5.2 BR-3
  @TC_WST_051 @Functional @Medium @Automation
  Scenario: Verify Code 'E-Gov' is accepted and saved
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | E-Gov          |
      | Name        | Name for E-Gov |
      | Parent Work | Building       |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then The Work Sub Type is saved and toaster "Work Sub Type added successfully." is displayed
    And Code is displayed as 'E-Gov'
    And A Code may start with any allowed character (letters, numbers, - _ . /)

  # Ref: US-2 AC-6; FRD 5.2 BR-3
  @TC_WST_052 @Functional @Medium @Automation
  Scenario: Verify Code 'NH_1' is accepted and saved
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | NH_1          |
      | Name        | Name for NH_1 |
      | Parent Work | Building      |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then The Work Sub Type is saved and toaster "Work Sub Type added successfully." is displayed
    And Code is displayed as 'NH_1'
    And A Code may start with any allowed character (letters, numbers, - _ . /)

  # Ref: US-2 AC-6; FRD 5.2 BR-3
  @TC_WST_053 @Functional @Medium @Automation
  Scenario: Verify Code 'SH.2' is accepted and saved
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | SH.2          |
      | Name        | Name for SH.2 |
      | Parent Work | Building      |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then The Work Sub Type is saved and toaster "Work Sub Type added successfully." is displayed
    And Code is displayed as 'SH.2'
    And A Code may start with any allowed character (letters, numbers, - _ . /)

  # Ref: US-2 AC-6; FRD 5.2 BR-3
  @TC_WST_054 @Functional @Medium @Automation
  Scenario: Verify Code 'MDR/3' is accepted and saved
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | MDR/3          |
      | Name        | Name for MDR/3 |
      | Parent Work | Building       |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then The Work Sub Type is saved and toaster "Work Sub Type added successfully." is displayed
    And Code is displayed as 'MDR/3'
    And A Code may start with any allowed character (letters, numbers, - _ . /)

  # Ref: US-2 AC-6; FRD 5.2 BR-3
  @TC_WST_055 @Functional @Medium @Automation
  Scenario: Verify Code '-RB' is accepted and saved
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | -RB          |
      | Name        | Name for -RB |
      | Parent Work | Building     |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then The Work Sub Type is saved and toaster "Work Sub Type added successfully." is displayed
    And Code is displayed as '-RB'
    And A Code may start with any allowed character (letters, numbers, - _ . /)

  # Ref: US-2 AC-6; FRD 5.2 BR-3
  @TC_WST_056 @Functional @Medium @Automation
  Scenario: Verify Code '/NH' is accepted and saved
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | /NH          |
      | Name        | Name for /NH |
      | Parent Work | Building     |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then The Work Sub Type is saved and toaster "Work Sub Type added successfully." is displayed
    And Code is displayed as '/NH'
    And A Code may start with any allowed character (letters, numbers, - _ . /)

  # Ref: FRD 5.2 BR-3
  @TC_WST_057 @Functional @Medium @Automation
  Scenario: Verify Code is saved with the letter case exactly as entered
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | Rb-Ad               |
      | Name        | Case Preserved Code |
      | Parent Work | Building            |
    When the user enters Code 'Rb-Ad'
    And the user enters Name 'Case Preserved Code'
    And the user selects Parent Work 'Building'
    And the user clicks Save
    Then The list shows Code exactly as 'Rb-Ad' (not upper or lower cased)

  # Ref: FRD 5.2 F-Code
  @TC_WST_058 @Functional @Medium @Automation
  Scenario: Verify a Code of exactly 20 characters is accepted (boundary max)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | ABCDEFGHIJ1234567890 (20) |
      | Name        | Twenty Char Code          |
      | Parent Work | Bridge                    |
    When the user enters a 20-character Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then The Work Sub Type is saved and the full 20-character Code is stored and displayed

  # Ref: FRD 5.2 F-Code
  @TC_WST_059 @Functional @Low @Automation
  Scenario: Verify a Code of 19 characters is accepted (boundary max-1)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | ABCDEFGHIJ123456789 (19) |
      | Name        | Nineteen Char Code       |
      | Parent Work | Bridge                   |
    When the user enters a 19-character Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then The Work Sub Type is saved with the 19-character Code

  # Ref: FRD 5.2 F-Name
  @TC_WST_060 @Functional @Medium @Automation
  Scenario: Verify a Name of exactly 100 characters is accepted (boundary max)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | LONGNM                                  |
      | Name        | 100 characters ('N' repeated 100 times) |
      | Parent Work | Bridge                                  |
    When the user enters Code
    And the user enters a 100-character Name
    And the user selects Parent Work
    And the user clicks Save
    Then The Work Sub Type is saved and the full 100-character Name is stored; long Name is wrapped in the list

  # Ref: FRD 5.2 F-Name
  @TC_WST_061 @Functional @Low @Automation
  Scenario: Verify a Name of 99 characters is accepted (boundary max-1)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | NM99                                  |
      | Name        | 99 characters ('M' repeated 99 times) |
      | Parent Work | Bridge                                |
    When the user enters Code
    And the user enters a 99-character Name
    And the user selects Parent Work
    And the user clicks Save
    Then The Work Sub Type is saved with the 99-character Name

  # Ref: FRD 5.2 BR-5; FRD 5.2 F-Name
  @TC_WST_062 @Functional @Medium @Automation
  Scenario: Verify Name accepts all special characters and is saved as entered
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | SPL-1                                      |
      | Name        | Roads & Bridges (Phase-1) #2 @ 50% < > " ' |
      | Parent Work | Bridge                                     |
    When the user enters Code
    And the user enters Name with special characters
    And the user selects Parent Work
    And the user clicks Save
    Then The Work Sub Type is saved and the Name is displayed exactly as entered

  # Ref: FRD 5.2 BR-5
  @TC_WST_063 @Functional @Medium @Automation
  Scenario: Verify Name is saved with the letter case exactly as entered
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | CASE-N          |
      | Name        | mIxEd CaSe NaMe |
      | Parent Work | Bridge          |
    When the user enters Code 'CASE-N'
    And the user enters Name 'mIxEd CaSe NaMe'
    And the user selects Parent Work 'Bridge'
    And the user clicks Save
    Then The Name is displayed as 'mIxEd CaSe NaMe'

  # Ref: FRD 5.2 BR-2; FRD 5.2 F-Name; FRD 5.2 F-Code
  @TC_WST_064 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces in Code and Name are removed before saving
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | ' TRM-1 '        |
      | Name        | ' Trimmed Name ' |
      | Parent Work | Bridge           |
    When the user enters Code ' TRM-1 '
    And the user enters Name ' Trimmed Name '
    And the user selects Parent Work 'Bridge'
    And the user clicks Save
    Then The saved Code is 'TRM-1' and saved Name is 'Trimmed Name' (no leading/trailing spaces)

  # Ref: FRD 5.2 BR-2; FRD 5.2 F-Name
  @TC_WST_065 @Functional @Medium @Automation
  Scenario: Verify two or more consecutive internal spaces in Name are reduced to one space
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | SPC-1                |
      | Name        | 'Rural Road Network' |
      | Parent Work | Bridge               |
    When the user enters Code 'SPC-1'
    And the user enters Name 'Rural Road Network'
    And the user selects Parent Work 'Bridge'
    And the user clicks Save
    Then The saved Name is 'Rural Road Network'

  # Ref: US-2 AC-9; FRD 5.2 BR-7
  @TC_WST_066 @Functional @High @Automation
  Scenario: Verify a Work Sub Type may have the same Name as a Work Type under a different Work Type
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RD-BLD   |
      | Name        | Building |
      | Parent Work | Road     |
    When the user enters Code 'RD-BLD'
    And the user enters Name 'Building'
    And the user selects Parent Work 'Road'
    And the user clicks Save
    Then The Work Sub Type is saved because uniqueness is checked only against other Work Sub Types; toaster "Work Sub Type added successfully." is displayed

  # Ref: FRD 5.2 BR-7
  @TC_WST_067 @Functional @Low @Automation
  Scenario: Verify a Work Sub Type may have a Code equal to a Work Type name
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | Road                        |
      | Name        | Road Code Same As Work Type |
      | Parent Work | Bridge                      |
    When the user enters Code 'Road'
    And the user enters Name 'Road Code Same As Work Type'
    And the user selects Parent Work 'Bridge'
    And the user clicks Save
    Then The Work Sub Type is saved; Code uniqueness is checked only against other Work Sub Types

  # Ref: FRD 5.2 FB-6; FRD 5.2 F-Cancel
  @TC_WST_068 @Functional @Medium @Automation
  Scenario: Verify Cancel closes the Add pop-up without creating a record or audit entry
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | CNL-1        |
      | Name        | Cancel Check |
      | Parent Work | Road         |
    When the user enters Code 'CNL-1'
    And the user enters Name 'Cancel Check'
    And the user selects Parent Work 'Road'
    And the user clicks Cancel
    Then The pop-up closes
    And No Work Sub Type 'CNL-1' is created and no Activity Log entry is written

  # Ref: FRD 5.2 FB-6
  @TC_WST_069 @Functional @Medium @Automation
  Scenario: Verify the close (X) icon closes the Add pop-up without creating a record or audit entry
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | CNL-2            |
      | Name        | Close Icon Check |
      | Parent Work | Road             |
    When the user enters Code 'CNL-2'
    And the user enters Name 'Close Icon Check'
    And the user selects Parent Work 'Road'
    And the user clicks the close (X) icon
    Then The pop-up closes
    And No Work Sub Type 'CNL-2' is created and no Activity Log entry is written

  # Ref: FRD 5.2 FB-2; FRD 5.2 F-Save
  @TC_WST_070 @Functional @Medium @Automation
  Scenario: Verify the Save button is always enabled, including on an empty form
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | All fields | empty |
    When the user observes the Save button without entering any value
    Then 'Save' button is enabled

  # Ref: FRD 5.2 FB-7; FRD 5.2 F-Save
  @TC_WST_071 @Functional @High @Automation
  Scenario: Verify a double click on Save creates only one record (Save disabled while the request is in progress)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | DBL-1              |
      | Name        | Double Click Check |
      | Parent Work | Road               |
    When the user enters Code 'DBL-1', Name 'Double Click Check', Parent Work 'Road'
    And the user double-clicks Save quickly
    Then Save is disabled while the request is in progress
    And Only one 'DBL-1' record is created and one Activity Log 'Work Sub Type Created' entry exists

  # Ref: FRD 5.2 FB-4; FRD 5.3 FB-10
  @TC_WST_072 @Functional @Medium @Automation
  Scenario: Verify column search values are cleared after a successful Add
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search (Code) | NH    |
      | New record    | CLR-1 |
    When the user types 'NH' in the Code column search
    And the user adds Code 'CLR-1', Name 'Search Clear Check', Parent Work 'Bridge'
    And the user clicks Save
    Then After Save the Code and Name search boxes are cleared and the full list is shown with the new record visible

  # Ref: FRD 5.2 FB-5; FRD 7 FE-1; FRD 7 FE-4; FRD 7 FE-6
  @TC_WST_073 @Functional @Medium @Automation
  Scenario: Verify a field-level error is cleared as soon as the user corrects the value
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB-9      |
      | Name        | Name Nine |
      | Parent Work | Bridge    |
    When the user leaves all fields empty and click Save
    And the user types 'RB-9' in Code
    And the user types 'Name Nine' in Name
    And the user selects Parent Work 'Bridge'
    Then Each field-level error disappears as soon as a valid value is entered/selected in that field, before clicking Save again

  # Ref: FRD 5.2 FB-2
  @TC_WST_074 @Functional @Medium @Automation
  Scenario: Verify field-level checks run first and duplicate checks are not reported while a field-level error exists
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB (existing) |
      | Name        | (blank)       |
      | Parent Work | Building      |
    When the user enters existing Code 'RB'
    And the user leaves Name blank
    And the user selects Parent Work 'Building'
    And the user clicks Save
    Then Only "Name is required." is shown; the server duplicate Code message is not shown because field-level checks are performed first

  # Ref: FRD 5.2 EP-1; FRD 5.2 F-AddedUnder
  @TC_WST_075 @Functional @Medium @Automation
  Scenario: Verify the Added Under field is not shown for Level 1 creation via the Add button
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Entry point | Add button |
    When the user observes the pop-up fields
    Then Only Code, Name and Parent Work fields are displayed; 'Added Under' is not shown

  # Ref: US-3 AC-1; FRD 5.2 EP-2; FRD 5.2 F-Parent
  @TC_WST_076 @Functional @High @Automation
  Scenario: Verify 'Add Sub Work Type' on a Work Type row opens the pop-up with Parent Work pre-selected and disabled and no 'Added Under'
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type row | Road |
    When the user clicks 'Add Sub Work Type' on Work Type row 'Road'
    Then The pop-up opens with Parent Work = 'Road' and disabled
    And 'Added Under' is not shown

  # Ref: US-3 AC-1; FRD 5.2 EP-2; FRD 5.2 BR-10
  @TC_WST_077 @Functional @High @Automation
  Scenario: Verify a record added from a Work Type row is saved at Level 1 under that Work Type
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code          | SH-2              |
      | Name          | State Highway Two |
      | Work Type row | Road              |
    When the user clicks 'Add Sub Work Type' on Work Type row 'Road'
    And the user enters Code 'SH-2'
    And the user enters Name 'State Highway Two'
    And the user clicks Save
    Then Toaster "Work Sub Type added successfully." is displayed
    And 'SH-2' is saved as a Level 1 Work Sub Type under 'Road' (appears first, Sl. No. 1)

  # Ref: US-3 AC-1; US-1 AC-5
  @TC_WST_078 @Functional @Medium @Automation
  Scenario: Verify adding the first Work Sub Type to a Work Type with none replaces the 'No Work Sub Types added.' message
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code          | BR-1          |
      | Name          | Girder Bridge |
      | Work Type row | Bridge        |
    When the user clicks 'Add Sub Work Type' on Work Type row 'Bridge'
    And the user enters Code 'BR-1'
    And the user enters Name 'Girder Bridge'
    And the user clicks Save
    Then 'BR-1' is shown under 'Bridge' with Sl. No. 1 and the message "No Work Sub Types added." is no longer displayed

  # Ref: US-3 AC-2; FRD 5.2 EP-3; FRD 5.2 F-AddedUnder
  @TC_WST_079 @Functional @High @Automation
  Scenario: Verify 'Add Sub Work Type' from a Level 2 row shows Parent Work (disabled) and read-only 'Added Under' as '<Code> – <Name> (Level n)'
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen with 'NH-SEC - NH Sections' (Level 2) visible
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | NH-SEC - NH Sections (Level 2) under Road |
    When the user clicks kebab (⋮) of 'NH-SEC - NH Sections'
    And the user selects 'Add Sub Work Type'
    Then Pop-up opens with Parent Work = 'Road' (disabled)
    And Read-only 'Added Under' shows "NH-SEC – NH Sections (Level 2)"

  # Ref: US-3 AC-2; FRD 5.2 BR-10; FRD 5.2 BR-11; FRD 5.2 EP-3
  @TC_WST_080 @Functional @High @Automation
  Scenario: Verify a record added from a Level 2 row is created at Level 3 under the same Work Type directly under that row
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen with 'NH-SEC - NH Sections' (Level 2) visible
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | NH-SEC-B  |
      | Name | Section B |
    When the user clicks kebab (⋮) of 'NH-SEC - NH Sections' and select 'Add Sub Work Type'
    And the user enters Code 'NH-SEC-B'
    And the user enters Name 'Section B'
    And the user clicks Save
    Then 'NH-SEC-B' belongs to 'Road' at Level 3 directly under 'NH-SEC' and is shown first under NH-SEC (Sl. No. 2.1.1); rule: row at Level n creates Level n + 1

  # Ref: US-3 AC-2; FRD 5.2 BR-10; FRD 5.2 EP-3
  @TC_WST_081 @Functional @High @Automation
  Scenario: Verify a record added from a Level 1 row is created at Level 2
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen with 'RB - Residential Building' (Level 1) visible
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | RB-VIL |
      | Name | Villas |
    When the user clicks kebab (⋮) of 'RB - Residential Building' and select 'Add Sub Work Type'
    And the user observes 'Added Under'
    And the user enters Code 'RB-VIL'
    And the user enters Name 'Villas'
    And the user clicks Save
    Then 'Added Under' shows "RB – Residential Building (Level 1)"
    And 'RB-VIL' is created at Level 2 under 'RB' within Work Type 'Building'

  # Ref: US-3 AC-2; FRD 5.2 BR-10; FRD 5.2 BR-8
  @TC_WST_082 @Functional @High @Automation
  Scenario: Verify a record added from a Level 3 row is created at Level 4 (maximum level)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen with 'NH-SEC-A - Section A' (Level 3) visible
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | NH-SEC-A2      |
      | Name | Sub Section A2 |
    When the user clicks kebab (⋮) of 'NH-SEC-A - Section A' and select 'Add Sub Work Type'
    And the user enters Code 'NH-SEC-A2'
    And the user enters Name 'Sub Section A2'
    And the user clicks Save
    Then 'NH-SEC-A2' is created at Level 4 under 'NH-SEC-A' and shown first (Sl. No. 2.1.1.1); the former first child is renumbered 2.1.1.2

  # Ref: FRD 5.2 FB-4
  @TC_WST_083 @Functional @Medium @Automation
  Scenario: Verify the row added-under and all ancestors are expanded and the Work Type row is expanded after Add from a Work Sub Type row
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | NH-SEC-C  |
      | Name | Section C |
    When the user collapses 'Road'
    And the user adds Sub Work Type from 'NH-SEC - NH Sections' with Code 'NH-SEC-C' and Name 'Section C'
    And the user clicks Save
    Then 'Road', 'NH' and 'NH-SEC' are expanded and the new row is scrolled into view

  # Ref: US-3 AC-4; FRD 5.2 F-Parent
  @TC_WST_084 @Functional @High @Automation
  Scenario: Verify Parent Work cannot be emptied or changed when the pop-up is opened from a row
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen with 'NH-SEC - NH Sections' visible
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Parent Work | Road (locked) |
    When the user opens 'Add Sub Work Type' from 'NH-SEC - NH Sections'
    And the user tries to open/change the Parent Work field
    Then Parent Work is disabled, remains 'Road' and cannot be emptied or changed

  # Ref: US-3 AC-4; FRD 7 FE-1
  @TC_WST_085 @Functional @Medium @Automation
  Scenario: Verify all Add-button validations also apply to the Add Sub Work Type pop-up (Code required)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen with Work Type row 'Road' visible
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | (blank)    |
      | Name | Valid Name |
    When the user clicks 'Add Sub Work Type' on 'Road'
    And the user leaves Code blank and enter Name 'Valid Name'
    And the user clicks Save
    Then Error "Code is required." is displayed below Code and no record is saved

  # Ref: FRD 5.2 BR-9
  @TC_WST_087 @Functional @Medium @Automation
  Scenario: Verify increasing the backend maximum level takes effect on the next screen open (Level 4 rows offer 'Add Sub Work Type')
    Given Backend access available
    And Admin_User1 is logged in
    And Backend maximum level is changed from 4 to 5
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Backend maximum | 5 |
    When the user reopens the Work Sub Type screen
    And the user clicks kebab (⋮) of Level 4 row 'NH-SEC-A1'
    Then 'Add Sub Work Type' is now displayed for Level 4 rows and a Level 5 record can be created

  # Ref: FRD 5.2 BR-9; FRD 5.1 FB-4
  @TC_WST_088 @Functional @Medium @Automation
  Scenario: Verify reducing the backend maximum level keeps existing deeper records visible but allows no new Work Sub Type under records at or below the new maximum
    Given Backend access available
    And Admin_User1 is logged in
    And Backend maximum level is changed from 4 to 3
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Backend maximum | 3 |
    When the user reopens the Work Sub Type screen
    And the user observes Level 4 row 'NH-SEC-A1'
    And the user clicks kebab (⋮) of Level 3 row 'NH-SEC-A'
    Then Existing Level 4 record 'NH-SEC-A1' is kept and visible
    And 'Add Sub Work Type' is not offered for Level 3 rows (and none below)

  # Ref: FRD 5.2 BR-10; FRD 5.5 BR-1
  @TC_WST_089 @Functional @High @Automation
  Scenario: Verify the level of a Work Sub Type never changes after creation
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record   | NH-SEC              |
      | New Name | NH Sections Updated |
    When the user edits 'NH-SEC - NH Sections' (Level 2), change Name to 'NH Sections Updated' and Save
    And the user opens View for the record
    Then Level remains 2 and the position under 'NH' is unchanged

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-4; FRD 5.2 BR-1; FRD 7 FE-1
  @TC_WST_181 @Negative @High @Automation
  Scenario: Verify Save is rejected when Code is blank
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | (blank)          |
      | Name        | Blank Code Check |
      | Parent Work | Road             |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code is required." is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: US-2 AC-4; FRD 5.2 BR-2; FRD 7 FE-1
  @TC_WST_182 @Negative @High @Automation
  Scenario: Verify Save is rejected when Code contains only spaces
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | ' '              |
      | Name        | Space Code Check |
      | Parent Work | Road             |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code is required." is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: US-2 AC-5; FRD 5.2 BR-3; FRD 7 FE-2
  @TC_WST_183 @Negative @High @Automation
  Scenario: Verify Code containing a space in the middle is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | R B           |
      | Name        | Space In Code |
      | Parent Work | Road          |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: US-2 AC-5; FRD 7 FE-2
  @TC_WST_184 @Negative @High @Automation
  Scenario: Verify Code containing '#' is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB#          |
      | Name        | Hash In Code |
      | Parent Work | Road         |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: US-2 AC-5; FRD 7 FE-2
  @TC_WST_185 @Negative @Medium @Automation
  Scenario: Verify Code containing '@' is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB@1       |
      | Name        | At In Code |
      | Parent Work | Road       |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Code; FRD 7 FE-2
  @TC_WST_186 @Negative @Medium @Automation
  Scenario: Verify Code containing dollar ('RB$1') is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB$1                |
      | Name        | Invalid Code dollar |
      | Parent Work | Road                |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Code; FRD 7 FE-2
  @TC_WST_187 @Negative @Medium @Automation
  Scenario: Verify Code containing percent ('RB%1') is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB%1                 |
      | Name        | Invalid Code percent |
      | Parent Work | Road                 |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Code; FRD 7 FE-2
  @TC_WST_188 @Negative @Medium @Automation
  Scenario: Verify Code containing ampersand ('RB&1') is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB&1                   |
      | Name        | Invalid Code ampersand |
      | Parent Work | Road                   |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Code; FRD 7 FE-2
  @TC_WST_189 @Negative @Medium @Automation
  Scenario: Verify Code containing brackets ('RB(1)') is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB(1)                 |
      | Name        | Invalid Code brackets |
      | Parent Work | Road                  |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Code; FRD 7 FE-2
  @TC_WST_190 @Negative @Medium @Automation
  Scenario: Verify Code containing comma ('RB,1') is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB,1               |
      | Name        | Invalid Code comma |
      | Parent Work | Road               |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Code; FRD 7 FE-2
  @TC_WST_191 @Negative @Medium @Automation
  Scenario: Verify Code containing colon ('RB:1') is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB:1               |
      | Name        | Invalid Code colon |
      | Parent Work | Road               |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Code; FRD 7 FE-2
  @TC_WST_192 @Negative @Medium @Automation
  Scenario: Verify Code containing backslash ('RB\1') is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB\1                   |
      | Name        | Invalid Code backslash |
      | Parent Work | Road                   |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Code; FRD 7 FE-2
  @TC_WST_193 @Negative @Medium @Automation
  Scenario: Verify Code containing angle brackets ('RB<1>') is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB<1>                       |
      | Name        | Invalid Code angle brackets |
      | Parent Work | Road                        |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Code
  @TC_WST_194 @Negative @Medium @Automation
  Scenario: Verify Code containing a non-ASCII letter is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RBé1          |
      | Name        | NonAscii Code |
      | Parent Work | Road          |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code (only A-Z, a-z, 0-9 and - _ . / are allowed)
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 F-Code
  @TC_WST_195 @Negative @High @Automation
  Scenario: Verify the Code box does not accept more than 20 characters when typing (max+1 boundary)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed | ABCDEFGHIJ1234567890X (21) |
    When the user clicks Code
    And the user types a 21-character value
    Then Typing stops at 20 characters; the Code box contains 'ABCDEFGHIJ1234567890'

  # Ref: FRD 5.2 F-Code
  @TC_WST_196 @Negative @Medium @Automation
  Scenario: Verify pasted text longer than 20 characters is cut at 20 in Code
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pasted | ABCDEFGHIJ1234567890ZZZZZZZZZZ (30) |
    When the user pastes a 30-character value in Code
    Then The Code box contains only the first 20 characters

  # Ref: FRD 5.2 F-Name
  @TC_WST_197 @Negative @High @Automation
  Scenario: Verify the Name box does not accept more than 100 characters when typing (max+1 boundary)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed | 'N' x 101 |
    When the user clicks Name
    And the user types a 101-character value
    Then Typing stops at 100 characters

  # Ref: FRD 5.2 F-Name
  @TC_WST_198 @Negative @Medium @Automation
  Scenario: Verify pasted text longer than 100 characters is cut at 100 in Name
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pasted | 'M' x 150 |
    When the user pastes a 150-character value in Name
    Then The Name box contains only the first 100 characters

  # Ref: US-2 AC-7; FRD 5.2 BR-1; FRD 7 FE-4
  @TC_WST_199 @Negative @High @Automation
  Scenario: Verify Save is rejected when Name is blank
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | NM-BLK  |
      | Name        | (blank) |
      | Parent Work | Road    |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Name is required." is displayed below Name
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: US-2 AC-7; FRD 5.2 BR-2; FRD 7 FE-4
  @TC_WST_200 @Negative @High @Automation
  Scenario: Verify Save is rejected when Name contains only spaces
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | NM-SPC |
      | Name        | ' '    |
      | Parent Work | Road   |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Name is required." is displayed below Name
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: US-2 AC-8; FRD 5.2 F-Parent; FRD 7 FE-6; FRD 5.2 BR-1
  @TC_WST_201 @Negative @High @Automation
  Scenario: Verify Save is rejected when Parent Work is not selected via the Add button
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | PRN-1                                             |
      | Name        | No Parent Work                                    |
      | Parent Work | (not selected - placeholder 'Select Parent Work') |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "Parent Work is required." is displayed below Parent Work
    And The placeholder is not accepted as a value
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: US-2 AC-10; FRD 5.2 FB-3; FRD 7 FE-1; FRD 7 FE-4; FRD 7 FE-6
  @TC_WST_202 @Negative @High @Automation
  Scenario: Verify all three field-level errors are displayed together when all fields are empty
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | All fields | empty |
    When the user leaves Code, Name and Parent Work empty
    And the user clicks Save
    Then "Code is required.", "Name is required." and "Parent Work is required." are displayed at the same time
    And No toaster is displayed and the pop-up stays open

  # Ref: FRD 5.2 FB-3
  @TC_WST_203 @Negative @Medium @Automation
  Scenario: Verify the cursor moves to the first failing field and field borders are highlighted in red on validation failure
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | (blank)        |
      | Name        | Focus Check    |
      | Parent Work | (not selected) |
    When the user enters valid Name 'Focus Check'
    And the user leaves Code blank and Parent Work unselected
    And the user clicks Save
    Then Code and Parent Work borders are highlighted red
    And Cursor/focus moves to Code (first failing field)

  # Ref: FRD 5.2 FB-3; FRD 7 T-Only
  @TC_WST_204 @Negative @Medium @Automation
  Scenario: Verify entered values are retained and no toaster is shown when validation fails
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | R B          |
      | Name        | Retain Check |
      | Parent Work | Road         |
    When the user enters Code 'R B', Name 'Retain Check', Parent Work 'Road'
    And the user clicks Save
    Then Code, Name and Parent Work values remain as entered; no toaster is displayed

  # Ref: FRD 5.2 FB-3
  @TC_WST_205 @Negative @Medium @Automation
  Scenario: Verify combined invalid inputs show all applicable field errors simultaneously
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB#            |
      | Name        | (blank)        |
      | Parent Work | (not selected) |
    When the user enters Code 'RB#'
    And the user leaves Name blank
    And the user leaves Parent Work unselected
    And the user clicks Save
    Then "Code may contain only letters, numbers and the characters - _ . /", "Name is required." and "Parent Work is required." are displayed at the same time

  # Ref: US-2 AC-11; FRD 5.2 BR-4; FRD 7 FE-3; FRD 5.2 F-Code
  @TC_WST_206 @Negative @High @Automation
  Scenario: Verify duplicate Code with different letter case anywhere in the hierarchy is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | rb               |
      | Name        | Unique Name Dup1 |
      | Parent Work | Road             |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "A Work Sub Type with this code already exists." is displayed below Code (existing Code 'RB' is under Building)
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-4; FRD 7 FE-3
  @TC_WST_207 @Negative @High @Automation
  Scenario: Verify an exact duplicate Code is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | NH               |
      | Name        | Unique Name Dup2 |
      | Parent Work | Road             |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "A Work Sub Type with this code already exists." is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-4; FRD 7 FE-3
  @TC_WST_208 @Negative @High @Automation
  Scenario: Verify a Code duplicate is rejected across different Work Types (Code 'SH' under Building)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | SH               |
      | Name        | Unique Name Dup3 |
      | Parent Work | Building         |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "A Work Sub Type with this code already exists." is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-4; FRD 7 FE-3
  @TC_WST_209 @Negative @High @Automation
  Scenario: Verify a Code duplicate is rejected when the existing record is at a different level (Level 4 'NH-SEC-A1')
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | nh-sec-a1        |
      | Name        | Unique Name Dup4 |
      | Parent Work | Bridge           |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "A Work Sub Type with this code already exists." is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-2; FRD 5.2 BR-4
  @TC_WST_210 @Negative @Medium @Automation
  Scenario: Verify a duplicate Code with leading/trailing spaces is rejected after trimming
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | ' RB '           |
      | Name        | Unique Name Dup5 |
      | Parent Work | Road             |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "A Work Sub Type with this code already exists." is displayed below Code
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: US-2 AC-12; FRD 5.2 BR-6; FRD 7 FE-5
  @TC_WST_211 @Negative @High @Automation
  Scenario: Verify duplicate Name with different case and extra spaces is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | DUP-N1               |
      | Name        | residential building |
      | Parent Work | Road                 |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "A Work Sub Type with this name already exists." is displayed below Name
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-6; FRD 7 FE-5
  @TC_WST_212 @Negative @High @Automation
  Scenario: Verify an exact duplicate Name is rejected
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | DUP-N2               |
      | Name        | Residential Building |
      | Parent Work | Road                 |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "A Work Sub Type with this name already exists." is displayed below Name
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-2; FRD 5.2 BR-6
  @TC_WST_213 @Negative @Medium @Automation
  Scenario: Verify a Name duplicate is rejected after reducing repeated internal spaces
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | DUP-N3               |
      | Name        | Residential Building |
      | Parent Work | Bridge               |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "A Work Sub Type with this name already exists." is displayed below Name
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 BR-6; FRD 7 FE-5
  @TC_WST_214 @Negative @High @Automation
  Scenario: Verify a Name duplicate is rejected across Work Types and levels (existing Level 4 'Sub Section A1')
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | DUP-N4         |
      | Name        | SUB SECTION A1 |
      | Parent Work | Building       |
    When the user enters Code
    And the user enters Name
    And the user selects Parent Work
    And the user clicks Save
    Then Error "A Work Sub Type with this name already exists." is displayed below Name
    And The pop-up stays open with all entered values retained and no record is created
    And No toaster is displayed

  # Ref: FRD 5.2 FB-2; FRD 7 FE-3
  @TC_WST_215 @Negative @Medium @Automation
  Scenario: Verify duplicate Code error is shown (and duplicate Name error is not) when only Code is duplicate
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB             |
      | Name        | Brand New Name |
      | Parent Work | Road           |
    When the user enters Code 'RB'
    And the user enters unique Name 'Brand New Name'
    And the user selects Parent Work 'Road'
    And the user clicks Save
    Then Only "A Work Sub Type with this code already exists." is displayed below Code; no Name error is displayed

  # Ref: FRD 5.2 FB-2
  @TC_WST_216 @Negative @Medium @Automation
  Scenario: Verify the duplicate Code check is performed before the duplicate Name check when both Code and Name are duplicates
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | RB                   |
      | Name        | Residential Building |
      | Parent Work | Road                 |
    When the user enters Code 'RB'
    And the user enters Name 'Residential Building'
    And the user selects Parent Work 'Road'
    And the user clicks Save
    Then "A Work Sub Type with this code already exists." is displayed below Code (Code check is evaluated first); no record is created. (See Open Question OQ-4 on whether the Name error is displayed simultaneously.)

  # Ref: US-3 AC-4; FRD 7 FE-3
  @TC_WST_217 @Negative @Medium @Automation
  Scenario: Verify duplicate validations apply when adding via 'Add Sub Work Type' from a kebab menu
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen with 'NH-SEC - NH Sections' visible
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | sh            |
      | Name | Dup Via Kebab |
    When the user opens 'Add Sub Work Type' from 'NH-SEC'
    And the user enters Code 'sh'
    And the user enters Name 'Dup Via Kebab'
    And the user clicks Save
    Then Error "A Work Sub Type with this code already exists." is displayed below Code

  # Ref: FRD 5.2 FB-5
  @TC_WST_218 @Negative @Medium @Automation
  Scenario: Verify Code error text clears once the Code is corrected after a duplicate error
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | RB -> RB-NEW |
    When the user enters Code 'RB', Name 'Clear Dup Check', Parent Work 'Road' and click Save
    And the user changes Code to 'RB-NEW'
    Then The duplicate Code error is cleared as soon as the Code value is corrected

  # Ref: FRD 5.2 BR-8; US-3 AC-3
  @TC_WST_227 @Negative @High @Automation
  Scenario: Verify the server rejects creation of a Work Sub Type under a Level 4 record
    Given API client authenticated with the token of Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | {code:'L5-1', name:'Level Five Attempt', parentWork:'Road', addedUnder:'NH-SEC-A1'} |
    When the user sends a create request with Added Under = 'NH-SEC-A1' (Level 4), Code 'L5-1', Name 'Level Five Attempt'
    And the user queries the record
    Then Request is rejected by the server; no Level 5 record is created

  # Ref: FRD 5.2 BR-15
  @TC_WST_228 @Negative @High @Automation
  Scenario: Verify the server validates all inputs independently of the screen (blank Code, invalid Code, 21-char Code, blank Name, 101-char Name)
    Given API client authenticated with the token of Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payloads | Code ''                           |
      | Data     | 'R#B'                             |
      | Data     | 'ABCDEFGHIJ1234567890X' ; Name '' |
      | Data     | 'N' x 101                         |
    When the user sends create requests bypassing the UI with: blank Code; Code 'R#B'; Code of 21 characters; blank Name; Name of 101 characters
    Then Every request is rejected by the server and no record is created

  # Ref: FRD 5.2 BR-12; FRD 5.2 BR-15
  @TC_WST_229 @Negative @High @Automation
  Scenario: Verify the server rejects a create request with a non-existent Parent Work
    Given API client authenticated with the token of Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | {code:'INV-1', name:'Invalid Parent', parentWork:'WT-DOES-NOT-EXIST'} |
    When the user sends a create request with Parent Work ID that does not exist
    Then Request is rejected and no record is created

  # Ref: FRD 5.2 BR-15; FRD 5.2 BR-4; FRD 5.2 BR-6
  @TC_WST_230 @Negative @High @Automation
  Scenario: Verify the server rejects a duplicate Code/Name sent directly via API
    Given API client authenticated with the token of Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payloads | {code:'rb'}             |
      | {name    | 'residential building'} |
    When the user sends a create request with Code 'rb'
    And the user sends a create request with Name 'residential building'
    Then Both requests are rejected with the corresponding duplicate error and no record is created

  # Ref: FRD 5.2 BR-12; FRD 7 FE-7
  @TC_WST_231 @Negative @High @Automation
  Scenario: Verify error 'Selected Parent Work no longer exists.' when the selected Work Type is deleted by another user before Save
    Given Admin_User1 (Session A) is in the Add pop-up with Parent Work 'Bridge' selected
    And Admin_User2 (Session B) can delete Work Types
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | CON-1             |
      | Name        | Concurrent Parent |
      | Parent Work | Bridge (deleted)  |
    When In Session A enter Code 'CON-1', Name 'Concurrent Parent' and select Parent Work 'Bridge'
    And In Session B delete Work Type 'Bridge'
    And In Session A click Save
    Then The server rejects the save and displays field-level error "Selected Parent Work no longer exists." below Parent Work; no toaster is shown and no record is created

  # Ref: FRD 5.2 BR-13; FRD 7 FE-8
  @TC_WST_232 @Negative @High @Automation
  Scenario: Verify error 'The Work Sub Type you are adding under no longer exists.' when the Added Under record is deleted by another user before Save
    Given Admin_User1 (Session A) is in the 'Add Sub Work Type' pop-up opened from 'RB-APT - Apartments'
    And Admin_User2 (Session B) can delete Work Sub Types
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | CON-2            |
      | Name        | Concurrent Under |
      | Added Under | RB-APT (deleted) |
    When In Session A enter Code 'CON-2', Name 'Concurrent Under'
    And In Session B delete 'RB-APT'
    And In Session A click Save
    Then The server rejects the save and displays field-level error "The Work Sub Type you are adding under no longer exists." below the Added Under field; no record is created

  # Ref: FRD 5.2 BR-15; FRD 5.2 BR-5
  @TC_WST_244 @Negative @High @Automation
  Scenario: Verify HTML/script content in Name is stored and displayed as plain text in the list
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | XSS-1                     |
      | Name        | <script>alert(1)</script> |
      | Parent Work | Bridge                    |
    When the user enters Code 'XSS-1'
    And the user enters Name '<script>alert(1)</script>'
    And the user selects Parent Work 'Bridge'
    And the user clicks Save
    And the user observes the list
    Then The Name is displayed as plain text '<script>alert(1)</script>'; no script is executed

  # Ref: FRD 5.2 BR-15
  @TC_WST_245 @Negative @High @Automation
  Scenario: Verify special characters < > & " ' in Name are HTML-encoded in View, Edit and the delete confirmation
    Given Admin_User1 is logged in; Work Sub Type 'XSS-2' with Name '<b>Bold</b> & "Q" S' exists
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | <b>Bold</b> & "Q" S |
    When the user opens View for 'XSS-2'
    And the user opens Edit for 'XSS-2'
    And the user selects Delete for 'XSS-2'
    Then The Name is displayed as plain text in every place (no bold rendering, no script execution), including the dialog text

  # Ref: FRD 5.2 BR-15; FRD 5.6 FB-1
  @TC_WST_246 @Negative @Medium @Automation
  Scenario: Verify HTML/script content in Name is displayed as plain text on the Create Work Work Sub Type selection
    Given Work Sub Type 'XSS-1' (Name '<script>alert(1)</script>') exists under 'Bridge'
    And Admin_User1 is on the Create Work form
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name | <script>alert(1)</script> |
    When the user selects Work Type 'Bridge'
    And the user opens the Work Sub Type selection
    Then The Name is shown as plain text and no script is executed

  # Ref: FRD 5.2 BR-15
  @TC_WST_247 @Negative @High @Automation
  Scenario: Verify SQL-injection text in Name is saved as plain text (parameterized queries)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | SQL-1                           |
      | Name        | x'; DROP TABLE work_sub_type;-- |
      | Parent Work | Bridge                          |
    When the user enters Code 'SQL-1'
    And the user enters Name "x'; DROP TABLE work_sub_type;--"
    And the user selects Parent Work 'Bridge'
    And the user clicks Save
    And the user reloads the screen
    Then The Name is stored and displayed as plain text; the Work Sub Type table and data remain intact

  # Ref: FRD 5.2 BR-3; FRD 5.2 BR-15
  @TC_WST_248 @Negative @High @Automation
  Scenario: Verify SQL-injection text in Code is rejected by the allowed-characters validation
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and the 'Add Work Sub Type' pop-up is open via the 'Add' button
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | 1' OR '1'='1   |
      | Name        | SQL Code Check |
      | Parent Work | Bridge         |
    When the user enters Code "1' OR '1'='1"
    And the user enters Name 'SQL Code Check'
    And the user selects Parent Work 'Bridge'
    And the user clicks Save
    Then Error "Code may contain only letters, numbers and the characters - _ . /" is displayed below Code and no record is created
