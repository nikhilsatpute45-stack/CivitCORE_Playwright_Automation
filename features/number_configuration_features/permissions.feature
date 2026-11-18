@NumberConfiguration @Permissions
Feature: Permissions
  Automated scenarios for the "Permissions" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1 BR-1; FRD 6.1 FB-1
  @TC_NC_136 @Negative @High @Automation
  Scenario: Verify a user without Number Configuration permission cannot access the screen
    Given NoAccess_User1 (no Number Configuration permission) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user checks the Admin / Configuration menu for Number Configuration
    And the user opens the Number Configuration URL directly
    Then Menu entry is not displayed and direct URL access is denied; no configuration data is exposed

  # Ref: FRD 6.1 BR-1; FRD 6.3 BR-1
  @TC_NC_137 @Negative @High @Automation
  Scenario: Verify a view-only user cannot create a configuration via API
    Given API client authenticated with the token of Viewer_User1 (view access only)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1                   |
      | Config | PO-Cfg-1 / PO-Cfg-3 / PO-Cfg-4 |
    When the user sends a create-configuration request for Process 'Purchase Order'
    And the user checks the configuration data
    Then Request is rejected (403); no data is changed

  # Ref: FRD 6.1 BR-1; FRD 6.3 BR-1
  @TC_NC_138 @Negative @High @Automation
  Scenario: Verify a view-only user cannot update a configuration via API
    Given API client authenticated with the token of Viewer_User1 (view access only)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1                   |
      | Config | PO-Cfg-1 / PO-Cfg-3 / PO-Cfg-4 |
    When the user sends an update request for PO-Cfg-3
    And the user checks the configuration data
    Then Request is rejected (403); no data is changed

  # Ref: FRD 6.1 BR-1; FRD 6.3 BR-1
  @TC_NC_139 @Negative @High @Automation
  Scenario: Verify a view-only user cannot activate a configuration via API
    Given API client authenticated with the token of Viewer_User1 (view access only)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1                   |
      | Config | PO-Cfg-1 / PO-Cfg-3 / PO-Cfg-4 |
    When the user sends an activate request for PO-Cfg-3
    And the user checks the configuration data
    Then Request is rejected (403); no data is changed

  # Ref: FRD 6.1 BR-1; FRD 6.3 BR-1
  @TC_NC_140 @Negative @High @Automation
  Scenario: Verify a view-only user cannot deactivate a configuration via API
    Given API client authenticated with the token of Viewer_User1 (view access only)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1                   |
      | Config | PO-Cfg-1 / PO-Cfg-3 / PO-Cfg-4 |
    When the user sends a deactivate request for PO-Cfg-1
    And the user checks the configuration data
    Then Request is rejected (403); no data is changed

  # Ref: FRD 6.1 BR-1; FRD 6.3 BR-1
  @TC_NC_141 @Negative @High @Automation
  Scenario: Verify a view-only user cannot delete a configuration via API
    Given API client authenticated with the token of Viewer_User1 (view access only)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1                   |
      | Config | PO-Cfg-1 / PO-Cfg-3 / PO-Cfg-4 |
    When the user sends a delete request for PO-Cfg-4
    And the user checks the configuration data
    Then Request is rejected (403); no data is changed
