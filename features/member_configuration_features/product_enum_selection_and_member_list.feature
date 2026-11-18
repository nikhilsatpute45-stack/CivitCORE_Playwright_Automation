@MembersConfiguration @ProductEnumSelectionAndMemberList
Feature: Product Enum Selection and Member List
  Automated scenarios for the "Product Enum Selection and Member List" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-2; FRD 5.2 FB-1
  @TC_MC_008 @Functional @High @Automation
  Scenario: Verify the Product Enum dropdown lists exactly the backend Product Enums in the configured order
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Expected order (backend) | Proposal Nature, Proposal Classification, Tender Type, Modules, LeadQryType, Estate House Type, TestEnum50, TestEnum51, TestEnum120 |
    When the user clicks the Product Enum dropdown
    And the user reads the options from top to bottom
    Then Dropdown lists exactly these 9 Product Enums, no more, no fewer, in the same order as the backend configuration

  # Ref: US-1 AC-3; FRD 5.2 FB-1
  @TC_MC_009 @Functional @High @Automation
  Scenario: Verify selecting another Product Enum reloads the Member List for that enum
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | Tender Type                             |
      | Members      | OpenTender, LimitedTender, SingleTender |
    When the user opens the Product Enum dropdown
    And the user selects 'Tender Type'
    Then Member List reloads and shows exactly the 3 members of 'Tender Type'
    And No member of 'Proposal Nature' is shown

  # Ref: US-1 AC-3; FRD 5.2 FB-1
  @TC_MC_010 @Functional @High @Automation
  Scenario: Verify changing the Product Enum resets the list to page 1
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected and the user is on page 3
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | From | TestEnum120 page 3 |
      | To   | TestEnum51         |
    When the user clicks 'Next' twice to reach page 3 of 'TestEnum120'
    And the user selects 'TestEnum51' in the Product Enum dropdown
    And the user observes the page indicator
    Then 'TestEnum51' list loads on page 1; indicator shows '1 / 2'
    And Sl. No. starts at 1

  # Ref: US-1 AC-3; FRD 5.2 FB-1
  @TC_MC_011 @Functional @High @Automation
  Scenario: Verify changing the Product Enum clears all column search values
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member Name search | repair      |
      | Active search      | Active      |
      | New enum           | Tender Type |
    When the user types 'repair' in the Member Name search box
    And the user selects 'Active' in the Active search dropdown
    And the user selects 'Tender Type' in the Product Enum dropdown
    And the user observes the search boxes
    Then Member Name and Description search boxes are empty and Active search is back to 'All'
    And All 3 Tender Type members are shown

  # Ref: US-1 AC-4; FRD 5.2 FB-2
  @TC_MC_012 @Functional @High @Automation
  Scenario: Verify the Member List shows columns Sl. No., Member Name, Description, Active and Actions with the members in backend order
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Backend order | Project, RepairAndMaintenance, Modernization, Consultancy, Others, OriginalWork |
    When the user observes the grid for 'Proposal Nature'
    Then Columns are Sl. No., Member Name, Description, Active and Actions
    And Rows appear in the backend-configured order listed in Test Data

  # Ref: FRD 5.2 FB-2
  @TC_MC_013 @Functional @Medium @Automation
  Scenario: Verify editing a member does not change its position in the list
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member          | Others        |
      | New Description | Miscellaneous |
    When the user edits member 'Others' and change Description to 'Miscellaneous'
    And the user clicks Save
    And the user observes the row order
    Then Order stays Project, RepairAndMaintenance, Modernization, Consultancy, Others, OriginalWork
    And 'Others' remains 5th with Description 'Miscellaneous'

  # Ref: FRD 5.2 C-MemberName; FRD 5.2 C-Description
  @TC_MC_014 @Functional @Medium @Automation
  Scenario: Verify each row shows the fixed Member Name and the user-facing Description
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member Name | RepairAndMaintenance |
      | Description | AMC                  |
    When the user locates the row for member 'RepairAndMaintenance'
    Then Member Name column shows 'RepairAndMaintenance' and Description column shows 'AMC'

  # Ref: FRD 5.2 C-Active; FRD 5.4 F-Active
  @TC_MC_015 @Functional @Medium @Automation
  Scenario: Verify the Active column checkbox reflects each member's status
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Inactive | Modernization                                                    |
      | Active   | Project, RepairAndMaintenance, Consultancy, Others, OriginalWork |
    When the user observes the Active checkbox of every row of 'Proposal Nature'
    Then 'Modernization' checkbox is unchecked; the other 5 are checked

  # Ref: FRD 5.2 BR-2; FRD 5.2 C-SlNo
  @TC_MC_016 @Functional @Medium @Automation
  Scenario: Verify Sl. No. runs 1, 2, 3 ... in the current result set
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | Proposal Nature (6 members) |
    When the user observes the Sl. No. column of 'Proposal Nature'
    Then Sl. No. shows 1 to 6 in row order; it is a display sequence only

  # Ref: FRD 5.2 BR-2; FRD 5.2 C-SlNo
  @TC_MC_017 @Functional @Medium @Automation
  Scenario: Verify Sl. No. runs continuously across pages
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | TestEnum120 |
    When the user observes Sl. No. of the first and last row on page 1
    And the user clicks 'Next'
    And the user observes Sl. No. of the first row on page 2
    Then Page 1 shows 1 to 50
    And Page 2 starts at 51 (not 1)

  # Ref: FRD 5.2 BR-2; FRD 5.2 FB-5
  @TC_MC_018 @Functional @Medium @Automation
  Scenario: Verify Sl. No. is re-sequenced after the list is refreshed
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Active search | Inactive then All |
    When the user selects Active search 'Inactive'
    And the user observes Sl. No
    And the user sets Active search back to 'All'
    Then Filtered list shows Sl. No. 1 for 'Modernization'
    And After clearing, Sl. No. is again 1 to 6 for all members

  # Ref: FRD 5.2 FB-3
  @TC_MC_019 @Functional @High @Automation
  Scenario: Verify page 1 shows 50 records per page when the enum has more than 50 members
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | TestEnum120 (120 members) |
    When the user counts the rows on page 1
    Then Page 1 shows exactly 50 rows
    And Indicator shows '1 / 3'

  # Ref: FRD 5.2 FB-3
  @TC_MC_020 @Functional @High @Automation
  Scenario: Verify pagination controls are hidden when the enum has exactly 50 members (boundary)
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum50' is selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | TestEnum50 (50 members) |
    When the user observes the area below the grid
    Then All 50 rows are shown on one page
    And Pagination controls and page indicator are hidden

  # Ref: FRD 5.2 FB-3
  @TC_MC_021 @Functional @High @Automation
  Scenario: Verify pagination appears and the second page holds 1 record when the enum has 51 members (boundary)
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum51' is selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | TestEnum51 (51 members) |
    When the user observes the pagination area
    And the user clicks 'Next'
    Then Pagination is shown with indicator '1 / 2'
    And Page 2 shows exactly 1 row (Sl. No. 51) and the indicator is '2 / 2'

  # Ref: FRD 5.2 FB-3
  @TC_MC_022 @Functional @Medium @Automation
  Scenario: Verify pagination controls are hidden when the enum has fewer than 50 members
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | Proposal Nature (6 members) |
    When the user observes the area below the grid of 'Proposal Nature'
    Then Pagination controls are hidden

  # Ref: FRD 5.2 FB-3
  @TC_MC_023 @Functional @Medium @Automation
  Scenario: Verify First and Previous are disabled on page 1
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected on page 1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | TestEnum120 |
      | Page         | 1           |
    When the user observes the state of First, Previous, Next and Last
    Then 'First' and 'Previous' are disabled
    And 'Next' and 'Last' are enabled

  # Ref: FRD 5.2 FB-3
  @TC_MC_024 @Functional @Medium @Automation
  Scenario: Verify Next moves to the next page and updates the page indicator
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected on page 1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | TestEnum120 |
    When the user clicks 'Next'
    And the user observes the indicator and first row
    Then Page 2 is shown with indicator '2 / 3'
    And 'First' and 'Previous' become enabled

  # Ref: FRD 5.2 FB-3
  @TC_MC_025 @Functional @Medium @Automation
  Scenario: Verify Last goes to the last page and Next and Last are disabled there
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected on page 1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | TestEnum120 |
    When the user clicks 'Last'
    And the user observes the controls and row count
    Then Page 3 is shown with indicator '3 / 3' and 20 rows (Sl. No. 101 to 120)
    And 'Next' and 'Last' are disabled

  # Ref: FRD 5.2 FB-3
  @TC_MC_026 @Functional @Medium @Automation
  Scenario: Verify First and Previous navigate back from the last page
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected on page 3
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | TestEnum120 |
    When the user clicks 'Previous'
    And the user observes the indicator
    And the user clicks 'First'
    And the user observes the indicator
    Then 'Previous' shows page 2 ('2 / 3')
    And 'First' shows page 1 ('1 / 3')

  # Ref: FRD 5.2 FB-3
  @TC_MC_027 @Functional @Medium @Automation
  Scenario: Verify clicking a page number opens that page
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected on page 1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | TestEnum120 |
      | Page number  | 3           |
    When the user clicks page number '3' in the pagination bar
    Then Page 3 opens; indicator shows '3 / 3'

  # Ref: FRD 5.2 FB-5; FRD 5.2 FB-3
  @TC_MC_028 @Functional @Medium @Automation
  Scenario: Verify filtered results are paginated and Sl. No. restarts from 1
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description search | member (matches all 120 members, 'Member 001' to 'Member 120') |
    When the user types 'member' in the Description search box
    And the user observes the first row Sl. No
    And the user clicks 'Next'
    Then Filtered result is paginated at 50 per page with indicator '1 / 3'
    And Sl. No. starts at 1 and continues 51 on page 2

  # Ref: US-1 AC-5; FRD 5.2 ES-When; FRD 5.2 ES-Illus; FRD 5.2 ES-Head; FRD 5.2 ES-Msg
  @TC_MC_042 @Functional @High @Automation
  Scenario: Verify a Product Enum with no members shows the empty state and no grid or Add button
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | Estate House Type (no members) |
    When the user selects 'Estate House Type' in the Product Enum dropdown
    And the user observes the screen
    Then Empty state is shown with an illustration, heading 'No members configured' and message 'Members of this enum are not configured. Please contact system administrator.'
    And No grid and no Add button are displayed

  # Ref: FRD 5.2 ES-Btn; FRD 5.2 FB-1
  @TC_MC_043 @Functional @Medium @Automation
  Scenario: Verify the Product Enum dropdown stays visible in the empty state and another enum can be selected
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'Estate House Type' is selected and the empty state is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | From | Estate House Type |
      | To   | Proposal Nature   |
    When the user observes the Product Enum dropdown
    And the user selects 'Proposal Nature'
    Then Dropdown is visible in the empty state
    And After selecting 'Proposal Nature' the empty state disappears and its 6 members are listed
