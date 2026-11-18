@MembersConfiguration @MembersConfigurationInitiation
Feature: Members Configuration Initiation
  Automated scenarios for the "Members Configuration Initiation" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 FB-1; FRD 5.1 FB-2; US-1 AC-1
  @TC_MC_001 @Functional @High @Automation
  Scenario: Verify Members Configuration opens from the left navigation with the first Product Enum selected and its Member List shown
    Given Admin_User1 (Members Configuration: View + Edit) is logged in to CivitINFRA on the home page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User      | Admin_User1                                   |
      | Menu path | Admin > Configuration > Members Configuration |
    When the user expands 'Admin' in the left navigation tree
    And the user expands 'Configuration'
    And the user clicks 'Members Configuration'
    And the user observes the screen
    Then Members Configuration screen opens
    And Product Enum dropdown is displayed at the top with 'Proposal Nature' (first Product Enum) selected
    And Member List of 'Proposal Nature' is displayed below the dropdown (6 members)

  # Ref: US-1 AC-1; FRD 5.2 BR-1
  @TC_MC_002 @Functional @High @Automation
  Scenario: Verify a View-only user can open the screen and see the Member List
    Given Viewer_User1 (Members Configuration: View only) is logged in to CivitINFRA. Baseline data (see Summary) is loaded
    And the following test data is used
      | User       | Viewer_User1 |
      | Permission | View         |
    When the user navigates to Admin > Configuration > Members Configuration
    And the user observes the screen
    Then Screen opens with 'Proposal Nature' selected and its 6 members listed
    And List is available because the user holds View permission

  # Ref: FRD 5.1 FB-3; US-1 AC-7
  @TC_MC_003 @Functional @High @Automation
  Scenario: Verify the kebab menu shows View and Edit for a user with View and Edit permission
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Admin_User1 |
      | Member | Project     |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user observes the menu items
    Then Kebab menu shows exactly 'View' and 'Edit'
    And No 'Delete' option is shown

  # Ref: US-4 AC-6; FRD 5.1 FB-3
  @TC_MC_004 @Functional @High @Automation
  Scenario: Verify the kebab menu shows only View for a user without Edit permission
    Given Viewer_User1 (Members Configuration: View only) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1 |
      | Member | Project      |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user observes the menu items
    Then Kebab menu shows 'View' only; 'Edit' is not offered

  # Ref: FRD 5.1 FB-4
  @TC_MC_005 @Functional @Medium @Automation
  Scenario: Verify clicking outside an open kebab menu closes it without performing any action
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user clicks on an empty area outside the menu
    Then Kebab menu closes
    And No pop-up opens and no data changes; no toaster is displayed

  # Ref: FRD 5.1 FB-4
  @TC_MC_006 @Functional @Medium @Automation
  Scenario: Verify pressing Esc closes an open kebab menu without performing any action
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project |
      | Key    | Esc     |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user presses the Esc key
    Then Kebab menu closes
    And No pop-up opens and no data changes

  # Ref: FRD 5.1 BR-1
  @TC_MC_007 @Functional @High @Automation
  Scenario: Verify permissions are role-based: granting Edit to the role of a View-only user enables Edit for that user
    Given Viewer_User1 (Members Configuration: View only) belongs to role 'Role_MemberViewer'
    And Admin_User1 can open Role Permission Configuration
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role             | Role_MemberViewer |
      | Permission added | Edit              |
      | User             | Viewer_User1      |
    When As Admin_User1, add the 'Edit' permission of Members Configuration to role 'Role_MemberViewer'
    And the user logs in as Viewer_User1 again
    And the user opens Members Configuration
    And the user clicks the kebab (⋮) icon of member 'Project'
    Then Kebab menu now shows 'View' and 'Edit'; Active checkboxes are enabled
    And Permission came through the role; no per-user permission was assigned
