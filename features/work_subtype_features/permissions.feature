@WorkSubType @Permissions
Feature: Permissions
  Automated scenarios for the "Permissions" module of Work Sub Type.
  Source: CivitINFRA_WorkSubType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-006_CivitINFRA Configuration_Work Sub Type.pdf (PRD Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 BR-2; FRD 5.3 BR-1
  @TC_WST_003 @Functional @High @Automation
  Scenario: Verify a View-only user sees the list but no 'Add', 'Add Sub Work Type', Edit or Delete option
    Given Viewer_User1 (Work Sub Type: View only) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1          |
      | Row  | NH - National Highway |
    When the user observes the area above the list
    And the user observes a Work Type row ('Road')
    And the user clicks the kebab (⋮) icon of 'NH - National Highway'
    Then The list is displayed
    And 'Add' button and 'Add Sub Work Type' option on Work Type rows are not displayed
    And Kebab menu shows only 'View'; Add Sub Work Type, Edit and Delete are not displayed

  # Ref: FRD 5.1 BR-2
  @TC_WST_004 @Functional @High @Automation
  Scenario: Verify an Add-only user sees 'Add' and 'Add Sub Work Type' but not Edit or Delete
    Given Adder_User1 (Work Sub Type: View, Add) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Adder_User1        |
      | Row  | SH - State Highway |
    When the user observes the area above the list
    And the user observes the 'Road' Work Type row
    And the user clicks the kebab (⋮) icon of 'SH - State Highway'
    Then 'Add' button is displayed
    And 'Add Sub Work Type' is displayed on Work Type rows
    And Kebab menu shows Add Sub Work Type and View; Edit and Delete are not displayed

  # Ref: FRD 5.1 BR-2; US-4 AC-2
  @TC_WST_005 @Functional @High @Automation
  Scenario: Verify an Edit-only user sees Edit in the kebab menu and on the View pop-up but no Add or Delete
    Given Editor_User1 (Work Sub Type: View, Edit) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Editor_User1       |
      | Row  | SH - State Highway |
    When the user observes the area above the list
    And the user clicks the kebab (⋮) icon of 'SH - State Highway'
    And the user selects View
    And the user observes the buttons of the View pop-up
    Then 'Add' button and 'Add Sub Work Type' options are not displayed
    And Kebab menu shows View and Edit; Delete is not displayed
    And View pop-up shows the 'Edit' button

  # Ref: FRD 5.1 BR-2; US-4 AC-2
  @TC_WST_006 @Functional @High @Automation
  Scenario: Verify a Delete-only user sees Delete in the kebab menu but no Add or Edit (View pop-up has no Edit button)
    Given Deleter_User1 (Work Sub Type: View, Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Deleter_User1      |
      | Row  | SH - State Highway |
    When the user observes the area above the list
    And the user clicks the kebab (⋮) icon of 'SH - State Highway'
    And the user selects View
    And the user observes the buttons of the View pop-up
    Then 'Add' button and 'Add Sub Work Type' options are not displayed
    And Kebab menu shows View and Delete; Edit is not displayed
    And View pop-up shows only 'Close'; 'Edit' button is not displayed

  # Ref: US-4 AC-2; FRD 5.4 FB-3
  @TC_WST_007 @Functional @Medium @Automation
  Scenario: Verify the 'View Work Sub Type' pop-up shows the 'Edit' button only to users with Edit permission
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Admin_User1        |
      | Record | SH - State Highway |
    When the user clicks the kebab (⋮) icon of 'SH - State Highway'
    And the user selects View
    And the user observes the buttons of the pop-up
    Then 'Edit' and 'Close' buttons are displayed

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 BR-4
  @TC_WST_236 @Negative @High @Automation
  Scenario: Verify a user without View permission does not see the Work Sub Type entry in the navigation tree
    Given NoAccess_User1 (no Work Sub Type permission) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user expands Admin > Configuration > Work Category
    Then The 'Work Sub Type' entry is not displayed in the navigation tree

  # Ref: FRD 5.1 BR-4
  @TC_WST_237 @Negative @High @Automation
  Scenario: Verify a user without View permission is denied when opening the Work Sub Type URL directly
    Given NoAccess_User1 (no Work Sub Type permission) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user opens the Work Sub Type screen URL directly in the browser
    Then Access is denied; no Work Sub Type data is displayed

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_WST_238 @Negative @High @Automation
  Scenario: Verify the server rejects a create request from a user without Add permission and shows no toaster
    Given API client authenticated with the token of Viewer_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Viewer_User1                                               |
      | Payload | {code:'ADD-X', name:'Unauthorized Add', parentWork:'Road'} |
    When the user sends a create request
    And the user checks the Work Sub Type list
    Then Request is rejected; no record is created; no toaster is displayed

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_WST_239 @Negative @High @Automation
  Scenario: Verify the server rejects an update request from a user without Edit permission and shows no toaster
    Given API client authenticated with the token of Adder_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Adder_User1                         |
      | Payload | {id:'SH', name:'Unauthorized Edit'} |
    When the user sends an update request for 'SH' changing Name
    And the user retrieves the record
    Then Request is rejected; the record is unchanged; no toaster is displayed

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_WST_240 @Negative @High @Automation
  Scenario: Verify the server rejects a delete request from a user without Delete permission and shows no toaster
    Given API client authenticated with the token of Editor_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Editor_User1 |
      | Record | SH           |
    When the user sends a delete request for 'SH'
    And the user queries the record
    Then Request is rejected; 'SH' still exists; no toaster is displayed

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-4
  @TC_WST_241 @Negative @High @Automation
  Scenario: Verify the server rejects a view/list request from a user without View permission
    Given API client authenticated with the token of NoAccess_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user sends a request to list/view Work Sub Types
    Then Request is rejected and no Work Sub Type data is returned

  # Ref: FRD 5.1 BR-2
  @TC_WST_242 @Negative @High @Automation
  Scenario: Verify a user without Add permission sees neither 'Add' nor any 'Add Sub Work Type' option (Work Type rows and kebab menus)
    Given Editor_User1 (Work Sub Type: View, Edit) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Editor_User1 |
    When the user observes the area above the list
    And the user observes Work Type rows
    And the user opens kebab menus of Level 1 to Level 3 rows
    Then 'Add' and every 'Add Sub Work Type' option are not displayed

  # Ref: FRD 5.1 BR-2
  @TC_WST_243 @Negative @High @Automation
  Scenario: Verify a user without Delete permission does not see Delete in the kebab menu
    Given Adder_User1 (Work Sub Type: View, Add) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Adder_User1 |
    When the user opens kebab menu of 'SH - State Highway'
    Then 'Delete' is not displayed
