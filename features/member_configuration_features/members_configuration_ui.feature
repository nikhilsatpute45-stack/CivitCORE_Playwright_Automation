@MembersConfiguration @MembersConfigurationUi
Feature: Members Configuration UI
  Automated scenarios for the "Members Configuration UI" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.2 FB-4
  @TC_MC_116 @UIVisual @Medium @Automation
  Scenario: Verify the Active column search is a dropdown with All, Active and Inactive and defaults to All
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Options | All      |
      | Data    | Active   |
      | Data    | Inactive |
    When the user observes the Active column search control
    And the user opens the dropdown
    Then Active search is a dropdown (not free text) with options All, Active, Inactive
    And Default selection is 'All'

  # Ref: FRD 5.2 FB-4
  @TC_MC_117 @UIVisual @Low @Automation
  Scenario: Verify Sl. No. and Actions columns have no search box
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Columns | Sl. No., Actions |
    When the user observes the cells below the 'Sl. No.' and 'Actions' headers
    Then No search box is shown for Sl. No. or Actions

  # Ref: FRD 5.1 FB-3; FRD 5.2 C-Actions
  @TC_MC_118 @UIVisual @Medium @Automation
  Scenario: Verify a kebab (⋮) icon is shown in the Actions column of every row
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | Proposal Nature |
    When the user observes the Actions column of all 6 rows
    Then Every row shows a kebab (⋮) icon in the Actions column

  # Ref: US-1 AC-6; FRD 5.1 BR-4; FRD 5.7 BR-2
  @TC_MC_119 @UIVisual @High @Automation
  Scenario: Verify no Add button is shown on the Member List
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enums | Proposal Nature, Tender Type |
    When the user observes the toolbar and grid area for 'Proposal Nature'
    And the user selects 'Tender Type' and observe again
    Then No Add button is shown for any Product Enum

  # Ref: US-1 AC-6; FRD 5.1 BR-4; FRD 5.7 BR-2
  @TC_MC_120 @UIVisual @High @Automation
  Scenario: Verify no Delete option is available anywhere on the screen
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project |
    When the user opens the kebab menu of a row
    And the user opens View Member and Edit Member pop-ups
    And the user looks for any delete control
    Then No Delete option is present in the kebab menu, View Member, Edit Member or elsewhere on the screen

  # Ref: FRD 5.2 C-Active; US-4 AC-1
  @TC_MC_121 @UIVisual @Medium @Automation
  Scenario: Verify Active checkboxes are enabled for a user with Edit permission
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1 |
    When the user observes the Active checkboxes in the list
    Then All Active checkboxes are enabled (editable in place)

  # Ref: US-4 AC-6; FRD 5.2 C-Active
  @TC_MC_122 @UIVisual @High @Automation
  Scenario: Verify Active checkboxes are disabled for a user without Edit permission
    Given Viewer_User1 (Members Configuration: View only) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user observes the Active checkboxes in the list
    Then All Active checkboxes are shown but disabled

  # Ref: FRD 5.2 ES-Grid; US-1 AC-5
  @TC_MC_127 @UIVisual @Medium @Automation
  Scenario: Verify column headers, column search and pagination are not shown in the empty state
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | Estate House Type |
    When the user selects 'Estate House Type'
    And the user observes the area below the dropdown
    Then Column headers, column search boxes and pagination are not shown

  # Ref: FRD 5.4 F-Save; FRD 5.4 F-Cancel; FRD 5.4 FB-3
  @TC_MC_133 @UIVisual @Medium @Automation
  Scenario: Verify Save and Cancel are enabled when the Edit pop-up opens
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user observes the Save and Cancel buttons without changing anything
    Then 'Save' and 'Cancel' are both enabled on open (Save is always enabled)

  # Ref: FRD Sec 7 FE-Note
  @TC_MC_136 @UIVisual @Medium @Automation
  Scenario: Verify the field error clears as soon as the user corrects the field
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description | blank then 'Capital Project' |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user clears Description
    And the user clicks 'Save'
    And the user types 'Capital Project' in Description
    Then 'Description is required.' and the red border disappear as soon as a value is typed
