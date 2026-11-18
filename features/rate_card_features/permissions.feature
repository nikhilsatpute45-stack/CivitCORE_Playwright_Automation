@RateCard @Permissions
Feature: Permissions
  Automated scenarios for the "Permissions" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 BR-4
  @TC_RC_186 @Negative @High @Automation
  Scenario: Verify a user without View permission does not see the Rate Card menu entry
    Given NoAccess_User1 (no Rate Card permission) is logged in and on the application home page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user expands Admin > Configuration in the navigation tree
    Then The 'Rate Card' entry is not displayed

  # Ref: FRD 5.1 BR-4
  @TC_RC_187 @Negative @High @Automation
  Scenario: Verify a user without View permission is denied when opening the Rate Card URL directly
    Given NoAccess_User1 (no Rate Card permission) is logged in and on the application home page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user opens the Rate Card screen URL directly in the address bar
    Then Access is denied and no Rate Card data is exposed

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-4
  @TC_RC_188 @Negative @High @Automation
  Scenario: Verify a user without View permission cannot list Rate Cards via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user sends a get-Rate Card-list request
    Then Request is rejected (403) and no data is returned

  # Ref: FRD 5.1 BR-3
  @TC_RC_189 @Negative @High @Automation
  Scenario: Verify a user without View permission cannot fetch a single Rate Card via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User      | NoAccess_User1  |
      | Rate Card | Sub Mountanious |
    When the user sends a get request for 'Sub Mountanious'
    Then Request is rejected (403) and no data is returned

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_RC_190 @Negative @High @Automation
  Scenario: Verify a View-only user cannot create a Rate Card via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Viewer_User1      |
      | Payload | {name:'Api Zone'} |
    When the user sends a create-Rate Card request
    And the user checks the Rate Card master
    Then Request is rejected (403); no Rate Card is created

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_RC_191 @Negative @High @Automation
  Scenario: Verify a View-only user cannot update a Rate Card via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Viewer_User1              |
      | Payload | {name:'Coastal Region X'} |
    When the user sends an update request for 'Coastal Region'
    And the user checks the Rate Card master
    Then Request is rejected (403); the name is unchanged

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_RC_192 @Negative @High @Automation
  Scenario: Verify a View-only user cannot delete a Rate Card via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User      | Viewer_User1   |
      | Rate Card | Coastal Region |
    When the user sends a delete request for 'Coastal Region'
    And the user checks the Rate Card master
    Then Request is rejected (403); 'Coastal Region' still exists

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_RC_193 @Negative @High @Automation
  Scenario: Verify an Edit-only user cannot delete a Rate Card via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User      | Editor_User1   |
      | Rate Card | Coastal Region |
    When the user sends a delete request for 'Coastal Region'
    Then Request is rejected (403); 'Coastal Region' still exists

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_RC_194 @Negative @High @Automation
  Scenario: Verify an Add-only user cannot update a Rate Card via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Adder_User1               |
      | Payload | {name:'Coastal Region X'} |
    When the user sends an update request for 'Coastal Region'
    Then Request is rejected (403); the name is unchanged

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_RC_195 @Negative @High @Automation
  Scenario: Verify a Delete-only user cannot create or update a Rate Card via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Deleter_User1     |
      | Payload | {name:'Api Zone'} |
    When the user sends a create-Rate Card request
    And the user sends an update request for 'Coastal Region'
    Then Both requests are rejected (403); no change is made

  # Ref: FRD 5.1 BR-3; FRD 5.3 SEQ-5
  @TC_RC_196 @Negative @High @Automation
  Scenario: Verify a View-only user cannot change the display sequence via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User      | Viewer_User1   |
      | Rate Card | Civit-ratecard |
    When the user sends a reorder request moving 'Civit-ratecard' to position 1
    Then Request is rejected (403); the sequence is unchanged and no 'Sequence Changed' entry is written

  # Ref: FRD 5.1 BR-3
  @TC_RC_197 @Negative @High @Automation
  Scenario: Verify a rejected request for a missing permission shows no toaster
    Given Editor_User1 is logged in on the Rate Card List with the Edit pop-up of 'Coastal Region' open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User      | Editor_User1   |
      | Rate Card | Coastal Region |
    When As Admin_User1 remove the Edit permission from the role of Editor_User1
    And In the Editor_User1 session change the name to 'Coastal Region X' and click Save
    Then The server rejects the request and the name is unchanged
    And No toaster message is displayed
