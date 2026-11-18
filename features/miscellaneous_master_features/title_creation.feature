@MiscellaneousMaster @TitleCreation
Feature: Title Creation
  Automated scenarios for the "Title Creation" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.2 FB-1; FRD 5.2 FB-2
  @TC_MM_013 @Functional @Medium @Automation
  Scenario: Verify clicking Add opens the Add Title pop-up with the cursor in Field Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1 |
    When the user clicks 'Add' on the Title List
    And the user observes the pop-up and the cursor position
    Then 'Add Title' form opens as a pop-up over the Title List
    And The cursor is placed in the Field Title box

  # Ref: Section 4 AC-AD-1; FRD 5.2 FB-6; FRD Sec 7 Toaster #1; FRD 5.2 BR-1
  @TC_MM_014 @Functional @High @Automation
  Scenario: Verify a Title is created with only the mandatory Field Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title  | Contractor Category |
      | Parent Title | none                |
      | Enum ID      | blank               |
      | Display      | unchecked           |
    When the user clicks 'Add'
    And the user enters Field Title
    And the user clicks Save
    Then Title is saved, the form closes and toaster 'Title added successfully.' is displayed
    And 'Contractor Category' is shown in the Title List

  # Ref: FRD 5.2 FB-6; FRD 5.3 FB-1
  @TC_MM_015 @Functional @Medium @Automation
  Scenario: Verify the new Title is shown as the last record of the list
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title     | Contractor Category |
      | Existing Titles | 18                  |
    When the user clicks 'Add'
    And the user enters Field Title and click Save
    And the user goes to the last page and observe the last row
    Then 'Contractor Category' is the last row with Sl. No. 19 (creation order, oldest first)

  # Ref: Section 4 AC-AD-4; FRD 5.2 BR-5; FRD 5.2 F-EN
  @TC_MM_016 @Functional @High @Automation
  Scenario: Verify a Title saved with a blank Enum ID has an empty Enum ID and none is generated
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | blank               |
    When the user clicks 'Add'
    And the user enters Field Title and leave Enum ID blank
    And the user clicks Save
    And the user observes the Enum ID column of the new row
    Then Title is saved with an empty Enum ID
    And The Enum ID column of the new row is blank; the system does not generate an Enum ID

  # Ref: Section 4 AC-PT-3; FRD 5.2 F-PT
  @TC_MM_017 @Functional @Medium @Automation
  Scenario: Verify a Title saved without a Parent Title shows a blank Parent Title column
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title  | Contractor Category       |
      | Parent Title | -- Select Parent Title -- |
    When the user clicks 'Add'
    And the user enters Field Title and leave Parent Title as '-- Select Parent Title --'
    And the user clicks Save
    And the user observes the Parent Title column of the new row
    Then The Parent Title column of the new row is blank

  # Ref: FRD 5.2 FB-6; Section 4 AC-AD-1; FRD Sec 7 Toaster #1
  @TC_MM_018 @Functional @High @Automation
  Scenario: Verify a Title is created with all fields populated
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title  | Vendor Rating Scale |
      | Parent Title | List of Firm Type   |
      | Enum ID      | 401                 |
      | Display      | checked             |
    When the user clicks 'Add'
    And the user enters Field Title, select Parent Title, enter Enum ID and check Display
    And the user clicks Save
    And the user observes the new row
    Then Toaster 'Title added successfully.' is displayed
    And New row shows Enum ID 401, Title 'Vendor Rating Scale', Parent Title 'List of Firm Type' and Display checked

  # Ref: Section 4 AC-AD-5; FRD 5.7 FB-3
  @TC_MM_019 @Functional @High @Automation
  Scenario: Verify a Title created with an Enum ID is shown on the form linked to that Enum ID
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Vendor Rating Scale |
      | Enum ID     | 401                 |
      | Form        | Vendor Registration |
    When the user clicks 'Add'
    And the user enters Field Title and Enum ID 401 (created in the backend for the 'Vendor Rating' field of the Vendor Registration form) and click Save
    And the user opens the Vendor Registration form
    Then The Title 'Vendor Rating Scale' is shown on the Vendor Registration form field linked to Enum ID 401

  # Ref: Section 4 AC-AD-7; FRD 5.7 FB-2; FRD Fig 1
  @TC_MM_020 @Functional @High @Automation
  Scenario: Verify a Title created with Display checked is available in the Specialization Master
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Display     | checked             |
    When the user clicks 'Add'
    And the user enters Field Title, check Display and click Save
    And the user opens Specialization Master
    Then 'Contractor Category' is available in Specialization Master for configuration and adding values, without any further configuration

  # Ref: FRD 5.2 BR-8; FRD 5.2 F-DS; FRD 5.7 FB-1
  @TC_MM_021 @Functional @High @Automation
  Scenario: Verify Display is unchecked by default and a Title saved unchecked is not available in the Specialization Master
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Display     | default             |
    When the user clicks 'Add' and observe the Display checkbox
    And the user enters Field Title and click Save without touching Display
    And the user opens Specialization Master
    Then Display is unchecked on the Add form
    And The saved Title has Display unchecked and is not listed in Specialization Master

  # Ref: FRD 5.2 F-PT; FRD 5.3 C-PA
  @TC_MM_022 @Functional @Medium @Automation
  Scenario: Verify the selected Parent Title is saved and displayed in the Parent Title column
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title  | Firm Sub Type     |
      | Parent Title | List of Firm Type |
    When the user clicks 'Add'
    And the user enters Field Title and select Parent Title
    And the user clicks Save
    And the user observes the Parent Title column
    Then The new row shows Parent Title 'List of Firm Type'

  # Ref: Section 4 AC-AD-8; FRD 5.2 BR-7
  @TC_MM_023 @Functional @High @Automation
  Scenario: Verify Field Title with special characters is saved exactly as entered and displayed as plain text
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Site/Plant #1 (Main) - <A&B> |
    When the user clicks 'Add'
    And the user enters Field Title containing special characters
    And the user clicks Save
    And the user observes the new row and open it in View
    Then Title is saved exactly as 'Site/Plant #1 (Main) - <A&B>'
    And It is displayed as plain text in the list and in View

  # Ref: FRD 5.2 BR-10
  @TC_MM_024 @Functional @High @Automation
  Scenario: Verify a script tag in Field Title is stored as text, HTML-encoded on display and never executed
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | <script>alert('x')</script> " ' & > |
    When the user clicks 'Add'
    And the user enters Field Title with a script tag
    And the user clicks Save
    And the user observes the list, View pop-up and Edit pop-up
    Then Title is saved exactly as entered
    And It is displayed as plain text everywhere; no alert is raised and no script is executed

  # Ref: FRD 5.2 BR-10; FRD 5.2 BR-7
  @TC_MM_025 @Functional @High @Automation
  Scenario: Verify special SQL-like text in Field Title is stored as plain data (parameterized storage)
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Robert'); DROP TABLE Titles;-- |
    When the user clicks 'Add'
    And the user enters Field Title with SQL-like text
    And the user clicks Save
    And the user reloads the Title List
    Then Title is saved exactly as entered
    And All other Titles remain in the list; no data is lost or altered

  # Ref: FRD 5.2 BR-2
  @TC_MM_026 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces in Field Title are removed on save
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | ' Contractor Grade ' |
    When the user clicks 'Add'
    And the user enters Field Title with leading and trailing spaces
    And the user clicks Save
    And the user opens the new Title in View
    Then Title is saved as 'Contractor Grade' without leading or trailing spaces

  # Ref: FRD 5.2 BR-2
  @TC_MM_027 @Functional @Medium @Automation
  Scenario: Verify repeated internal spaces in Field Title are reduced to one space on save
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | 'Contractor Grade Level' |
    When the user clicks 'Add'
    And the user enters Field Title with runs of internal spaces
    And the user clicks Save
    And the user opens the new Title in View
    Then Title is saved as 'Contractor Grade Level'

  # Ref: FRD 5.2 BR-4
  @TC_MM_028 @Functional @Medium @Automation
  Scenario: Verify Field Title is saved with the letter case exactly as entered
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | cOnTrAcToR cLaSs |
    When the user clicks 'Add'
    And the user enters Field Title in mixed case
    And the user clicks Save
    And the user observes the new row
    Then Title is saved and displayed as 'cOnTrAcToR cLaSs' (no case conversion)

  # Ref: FRD 5.2 F-FT; FRD 5.2 BR-7
  @TC_MM_029 @Functional @High @Automation
  Scenario: Verify Field Title of exactly 100 characters is accepted
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | 'A' x 100 characters (e.g., AAAA...A, 100 chars) |
    When the user clicks 'Add'
    And the user enters a Field Title of exactly 100 characters
    And the user clicks Save
    Then Title is saved; toaster 'Title added successfully.' is displayed
    And The full 100 characters are shown in the list (wrapped)

  # Ref: FRD 5.2 F-FT; FRD 5.2 BR-1
  @TC_MM_030 @Functional @Medium @Automation
  Scenario: Verify Field Title of 1 character is accepted
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Z |
    When the user clicks 'Add'
    And the user enters a Field Title of 1 character
    And the user clicks Save
    Then Title 'Z' is saved; toaster 'Title added successfully.' is displayed

  # Ref: FRD 5.2 BR-6; FRD 5.2 F-EN
  @TC_MM_031 @Functional @Medium @Automation
  Scenario: Verify Enum ID entered by the user is saved as entered
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 501                 |
    When the user clicks 'Add'
    And the user enters Field Title and Enum ID
    And the user clicks Save
    And the user observes the Enum ID column
    Then Title is saved with Enum ID 501 and the column shows 501

  # Ref: FRD 5.2 F-EN; FRD 5.2 FB-6
  @TC_MM_032 @Functional @Medium @Automation
  Scenario: Verify leading zeros are removed from Enum ID before saving
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 0012                |
    When the user clicks 'Add'
    And the user enters Field Title and Enum ID with leading zeros
    And the user clicks Save
    And the user observes the Enum ID column
    Then Title is saved with Enum ID 12 (not 0012)

  # Ref: FRD 5.2 BR-6; FRD 5.2 F-EN
  @TC_MM_033 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces are removed from Enum ID before validation
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | ' 502 '             |
    When the user clicks 'Add'
    And the user enters Field Title and Enum ID surrounded by spaces
    And the user clicks Save
    And the user observes the Enum ID column
    Then Title is saved with Enum ID 502

  # Ref: FRD 5.2 F-EN
  @TC_MM_034 @Functional @Medium @Automation
  Scenario: Verify minimum valid Enum ID 1 is accepted
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 1                   |
    When the user clicks 'Add'
    And the user enters Field Title and Enum ID 1
    And the user clicks Save
    Then Title is saved with Enum ID 1

  # Ref: FRD 5.2 F-EN
  @TC_MM_035 @Functional @Medium @Automation
  Scenario: Verify maximum length Enum ID of 10 digits is accepted
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 9999999999          |
    When the user clicks 'Add'
    And the user enters Field Title and a 10-digit Enum ID
    And the user clicks Save
    Then Title is saved with Enum ID 9999999999 (Assumption A-6: no numeric overflow)

  # Ref: FRD 5.2 F-EN
  @TC_MM_036 @Functional @Medium @Automation
  Scenario: Verify a 10-character Enum ID with leading zeros is saved without the zeros
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 0000000503          |
    When the user clicks 'Add'
    And the user enters Field Title and a 10-character Enum ID padded with zeros
    And the user clicks Save
    Then Title is saved with Enum ID 503

  # Ref: FRD 5.2 BR-9; FRD 5.2 FB-6
  @TC_MM_037 @Functional @High @Automation
  Scenario: Verify a unique Internal ID is created for each new Title and is not displayed on any screen
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Titles | Contractor Category, Contractor Grade |
    When the user creates Title 'Contractor Category'
    And the user creates Title 'Contractor Grade'
    And the user queries the Title store for both Internal IDs
    And the user inspects list, Add, View and Edit screens for an Internal ID
    Then Each Title has a distinct, system-generated Internal ID
    And The Internal ID is not shown on any screen and cannot be entered or edited

  # Ref: FRD 5.2 FB-6; Section 4 AC-VW-1
  @TC_MM_038 @Functional @Medium @Automation
  Scenario: Verify Created By and Created On are recorded for a new Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Admin_User1         |
      | Field Title | Contractor Category |
    When the user creates Title 'Contractor Category' as Admin_User1
    And the user opens the Title in View
    Then View shows Created By 'Admin_User1' and Created On as the current date-time

  # Ref: FRD 5.2 FB-9; FRD 5.2 F-BT
  @TC_MM_039 @Functional @High @Automation
  Scenario: Verify Save is disabled while a save request is in progress and a double click creates only one record
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
    When the user throttles the save API response by 5 seconds
    And the user clicks 'Add', enter Field Title
    And the user double-clicks Save and observe the button
    And the user waits for completion and search the list
    Then Save is disabled while the request is in progress
    And Exactly one 'Contractor Category' record is created

  # Ref: FRD 5.2 FB-7
  @TC_MM_040 @Functional @Medium @Automation
  Scenario: Verify an inline error is cleared as soon as the value in that field is corrected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
    When the user clicks 'Add' and click Save with Field Title blank
    And the user types 'Contractor Category' in Field Title
    And the user observes the error message and border
    Then 'Field Title is required.' disappears and the red border is removed as soon as the value is corrected

  # Ref: Section 4 AC-PT-1; FRD 5.2 F-PT
  @TC_MM_041 @Functional @High @Automation
  Scenario: Verify the Parent Title dropdown lists a blank option first, followed by every Title in list order across all pages
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset C (120 Titles, see Summary) is loaded
    And the following test data is used
      | Dataset | 120 Titles (see Summary) |
    When the user clicks 'Add'
    And the user opens the Parent Title dropdown
    And the user compares options with the Title List across all pages
    Then First option is the blank '-- Select Parent Title --'
    And All 120 Titles follow in the same order as the Title List (creation order, oldest first), including Titles on pages 2 and 3

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: Section 4 AC-AD-2; FRD 5.2 BR-1; FRD Sec 7 Field Error #1
  @TC_MM_177 @Negative @Medium @Automation
  Scenario: Verify blank Field Title blocks Save with 'Field Title is required.'
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | blank |
    When the user clicks 'Add'
    And the user leaves Field Title blank
    And the user clicks Save
    Then Title is not saved; inline error 'Field Title is required.' is shown below Field Title, the form stays open and no toaster is shown

  # Ref: Section 4 AC-AD-2; FRD 5.2 BR-2; FRD Sec 7 Field Error #1
  @TC_MM_178 @Negative @Medium @Automation
  Scenario: Verify whitespace-only Field Title is treated as blank
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | ' ' (5 spaces) |
    When the user clicks 'Add'
    And the user enters spaces only in Field Title
    And the user clicks Save
    Then Title is not saved; inline error 'Field Title is required.' is displayed

  # Ref: FRD 5.2 BR-3; FRD Sec 7 Field Error #2; FRD 5.2 FB-5
  @TC_MM_179 @Negative @High @Automation
  Scenario: Verify exact-match duplicate Field Title is blocked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | List of Title |
    When the user clicks 'Add'
    And the user enters an existing Title name
    And the user clicks Save
    Then Title is not saved; inline error 'A title with this name already exists.' is shown below Field Title; the form stays open with values retained

  # Ref: FRD 5.2 BR-3; FRD Sec 7 Field Error #2
  @TC_MM_180 @Negative @High @Automation
  Scenario: Verify a lower-case duplicate Field Title is blocked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | list of title |
    When the user clicks 'Add'
    And the user enters an existing Title name in lower case
    And the user clicks Save
    Then Title is not saved; 'A title with this name already exists.' is displayed

  # Ref: FRD 5.2 BR-3; FRD Sec 7 Field Error #2
  @TC_MM_181 @Negative @High @Automation
  Scenario: Verify an upper-case duplicate Field Title is blocked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | LIST OF TITLE |
    When the user clicks 'Add'
    And the user enters an existing Title name in upper case
    And the user clicks Save
    Then Title is not saved; 'A title with this name already exists.' is displayed

  # Ref: Section 4 AC-AD-3; FRD 5.2 BR-2; FRD Sec 7 Field Error #2
  @TC_MM_182 @Negative @High @Automation
  Scenario: Verify a duplicate Field Title with different case and leading/trailing spaces is blocked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | ' list of title ' |
    When the user clicks 'Add'
    And the user enters the existing Title in different case with surrounding spaces
    And the user clicks Save
    Then Title is not saved; 'A title with this name already exists.' is displayed

  # Ref: FRD 5.2 BR-2; FRD 5.2 BR-3; FRD Sec 7 Field Error #2
  @TC_MM_183 @Negative @High @Automation
  Scenario: Verify a duplicate Field Title with repeated internal spaces is blocked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | 'List of Title' |
    When the user clicks 'Add'
    And the user enters the existing Title with repeated internal spaces
    And the user clicks Save
    Then Title is not saved; 'A title with this name already exists.' is displayed (internal spaces reduced to one before the duplicate check)

  # Ref: FRD 5.2 BR-3; FRD Sec 7 Field Error #2
  @TC_MM_184 @Negative @Medium @Automation
  Scenario: Verify a Field Title that duplicates a Title on another list page is blocked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Pagination Dataset C (120 Titles, see Summary) is loaded
    And the following test data is used
      | Data        | Dataset C      |
      | Field Title | Bulk Title 070 |
    When the user clicks 'Add'
    And the user enters the name of a Title that is on page 3 of the list
    And the user clicks Save
    Then Title is not saved; 'A title with this name already exists.' is displayed (uniqueness is checked across the whole Master)

  # Ref: FRD 5.2 F-FT; FRD 5.2 BR-10
  @TC_MM_185 @Negative @High @Automation
  Scenario: Verify Field Title cannot exceed 100 characters from the server side
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Admin_User1 |
      | Field Title | 'A' x 101   |
    When the user sends a create-Title request with a 101-character Field Title
    Then Request is rejected (Assumption A-5); no Title is created

  # Ref: FRD 5.2 BR-10; FRD 5.2 BR-1
  @TC_MM_186 @Negative @High @Automation
  Scenario: Verify the server rejects a blank Field Title sent directly through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Admin_User1 |
      | Field Title | ''          |
    When the user sends a create-Title request with a blank Field Title
    Then Request is rejected; no Title is created (server-side validation in addition to the screen)

  # Ref: FRD 5.2 BR-10; FRD 5.2 F-EN
  @TC_MM_187 @Negative @High @Automation
  Scenario: Verify the server rejects a non-numeric Enum ID sent directly through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Admin_User1         |
      | Field Title | Contractor Category |
      | Enum ID     | abc                 |
    When the user sends a create-Title request with a non-numeric Enum ID
    Then Request is rejected; no Title is created

  # Ref: FRD 5.2 F-EN; FRD 5.2 BR-10
  @TC_MM_188 @Negative @High @Automation
  Scenario: Verify the server rejects an Enum ID longer than 10 characters sent directly through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Admin_User1         |
      | Field Title | Contractor Category |
      | Enum ID     | 12345678901         |
    When the user sends a create-Title request with an 11-digit Enum ID
    Then Request is rejected (Assumption A-5); no Title is created

  # Ref: FRD 5.2 F-PT; FRD 5.2 BR-10
  @TC_MM_189 @Negative @Medium @Automation
  Scenario: Verify the server rejects a Parent Title reference that does not exist
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User                     | Admin_User1         |
      | Field Title              | Contractor Category |
      | Parent Title Internal ID | 99999999            |
    When the user sends a create-Title request with a non-existent Parent Title Internal ID
    Then Request is rejected (Assumption A-12); no Title is created

  # Ref: FRD 5.2 F-EN; FRD Sec 7 Field Error #3
  @TC_MM_190 @Negative @Medium @Automation
  Scenario: Verify Enum ID with letters is rejected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | abc                 |
    When the user clicks 'Add'
    And the user enters Field Title
    And the user enters the Enum ID
    And the user clicks Save
    Then Title is not saved; inline error 'Enum ID must be a whole number greater than 0.' is shown below Enum ID; the form stays open

  # Ref: FRD 5.2 F-EN; FRD Sec 7 Field Error #3
  @TC_MM_191 @Negative @Medium @Automation
  Scenario: Verify Enum ID with letters mixed with digits is rejected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 12a                 |
    When the user clicks 'Add'
    And the user enters Field Title
    And the user enters the Enum ID
    And the user clicks Save
    Then Title is not saved; inline error 'Enum ID must be a whole number greater than 0.' is shown below Enum ID; the form stays open

  # Ref: FRD 5.2 F-EN; FRD Sec 7 Field Error #3
  @TC_MM_192 @Negative @Medium @Automation
  Scenario: Verify Enum ID with a decimal point is rejected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 1.5                 |
    When the user clicks 'Add'
    And the user enters Field Title
    And the user enters the Enum ID
    And the user clicks Save
    Then Title is not saved; inline error 'Enum ID must be a whole number greater than 0.' is shown below Enum ID; the form stays open

  # Ref: FRD 5.2 F-EN; FRD Sec 7 Field Error #3
  @TC_MM_193 @Negative @Medium @Automation
  Scenario: Verify Enum ID with a minus sign is rejected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | -5                  |
    When the user clicks 'Add'
    And the user enters Field Title
    And the user enters the Enum ID
    And the user clicks Save
    Then Title is not saved; inline error 'Enum ID must be a whole number greater than 0.' is shown below Enum ID; the form stays open

  # Ref: FRD 5.2 F-EN; FRD Sec 7 Field Error #3
  @TC_MM_194 @Negative @Medium @Automation
  Scenario: Verify Enum ID with a plus sign is rejected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | +5                  |
    When the user clicks 'Add'
    And the user enters Field Title
    And the user enters the Enum ID
    And the user clicks Save
    Then Title is not saved; inline error 'Enum ID must be a whole number greater than 0.' is shown below Enum ID; the form stays open

  # Ref: FRD 5.2 F-EN; FRD Sec 7 Field Error #3
  @TC_MM_195 @Negative @Medium @Automation
  Scenario: Verify Enum ID with an inner space is rejected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 1 2                 |
    When the user clicks 'Add'
    And the user enters Field Title
    And the user enters the Enum ID
    And the user clicks Save
    Then Title is not saved; inline error 'Enum ID must be a whole number greater than 0.' is shown below Enum ID; the form stays open

  # Ref: FRD 5.2 F-EN; FRD Sec 7 Field Error #3
  @TC_MM_196 @Negative @Medium @Automation
  Scenario: Verify Enum ID with a special character is rejected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 12#                 |
    When the user clicks 'Add'
    And the user enters Field Title
    And the user enters the Enum ID
    And the user clicks Save
    Then Title is not saved; inline error 'Enum ID must be a whole number greater than 0.' is shown below Enum ID; the form stays open

  # Ref: FRD 5.2 F-EN; FRD Sec 7 Field Error #3
  @TC_MM_197 @Negative @Medium @Automation
  Scenario: Verify Enum ID 0 is rejected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 0                   |
    When the user clicks 'Add'
    And the user enters Field Title and Enum ID 0
    And the user clicks Save
    Then Title is not saved; 'Enum ID must be a whole number greater than 0.' is displayed

  # Ref: FRD 5.2 F-EN; FRD Sec 7 Field Error #3
  @TC_MM_198 @Negative @Medium @Automation
  Scenario: Verify Enum ID of only zeros is rejected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 000                 |
    When the user clicks 'Add'
    And the user enters Field Title and Enum ID 000
    And the user clicks Save
    Then Title is not saved; 'Enum ID must be a whole number greater than 0.' is displayed

  # Ref: FRD 5.2 BR-6; FRD 5.2 BR-5
  @TC_MM_199 @Negative @Medium @Automation
  Scenario: Verify a spaces-only Enum ID is treated as blank after trimming
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | ' '                 |
    When the user clicks 'Add'
    And the user enters Field Title and spaces only in Enum ID
    And the user clicks Save
    Then Title is saved with an empty Enum ID (spaces removed, optional field; Assumption A-7)

  # Ref: FRD 5.2 F-EN
  @TC_MM_200 @Negative @Medium @Automation
  Scenario: Verify Enum ID of 11 characters cannot be typed
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum ID typed | 12345678901 |
    When the user clicks 'Add'
    And the user types 11 digits in Enum ID and click Save
    Then Only the first 10 characters '1234567890' remain in the box and are used on save

  # Ref: Section 4 AC-AD-6; FRD 5.2 BR-6; FRD Sec 7 Field Error #4
  @TC_MM_201 @Negative @High @Automation
  Scenario: Verify a duplicate Enum ID is blocked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 101                 |
    When the user clicks 'Add'
    And the user enters Field Title and an Enum ID used by another Title
    And the user clicks Save
    Then Title is not saved; inline error 'Enum ID already exists.' is shown below Enum ID; the form stays open with values retained

  # Ref: FRD 5.2 F-EN; Section 4 AC-AD-6; FRD Sec 7 Field Error #4
  @TC_MM_202 @Negative @High @Automation
  Scenario: Verify a duplicate Enum ID is detected after leading zeros are removed
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | 0101                |
    When the user clicks 'Add'
    And the user enters Field Title and an Enum ID with leading zeros that equals an existing one
    And the user clicks Save
    Then Title is not saved; 'Enum ID already exists.' is displayed

  # Ref: FRD 5.2 BR-6; FRD Sec 7 Field Error #4
  @TC_MM_203 @Negative @High @Automation
  Scenario: Verify a duplicate Enum ID with surrounding spaces is blocked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
      | Enum ID     | ' 101 '             |
    When the user clicks 'Add'
    And the user enters Field Title and an existing Enum ID with leading and trailing spaces
    And the user clicks Save
    Then Title is not saved; 'Enum ID already exists.' is displayed

  # Ref: FRD 5.2 FB-4; FRD Sec 7 Field Error #1; FRD Sec 7 Field Error #3
  @TC_MM_204 @Negative @Medium @Automation
  Scenario: Verify all field-level errors are displayed at the same time
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | blank |
      | Enum ID     | 1.5   |
    When the user clicks 'Add'
    And the user leaves Field Title blank and enter an invalid Enum ID
    And the user clicks Save
    Then Both 'Field Title is required.' and 'Enum ID must be a whole number greater than 0.' are displayed together; the form stays open with entered values retained

  # Ref: FRD 5.2 FB-3
  @TC_MM_205 @Negative @High @Automation
  Scenario: Verify field-level checks run before server-side duplicate checks
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | List of Title |
      | Enum ID     | abc           |
    When the user clicks 'Add'
    And the user enters an existing Title name and an invalid Enum ID
    And the user clicks Save
    Then Only 'Enum ID must be a whole number greater than 0.' is displayed; the duplicate Title check is not reached

  # Ref: FRD 5.2 FB-3; FRD Sec 7 Field Error #2
  @TC_MM_206 @Negative @High @Automation
  Scenario: Verify only the first failing server-side check message is displayed
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | List of Title |
      | Enum ID     | 101           |
    When the user clicks 'Add'
    And the user enters a duplicate Title name and a duplicate Enum ID
    And the user clicks Save
    Then Only 'A title with this name already exists.' is displayed; 'Enum ID already exists.' is not shown

  # Ref: FRD 5.2 FB-5; FRD Sec 7 (Toaster rules)
  @TC_MM_207 @Negative @High @Automation
  Scenario: Verify a server-side validation failure shows no toaster and retains the entered values
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | List of Title |
      | Parent      | Region        |
      | Enum ID     | 501           |
      | Display     | checked       |
    When the user clicks 'Add'
    And the user enters Field Title 'List of Title', Parent 'Region', Enum ID 501, Display checked
    And the user clicks Save
    Then Inline error is shown, no toaster appears, the form stays open and all four entered values are retained

  # Ref: FRD 5.2 FB-8
  @TC_MM_208 @Negative @Medium @Automation
  Scenario: Verify Cancel on the Add Title form saves nothing
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
    When the user clicks 'Add'
    And the user enters Field Title 'Contractor Category'
    And the user clicks Cancel
    And the user searches the list and check the Activity Log
    Then Form closes; no Title is created and no Activity Log entry is written

  # Ref: FRD 5.2 FB-8
  @TC_MM_209 @Negative @Medium @Automation
  Scenario: Verify the close (X) icon on the Add Title form saves nothing
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | Contractor Category |
    When the user clicks 'Add'
    And the user enters Field Title 'Contractor Category'
    And the user clicks the close (X) icon
    And the user searches the list and check the Activity Log
    Then Form closes; no Title is created and no Activity Log entry is written

  # Ref: FRD 6 FB-1; FRD 5.2 FB-5
  @TC_MM_210 @Negative @Medium @Automation
  Scenario: Verify a failed validation does not create an Activity Log entry or a Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | List of Title |
    When the user clicks 'Add'
    And the user enters duplicate Field Title 'List of Title' and click Save
    And the user checks the list and the Activity Log
    Then No new Title and no Activity Log entry are created
