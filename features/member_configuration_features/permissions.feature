@MembersConfiguration @Permissions
Feature: Permissions
  Automated scenarios for the "Permissions" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 BR-3
  @TC_MC_164 @Negative @High @Automation
  Scenario: Verify a user without View permission does not see the Members Configuration menu entry
    Given NoAccess_User1 (no Members Configuration permission) is logged in to CivitINFRA. Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user expands Admin > Configuration in the left navigation
    Then 'Members Configuration' is not shown in the navigation tree

  # Ref: FRD 5.1 BR-3
  @TC_MC_165 @Negative @High @Automation
  Scenario: Verify a user without View permission is denied when opening the screen URL directly
    Given NoAccess_User1 (no Members Configuration permission) is logged in to CivitINFRA. Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user enters the Members Configuration screen URL in the browser address bar
    Then Access is denied and no member data is exposed

  # Ref: FRD 5.1 BR-2; FRD 5.1 BR-1
  @TC_MC_166 @Negative @High @Automation
  Scenario: Verify the member list API rejects a request without View permission
    Given API client authenticated with the token of NoAccess_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | NoAccess_User1  |
      | Product Enum | Proposal Nature |
    When the user sends a get-members request for 'Proposal Nature'
    Then Request is rejected (403); no member data is returned

  # Ref: FRD 5.1 BR-2
  @TC_MC_167 @Negative @High @Automation
  Scenario: Verify the Product Enum list API rejects a request without View permission
    Given API client authenticated with the token of NoAccess_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user sends a get-Product-Enums request
    Then Request is rejected (403); no Product Enum names are returned

  # Ref: FRD 5.1 BR-2; FRD 5.1 BR-1
  @TC_MC_168 @Negative @High @Automation
  Scenario: Verify a View-only user cannot update a Description via API
    Given API client authenticated with the token of Viewer_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1 |
      | Member | Project      |
    When the user sends an update-member request for 'Project' with Description 'Capital Project'
    And the user reads the member
    Then Request is rejected (403) by the server; Description of 'Project' is unchanged

  # Ref: FRD 5.1 BR-2; US-4 AC-6
  @TC_MC_169 @Negative @High @Automation
  Scenario: Verify a View-only user cannot change Active status via API
    Given API client authenticated with the token of Viewer_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1 |
      | Member | Project      |
    When the user sends an update-status request setting 'Project' to inactive
    And the user reads the member
    Then Request is rejected (403); 'Project' is still active and no Activity Log entry is written

  # Ref: US-4 AC-6
  @TC_MC_170 @Negative @High @Automation
  Scenario: Verify a View-only user cannot change the Active checkbox in the list
    Given Viewer_User1 (Members Configuration: View only) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1 |
      | Member | Project      |
    When the user clicks the Active checkbox of 'Project'
    Then Checkbox does not change; no request is made and no toaster is displayed

  # Ref: FRD 5.1 BR-2
  @TC_MC_171 @Negative @Medium @Automation
  Scenario: Verify a rejected request for lack of permission shows no toaster
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Edit permission is removed from Admin_User1's role after the Edit pop-up is opened
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Project         |
      | Description | Capital Project |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user removes the Edit permission of Admin_User1's role in another session
    And the user changes Description to 'Capital Project'
    And the user clicks 'Save'
    Then Server rejects the request; Description of 'Project' is unchanged
    And No toaster message is displayed

  # Ref: FRD 5.7 BR-2; FRD 5.1 BR-4
  @TC_MC_172 @Negative @High @Automation
  Scenario: Verify members cannot be added through the server
    Given API client authenticated with the token of Admin_User1 (View + Edit)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member Name | NewMember  |
      | Description | New Member |
    When the user sends a create-member request for 'Proposal Nature' with Member Name 'NewMember'
    And the user reads the member list
    Then Request is rejected or no such endpoint exists; no member is added

  # Ref: FRD 5.7 BR-2; FRD 5.1 BR-4
  @TC_MC_173 @Negative @High @Automation
  Scenario: Verify members cannot be deleted through the server
    Given API client authenticated with the token of Admin_User1 (View + Edit)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Others |
    When the user sends a delete-member request for 'Others'
    And the user reads the member list
    Then Request is rejected or no such endpoint exists; 'Others' is still listed

  # Ref: FRD 5.7 BR-2
  @TC_MC_174 @Negative @High @Automation
  Scenario: Verify a Product Enum cannot be added or deleted through the server
    Given API client authenticated with the token of Admin_User1 (View + Edit)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum | NewEnum           |
      | Enum | Estate House Type |
    When the user sends a create-Product-Enum request named 'NewEnum'
    And the user sends a delete-Product-Enum request for 'Estate House Type'
    And the user reads the Product Enum list
    Then Both requests are rejected or unavailable; the Product Enum list still has the 9 backend enums
