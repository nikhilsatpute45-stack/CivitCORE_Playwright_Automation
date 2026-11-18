@WorkSubType @WorkSubTypeInitiation
Feature: Work Sub Type Initiation
  Automated scenarios for the "Work Sub Type Initiation" module of Work Sub Type.
  Source: CivitINFRA_WorkSubType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-006_CivitINFRA Configuration_Work Sub Type.pdf (PRD Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 FB-1; FRD 5.1 FB-2; US-1 AC-1; FRD Fig 1
  @TC_WST_001 @Functional @High @Automation
  Scenario: Verify the Work Sub Type screen opens from the left navigation and shows the hierarchical list with an 'Add' button
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in to CivitINFRA. At least one Work Type exists
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1                                           |
      | Path | Admin > Configuration > Work Category > Work Sub Type |
    When the user logs in to CivitINFRA as Admin_User1
    And the user expands Admin in the left navigation tree
    And the user expands Configuration, then Work Category
    And the user clicks Work Sub Type
    Then The Work Sub Type screen opens with the hierarchical Work Sub Type List (one row per Work Type with its Work Sub Types beneath)
    And The 'Add' button is displayed above the list

  # Ref: FRD 5.1 FB-4; US-1 AC-8
  @TC_WST_008 @Functional @High @Automation
  Scenario: Verify the kebab (⋮) menu is available in the Actions column of every Work Sub Type row with Add Sub Work Type, View, Edit and Delete for Levels 1-3
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rows | NH (L1)       |
      | Data | NH-SEC (L2)   |
      | Data | NH-SEC-A (L3) |
    When the user clicks the kebab (⋮) icon of Level 1 row 'NH - National Highway'
    And the user closes the menu and click the kebab icon of Level 2 row 'NH-SEC - NH Sections'
    And the user closes the menu and click the kebab icon of Level 3 row 'NH-SEC-A - Section A'
    Then Each of the three kebab menus shows 'Add Sub Work Type', 'View', 'Edit' and 'Delete'

  # Ref: US-1 AC-8; US-3 AC-3; FRD 5.1 FB-4
  @TC_WST_009 @Functional @High @Automation
  Scenario: Verify the kebab menu of a Level 4 Work Sub Type does not offer 'Add Sub Work Type'
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | NH-SEC-A1 - Sub Section A1 (Level 4) |
    When the user clicks the kebab (⋮) icon of Level 4 row 'NH-SEC-A1 - Sub Section A1'
    And the user observes the menu options
    Then Menu shows View, Edit and Delete only
    And 'Add Sub Work Type' is never displayed, so no fifth level can be created

  # Ref: US-1 AC-7; FRD 5.1 FB-5; FRD 5.7 BR-6
  @TC_WST_010 @Functional @High @Automation
  Scenario: Verify Work Type rows show only the 'Add Sub Work Type' option and no kebab menu, View, Edit or Delete
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Road (Work Type) |
    When the user observes the Actions column of Work Type row 'Road'
    And the user right-clicks the 'Road' row
    Then Only the 'Add Sub Work Type' option is shown on the Work Type row
    And No kebab icon, View, Edit or Delete is shown
    And The old right-click menu is not provided

  # Ref: FRD 5.1 FB-6
  @TC_WST_011 @Functional @Medium @Automation
  Scenario: Verify clicking outside an open kebab menu closes it without performing any action
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | SH - State Highway |
    When the user clicks the kebab (⋮) icon of 'SH - State Highway'
    And the user clicks on an empty area outside the menu
    Then The menu closes and no action (View/Edit/Delete/Add) is performed

  # Ref: FRD 5.1 FB-6
  @TC_WST_012 @Functional @Medium @Automation
  Scenario: Verify pressing Esc closes an open kebab menu without performing any action
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | SH - State Highway |
    When the user clicks the kebab (⋮) icon of 'SH - State Highway'
    And the user presses the Esc key
    Then The menu closes and no action is performed

  # Ref: FRD 5.1 FB-6
  @TC_WST_013 @Functional @Medium @Automation
  Scenario: Verify only one kebab menu can be open at a time
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rows | SH, NH |
    When the user clicks the kebab (⋮) icon of 'SH - State Highway'
    And the user clicks the kebab (⋮) icon of 'NH - National Highway'
    Then The menu of 'SH' closes and only the menu of 'NH' is open

  # Ref: FRD 5.2 BR-8
  @TC_WST_086 @Functional @Medium @Automation
  Scenario: Verify the maximum level is configurable only in the backend and the current setting is 4
    Given Backend configuration access is available
    And Admin_User1 is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Backend setting | maximum levels = 4 |
    When the user opens the Work Sub Type screen and look for any maximum-level setting
    And the user checks the backend configuration value
    Then No screen allows changing the maximum level
    And Backend value is 4 and the screen allows Work Sub Types up to Level 4
