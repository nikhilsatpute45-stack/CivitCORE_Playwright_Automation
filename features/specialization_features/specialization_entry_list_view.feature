@Specialization @SpecializationEntryListView
Feature: Specialization Entry List View
  Automated scenarios for the "Specialization Entry List View" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-5; FRD 5.3 ES-1
  @TC_SP_040 @Functional @High @Automation
  Scenario: Verify the empty state is shown for a Misc Type with no Specialization Entries
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded. 'List of Firm Type' has no Specialization Entries
    And the following test data is used
      | Misc Type | List of Firm Type |
    When the user selects 'List of Firm Type' in the Misc Type dropdown
    And the user observes the screen
    Then Illustration, heading 'No Specialization Entries added yet' and message 'Click Add to add the first Specialization Entry for this field.' are shown with an 'Add' button
    And Misc Type dropdown stays visible

  # Ref: FRD 5.3 ES-1
  @TC_SP_041 @Functional @Medium @Automation
  Scenario: Verify column headers, column search and pagination are hidden on the empty state
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded. 'List of Firm Type' has no Specialization Entries
    And the following test data is used
      | Misc Type | List of Firm Type |
    When the user selects 'List of Firm Type'
    And the user looks for column headers, column search boxes and pagination controls
    Then Column headers, column search boxes and pagination are not displayed

  # Ref: US-1 AC-6; FRD 5.3 ES-2
  @TC_SP_042 @Functional @Medium @Automation
  Scenario: Verify the 'No field types available' state when no Title has Display checked
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And No Title has Display checked in the Miscellaneous Master
    And the following test data is used
      | Miscellaneous Master | Display unchecked for all Titles |
    When the user opens Admin > Configuration > Specialization
    And the user observes the screen
    Then Heading 'No field types available' and message 'Check “Display” for a Title in the Miscellaneous Master to add its Specialization Entries here.' are shown
    And No Misc Type dropdown, list or 'Add' button is displayed

  # Ref: FRD 5.3 FB-3
  @TC_SP_043 @Functional @High @Automation
  Scenario: Verify pagination shows 50 records per page with a page indicator
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Misc Type | List of Qualification (120 entries) |
    When the user selects 'List of Qualification' (120 entries)
    And the user counts the rows on page 1
    And the user reads the page indicator
    Then Page 1 shows 50 rows (Sl. No. 1 to 50)
    And Indicator shows '1 / 3'

  # Ref: FRD 5.3 BR-2; FRD 5.3 FB-3
  @TC_SP_044 @Functional @High @Automation
  Scenario: Verify Sl. No. runs continuously across pages
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Misc Type | List of Qualification (120 entries) |
    When the user selects 'List of Qualification'
    And the user clicks Next to open page 2
    And the user reads the first Sl. No
    And the user clicks Last and read the first Sl. No. and the row count
    Then Page 2 starts at Sl. No. 51
    And Page 3 starts at Sl. No. 101 and shows 20 rows

  # Ref: FRD 5.3 FB-3
  @TC_SP_045 @Functional @Medium @Automation
  Scenario: Verify First and Previous are disabled on page 1
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Page | 1 / 3 |
    When the user selects 'List of Qualification'
    And the user observes First and Previous on page 1
    Then First and Previous are disabled; Next and Last are enabled

  # Ref: FRD 5.3 FB-3
  @TC_SP_046 @Functional @Medium @Automation
  Scenario: Verify Next and Last are disabled on the last page
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Page | 3 / 3 |
    When the user selects 'List of Qualification'
    And the user clicks Last
    And the user observes Next and Last
    Then Indicator shows '3 / 3'
    And Next and Last are disabled; First and Previous are enabled

  # Ref: FRD 5.3 FB-3
  @TC_SP_047 @Functional @Medium @Automation
  Scenario: Verify First, Previous, Next, Last and page number navigation
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Misc Type | List of Qualification (3 pages) |
    When the user clicks Next
    And the user clicks Last
    And the user clicks Previous
    And the user clicks First
    And the user clicks page number 3
    Then Pages shown are 2, 3, 2, 1 and 3 respectively; the indicator updates to match each page

  # Ref: FRD 5.3 FB-3
  @TC_SP_048 @Functional @Medium @Automation
  Scenario: Verify pagination controls are hidden when there are 50 or fewer records
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Grade' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Misc Type | List of Grade (50 entries) |
    When the user selects 'List of Grade' (exactly 50 entries)
    And the user looks for pagination controls
    Then All 50 rows are shown on one page and pagination controls are hidden

  # Ref: FRD 5.3 FB-3
  @TC_SP_049 @Functional @Medium @Automation
  Scenario: Verify pagination controls appear when the record count becomes 51
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Grade' selected
    And Baseline data (see Summary) is loaded. 'List of Grade' has 50 entries
    And the following test data is used
      | Code | G51      |
      | Name | Grade 51 |
    When the user clicks 'Add'
    And the user enters Code 'G51' and Name 'Grade 51'
    And the user clicks Save
    And the user observes pagination
    Then Pagination controls are displayed with indicator '1 / 2'
    And Page 1 shows 50 rows

  # Ref: FRD 5.3 BR-1; US-1 AC-1
  @TC_SP_050 @Functional @High @Automation
  Scenario: Verify the list is available to a user with View permission only
    Given Viewer_User1 (Specialization: View only) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens Admin > Configuration > Specialization
    And the user observes the list
    Then Misc Type dropdown and the Specialization Entry List are displayed

  # Ref: FRD 5.3 FB-2
  @TC_SP_051 @Functional @Medium @Automation
  Scenario: Verify entries are listed in display sequence by default with newest first
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entries 'Adv.' then 'Prof.' were added to 'List of Title' in that order, with no drag and drop
    And the following test data is used
      | Added order | Adv., Prof. |
    When the user opens the list for 'List of Title'
    And the user reads the first two rows
    Then 'Prof.' is Sl. No. 1 and 'Adv.' is Sl. No. 2, followed by the baseline entries

  # Ref: FRD 5.3 FB-8; FRD 5.5 FB-4
  @TC_SP_052 @Functional @Medium @Automation
  Scenario: Verify the list keeps Misc Type, page and column search after Edit
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And Misc Type 'List of Qualification', page 2 and Code search 'Q0'
    And the following test data is used
      | Remark | Updated |
    When the user opens Edit for the first visible row
    And the user changes Remark to 'Updated'
    And the user clicks Save
    And the user observes the list state
    Then Misc Type, current page and Code search 'Q0' are unchanged after the list refreshes

  # Ref: FRD 5.3 FB-8; FRD 5.7 FB-5
  @TC_SP_053 @Functional @Medium @Automation
  Scenario: Verify the list keeps Misc Type, page and column search after Delete
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And Misc Type 'List of Qualification', Code search 'Q1', page 1
    And the following test data is used
      | Entry  | Q100 / Qualification 100 |
      | Search | Q1                       |
    When the user opens Delete for 'Q100'
    And the user clicks Yes in the confirmation dialog
    And the user observes the list state
    Then Misc Type and Code search 'Q1' are retained and the list is refreshed without 'Q100'
