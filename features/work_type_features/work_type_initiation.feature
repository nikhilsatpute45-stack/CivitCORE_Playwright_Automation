@WorkType @WorkTypeInitiation
Feature: Work Type Initiation
  Automated scenarios for the "Work Type Initiation" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-1; FRD 5.1 FB-1; FRD 5.1 FB-2; FRD 5.3 FB-1
  @TC_WT_001 @Functional @High @Automation
  Scenario: Verify Work Type List loads with the required columns, newest first, and an 'Add' button above the grid
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA. Baseline data (see Summary) is loaded
    And the following test data is used
      | User       | Admin_User1        |
      | Work Types | 9 baseline records |
    When the user logs in as Admin_User1
    And the user navigates to Admin > Configuration > Work Category > Work Type
    And the user observes the page that loads
    Then Work Type List is displayed with the columns Sl. No., Work Type Name, Work Type and Actions
    And Records are listed newest first: Boundary Wall (Sl. No. 1), Apron (2), Taxiway (3), Parking Bay (4), Fuel Farm (5), Control Tower (6), Hanger (7), Terminal Building (8), Runway (9)
    And An 'Add' button is displayed above the grid

  # Ref: US-1 AC-2; FRD 5.1 FB-3; FRD 5.3 Empty State
  @TC_WT_002 @Functional @High @Automation
  Scenario: Verify the empty state is displayed when no Work Type exists
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in
    And No Work Type exists in the system
    And the following test data is used
      | User       | Admin_User1 |
      | Work Types | none        |
    When the user navigates to Admin > Configuration > Work Category > Work Type
    And the user observes the page that loads
    Then Empty state is displayed instead of the grid, with heading 'No Work Types added yet' and message 'Click Add to create your first Work Type.'
    And An 'Add' button is displayed below the message

  # Ref: US-1 AC-3; FRD 5.1 BR-2
  @TC_WT_003 @Functional @High @Automation
  Scenario: Verify the 'Add' button on the Work Type List is displayed to a user with Add permission
    Given Adder_User1 (Work Type: View+Add) is logged in to CivitINFRA and and Work Types exist
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Adder_User1 (View+Add) |
    When the user navigates to Admin > Configuration > Work Category > Work Type
    And the user observes the area above the grid
    Then 'Add' button is visible above the grid
    And Rule: 'Add' is displayed only with Add permission

  # Ref: US-1 AC-3; FRD 5.3 Empty State Add button
  @TC_WT_004 @Functional @High @Automation
  Scenario: Verify the 'Add' button on the empty state opens the Add Work Type pop-up for a user with Add permission
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in
    And No Work Type exists in the system
    And the following test data is used
      | User       | Admin_User1 |
      | Work Types | none        |
    When the user navigates to Admin > Configuration > Work Category > Work Type
    And the user clicks the 'Add' button shown below the message
    Then 'Add Work Type' pop-up opens over the screen

  # Ref: US-1 AC-4; FRD 5.1 FB-4
  @TC_WT_005 @Functional @High @Automation
  Scenario: Verify the kebab menu shows View, Edit and Delete for a user holding all four permissions
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway     |
      | User      | Admin_User1 |
    When the user clicks the kebab (⋮) icon on the row 'Taxiway'
    And the user observes the menu options
    Then Menu lists View, Edit and Delete

  # Ref: US-1 AC-4; FRD 5.1 BR-2
  @TC_WT_006 @Functional @High @Automation
  Scenario: Verify the kebab menu shows only View for a view-only user
    Given Viewer_User1 (Work Type: View only) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway                  |
      | User      | Viewer_User1 (View only) |
    When the user clicks the kebab (⋮) icon on the row 'Taxiway'
    And the user observes the menu options
    Then Menu lists only View; Edit and Delete are not displayed

  # Ref: US-1 AC-4; FRD 5.1 BR-2
  @TC_WT_007 @Functional @High @Automation
  Scenario: Verify the kebab menu shows View and Edit but not Delete for a user with Edit permission
    Given Editor_User1 (Work Type: View+Edit) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway                  |
      | User      | Editor_User1 (View+Edit) |
    When the user clicks the kebab (⋮) icon on the row 'Taxiway'
    And the user observes the menu options
    Then Menu lists View and Edit; Delete is not displayed

  # Ref: US-1 AC-4; FRD 5.1 BR-2
  @TC_WT_008 @Functional @High @Automation
  Scenario: Verify the kebab menu shows View and Delete but not Edit for a user with Delete permission
    Given Deleter_User1 (Work Type: View+Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway                     |
      | User      | Deleter_User1 (View+Delete) |
    When the user clicks the kebab (⋮) icon on the row 'Taxiway'
    And the user observes the menu options
    Then Menu lists View and Delete; Edit is not displayed

  # Ref: FRD 5.3 BR-1; US-1 AC-1; US-1 AC-3
  @TC_WT_009 @Functional @High @Automation
  Scenario: Verify the Work Type List is available to a user holding only View permission
    Given Viewer_User1 (Work Type: View only) is logged in to CivitINFRA and has just logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 (View only) |
    When the user navigates to Admin > Configuration > Work Category > Work Type
    And the user observes the page
    Then Work Type List is displayed; 'Add' button is not displayed
    And Rule: the list is available to any user with View permission independent of Add, Edit or Delete

  # Ref: FRD 5.1 BR-1; FRD 5.1 BR-2
  @TC_WT_010 @Functional @High @Automation
  Scenario: Verify permissions follow the role: removing Delete from the role removes Delete from the kebab menu
    Given Deleter_User1 is assigned role 'WT Deleter' (Work Type: View+Delete) and is logged in on the Work Type List
    And An administrator can edit role permissions
    And the following test data is used
      | Role               | WT Deleter |
      | Permission removed | Delete     |
    When the user clicks the kebab on 'Taxiway' and confirm Delete is listed
    And the user removes the Delete permission from role 'WT Deleter' and save
    And the user logs in again as Deleter_User1
    And the user clicks the kebab on 'Taxiway'
    Then Before the change, Delete is listed
    And After the change, Delete is not listed; only View remains
    And Rule: permissions are assigned to roles, not individual users

  # Ref: FRD 5.1 FB-5
  @TC_WT_011 @Functional @Medium @Automation
  Scenario: Verify an open kebab menu closes when the user clicks outside it
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user clicks the kebab on 'Taxiway'
    And the user clicks on an empty area outside the menu
    Then Menu closes and no action (View/Edit/Delete) is performed

  # Ref: FRD 5.1 FB-5
  @TC_WT_012 @Functional @Medium @Automation
  Scenario: Verify an open kebab menu closes when Esc is pressed
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user clicks the kebab on 'Taxiway'
    And the user presses Esc
    Then Menu closes and no action is performed

  # Ref: FRD 5.1 FB-5
  @TC_WT_013 @Functional @Medium @Automation
  Scenario: Verify only one kebab menu can be open at a time
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Types | Taxiway, Apron |
    When the user clicks the kebab on 'Taxiway'
    And the user clicks the kebab on 'Apron' without closing the first menu
    Then The menu of 'Taxiway' closes and only the menu of 'Apron' is open
