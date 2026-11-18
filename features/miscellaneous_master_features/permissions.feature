@MiscellaneousMaster @Permissions
Feature: Permissions
  Automated scenarios for the "Permissions" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 BR-3
  @TC_MM_167 @Negative @High @Automation
  Scenario: Verify a user without View permission cannot see the menu entry or open the screen by URL
    Given NoAccess_User1 (no Miscellaneous Master permission) is logged in
    And the following test data is used
      | User        | NoAccess_User1 |
      | Permissions | none           |
    When the user checks the Admin > Configuration menu for Miscellaneous Master
    And the user opens the Miscellaneous Master URL directly
    Then The Miscellaneous Master entry is not displayed and direct URL access is denied; no Title data is exposed

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_MM_168 @Negative @High @Automation
  Scenario: Verify a user without View permission cannot read the Title list through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user sends a list-Titles request
    Then Request is rejected; no Title data is returned

  # Ref: FRD 5.1 BR-2; FRD 5.1 BR-1
  @TC_MM_169 @Negative @High @Automation
  Scenario: Verify a view-only user cannot create a Title through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Viewer_User1                       |
      | Payload | {fieldTitle:'Contractor Category'} |
    When the user sends a create-Title request
    And the user checks the Title List
    Then Request is rejected on the server (Assumption A-4); no Title is created

  # Ref: FRD 5.1 BR-2; FRD 5.1 BR-1
  @TC_MM_170 @Negative @High @Automation
  Scenario: Verify an Edit-only user cannot create a Title through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Editor_User1                       |
      | Payload | {fieldTitle:'Contractor Category'} |
    When the user sends a create-Title request
    Then Request is rejected; no Title is created

  # Ref: FRD 5.1 BR-2; FRD 5.1 BR-1
  @TC_MM_171 @Negative @High @Automation
  Scenario: Verify a view-only user cannot update a Title through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Viewer_User1                     |
      | Payload | {fieldTitle:'List of Operators'} |
    When the user sends an update-Title request for 'List of Operator'
    Then Request is rejected; 'List of Operator' is unchanged

  # Ref: FRD 5.1 BR-2; FRD 5.1 BR-1
  @TC_MM_172 @Negative @High @Automation
  Scenario: Verify an Add-only user cannot update a Title through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Adder_User1                      |
      | Payload | {fieldTitle:'List of Operators'} |
    When the user sends an update-Title request for 'List of Operator'
    Then Request is rejected; 'List of Operator' is unchanged

  # Ref: FRD 5.1 BR-2; FRD 5.1 BR-1
  @TC_MM_173 @Negative @High @Automation
  Scenario: Verify a view-only user cannot delete a Title through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User  | Viewer_User1   |
      | Title | Obsolete Field |
    When the user sends a delete-Title request for 'Obsolete Field'
    Then Request is rejected; 'Obsolete Field' still exists

  # Ref: FRD 5.1 BR-2; FRD 5.1 BR-1
  @TC_MM_174 @Negative @High @Automation
  Scenario: Verify an Edit-only user cannot delete a Title through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User  | Editor_User1   |
      | Title | Obsolete Field |
    When the user sends a delete-Title request for 'Obsolete Field'
    Then Request is rejected; 'Obsolete Field' still exists

  # Ref: FRD 5.1 BR-2; Section 4 AC-DS-2; FRD 5.6 BR-1
  @TC_MM_175 @Negative @High @Automation
  Scenario: Verify a user without Edit permission cannot change Display through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Deleter_User1 |
      | Permissions | View + Delete |
      | Display     | true          |
    When the user sends a Display update request for 'List of Specialization'
    Then Request is rejected; Display of 'List of Specialization' remains unchecked

  # Ref: FRD 5.1 BR-2; FRD Sec 7 (Toaster rules)
  @TC_MM_176 @Negative @Medium @Automation
  Scenario: Verify a request without the required permission shows no toaster
    Given Adder_User1 (Miscellaneous Master: View/Add) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And A Role Admin account is available
    And the following test data is used
      | User        | Adder_User1         |
      | Field Title | Contractor Category |
    When the user opens 'Add' and enter Field Title as Adder_User1
    And In the Role Admin account remove Add from the user's role
    And the user clicks Save
    Then The server rejects the request, no Title is created and no toaster message is displayed
