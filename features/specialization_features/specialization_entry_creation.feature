@Specialization @SpecializationEntryCreation
Feature: Specialization Entry Creation
  Automated scenarios for the "Specialization Entry Creation" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-1; FRD 5.2 FB-2; FRD 5.2 F-MiscType
  @TC_SP_010 @Functional @High @Automation
  Scenario: Verify Add pop-up opens with read-only Misc Type and empty Code, Name and Remark
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Misc Type | List of Title |
    When the user clicks 'Add'
    And the user observes the pop-up fields
    Then 'Add Specialization Entry' pop-up opens
    And Misc Type shows 'List of Title' as read-only text
    And Code, Name and Remark are empty

  # Ref: FRD 5.2 FB-2
  @TC_SP_011 @Functional @Low @Automation
  Scenario: Verify Add pop-up places the cursor in Code on open
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed text | Prof. |
    When the user clicks 'Add'
    And the user types 'Prof.' without clicking any field
    Then Cursor is in the Code field and 'Prof.' appears in Code

  # Ref: US-2 AC-2; FRD 5.2 FB-5; FRD 7 T-1; FRD 5.2 FB-1
  @TC_SP_012 @Functional @High @Automation
  Scenario: Verify a Specialization Entry is created with unique Code and Name and success toaster shown
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code   | Prof.          |
      | Name   | Professor      |
      | Remark | Academic title |
    When the user clicks 'Add'
    And the user enters Code
    And the user enters Name
    And the user enters Remark
    And the user clicks Save
    Then Pop-up closes
    And Toaster 'Specialization Entry added successfully.' is displayed
    And Entry 'Prof.' / 'Professor' / 'Academic title' is saved for 'List of Title'

  # Ref: US-2 AC-2; US-3 AC-4; FRD 5.2 FB-5; FRD 5.3 FB-2
  @TC_SP_013 @Functional @High @Automation
  Scenario: Verify the new Specialization Entry is shown as Sl. No. 1 and existing entries move down by one
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code               | Prof.           |
      | Name               | Professor       |
      | Existing top entry | Mr. (Sl. No. 1) |
    When the user clicks 'Add' and save Code 'Prof.' with Name 'Professor'
    And the user observes the list
    Then 'Prof.' is shown at Sl. No. 1 on page 1
    And 'Mr.' moves to Sl. No. 2 and every other entry moves down by one (Ms. becomes Sl. No. 8)

  # Ref: US-2 AC-2; FRD 5.2 FB-5; FRD 5.3 FB-8
  @TC_SP_014 @Functional @Medium @Automation
  Scenario: Verify list returns to page 1 with column search cleared after Add
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And Misc Type 'List of Qualification' is selected, page 2 is open and 'Q1' is typed in the Code column search
    And the following test data is used
      | Code | Q121              |
      | Name | Qualification 121 |
    When the user clicks 'Add'
    And the user enters Code 'Q121' and Name 'Qualification 121'
    And the user clicks Save
    And the user observes the list and search boxes
    Then List is shown on page 1 with all column search boxes empty
    And 'Q121' is shown as Sl. No. 1

  # Ref: FRD 5.2 FB-5
  @TC_SP_015 @Functional @High @Automation
  Scenario: Verify first entry of an empty Misc Type replaces the empty state with the list
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Firm Type' selected
    And Baseline data (see Summary) is loaded. 'List of Firm Type' has no Specialization Entries
    And the following test data is used
      | Code      | PVT               |
      | Name      | Private Limited   |
      | Misc Type | List of Firm Type |
    When the user clicks 'Add' on the empty state
    And the user enters Code 'PVT' and Name 'Private Limited'
    And the user clicks Save
    Then Empty state is replaced by the list
    And 'PVT' is shown at Sl. No. 1

  # Ref: US-2 AC-11; FRD 5.3 FB-10; FRD 5.2 F-Remark
  @TC_SP_016 @Functional @Medium @Automation
  Scenario: Verify Specialization Entry is saved with blank Remark and shown as '-'
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code   | Adv.     |
      | Name   | Advocate |
      | Remark | (empty)  |
    When the user clicks 'Add'
    And the user enters Code 'Adv.' and Name 'Advocate'
    And the user leaves Remark empty
    And the user clicks Save
    And the user observes the Remark column of the new row
    Then Entry is saved with blank Remark
    And Remark column shows '-'

  # Ref: FRD 5.2 FB-5; FRD 5.4 FB-2
  @TC_SP_017 @Functional @Medium @Automation
  Scenario: Verify Created By and Created On are recorded on creation
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Prof.       |
      | Name | Professor   |
      | User | Admin_User1 |
    When the user clicks 'Add' and save Code 'Prof.' with Name 'Professor'
    And the user opens View for the new row
    And the user reads Created By, Created On, Last Modified By and Last Modified On
    Then Created By shows Admin_User1 and Created On shows the current date-time
    And Last Modified By and Last Modified On show '-'

  # Ref: FRD 5.2 BR-7; FRD 5.2 FB-5
  @TC_SP_018 @Functional @High @Automation
  Scenario: Verify a unique Internal ID is generated on save and is never shown on screen
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Entries | Prof./Professor, Adv./Advocate |
    When the user adds Code 'Prof.' with Name 'Professor' and Save
    And the user adds Code 'Adv.' with Name 'Advocate' and Save
    And the user queries the stored records for both entries
    And the user inspects Add, Edit and View pop-ups and the list for any ID
    Then Each stored entry has a system-generated Internal ID and the two IDs differ
    And Internal ID is not displayed on the list, Add, Edit or View pop-up

  # Ref: US-2 AC-9; FRD 5.2 BR-5
  @TC_SP_019 @Functional @High @Automation
  Scenario: Verify the same Code can be saved in a different Misc Type
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Firm Type' selected
    And Baseline data (see Summary) is loaded. 'List of Firm Type' has no entries
    And the following test data is used
      | Misc Type | List of Firm Type |
      | Code      | Mr.               |
      | Name      | Mister Firm       |
    When the user clicks 'Add'
    And the user enters Code 'Mr.' (exists only in 'List of Title') and Name 'Mister Firm'
    And the user clicks Save
    Then Entry is saved and toaster 'Specialization Entry added successfully.' is displayed

  # Ref: US-2 AC-9; FRD 5.2 BR-6
  @TC_SP_020 @Functional @High @Automation
  Scenario: Verify the same Name can be saved in a different Misc Type
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Firm Type' selected
    And Baseline data (see Summary) is loaded. 'List of Firm Type' has no entries
    And the following test data is used
      | Misc Type | List of Firm Type |
      | Code      | MS1               |
      | Name      | Miss              |
    When the user clicks 'Add'
    And the user enters Code 'MS1' and Name 'Miss' (exists only in 'List of Title')
    And the user clicks Save
    Then Entry is saved and toaster 'Specialization Entry added successfully.' is displayed

  # Ref: US-2 AC-10; FRD 5.2 BR-4
  @TC_SP_021 @Functional @High @Automation
  Scenario: Verify Code and Name with letters, numbers and special characters are saved exactly as entered
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Dr.(Prof)   |
      | Name | Dr. & Prof. |
    When the user clicks 'Add'
    And the user enters Code and Name
    And the user clicks Save
    And the user opens View for the new row
    Then Entry is saved and displayed as plain text exactly as 'Dr.(Prof)' and 'Dr. & Prof.'

  # Ref: FRD 5.2 BR-4; FRD 5.2 F-Code
  @TC_SP_022 @Functional @Medium @Automation
  Scenario: Verify Code accepts a mix of letters, digits and special characters
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | A-01/2     |
      | Name | Category A |
    When the user clicks 'Add'
    And the user enters Code 'A-01/2' and Name 'Category A'
    And the user clicks Save
    Then Entry is saved with Code 'A-01/2'

  # Ref: FRD 5.2 BR-4; FRD 5.2 F-Code
  @TC_SP_023 @Functional @Medium @Automation
  Scenario: Verify Code accepts digits only
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | 12345        |
      | Name | Numeric Code |
    When the user clicks 'Add'
    And the user enters Code '12345' and Name 'Numeric Code'
    And the user clicks Save
    Then Entry is saved with Code '12345'

  # Ref: FRD 5.2 BR-4
  @TC_SP_024 @Functional @Medium @Automation
  Scenario: Verify Code, Name and Remark are saved with the letter case exactly as entered
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code   | pRoF               |
      | Name   | pROFESSOR eMERITUS |
      | Remark | aCADEMIC tITLE     |
    When the user clicks 'Add'
    And the user enters Code 'pRoF', Name 'pROFESSOR eMERITUS' and Remark 'aCADEMIC tITLE'
    And the user clicks Save
    Then List shows 'pRoF', 'pROFESSOR eMERITUS' and 'aCADEMIC tITLE' without case conversion

  # Ref: US-2 AC-6; FRD 5.2 BR-3
  @TC_SP_025 @Functional @High @Automation
  Scenario: Verify leading and trailing spaces in Code are removed without an error
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | ' Prof. ' (2 leading + 2 trailing spaces) |
      | Name | Professor                                 |
    When the user clicks 'Add'
    And the user enters Code ' Prof. ' and Name 'Professor'
    And the user clicks Save
    Then No error is shown and entry is saved with Code 'Prof.'

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Name
  @TC_SP_026 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces in Name are removed before saving
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Prof.         |
      | Name | ' Professor ' |
    When the user clicks 'Add'
    And the user enters Code 'Prof.' and Name ' Professor '
    And the user clicks Save
    Then Entry is saved with Name 'Professor' without surrounding spaces

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Remark
  @TC_SP_027 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces in Remark are removed before saving
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Remark | ' Academic title ' |
    When the user clicks 'Add'
    And the user enters Code 'Prof.', Name 'Professor' and Remark ' Academic title '
    And the user clicks Save
    Then Entry is saved with Remark 'Academic title' without surrounding spaces

  # Ref: FRD 5.2 BR-3; FRD 5.2 F-Name
  @TC_SP_028 @Functional @Medium @Automation
  Scenario: Verify two or more internal spaces in Name are reduced to one space
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | AP2                                            |
      | Name | 'Assistant Professor' (4 spaces between words) |
    When the user clicks 'Add'
    And the user enters Code 'AP2' and Name 'Assistant Professor'
    And the user clicks Save
    Then Entry is saved with Name 'Assistant Professor' (single space)

  # Ref: FRD 5.2 F-Code
  @TC_SP_029 @Functional @Medium @Automation
  Scenario: Verify Code of exactly 20 characters is accepted
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | ABCDEFGHIJKLMNOPQRST (20) |
      | Name | Twenty Char Code          |
    When the user clicks 'Add'
    And the user enters a 20-character Code
    And the user enters Name 'Twenty Char Code'
    And the user clicks Save
    Then Entry is saved with the full 20-character Code

  # Ref: FRD 5.2 F-Code; FRD 5.2 BR-2
  @TC_SP_030 @Functional @Medium @Automation
  Scenario: Verify Code of 1 character (minimum) is accepted
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | X                |
      | Name | Single Char Code |
    When the user clicks 'Add'
    And the user enters Code 'X' and Name 'Single Char Code'
    And the user clicks Save
    Then Entry is saved with Code 'X'

  # Ref: FRD 5.2 F-Name
  @TC_SP_031 @Functional @Medium @Automation
  Scenario: Verify Name of exactly 100 characters is accepted
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | N100                   |
      | Name | 'N' repeated 100 times |
    When the user clicks 'Add'
    And the user enters Code 'N100'
    And the user enters a 100-character Name
    And the user clicks Save
    Then Entry is saved with the full 100-character Name, wrapped (not cut off) in the list

  # Ref: FRD 5.2 F-Name; FRD 5.2 BR-2
  @TC_SP_032 @Functional @Medium @Automation
  Scenario: Verify Name of 1 character (minimum) is accepted
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | NM1 |
      | Name | Z   |
    When the user clicks 'Add'
    And the user enters Code 'NM1' and Name 'Z'
    And the user clicks Save
    Then Entry is saved with Name 'Z'

  # Ref: FRD 5.2 BR-4; FRD 5.2 F-Name
  @TC_SP_033 @Functional @Medium @Automation
  Scenario: Verify Name accepts special characters and symbols
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | SPC1                           |
      | Name | @#$% Dr. & Prof. (Hon.) / 100% |
    When the user clicks 'Add'
    And the user enters Code 'SPC1' and Name '@#$% Dr. & Prof. (Hon.) / 100%'
    And the user clicks Save
    Then Entry is saved with Name exactly as entered

  # Ref: FRD 5.2 F-Remark
  @TC_SP_034 @Functional @Medium @Automation
  Scenario: Verify Remark of exactly 250 characters is accepted
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code   | R250                   |
      | Name   | Remark 250             |
      | Remark | 'R' repeated 250 times |
    When the user clicks 'Add'
    And the user enters Code 'R250' and Name 'Remark 250'
    And the user enters a 250-character Remark
    And the user clicks Save
    Then Entry is saved with the full 250-character Remark, wrapped (not cut off) in the list

  # Ref: FRD 5.2 F-Remark; FRD 5.2 BR-4
  @TC_SP_035 @Functional @Medium @Automation
  Scenario: Verify Remark accepts any characters
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code   | RM1                                          |
      | Name   | Remark Chars                                 |
      | Remark | Used for A/B & C (2026) #1 "quoted" 'single' |
    When the user clicks 'Add'
    And the user enters Code 'RM1' and Name 'Remark Chars'
    And the user enters Remark with letters, digits, spaces and symbols
    And the user clicks Save
    Then Entry is saved with Remark exactly as entered

  # Ref: FRD 5.2 FB-3; FRD 5.2 F-Save
  @TC_SP_036 @Functional @Medium @Automation
  Scenario: Verify Save is always enabled and runs validations when form is empty
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | (empty) |
      | Name | (empty) |
    When the user clicks 'Add'
    And the user observes the Save button state
    And the user clicks Save without entering data
    Then Save button is enabled when the pop-up opens
    And Clicking Save shows field-level errors and does not create an entry

  # Ref: FRD 5.2 FB-8; FRD 5.2 F-Save
  @TC_SP_037 @Functional @High @Automation
  Scenario: Verify Save is disabled while a save request is in progress and double click creates one record
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Network is throttled so that the save request takes about 3 seconds
    And the following test data is used
      | Code | DBL1         |
      | Name | Double Click |
    When the user clicks 'Add'
    And the user enters Code 'DBL1' and Name 'Double Click'
    And the user double-clicks Save
    And the user observes Save state and count the entries named 'Double Click'
    Then Save is disabled while the request is in progress
    And Exactly one entry 'DBL1' is created

  # Ref: FRD 5.2 FB-7; FRD 5.2 F-Cancel
  @TC_SP_038 @Functional @High @Automation
  Scenario: Verify clicking Cancel closes the Add pop-up without creating a record or audit entry
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Prof.     |
      | Name | Professor |
    When the user clicks 'Add'
    And the user enters Code 'Prof.' and Name 'Professor'
    And the user clicks Cancel
    And the user checks the list and the Activity Log
    Then Pop-up closes
    And No entry 'Prof.' is created and no Activity Log entry exists

  # Ref: FRD 5.2 FB-7
  @TC_SP_039 @Functional @Medium @Automation
  Scenario: Verify clicking the close (X) icon closes the Add pop-up without saving
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Prof.     |
      | Name | Professor |
    When the user clicks 'Add'
    And the user enters Code 'Prof.' and Name 'Professor'
    And the user clicks the close (X) icon
    And the user checks the list
    Then Pop-up closes and no entry 'Prof.' is created

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-3; FRD 7 E-1
  @TC_SP_181 @Negative @High @Automation
  Scenario: Verify Code blank shows 'Code is required.'
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | (empty)   |
      | Name | Professor |
    When the user clicks 'Add'
    And the user leaves Code empty and enter Name 'Professor'
    And the user clicks Save
    Then Field-level error 'Code is required.' is shown below Code
    And Pop-up stays open and no entry is created

  # Ref: US-2 AC-3; FRD 5.2 BR-2
  @TC_SP_182 @Negative @High @Automation
  Scenario: Verify Code with only spaces shows 'Code is required.'
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | 5 spaces  |
      | Name | Professor |
    When the user clicks 'Add'
    And the user enters Code ' ' and Name 'Professor'
    And the user clicks Save
    Then Field-level error 'Code is required.' is shown below Code

  # Ref: US-2 AC-4; FRD 7 E-4
  @TC_SP_183 @Negative @High @Automation
  Scenario: Verify Name blank shows 'Name is required.'
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Prof.   |
      | Name | (empty) |
    When the user clicks 'Add'
    And the user enters Code 'Prof.' and leave Name empty
    And the user clicks Save
    Then Field-level error 'Name is required.' is shown below Name
    And Pop-up stays open and no entry is created

  # Ref: US-2 AC-4; FRD 5.2 BR-2
  @TC_SP_184 @Negative @High @Automation
  Scenario: Verify Name with only spaces shows 'Name is required.'
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Prof.    |
      | Name | 5 spaces |
    When the user clicks 'Add'
    And the user enters Code 'Prof.' and Name ' '
    And the user clicks Save
    Then Field-level error 'Name is required.' is shown below Name

  # Ref: US-2 AC-5; FRD 5.2 FB-4
  @TC_SP_185 @Negative @High @Automation
  Scenario: Verify both mandatory errors are shown at the same time when Code and Name are empty
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | (empty) |
      | Name | (empty) |
    When the user clicks 'Add'
    And the user leaves Code and Name empty
    And the user clicks Save
    Then 'Code is required.' and 'Name is required.' are displayed together below their fields

  # Ref: US-2 AC-6; FRD 7 E-2
  @TC_SP_186 @Negative @High @Automation
  Scenario: Verify Code with a space between characters shows 'Code must not contain spaces.'
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Dr Prof          |
      | Name | Doctor Professor |
    When the user clicks 'Add'
    And the user enters Code 'Dr Prof' and Name 'Doctor Professor'
    And the user clicks Save
    Then Field-level error 'Code must not contain spaces.' is shown below Code and no entry is created

  # Ref: FRD 5.2 BR-4; FRD 7 E-2
  @TC_SP_187 @Negative @Medium @Automation
  Scenario: Verify Code with a space still inside after trimming shows the error
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | ' Dr Prof ' |
    When the user clicks 'Add'
    And the user enters Code ' Dr Prof ' and Name 'Doctor Professor'
    And the user clicks Save
    Then Field-level error 'Code must not contain spaces.' is shown (outer spaces removed, inner space remains)

  # Ref: FRD 5.2 F-Code; FRD 7 E-2
  @TC_SP_188 @Negative @Medium @Automation
  Scenario: Verify Code with multiple consecutive internal spaces shows the error
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | 'Dr Prof' (3 spaces) |
    When the user clicks 'Add'
    And the user enters Code 'Dr Prof' and Name 'Doctor Professor'
    And the user clicks Save
    Then Field-level error 'Code must not contain spaces.' is shown

  # Ref: US-2 AC-7; FRD 5.2 BR-5; FRD 7 E-3
  @TC_SP_189 @Negative @High @Automation
  Scenario: Verify duplicate Code with different case and surrounding spaces is rejected
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | ' mr. ' (existing: Mr.) |
      | Name | Mister Two              |
    When the user clicks 'Add'
    And the user enters Code ' mr. ' and Name 'Mister Two'
    And the user clicks Save
    Then Field-level error 'A Specialization Entry with this code already exists for this field.' is shown below Code
    And Pop-up stays open and no entry is created

  # Ref: FRD 5.2 BR-5; FRD 7 E-3
  @TC_SP_190 @Negative @High @Automation
  Scenario: Verify duplicate Code with exact same case is rejected
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Dr. (existing: Dr.) |
      | Name | Doctor Two          |
    When the user clicks 'Add'
    And the user enters Code 'Dr.' and Name 'Doctor Two'
    And the user clicks Save
    Then Field-level error 'A Specialization Entry with this code already exists for this field.' is shown below Code

  # Ref: US-2 AC-8; FRD 5.2 BR-6; FRD 7 E-5
  @TC_SP_191 @Negative @High @Automation
  Scenario: Verify duplicate Name with different case is rejected
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | MS9                   |
      | Name | MISS (existing: Miss) |
    When the user clicks 'Add'
    And the user enters Code 'MS9' and Name 'MISS'
    And the user clicks Save
    Then Field-level error 'A Specialization Entry with this name already exists for this field.' is shown below Name
    And Pop-up stays open and no entry is created

  # Ref: FRD 5.2 BR-6; FRD 5.2 BR-3
  @TC_SP_192 @Negative @High @Automation
  Scenario: Verify duplicate Name with surrounding spaces is rejected
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | MS8      |
      | Name | ' Miss ' |
    When the user clicks 'Add'
    And the user enters Code 'MS8' and Name ' Miss '
    And the user clicks Save
    Then Field-level error 'A Specialization Entry with this name already exists for this field.' is shown below Name

  # Ref: FRD 5.2 BR-6; FRD 5.2 BR-3; FRD 7 E-5
  @TC_SP_193 @Negative @Medium @Automation
  Scenario: Verify duplicate Name is detected after repeated internal spaces are reduced
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry Code 'AP', Name 'Assistant Professor' exists in 'List of Title'
    And the following test data is used
      | Code | AP3                              |
      | Name | 'assistant professor' (5 spaces) |
    When the user clicks 'Add'
    And the user enters Code 'AP3' and Name 'assistant professor'
    And the user clicks Save
    Then Field-level error 'A Specialization Entry with this name already exists for this field.' is shown below Name

  # Ref: FRD 5.2 FB-4
  @TC_SP_194 @Negative @High @Automation
  Scenario: Verify the pop-up stays open with entered values retained when validation fails
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code   | Dr Prof          |
      | Name   | Doctor Professor |
      | Remark | Test remark      |
    When the user clicks 'Add'
    And the user enters Code 'Dr Prof', Name 'Doctor Professor' and Remark 'Test remark'
    And the user clicks Save
    And the user observes the pop-up values
    Then Pop-up remains open and Code, Name and Remark still contain the entered values

  # Ref: FRD 5.2 FB-4
  @TC_SP_195 @Negative @Medium @Automation
  Scenario: Verify the cursor moves to the first failing field
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | (empty)   |
      | Name | Professor |
    When the user clicks 'Add'
    And the user enters Name 'Professor' and leave Code empty
    And the user clicks Save
    And the user observes the cursor
    Then Cursor is placed in Code (first failing field)

  # Ref: FRD 5.2 FB-4
  @TC_SP_196 @Negative @Medium @Automation
  Scenario: Verify the cursor moves to Name when only Name fails
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Prof.   |
      | Name | (empty) |
    When the user clicks 'Add'
    And the user enters Code 'Prof.' and leave Name empty
    And the user clicks Save
    And the user observes the cursor
    Then Cursor is placed in Name

  # Ref: FRD 5.2 FB-4; FRD 7 T-ONLY
  @TC_SP_197 @Negative @High @Automation
  Scenario: Verify no toaster is displayed for any validation failure
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | (empty) |
      | Name | (empty) |
    When the user clicks 'Add'
    And the user clicks Save with Code and Name empty
    And the user observes the screen for 6 seconds
    Then Only field-level errors are shown; no toaster appears

  # Ref: FRD 5.2 FB-6
  @TC_SP_198 @Negative @Medium @Automation
  Scenario: Verify a field-level error clears as soon as the user corrects the value
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Prof. |
    When the user clicks 'Add'
    And the user clicks Save with Code empty to show 'Code is required.'
    And the user types 'Prof.' in Code
    Then The 'Code is required.' error and red border disappear on correction, before saving

  # Ref: FRD 5.2 FB-3
  @TC_SP_199 @Negative @Medium @Automation
  Scenario: Verify screen-level checks run before server duplicate checks
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Dr Prof |
      | Name | Miss    |
    When the user clicks 'Add'
    And the user enters Code 'Dr Prof' (contains a space) and Name 'Miss' (duplicate)
    And the user clicks Save
    Then 'Code must not contain spaces.' is displayed
    And Server duplicate-name error is not displayed because screen-level checks fail first

  # Ref: FRD 5.2 F-Code
  @TC_SP_200 @Negative @High @Automation
  Scenario: Verify Code typing stops at 20 characters
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed | ABCDEFGHIJKLMNOPQRSTU (21) |
    When the user clicks 'Add'
    And the user types a 21-character string in Code
    And the user reads the Code value
    Then Code contains only the first 20 characters 'ABCDEFGHIJKLMNOPQRST'

  # Ref: FRD 5.2 F-Code
  @TC_SP_201 @Negative @High @Automation
  Scenario: Verify pasted Code text is cut at 20 characters
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pasted | ABCDEFGHIJKLMNOPQRSTUVWXY (25) |
    When the user clicks 'Add'
    And the user pastes a 25-character string in Code
    And the user reads the Code value
    Then Code contains only the first 20 characters

  # Ref: FRD 5.2 F-Name
  @TC_SP_202 @Negative @High @Automation
  Scenario: Verify Name typing stops at 100 characters
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed | 'N' repeated 101 times |
    When the user clicks 'Add'
    And the user types a 101-character string in Name
    And the user reads the Name length
    Then Name contains 100 characters

  # Ref: FRD 5.2 F-Name
  @TC_SP_203 @Negative @High @Automation
  Scenario: Verify pasted Name text is cut at 100 characters
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pasted | 'N' repeated 120 times |
    When the user clicks 'Add'
    And the user pastes a 120-character string in Name
    And the user reads the Name length
    Then Name contains 100 characters

  # Ref: FRD 5.2 F-Remark
  @TC_SP_204 @Negative @High @Automation
  Scenario: Verify Remark typing stops at 250 characters
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed | 'R' repeated 251 times |
    When the user clicks 'Add'
    And the user types a 251-character string in Remark
    And the user reads the Remark length
    Then Remark contains 250 characters

  # Ref: FRD 5.2 F-Remark
  @TC_SP_205 @Negative @High @Automation
  Scenario: Verify pasted Remark text is cut at 250 characters
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pasted | 'R' repeated 300 times |
    When the user clicks 'Add'
    And the user pastes a 300-character string in Remark
    And the user reads the Remark length
    Then Remark contains 250 characters

  # Ref: FRD 5.2 BR-8
  @TC_SP_206 @Negative @High @Automation
  Scenario: Verify script text in Code, Name and Remark is stored and shown as plain text
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code   | <b>x</b>                     |
      | Name   | <script>alert(1)</script>    |
      | Remark | <img src=x onerror=alert(1)> |
    When the user clicks 'Add'
    And the user enters Code '<b>x</b>', Name '<script>alert(1)</script>' and Remark '<img src=x onerror=alert(1)>'
    And the user clicks Save
    And the user opens the list and View
    Then Entry is saved and values are displayed as plain text in the list and View pop-up; no script executes and no alert appears

  # Ref: FRD 5.2 BR-8
  @TC_SP_207 @Negative @High @Automation
  Scenario: Verify special characters < > & " ' are displayed as plain text
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | S<>&"'                |
      | Name | A < B > C & D "E" 'F' |
    When the user clicks 'Add'
    And the user enters Code 'S<>&"'' and Name 'A < B > C & D "E" 'F''
    And the user clicks Save
    And the user observes the list
    Then Values are displayed exactly as entered with no HTML interpretation or encoding artefacts

  # Ref: FRD 5.2 BR-8
  @TC_SP_208 @Negative @High @Automation
  Scenario: Verify SQL injection text is stored as literal text
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | SQL1                             |
      | Name | x'; DROP TABLE Specialization;-- |
    When the user clicks 'Add'
    And the user enters Code 'SQL1' and Name "x'; DROP TABLE Specialization;--"
    And the user clicks Save
    And the user reloads the screen
    Then Entry is saved with the literal text and the list still loads normally (parameterized queries)

  # Ref: FRD 5.2 BR-8; FRD 5.2 BR-2
  @TC_SP_209 @Negative @High @Automation
  Scenario: Verify the server rejects a create request with blank Code
    Given API client authenticated as Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | Misc Type List of Title, Code '', Name Professor |
    When the user sends a create request with blank Code
    And the user checks the stored records
    Then Request is rejected and no entry is created (server-side validation)

  # Ref: FRD 5.2 BR-8; FRD 5.2 BR-4
  @TC_SP_210 @Negative @High @Automation
  Scenario: Verify the server rejects a create request with a Code containing a space
    Given API client authenticated as Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | Misc Type List of Title, Code 'Dr Prof', Name Professor |
    When the user sends a create request with a Code containing a space
    And the user checks the stored records
    Then Request is rejected and no entry is created

  # Ref: FRD 5.2 BR-8; FRD 5.2 F-Code
  @TC_SP_211 @Negative @High @Automation
  Scenario: Verify the server rejects a create request with a Code longer than 20 characters
    Given API client authenticated as Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | Code ABCDEFGHIJKLMNOPQRSTU (21), Name Long Code |
    When the user sends a create request with a 21-character Code
    And the user checks the stored records
    Then Request is rejected and no entry is created

  # Ref: FRD 5.2 BR-8; FRD 5.2 F-Name
  @TC_SP_212 @Negative @High @Automation
  Scenario: Verify the server rejects a create request with a Name longer than 100 characters
    Given API client authenticated as Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | Code LN101, Name 'N' repeated 101 times |
    When the user sends a create request with a 101-character Name
    And the user checks the stored records
    Then Request is rejected and no entry is created

  # Ref: FRD 5.2 BR-8; FRD 5.2 F-Remark
  @TC_SP_213 @Negative @High @Automation
  Scenario: Verify the server rejects a create request with a Remark longer than 250 characters
    Given API client authenticated as Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | Code LR251, Name Long Remark, Remark 'R' repeated 251 times |
    When the user sends a create request with a 251-character Remark
    And the user checks the stored records
    Then Request is rejected and no entry is created

  # Ref: FRD 5.2 BR-8; FRD 5.2 BR-5
  @TC_SP_214 @Negative @High @Automation
  Scenario: Verify the server rejects a duplicate Code in the same Misc Type regardless of case
    Given API client authenticated as Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | Misc Type List of Title, Code MR., Name Mister Three |
    When the user sends a create request with an existing Code in a different case
    And the user checks the stored records
    Then Request is rejected and only one entry with Code 'Mr.' exists

  # Ref: FRD 5.2 BR-8; FRD 5.2 BR-6
  @TC_SP_215 @Negative @High @Automation
  Scenario: Verify the server rejects a duplicate Name in the same Misc Type regardless of case
    Given API client authenticated as Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | Misc Type List of Title, Code MS7, Name MISS |
    When the user sends a create request with an existing Name in a different case
    And the user checks the stored records
    Then Request is rejected and only one entry with Name 'Miss' exists

  # Ref: FRD 5.5 BR-1; FRD 5.2 BR-1
  @TC_SP_216 @Negative @High @Automation
  Scenario: Verify the Misc Type of an existing entry cannot be changed via API
    Given API client authenticated as Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row           | Mr.           |
      | New Misc Type | List of Grade |
    When the user sends an update request for 'Mr.' that sets the Misc Type to 'List of Grade'
    And the user reads the entry
    Then Misc Type of 'Mr.' remains 'List of Title'
