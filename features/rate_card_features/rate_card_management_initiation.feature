@RateCard @RateCardManagementInitiation
Feature: Rate Card Management Initiation
  Automated scenarios for the "Rate Card Management Initiation" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 FB-1; FRD 5.1 FB-2; FRD 3 Overview; US-1 AC-1
  @TC_RC_001 @Functional @Medium @Automation
  Scenario: Verify the Rate Card List loads from Admin > Configuration > Rate Card when at least one Rate Card exists
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the application home page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User      | Admin_User1                       |
      | Menu path | Admin > Configuration > Rate Card |
    When the user logs in to CivitINFRA as Admin_User1
    And In the left navigation tree, expand Admin > Configuration
    And the user clicks 'Rate Card'
    And the user observes the page that loads
    Then Rate Card List is displayed (not the empty state)
    And Grid shows the 8 baseline Rate Cards in display sequence

  # Ref: FRD 5.1 FB-2; US-1 AC-3
  @TC_RC_002 @Functional @Medium @Automation
  Scenario: Verify the 'Add' button is shown above the grid for a user with Add permission
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User       | Admin_User1 |
      | Permission | Add         |
    When the user observes the area above the Rate Card grid
    Then An 'Add' button is displayed above the grid and is enabled

  # Ref: FRD 5.1 FB-3; US-1 AC-4
  @TC_RC_003 @Functional @Medium @Automation
  Scenario: Verify the kebab (⋮) menu shows View, Edit and Delete for a user holding all permissions
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1    |
      | Row  | Coastal Region |
    When the user clicks the kebab (⋮) icon on the row 'Coastal Region'
    And the user observes the menu options
    Then Menu opens with exactly View, Edit and Delete
    And Delete remains subject to the dependency check of Section 5.8 (checked on click)

  # Ref: FRD 5.1 BR-2; US-1 AC-4
  @TC_RC_004 @Functional @High @Automation
  Scenario: Verify the kebab menu shows only View and Edit for a user with View+Edit permission
    Given Editor_User1 (Rate Card: View+Edit) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Editor_User1   |
      | Row  | Coastal Region |
    When the user clicks the kebab (⋮) icon on the row 'Coastal Region'
    And the user observes the menu options
    Then Only View and Edit are listed; Delete is not displayed

  # Ref: FRD 5.1 BR-2; US-1 AC-4
  @TC_RC_005 @Functional @High @Automation
  Scenario: Verify the kebab menu shows only View and Delete for a user with View+Delete permission
    Given Deleter_User1 (Rate Card: View+Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Deleter_User1  |
      | Row  | Coastal Region |
    When the user clicks the kebab (⋮) icon on the row 'Coastal Region'
    And the user observes the menu options
    Then Only View and Delete are listed; Edit is not displayed

  # Ref: FRD 5.3 BR-1; FRD 5.1 BR-2; US-1 AC-3; US-1 AC-4
  @TC_RC_006 @Functional @High @Automation
  Scenario: Verify a View-only user sees the Rate Card List with only 'View' in the kebab menu and no 'Add' button
    Given Viewer_User1 (Rate Card: View only) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1    |
      | Row  | Sub Mountanious |
    When the user observes the area above the grid
    And the user clicks the kebab (⋮) icon on the row 'Sub Mountanious'
    And the user observes the menu options
    Then Rate Card List is displayed (list is available to any user holding View permission)
    And 'Add' button is not displayed
    And Kebab menu lists only View

  # Ref: FRD 5.1 BR-2; US-1 AC-3; US-1 AC-4
  @TC_RC_007 @Functional @Medium @Automation
  Scenario: Verify a user with View+Add permission sees the 'Add' button but only 'View' in the kebab menu
    Given Adder_User1 (Rate Card: View+Add) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Adder_User1     |
      | Row  | Sub Mountanious |
    When the user observes the area above the grid
    And the user clicks the kebab (⋮) icon on the row 'Sub Mountanious'
    And the user observes the menu options
    Then 'Add' button is displayed
    And Kebab menu lists only View (no Edit, no Delete)

  # Ref: FRD 5.1 FB-4
  @TC_RC_008 @Functional @Medium @Automation
  Scenario: Verify clicking anywhere outside an open kebab menu closes it without performing any action
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Coastal Region |
    When the user clicks the kebab (⋮) icon on the row 'Coastal Region'
    And the user clicks on an empty area of the page outside the menu
    Then Menu closes
    And No pop-up opens, no toaster is displayed and no data changes

  # Ref: FRD 5.1 FB-4
  @TC_RC_009 @Functional @Medium @Automation
  Scenario: Verify pressing Esc closes an open kebab menu without performing any action
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Coastal Region |
    When the user clicks the kebab (⋮) icon on the row 'Coastal Region'
    And the user presses the Esc key
    Then Menu closes
    And No pop-up opens, no toaster is displayed and no data changes

  # Ref: FRD 5.1 FB-4
  @TC_RC_010 @Functional @Medium @Automation
  Scenario: Verify only one kebab menu can be open at a time
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rows | Coastal Region, Desert Zone |
    When the user clicks the kebab (⋮) icon on the row 'Coastal Region'
    And the user clicks the kebab (⋮) icon on the row 'Desert Zone' without closing the first menu
    And the user counts the open menus
    Then The menu of 'Coastal Region' closes
    And Only the menu of 'Desert Zone' is open

  # Ref: FRD 5.1 BR-1
  @TC_RC_011 @Functional @High @Automation
  Scenario: Verify permissions are assigned to roles, so removing Edit from a role removes Edit for every user holding that role
    Given Admin_User1 can edit role 'Rate Card Maintainer' in Role Entitlement
    And Editor_User1 holds the role 'Rate Card Maintainer' (View+Edit)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Rate Card Maintainer |
      | User | Editor_User1         |
    When As Admin_User1, remove the 'Edit' permission of Rate Card from role 'Rate Card Maintainer' and save
    And the user logs in as Editor_User1 (holder of that role)
    And the user opens Admin > Configuration > Rate Card and click the kebab (⋮) on 'Coastal Region'
    Then Edit is no longer offered to Editor_User1 without any change made on the user record
    And Only View is listed
