@RateCard @RateCardList
Feature: Rate Card List
  Automated scenarios for the "Rate Card List" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.3 FB-1
  @TC_RC_033 @Functional @High @Automation
  Scenario: Verify the Rate Card List shows Rate Cards newest first by default
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Cards | Highland Zone, Lowland Zone |
    When the user adds Rate Card 'Highland Zone'
    And the user adds Rate Card 'Lowland Zone'
    And the user observes the order of the first two rows
    Then 'Lowland Zone' is Sl. No. 1 and 'Highland Zone' is Sl. No. 2 (newest first)

  # Ref: FRD 5.3 FB-2; FRD 5.3 BR-2
  @TC_RC_034 @Functional @Medium @Automation
  Scenario: Verify the list shows 50 records per page with Sl. No. continuous across pages
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Records   | 120 |
      | Page size | 50  |
    When the user observes page 1 and note the first and last Sl. No
    And the user clicks Next
    And the user notes the first and last Sl. No. of page 2
    And the user clicks Next and observe page 3
    Then Page 1 shows 50 rows, Sl. No. 1 to 50
    And Page 2 shows 50 rows, Sl. No. 51 to 100
    And Page 3 shows 20 rows, Sl. No. 101 to 120

  # Ref: FRD 5.3 FB-2
  @TC_RC_035 @Functional @Medium @Automation
  Scenario: Verify the 'current page / total pages' indicator updates as the user navigates (First, Previous, Next, Last)
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Records | 120 |
      | Pages   | 3   |
    When the user observes the indicator on page 1
    And the user clicks Next
    And the user clicks Last
    And the user clicks Previous
    And the user clicks First
    Then Indicator shows '1 / 3', then '2 / 3', then '3 / 3', then '2 / 3', then '1 / 3' respectively

  # Ref: FRD 5.3 FB-2
  @TC_RC_036 @Functional @Medium @Automation
  Scenario: Verify pagination controls are hidden when exactly 50 Rate Cards exist (boundary)
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Dataset DS-50 (exactly 50 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Records | 50 |
    When the user observes the area below the grid
    Then All 50 rows are shown on one page
    And Pagination controls and the page indicator are not displayed

  # Ref: FRD 5.3 FB-2; FRD 5.3 BR-2
  @TC_RC_037 @Functional @Medium @Automation
  Scenario: Verify pagination controls appear when 51 Rate Cards exist (boundary)
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Dataset DS-51 (exactly 51 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Records | 51 |
    When the user observes the area below the grid
    And the user clicks Next
    Then Pagination controls are displayed with indicator '1 / 2'
    And Page 2 shows 1 row with Sl. No. 51

  # Ref: US-1 AC-5; FRD 5.3 FB-3
  @TC_RC_038 @Functional @Medium @Automation
  Scenario: Verify the Associated Offices cell shows '-' when no office is associated
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region (no offices) |
    When the user locates the row 'Coastal Region'
    And the user reads the Associated Offices cell
    Then Associated Offices cell shows '-'

  # Ref: FRD 5.3 FB-3
  @TC_RC_039 @Functional @Medium @Automation
  Scenario: Verify the Associated Offices cell lists 1 office name when one office is associated
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Single Office Card (Amritsar) |
    When the user locates the row 'Single Office Card'
    And the user reads the Associated Offices cell
    Then Associated Offices cell shows 'Amritsar' with no count prefix and no '+n more'

  # Ref: FRD 5.3 FB-3
  @TC_RC_040 @Functional @Medium @Automation
  Scenario: Verify the Associated Offices cell lists all names alphabetically, comma separated, for exactly 3 offices (boundary)
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Dataset with Rate Card 'Triple Office Card' (offices Samana, Nabha, Patiala) (see Summary) is loaded
    And the following test data is used
      | Offices | Samana, Nabha, Patiala |
    When the user locates the row 'Triple Office Card'
    And the user reads the Associated Offices cell
    Then Cell shows 'Nabha, Patiala, Samana' (alphabetical, comma separated) with no '+n more'

  # Ref: US-1 AC-5; FRD 5.3 FB-3
  @TC_RC_041 @Functional @Medium @Automation
  Scenario: Verify the Associated Offices cell shows count, first 3 names and '+1 more' for 4 offices (boundary)
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Sub Mountanious (Nabha, Patiala, Rajpura, Samana) |
    When the user locates the row 'Sub Mountanious'
    And the user reads the Associated Offices cell
    Then Cell shows '4 offices: Nabha, Patiala, Rajpura +1 more'

  # Ref: US-1 AC-5; FRD 5.3 FB-3; FRD 5.6 BR-2
  @TC_RC_042 @Functional @Medium @Automation
  Scenario: Verify the Associated Offices cell for a Rate Card with 248 offices shows the count, first 3 names and '+245 more'
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Dataset DS-248 (Rate Card 'Mega Office Card' with 248 offices) (see Summary) is loaded
    And the following test data is used
      | Offices | Abohar, Adampur, Ahmedgarh, Office-001 ... Office-245 |
    When the user locates the row 'Mega Office Card'
    And the user reads the Associated Offices cell
    Then Cell shows '248 offices: Abohar, Adampur, Ahmedgarh +245 more'

  # Ref: FRD 5.3 FB-3; FRD 5.4 FB-1
  @TC_RC_043 @Functional @Medium @Automation
  Scenario: Verify clicking '+<n> more' opens the View pop-up with the full office list
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Sub Mountanious |
    When In the row 'Sub Mountanious', click '+1 more' in the Associated Offices cell
    Then 'View Rate Card' pop-up opens for 'Sub Mountanious'
    And Associated Offices shows '4 offices' and lists Nabha, Patiala, Rajpura, Samana

  # Ref: US-6 AC-1; FRD 5.3 FB-5
  @TC_RC_044 @Functional @Medium @Automation
  Scenario: Verify the Rate Card Name search is a partial, case-insensitive match
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | mount |
    When the user types 'mount' in the Rate Card Name search box
    Then Only 'Sub Mountanious' is listed

  # Ref: US-6 AC-1; FRD 5.3 FB-5
  @TC_RC_045 @Functional @Medium @Automation
  Scenario: Verify the Rate Card Name search ignores letter case
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | MOUNT |
    When the user types 'MOUNT' in the Rate Card Name search box
    Then Only 'Sub Mountanious' is listed

  # Ref: US-6 AC-2; FRD 5.3 FB-5
  @TC_RC_046 @Functional @Medium @Automation
  Scenario: Verify the Associated Offices search lists Rate Cards with at least one matching office
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | Patiala |
    When the user types 'Patiala' in the Associated Offices search box
    Then Only 'Sub Mountanious' is listed

  # Ref: US-6 AC-2; FRD 5.3 FB-5
  @TC_RC_047 @Functional @Medium @Automation
  Scenario: Verify the Associated Offices search is a partial, case-insensitive match
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | pati |
    When the user types 'pati' in the Associated Offices search box
    Then Only 'Sub Mountanious' is listed

  # Ref: FRD 5.3 FB-5; US-6 AC-2
  @TC_RC_048 @Functional @Medium @Automation
  Scenario: Verify the Associated Offices search also matches an office not shown in the cell (beyond first 3 names)
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | Samana |
    When the user types 'Samana' in the Associated Offices search box (Samana is hidden under '+1 more')
    Then 'Sub Mountanious' is listed because any associated office matches

  # Ref: FRD 5.3 FB-5
  @TC_RC_049 @Functional @Medium @Automation
  Scenario: Verify the list is filtered as the user types without pressing Enter
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | Sub |
    When the user types 'S' then 'Su' then 'Sub' in the Rate Card Name search box, observing after each keystroke
    Then The grid refreshes after each keystroke without any Enter/search button

  # Ref: US-6 AC-3; FRD 5.3 FB-5
  @TC_RC_050 @Functional @Medium @Automation
  Scenario: Verify only Rate Cards matching both column searches are shown
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name search    | Sub     |
      | Offices search | Rajpura |
    When the user types 'Sub' in the Rate Card Name search box
    And the user types 'Rajpura' in the Associated Offices search box
    Then Only 'Sub Mountanious' is listed

  # Ref: FRD 5.3 FB-6
  @TC_RC_051 @Functional @Medium @Automation
  Scenario: Verify clearing one search box removes only that filter
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name search    | Sub                    |
      | Offices search | Patiala (then cleared) |
    When the user types 'Sub' in the Rate Card Name search box and 'Patiala' in the Associated Offices search box
    And the user clears the Associated Offices search box
    Then List is filtered by 'Sub' only (Sub Mountanious)

  # Ref: FRD 5.3 FB-6
  @TC_RC_052 @Functional @Medium @Automation
  Scenario: Verify clearing both search boxes shows the full list on page 1
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Search | Bulk Rate Card 12 (then cleared) |
    When the user types 'Bulk Rate Card 12' in the Rate Card Name search box
    And the user clears the box
    Then Full list is shown on page 1 with indicator '1 / 3' and Sl. No. 1 to 50

  # Ref: FRD 5.3 FB-6; FRD 5.3 BR-2
  @TC_RC_053 @Functional @Medium @Automation
  Scenario: Verify filtered results are paginated from page 1 with Sl. No. starting at 1
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Search  | Bulk |
      | Matches | 120  |
    When the user goes to page 3
    And the user types 'Bulk' in the Rate Card Name search box
    And the user observes page and Sl. No
    And the user clicks Next
    Then Filtered result opens on page 1 with Sl. No. 1 to 50 and indicator '1 / 3'
    And Page 2 continues from Sl. No. 51

  # Ref: FRD 5.3 BR-2
  @TC_RC_054 @Functional @Medium @Automation
  Scenario: Verify Sl. No. in a filtered result is the running number of the result set
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | Zone (matches Desert Zone and Hill Zone, which are Sl. No. 2 and 5 in the full list) |
    When the user types 'Zone' in the Rate Card Name search box
    And the user reads the Sl. No. column
    Then Filtered rows show Sl. No. 1 (Desert Zone) and 2 (Hill Zone), i.e. the running number of the result set, not their full-list positions

  # Ref: US-6 AC-3; FRD 5.3 FB-8; FRD 5.3 ES-1
  @TC_RC_055 @Functional @High @Automation
  Scenario: Verify the grid shows 'No records found.' when Rate Cards exist but nothing matches the search
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | Zzzz |
    When the user types 'Zzzz' in the Rate Card Name search box
    Then Grid shows 'No records found.'
    And The empty state (illustration, heading, Add message) is not displayed

  # Ref: US-6 AC-3; FRD 5.3 FB-5
  @TC_RC_056 @Functional @Medium @Automation
  Scenario: Verify no match is returned when both searches individually match but not the same Rate Card
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name search    | Civit   |
      | Offices search | Patiala |
    When the user types 'Civit' in the Rate Card Name search box
    And the user types 'Patiala' in the Associated Offices search box
    Then Grid shows 'No records found.' (Civit-ratecard has no Patiala office; Sub Mountanious does not match 'Civit')

  # Ref: FRD 5.3 FB-7
  @TC_RC_057 @Functional @Medium @Automation
  Scenario: Verify the current page and search values are kept after an Edit
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Search    | Bulk                                      |
      | Page      | 2                                         |
      | Rate Card | Bulk Rate Card 075 -> Bulk Rate Card 075A |
    When the user types 'Bulk' in the Rate Card Name search box and go to page 2
    And the user edits 'Bulk Rate Card 075' to 'Bulk Rate Card 075A' and Save
    Then List refreshes on page 2 with the search 'Bulk' still applied

  # Ref: FRD 5.3 FB-7; FRD 5.3 BR-2
  @TC_RC_058 @Functional @Medium @Automation
  Scenario: Verify the current page and search values are kept after a Delete
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Search    | Bulk               |
      | Page      | 2                  |
      | Rate Card | Bulk Rate Card 075 |
    When the user types 'Bulk' in the Rate Card Name search box and go to page 2
    And the user deletes 'Bulk Rate Card 075' and confirm Yes
    Then List refreshes on page 2 with the search 'Bulk' still applied and Sl. No. re-sequenced

  # Ref: FRD 5.3 FB-1; US-5 AC-2
  @TC_RC_059 @Functional @High @Automation
  Scenario: Verify editing a Rate Card does not change its position in the list
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Sub Mountanious -> Sub Mountanious North |
    When the user notes that 'Sub Mountanious' is Sl. No. 4
    And the user edits its name to 'Sub Mountanious North' and Save
    Then 'Sub Mountanious North' remains at Sl. No. 4

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.3 FB-5; FRD 5.3 FB-8
  @TC_RC_203 @Negative @Medium @Automation
  Scenario: Verify a search for the literal character '%' does not behave as a wildcard
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | % |
    When the user types '%' in the Rate Card Name search box
    Then Grid shows 'No records found.' (no baseline name contains '%'); the full list is not returned

  # Ref: FRD 5.3 FB-5; FRD 5.2 BR-8
  @TC_RC_204 @Negative @Medium @Automation
  Scenario: Verify a SQL-style search text is handled as plain text without error
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | ' OR '1'='1 |
    When the user types "' OR '1'='1" in the Rate Card Name search box
    Then Grid shows 'No records found.'; no error page and no unfiltered data is returned
