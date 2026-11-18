@MiscellaneousMaster @MiscellaneousMasterInitiation
Feature: Miscellaneous Master Initiation
  Automated scenarios for the "Miscellaneous Master Initiation" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 FB-1; FRD 5.1 FB-2; Section 4 AC-SC-1
  @TC_MM_001 @Functional @High @Automation
  Scenario: Verify Title List loads as the landing view with the Add button above the grid
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User      | Admin_User1                                  |
      | Menu path | Admin > Configuration > Miscellaneous Master |
    When the user logs in to CivitINFRA as Admin_User1
    And From the left navigation tree open Admin > Configuration > Miscellaneous Master
    And the user observes the page that loads
    Then Title List is displayed by default as the landing view
    And The 'Add' button is displayed above the grid

  # Ref: Section 4 AC-SC-2; FRD 5.1 FB-2
  @TC_MM_002 @Functional @High @Automation
  Scenario: Verify Add button is displayed for a user with Add permission
    Given Adder_User1 (Miscellaneous Master: View/Add) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Adder_User1 |
      | Permissions | View + Add  |
    When the user opens Miscellaneous Master
    And the user inspects the area above the grid
    Then The 'Add' button is displayed above the grid

  # Ref: Section 4 AC-SC-2; FRD 5.1 FB-2
  @TC_MM_003 @Functional @High @Automation
  Scenario: Verify Add button is not displayed for a user without Add permission
    Given Viewer_User1 (Miscellaneous Master: View only) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Viewer_User1 |
      | Permissions | View only    |
    When the user opens Miscellaneous Master
    And the user inspects the area above the grid
    Then Title List is displayed
    And The 'Add' button is not displayed

  # Ref: Section 4 AC-SC-3; FRD 5.1 FB-3
  @TC_MM_004 @Functional @Medium @Automation
  Scenario: Verify kebab menu shows View, Edit and Delete for a user holding all permissions
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1      |
      | Row  | List of Operator |
    When the user clicks the kebab icon on the row 'List of Operator'
    And the user observes the menu options
    Then Menu shows View, Edit and Delete

  # Ref: Section 4 AC-SC-3; FRD 5.1 FB-3
  @TC_MM_005 @Functional @Medium @Automation
  Scenario: Verify kebab menu shows only View and Edit for a user without Delete permission
    Given Editor_User1 (Miscellaneous Master: View/Edit) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Editor_User1     |
      | Permissions | View + Edit      |
      | Row         | List of Operator |
    When the user clicks the kebab icon on the row 'List of Operator'
    And the user observes the menu options
    Then Menu shows only View and Edit; Delete is not shown

  # Ref: Section 4 AC-SC-3; FRD 5.1 FB-3
  @TC_MM_006 @Functional @Medium @Automation
  Scenario: Verify kebab menu shows only View and Delete for a user without Edit permission
    Given Deleter_User1 (Miscellaneous Master: View/Delete) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Deleter_User1  |
      | Permissions | View + Delete  |
      | Row         | Obsolete Field |
    When the user clicks the kebab icon on the row 'Obsolete Field'
    And the user observes the menu options
    Then Menu shows only View and Delete; Edit is not shown

  # Ref: Section 4 AC-SC-3; FRD 5.1 FB-3
  @TC_MM_007 @Functional @Medium @Automation
  Scenario: Verify kebab menu shows only View for a view-only user
    Given Viewer_User1 (Miscellaneous Master: View only) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Viewer_User1     |
      | Permissions | View only        |
      | Row         | List of Operator |
    When the user clicks the kebab icon on the row 'List of Operator'
    And the user observes the menu options
    Then Menu shows only View; Edit and Delete are not shown

  # Ref: FRD 5.1 FB-4
  @TC_MM_008 @Functional @Medium @Automation
  Scenario: Verify Esc closes an open kebab menu without performing any action
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | List of Operator |
    When the user clicks the kebab icon on the row 'List of Operator'
    And the user presses the Esc key
    And the user observes the page
    Then The kebab menu closes
    And No pop-up opens and no data changes

  # Ref: FRD 5.1 FB-4
  @TC_MM_009 @Functional @Medium @Automation
  Scenario: Verify clicking outside an open kebab menu closes it without performing any action
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | List of Operator |
    When the user clicks the kebab icon on the row 'List of Operator'
    And the user clicks on an empty area of the page outside the menu
    And the user observes the page
    Then The kebab menu closes
    And No pop-up opens and no data changes

  # Ref: FRD 5.1 FB-4
  @TC_MM_010 @Functional @Medium @Automation
  Scenario: Verify only one kebab menu can be open at a time
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rows | List of Title, List of Operator |
    When the user clicks the kebab icon on the row 'List of Title'
    And Without closing it, click the kebab icon on the row 'List of Operator'
    And the user counts the open menus
    Then Only the menu of 'List of Operator' is open; the menu of 'List of Title' is closed

  # Ref: FRD 5.3 BR-1; FRD 5.1 BR-1
  @TC_MM_011 @Functional @Medium @Automation
  Scenario: Verify Title List is available to a user holding only View permission
    Given Viewer_User1 (Miscellaneous Master: View only) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Viewer_User1 |
      | Permissions | View only    |
      | Search      | firm         |
    When the user opens Miscellaneous Master
    And the user scrolls through the list and use the column search on Title with 'firm'
    Then All 18 baseline Titles are listed
    And Column search returns 'List of Firm Type'; list access does not depend on Add, Edit or Delete permission

  # Ref: FRD 5.1 BR-1
  @TC_MM_012 @Functional @High @Automation
  Scenario: Verify permissions are driven by the role: two users of the same role get identical actions and a role change applies to both
    Given Admin_User1 and Admin_User2 are both assigned role 'Infra Admin' (View/Add/Edit/Delete)
    And A Role Admin account is available
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Users  | Admin_User1, Admin_User2 |
      | Role   | Infra Admin              |
      | Change | remove Delete            |
    When the user logs in as Admin_User1 and open the kebab on 'Obsolete Field'; note the actions
    And the user logs in as Admin_User2 (same role 'Infra Admin') and repeat
    And As Role Admin remove Delete from role 'Infra Admin' and re-login both users
    And the user opens the kebab on 'Obsolete Field' for both users
    Then Both users initially see View, Edit, Delete
    And After the role change both users see only View and Edit; permissions follow the role, not the individual user
