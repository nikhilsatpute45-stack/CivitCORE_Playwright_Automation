@MembersConfiguration @MemberListSearch
Feature: Member List Search
  Automated scenarios for the "Member List Search" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-6 AC-1; FRD 5.2 FB-5
  @TC_MC_029 @Functional @High @Automation
  Scenario: Verify Member Name search matches partial text
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member Name search | repair |
    When the user types 'repair' in the Member Name search box
    Then Only 'RepairAndMaintenance' is shown (value contains 'repair')
    And Sl. No. shows 1

  # Ref: US-6 AC-1; FRD 5.2 FB-5
  @TC_MC_030 @Functional @High @Automation
  Scenario: Verify Member Name search ignores letter case
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member Name search | REPAIR |
    When the user types 'REPAIR' in the Member Name search box
    Then 'RepairAndMaintenance' is shown, same result as 'repair'

  # Ref: FRD 5.2 FB-5; US-6 AC-1
  @TC_MC_031 @Functional @High @Automation
  Scenario: Verify Description search matches partial text ignoring case
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description search | amc |
    When the user types 'amc' in the Description search box
    Then Only the member with Description 'AMC' (RepairAndMaintenance) is shown

  # Ref: FRD 5.2 FB-4; US-6 AC-1
  @TC_MC_032 @Functional @Medium @Automation
  Scenario: Verify Member Name search box does not search the Description column
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member Name search | AMC (no Member Name contains 'AMC'; only a Description does) |
    When the user types 'AMC' in the Member Name search box
    Then No row matches; grid shows 'No records found.'

  # Ref: FRD 5.2 FB-5
  @TC_MC_033 @Functional @Medium @Automation
  Scenario: Verify the list is filtered as the user types without pressing Enter
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description search typed | c then co |
    When the user types 'c' in the Description search box
    And Without pressing Enter, observe the grid
    And the user types 'o' so the box reads 'co'
    Then Grid updates after each keystroke without Enter or a search button
    And After 'co' only 'Consultancy' is shown

  # Ref: US-6 AC-2; FRD 5.2 FB-4
  @TC_MC_034 @Functional @High @Automation
  Scenario: Verify Active search 'Active' shows only active members
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Active search | Active |
    When the user selects 'Active' in the Active search dropdown
    Then 5 members shown (Project, RepairAndMaintenance, Consultancy, Others, OriginalWork); 'Modernization' is not shown

  # Ref: US-6 AC-2; FRD 5.2 FB-4
  @TC_MC_035 @Functional @High @Automation
  Scenario: Verify Active search 'Inactive' shows only inactive members
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Active search | Inactive |
    When the user selects 'Inactive' in the Active search dropdown
    Then Only 'Modernization' is shown

  # Ref: FRD 5.2 FB-4; FRD 5.2 FB-5
  @TC_MC_036 @Functional @Medium @Automation
  Scenario: Verify Active search 'All' shows both active and inactive members
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Active search | Inactive then All |
    When the user selects 'Inactive' in the Active search dropdown
    And the user selects 'All' in the Active search dropdown
    Then All 6 members are shown

  # Ref: US-6 AC-3; FRD 5.2 FB-5
  @TC_MC_037 @Functional @High @Automation
  Scenario: Verify several column search values are combined with AND
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member Name search | o                                                                                                 |
      | Active search      | Inactive (Member Names containing 'o': Project, Modernization, Consultancy, Others, OriginalWork) |
    When the user types 'o' in the Member Name search box
    And the user selects 'Inactive' in the Active search dropdown
    Then Only 'Modernization' is shown (matches both searches)

  # Ref: FRD 5.2 FB-5
  @TC_MC_038 @Functional @Medium @Automation
  Scenario: Verify clearing the searches shows the full list on page 1
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description search | 120, then cleared |
    When the user types '120' in the Description search box
    And the user clears the Description search box
    And the user observes the grid
    Then Full list is shown again on page 1 with indicator '1 / 3' and Sl. No. 1 to 50

  # Ref: US-6 AC-3; FRD 5.2 FB-7; FRD 5.2 ES-When
  @TC_MC_039 @Functional @High @Automation
  Scenario: Verify the grid shows 'No records found.' when members exist but none matches the search
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description search | zzz |
    When the user types 'zzz' in the Description search box
    Then Grid shows 'No records found.'
    And Column headers and search boxes stay visible; the empty state with illustration is not shown

  # Ref: FRD 5.2 FB-6; FRD 5.4 FB-5
  @TC_MC_040 @Functional @Medium @Automation
  Scenario: Verify enum, page and search values are kept after an Edit
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected on page 2 with Description search 'member' (matches all 120 members)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum    | TestEnum120        |
      | Page            | 2                  |
      | Search          | member             |
      | Member          | TE120_075          |
      | New Description | Member 075 Revised |
    When the user edits member 'TE120_075' (Description 'Member 075') and change Description to 'Member 075 Revised'
    And the user clicks Save
    And the user observes the screen
    Then Edit pop-up closes and list refreshes
    And Same Product Enum, search value 'member' and page 2 are still shown
    And Row 'TE120_075' shows 'Member 075 Revised'

  # Ref: FRD 5.2 FB-6; FRD 5.5 FB-2
  @TC_MC_041 @Functional @Medium @Automation
  Scenario: Verify enum, page and search values are kept after an Active change from the list
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'Tender Type' is selected with Description search 'tender'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | Tender Type   |
      | Search       | tender        |
      | Member       | LimitedTender |
    When the user unchecks the Active checkbox of 'LimitedTender'
    And the user observes the screen
    Then List refreshes; Product Enum stays 'Tender Type' and the search value 'tender' stays
    And 'LimitedTender' is shown unchecked
