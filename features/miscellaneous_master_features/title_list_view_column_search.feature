@MiscellaneousMaster @TitleListViewColumnSearch
Feature: Title List View / Column Search
  Automated scenarios for the "Title List View / Column Search" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.3 FB-1; FRD 5.3 C-SL
  @TC_MM_042 @Functional @Medium @Automation
  Scenario: Verify the Title List is displayed in creation order, oldest first, with Sl. No. 1 to 18
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Data | Baseline Titles 1-18 |
    When the user opens Miscellaneous Master
    And the user observes the order of rows and Sl. No
    Then Rows appear in creation order starting with 'List of Title'; Sl. No. runs 1 to 18

  # Ref: FRD 5.3 FB-2
  @TC_MM_043 @Functional @Medium @Automation
  Scenario: Verify 50 records are shown per page with the current/total pages indicator
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset C (120 Titles, see Summary) is loaded
    And the following test data is used
      | Dataset C | 120 Titles |
    When the user opens Miscellaneous Master and count rows on page 1
    And the user observes the pagination indicator
    Then Page 1 shows 50 rows
    And Indicator shows '1 / 3'

  # Ref: FRD 5.3 BR-2; FRD 5.3 FB-2
  @TC_MM_044 @Functional @Medium @Automation
  Scenario: Verify Sl. No. continues across pages (page 2 starts at 51)
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset C (120 Titles, see Summary) is loaded
    And the following test data is used
      | Dataset C | 120 Titles |
    When the user clicks Next to open page 2
    And the user observes the first Sl. No
    Then Page 2 shows Sl. No. 51 to 100 (starts at 51); indicator shows '2 / 3'

  # Ref: FRD 5.3 FB-2; FRD 5.3 BR-2
  @TC_MM_045 @Functional @Medium @Automation
  Scenario: Verify the last page shows the remaining 20 records with Sl. No. 101 to 120
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset C (120 Titles, see Summary) is loaded
    And the following test data is used
      | Dataset C | 120 Titles |
    When the user clicks Last
    And the user observes rows and indicator
    Then Page 3 shows 20 rows with Sl. No. 101 to 120; indicator shows '3 / 3'

  # Ref: FRD 5.3 FB-2
  @TC_MM_046 @Functional @Medium @Automation
  Scenario: Verify First and Previous are disabled on page 1
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset C (120 Titles, see Summary) is loaded
    And the following test data is used
      | Dataset C | 120 Titles |
    When the user opens Miscellaneous Master on page 1
    And the user inspects the First and Previous controls
    Then First and Previous are disabled; Next and Last are enabled

  # Ref: FRD 5.3 FB-2
  @TC_MM_047 @Functional @Medium @Automation
  Scenario: Verify Next and Last are disabled on the last page
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset C (120 Titles, see Summary) is loaded
    And the following test data is used
      | Dataset C | 120 Titles |
    When the user clicks Last
    And the user inspects the Next and Last controls
    Then Next and Last are disabled; First and Previous are enabled

  # Ref: FRD 5.3 FB-2
  @TC_MM_048 @Functional @Medium @Automation
  Scenario: Verify the First, Previous, Next, Last and page-number controls navigate correctly
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset C (120 Titles, see Summary) is loaded
    And the following test data is used
      | Dataset C | 120 Titles |
    When the user clicks Next
    And the user clicks page number 3
    And the user clicks Previous
    And the user clicks Last
    And the user clicks First
    Then Pages shown in order 2, 3, 2, 3, 1 with the indicator matching each page

  # Ref: FRD 5.3 FB-2
  @TC_MM_049 @Functional @Medium @Automation
  Scenario: Verify pagination controls are hidden when there are exactly 50 records
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset A (exactly 50 Titles, see Summary) is loaded
    And the following test data is used
      | Dataset A | exactly 50 Titles |
    When the user opens Miscellaneous Master
    Then All 50 rows are displayed on one page and pagination controls are hidden

  # Ref: FRD 5.3 FB-2
  @TC_MM_050 @Functional @Medium @Automation
  Scenario: Verify pagination controls are displayed when there are 51 records
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset B (51 Titles, see Summary) is loaded
    And the following test data is used
      | Dataset B | 51 Titles |
    When the user opens Miscellaneous Master
    And the user observes the pagination area and page 2
    Then Pagination is displayed with indicator '1 / 2'; page 2 contains 1 row with Sl. No. 51

  # Ref: FRD 5.3 FB-4; FRD 5.3 C-TI
  @TC_MM_051 @Functional @Medium @Automation
  Scenario: Verify Title column search matches partial text
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title search | firm |
    When the user types 'firm' in the Title column search box
    Then Only 'List of Firm Type' is displayed

  # Ref: FRD 5.3 FB-4
  @TC_MM_052 @Functional @Medium @Automation
  Scenario: Verify Title column search ignores letter case
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title search | FIRM |
    When the user types 'FIRM' in the Title column search box
    Then Only 'List of Firm Type' is displayed

  # Ref: FRD 5.3 FB-4; FRD 5.3 C-EN
  @TC_MM_053 @Functional @Medium @Automation
  Scenario: Verify Enum ID column search matches partial text
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum ID search | 20 |
    When the user types '20' in the Enum ID column search box
    Then Rows 'Region' (201), 'State' (202) and 'District' (203) are displayed

  # Ref: FRD 5.3 FB-4; FRD 5.3 C-PA
  @TC_MM_054 @Functional @Medium @Automation
  Scenario: Verify Parent Title column search matches partial text ignoring case
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Parent Title search | region |
    When the user types 'region' in the Parent Title column search box
    Then Only 'State' (Parent Title 'Region') is displayed

  # Ref: FRD 5.3 FB-3; FRD 5.3 C-DI
  @TC_MM_055 @Functional @Medium @Automation
  Scenario: Verify Display filter 'Checked' shows only Titles with Display checked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Display filter | Checked |
    When the user selects 'Checked' in the Display column dropdown
    Then Only List of Title, List of Firm Type, List of Operator, Zone Type and Material Group are displayed

  # Ref: FRD 5.3 FB-3; FRD 5.3 C-DI
  @TC_MM_056 @Functional @Medium @Automation
  Scenario: Verify Display filter 'Unchecked' shows only Titles with Display unchecked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Display filter | Unchecked |
    When the user selects 'Unchecked' in the Display column dropdown
    Then Only the 13 baseline Titles with Display unchecked are displayed

  # Ref: FRD 5.3 FB-3; FRD 5.3 FB-5
  @TC_MM_057 @Functional @Medium @Automation
  Scenario: Verify the Display filter defaults to All and shows every Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Display filter | All |
    When the user opens Miscellaneous Master and observe the Display dropdown
    And the user selects Checked, then select All
    Then Default value is 'All' showing 18 Titles
    And Selecting All again removes the filter and shows 18 Titles

  # Ref: FRD 5.3 FB-4
  @TC_MM_058 @Functional @Medium @Automation
  Scenario: Verify records must match all filters when more than one column search is used
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title search   | list    |
      | Display filter | Checked |
    When the user types 'list' in the Title search box
    And the user selects 'Checked' in the Display dropdown
    Then Only List of Title, List of Firm Type and List of Operator are displayed ('List of Specialization' is excluded as it is unchecked)

  # Ref: FRD 5.3 FB-4
  @TC_MM_059 @Functional @Medium @Automation
  Scenario: Verify the list is filtered as the user types without pressing Enter
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title search | f -> firm |
    When the user types 'f' in the Title search box and observe
    And the user continues typing to 'firm' without pressing Enter
    Then The list updates after each typed character; no Enter or button click is needed

  # Ref: FRD 5.3 FB-5
  @TC_MM_060 @Functional @Medium @Automation
  Scenario: Verify clearing the search boxes removes the filters and shows the full list on page 1
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title search | firm    |
      | Display      | Checked |
    When the user types 'firm' in Title search and select 'Checked' in Display
    And the user clears the Title search box and select All in Display
    And the user observes the list
    Then After each clear the filter is removed
    And When all filters are cleared the full list is displayed on page 1

  # Ref: FRD 5.3 FB-6; FRD 5.3 BR-2
  @TC_MM_061 @Functional @Medium @Automation
  Scenario: Verify filtered results are paginated from page 1 with Sl. No. starting at 1
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset C (120 Titles, see Summary) is loaded
    And the following test data is used
      | Data         | Dataset C                |
      | Title search | Bulk (matches 70 Titles) |
    When the user goes to page 3 of the list
    And the user types 'Bulk' in the Title search box
    And the user observes the page, Sl. No. and indicator
    And the user opens page 2
    Then Filtered results start on page 1 with Sl. No. 1; indicator '1 / 2'
    And Page 2 shows Sl. No. 51 to 70

  # Ref: FRD 5.3 FB-7
  @TC_MM_062 @Functional @Medium @Automation
  Scenario: Verify the list keeps the column search values after a new Title is added
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title search | list                 |
      | New Title    | List of Vendor Class |
    When the user types 'list' in the Title search box
    And the user clicks 'Add', enter Field Title 'List of Vendor Class' and click Save
    And the user observes the search box and list
    Then List refreshes automatically; Title search box still contains 'list'; the new Title appears in the filtered list

  # Ref: FRD 5.3 FB-7
  @TC_MM_063 @Functional @Medium @Automation
  Scenario: Verify the list keeps the column search values after a Title is edited
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title search | list                                  |
      | Edit         | List of Operator -> List of Operators |
    When the user types 'list' in the Title search box
    And the user edits 'List of Operator' and change Field Title to 'List of Operators'
    And the user clicks Save
    Then List refreshes and the search value 'list' is retained; 'List of Operators' is shown

  # Ref: FRD 5.3 FB-7; FRD 5.6 FB-2
  @TC_MM_064 @Functional @Medium @Automation
  Scenario: Verify the list keeps the column search values after a Display change
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Display filter | Unchecked              |
      | Row            | List of Specialization |
    When the user selects 'Unchecked' in the Display dropdown
    And the user checks the Display checkbox of 'List of Specialization'
    Then Toaster 'Display setting updated successfully.' is displayed
    And The Display filter remains 'Unchecked' after the automatic refresh

  # Ref: FRD 5.3 FB-7
  @TC_MM_065 @Functional @Medium @Automation
  Scenario: Verify the list keeps the column search values after a Title is deleted
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title search | field          |
      | Delete       | Obsolete Field |
    When the user types 'field' in the Title search box
    And the user deletes 'Obsolete Field' and confirm Yes
    Then List refreshes and the search value 'field' is retained; 'Obsolete Field' is removed

  # Ref: Section 4 AC-SC-4; FRD 5.3 FB-8
  @TC_MM_066 @Functional @Medium @Automation
  Scenario: Verify the grid shows 'No records found.' when a search has no match
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title search | zzzz |
    When the user types 'zzzz' in the Title search box
    Then The grid displays 'No records found.'
