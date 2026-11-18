@WorkType @WorkTypeListColumnSearch
Feature: Work Type List / Column Search
  Automated scenarios for the "Work Type List / Column Search" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.3 BR-2; FRD 5.3 Columns
  @TC_WT_035 @Functional @Medium @Automation
  Scenario: Verify Sl. No. is a continuous running number starting at 1 for the newest record
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Baseline | 9 records |
    When the user observes the Sl. No. column from top to bottom
    Then Sl. No. runs 1 to 9 continuously with Boundary Wall = 1 and Runway = 9

  # Ref: FRD 5.3 FB-1
  @TC_WT_036 @Functional @High @Automation
  Scenario: Verify editing a Work Type does not change its position in the list
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type     | Terminal Building |
      | New Work Type | Roads             |
    When the user edits 'Terminal Building' (Sl. No. 8) and change Work Type to 'Roads'
    And the user clicks 'Save'
    And the user observes the list
    Then Toaster 'Work Type updated successfully.' is displayed
    And 'Terminal Building' remains at Sl. No. 8; the order is unchanged

  # Ref: FRD 5.3 FB-2
  @TC_WT_037 @Functional @High @Automation
  Scenario: Verify page 1 shows 50 records with the 'current page / total pages' indicator and First/Previous disabled
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And the following test data is used
      | Records | 120 |
    When the user observes page 1
    And the user observes pagination controls
    Then 50 records are displayed (Sl. No. 1 to 50)
    And Indicator shows '1 / 3'; First and Previous are disabled; Next and Last are enabled

  # Ref: FRD 5.3 FB-2; FRD 5.3 BR-2
  @TC_WT_038 @Functional @High @Automation
  Scenario: Verify Sl. No. continues across pages (page 2 starts at 51)
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And the following test data is used
      | Records | 120 |
    When the user clicks 'Next'
    And the user observes the first row and the indicator
    Then Page 2 first row shows Sl. No. 51 ('Bulk WT 070'); indicator shows '2 / 3'

  # Ref: FRD 5.3 FB-2
  @TC_WT_039 @Functional @High @Automation
  Scenario: Verify the last page disables Next and Last
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And the following test data is used
      | Records | 120 |
    When the user clicks 'Last'
    And the user observes rows and controls
    Then Page 3 shows 20 records (Sl. No. 101 to 120); indicator shows '3 / 3'
    And Next and Last are disabled; First and Previous are enabled

  # Ref: FRD 5.3 FB-2
  @TC_WT_040 @Functional @Medium @Automation
  Scenario: Verify First, Previous, Next and Last navigate to the correct pages
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And the following test data is used
      | Records | 120 |
    When the user clicks 'Last'
    And the user clicks 'Previous'
    And the user clicks 'First'
    And the user clicks 'Next'
    Then Pages shown in order: 3 / 3, 2 / 3, 1 / 3, 2 / 3

  # Ref: FRD 5.3 FB-2
  @TC_WT_041 @Functional @Medium @Automation
  Scenario: Verify clicking a page number opens that page
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And the following test data is used
      | Records | 120 |
    When the user clicks page number '3' in the pagination controls
    Then Page 3 opens and the indicator shows '3 / 3'

  # Ref: FRD 5.3 FB-2
  @TC_WT_042 @Functional @Medium @Automation
  Scenario: Verify pagination controls are hidden when exactly 50 records exist
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the list is displayed; dataset 'Page50' is loaded (50 Work Types 'Page WT 001' to 'Page WT 050')
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Records | 50 |
    When the user observes the area below the grid
    Then All 50 records are displayed on one page and pagination controls are not displayed

  # Ref: FRD 5.3 FB-2
  @TC_WT_043 @Functional @Medium @Automation
  Scenario: Verify pagination controls are displayed when 51 records exist
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the list is displayed; dataset 'Page51' is loaded (51 Work Types 'Page WT 001' to 'Page WT 051')
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Records | 51 |
    When the user observes the area below the grid
    Then Pagination controls are displayed with indicator '1 / 2'; page 2 contains 1 record

  # Ref: FRD 5.3 FB-3; FRD 5.3 FB-4
  @TC_WT_044 @Functional @High @Automation
  Scenario: Verify Work Type Name search matches partial text and ignores case
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | run |
    When the user types 'run' in the Work Type Name search box
    Then Only 'Runway' is listed (Sl. No. 1)

  # Ref: FRD 5.3 FB-4
  @TC_WT_045 @Functional @Medium @Automation
  Scenario: Verify the Work Type Name search matches an upper-case term against mixed-case names
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | TAXI |
    When the user types 'TAXI' in the Work Type Name search box
    Then 'Taxiway' is listed

  # Ref: FRD 5.3 FB-4
  @TC_WT_046 @Functional @Medium @Automation
  Scenario: Verify the list is filtered as the user types without clicking a search button
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | a, then ap |
    When the user types 'a' in the Work Type Name search box
    And the user types 'p' to make the term 'ap'
    And the user observes the list after each keystroke
    Then List filters after each keystroke without any extra action
    And For 'ap' only 'Apron' is listed (names containing 'ap')

  # Ref: FRD 5.3 FB-3; FRD 5.6 BR-2
  @TC_WT_047 @Functional @High @Automation
  Scenario: Verify the Work Type column dropdown defaults to All and lists All plus every backend value
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Backend values | Other, Building, Roads |
    When the user observes the Work Type column search dropdown
    And the user opens it
    Then Default selection is 'All'
    And Options are All, Other, Building, Roads

  # Ref: FRD 5.3 FB-3
  @TC_WT_048 @Functional @High @Automation
  Scenario: Verify filtering by the Work Type dropdown value Building
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Building |
    When the user selects 'Building' in the Work Type column search
    Then Only Control Tower (Sl. No. 1), Hanger (2) and Terminal Building (3) are listed

  # Ref: FRD 5.3 FB-4
  @TC_WT_049 @Functional @High @Automation
  Scenario: Verify search values in both columns are combined (only records matching both are shown)
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name      | build    |
      | Work Type | Building |
    When the user types 'build' in the Work Type Name search
    And the user selects 'Building' in the Work Type search
    Then Only 'Terminal Building' is listed (Sl. No. 1)

  # Ref: FRD 5.3 FB-4; FRD 5.3 FB-8
  @TC_WT_050 @Functional @Medium @Automation
  Scenario: Verify both-column search returns no match when the combination does not exist
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name      | run   |
      | Work Type | Roads |
    When the user types 'run' in the Work Type Name search
    And the user selects 'Roads' in the Work Type search
    Then No row matches; grid shows 'No records found.'

  # Ref: FRD 5.3 FB-5
  @TC_WT_051 @Functional @Medium @Automation
  Scenario: Verify clearing a column search removes that filter
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name      | run   |
      | Work Type | Other |
    When the user types 'run' in the Name search and select 'Other' in Work Type
    And the user clears the Name search text
    And the user observes the list
    And the user selects 'All' in Work Type
    And the user observes the list
    Then After clearing the name, the list shows all 'Other' records (Boundary Wall, Fuel Farm, Runway)
    And After selecting 'All', the full list of 9 records is shown on page 1

  # Ref: FRD 5.3 FB-6
  @TC_WT_052 @Functional @Medium @Automation
  Scenario: Verify filtered results are paginated from page 1 with Sl. No. starting at 1
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And the following test data is used
      | Name search | Bulk WT 0 (matches 99 records, 'Bulk WT 001' to 'Bulk WT 099') |
    When the user goes to page 3 of the list
    And the user types 'Bulk WT 0' in the Name search
    And the user observes the page, the first row and the indicator
    Then Filtered results start on page 1 with the indicator '1 / 2'
    And First row has Sl. No. 1 ('Bulk WT 099'); page 2 holds 49 records

  # Ref: FRD 5.3 FB-7
  @TC_WT_053 @Functional @High @Automation
  Scenario: Verify current column search values and page are kept after an Edit
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And the following test data is used
      | Name search | Bulk WT 0   |
      | Page        | 2           |
      | Record      | Bulk WT 049 |
    When the user types 'Bulk WT 0' in the Name search and go to page 2
    And the user edits 'Bulk WT 049' (first row of page 2) and change Work Type to 'Roads'
    And the user clicks 'Save'
    And the user observes the list
    Then List refreshes automatically; Name search 'Bulk WT 0' and page 2 are retained

  # Ref: FRD 5.3 FB-7; FRD 5.8 FB-5
  @TC_WT_054 @Functional @High @Automation
  Scenario: Verify current column search values and page are kept after a Delete
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And the following test data is used
      | Name search | Bulk WT 0   |
      | Page        | 2           |
      | Record      | Bulk WT 010 |
    When the user types 'Bulk WT 0' in the Name search and go to page 2
    And the user deletes 'Bulk WT 010' and confirm 'Yes'
    And the user observes the list
    Then List refreshes automatically; Name search 'Bulk WT 0' and page 2 are retained; Sl. No. is re-sequenced

  # Ref: US-1 AC-5; FRD 5.3 FB-8; FRD 5.3 Empty State When shown
  @TC_WT_055 @Functional @High @Automation
  Scenario: Verify 'No records found.' is shown (and the empty state is not) when no record matches the column search
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | zzz |
    When the user types 'zzz' in the Work Type Name search
    Then Grid shows 'No records found.'
    And Empty-state illustration, heading and Add message are not displayed
