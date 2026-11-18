@MembersConfiguration @MemberView
Feature: Member View
  Automated scenarios for the "Member View" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-1; FRD 5.3 FB-1; FRD 5.3 FB-2
  @TC_MC_044 @Functional @High @Automation
  Scenario: Verify View opens the View Member pop-up with all required read-only details
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | RepairAndMaintenance |
    When the user clicks the kebab (⋮) icon of member 'RepairAndMaintenance'
    And the user selects 'View'
    And the user observes the pop-up
    Then 'View Member' pop-up opens showing Product Enum 'Proposal Nature', Member Name 'RepairAndMaintenance', Description 'AMC', Active (checked, 'Yes'), Last Modified By and Last Modified On
    And All fields are read-only

  # Ref: FRD 5.3 FB-2
  @TC_MC_045 @Functional @Medium @Automation
  Scenario: Verify Last Modified By and Last Modified On show '-' for a member never modified
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Member 'Consultancy' has never been modified from the screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Consultancy |
    When the user clicks the kebab (⋮) icon of member 'Consultancy'
    And the user selects 'View'
    Then Last Modified By shows '-'
    And Last Modified On shows '-'

  # Ref: FRD 5.3 FB-2
  @TC_MC_046 @Functional @Medium @Automation
  Scenario: Verify Active is shown as a disabled checkbox with text 'No' for an inactive member
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Modernization (inactive) |
    When the user clicks the kebab (⋮) icon of member 'Modernization'
    And the user selects 'View'
    Then Active shows a disabled, unchecked checkbox with the text 'No'

  # Ref: FRD 5.3 FB-2
  @TC_MC_047 @Functional @Medium @Automation
  Scenario: Verify Active is shown as a disabled checkbox with text 'Yes' for an active member
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project (active) |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'View'
    Then Active shows a disabled, checked checkbox with the text 'Yes'

  # Ref: FRD 5.3 FB-2; FRD 5.4 FB-5
  @TC_MC_048 @Functional @Medium @Automation
  Scenario: Verify View shows Last Modified By and Last Modified On after the member has been updated
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Admin_User1 has just changed Description of 'Others' to 'Miscellaneous' and saved
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others      |
      | Modified by | Admin_User1 |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'View'
    Then Last Modified By shows 'Admin_User1'
    And Last Modified On shows the date and time of the save

  # Ref: FRD 5.3 BR-2; US-2 AC-1
  @TC_MC_049 @Functional @High @Automation
  Scenario: Verify a View-only user can open View Member
    Given Viewer_User1 (Members Configuration: View only) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1 |
      | Member | Project      |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'View'
    Then 'View Member' pop-up opens with the member's details

  # Ref: US-2 AC-2; FRD 5.3 FB-3
  @TC_MC_050 @Functional @High @Automation
  Scenario: Verify the Edit button in View Member opens Edit Member for the same member for a user with Edit permission
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'View'
    And the user clicks 'Edit' in the pop-up
    Then 'Edit Member' pop-up opens for 'Project' in editable state (Description and Active editable, Member Name read-only)

  # Ref: US-2 AC-2; FRD 5.3 FB-4
  @TC_MC_051 @Functional @Medium @Automation
  Scenario: Verify Close in View Member returns to the list with the same enum, page and search values
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected on page 2 with Description search 'member'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | TestEnum120 |
      | Page         | 2           |
      | Search       | member      |
      | Member       | TE120_060   |
    When the user clicks the kebab (⋮) icon of member 'TE120_060'
    And the user selects 'View'
    And the user clicks 'Close'
    Then Pop-up closes; the same Product Enum, page 2 and search value are shown

  # Ref: FRD 5.3 FB-4
  @TC_MC_052 @Functional @Medium @Automation
  Scenario: Verify the close (X) icon in View Member returns to the list with the same enum, page and search values
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'TestEnum120' is selected on page 2 with Description search 'member'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | TestEnum120 |
      | Page         | 2           |
      | Search       | member      |
    When the user clicks the kebab (⋮) icon of member 'TE120_060'
    And the user selects 'View'
    And the user clicks the close (X) icon
    Then Pop-up closes; the same Product Enum, page 2 and search value are shown

  # Ref: US-2 AC-3; FRD 5.3 BR-1
  @TC_MC_053 @Functional @High @Automation
  Scenario: Verify View changes no data and creates no Activity Log entry
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Activity Log entry count for member 'Project' is noted (0)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'View'
    And the user clicks 'Close'
    And As Auditor_User1 open the Activity Log section and search member 'Project'
    Then Member record (Description, Active, Last Modified By/On) is unchanged
    And No Activity Log entry exists for the View action
