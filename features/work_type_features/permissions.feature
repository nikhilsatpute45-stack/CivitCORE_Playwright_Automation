@WorkType @Permissions
Feature: Permissions
  Automated scenarios for the "Permissions" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 BR-4; FRD 5.1 FB-1
  @TC_WT_144 @Negative @High @Automation
  Scenario: Verify a user without View permission does not see the Work Type entry in the navigation tree
    Given NoAccess_User1 (no Work Type permission) is logged in to CivitINFRA and has just logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user expands Admin > Configuration > Work Category in the left navigation tree
    Then 'Work Type' entry is not displayed in the tree

  # Ref: FRD 5.1 BR-4
  @TC_WT_145 @Negative @High @Automation
  Scenario: Verify a user without View permission is denied when the Work Type screen URL is opened directly
    Given NoAccess_User1 (no Work Type permission) is logged in to CivitINFRA and has just logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user pastes the Work Type screen URL in the browser address bar and press Enter
    Then Access is denied; no Work Type data is displayed

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_WT_146 @Negative @High @Automation
  Scenario: Verify a view-only user cannot create a Work Type via API
    Given API client is authenticated with the token of Viewer_User1 (Work Type: View only)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | {name:'Cargo Terminal', workType:'Building'} |
    When the user sends a create-Work-Type request
    And the user checks the Work Type list
    Then Request is rejected by the server; no Work Type is created and no toaster is displayed

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_WT_147 @Negative @High @Automation
  Scenario: Verify a view-only user cannot update a Work Type via API
    Given API client is authenticated with the token of Viewer_User1 (Work Type: View only)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload   | {name:'Taxiway X'} |
      | Work Type | Taxiway            |
    When the user sends an update request for 'Taxiway'
    And the user checks the record
    Then Request is rejected; 'Taxiway' remains unchanged

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_WT_148 @Negative @High @Automation
  Scenario: Verify a view-only user cannot delete a Work Type via API
    Given API client is authenticated with the token of Viewer_User1 (Work Type: View only)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user sends a delete request for 'Taxiway'
    And the user checks the record
    Then Request is rejected; 'Taxiway' still exists

  # Ref: FRD 5.1 BR-3
  @TC_WT_149 @Negative @High @Automation
  Scenario: Verify an Edit-only user cannot create a Work Type via API
    Given API client is authenticated with the token of Editor_User1 (Work Type: View+Edit)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | {name:'Cargo Terminal', workType:'Building'} |
    When the user sends a create-Work-Type request
    Then Request is rejected; no Work Type is created

  # Ref: FRD 5.1 BR-3
  @TC_WT_150 @Negative @High @Automation
  Scenario: Verify an Edit-only user cannot delete a Work Type via API
    Given API client is authenticated with the token of Editor_User1 (Work Type: View+Edit)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user sends a delete request for 'Taxiway'
    Then Request is rejected; 'Taxiway' still exists

  # Ref: FRD 5.1 BR-3
  @TC_WT_151 @Negative @High @Automation
  Scenario: Verify an Add-only user cannot update a Work Type via API
    Given API client is authenticated with the token of Adder_User1 (Work Type: View+Add)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | {name:'Taxiway X'} |
    When the user sends an update request for 'Taxiway'
    Then Request is rejected; 'Taxiway' remains unchanged

  # Ref: FRD 5.1 BR-3
  @TC_WT_152 @Negative @High @Automation
  Scenario: Verify a Delete-only user cannot update a Work Type via API
    Given API client is authenticated with the token of Deleter_User1 (Work Type: View+Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload | {name:'Taxiway X'} |
    When the user sends an update request for 'Taxiway'
    Then Request is rejected; 'Taxiway' remains unchanged

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-4
  @TC_WT_153 @Negative @High @Automation
  Scenario: Verify a user without View permission cannot read the Work Type list via API
    Given API client is authenticated with the token of NoAccess_User1 (no Work Type permission)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user sends a get-Work-Type-list request
    Then Request is rejected; no Work Type data is returned
