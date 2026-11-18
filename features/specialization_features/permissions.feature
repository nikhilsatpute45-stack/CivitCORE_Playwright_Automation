@Specialization @Permissions
Feature: Permissions
  Automated scenarios for the "Permissions" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.1 BR-4
  @TC_SP_170 @Negative @High @Automation
  Scenario: Verify a user without View permission does not see the Specialization menu and is denied direct URL access
    Given NoAccess_User1 (no Specialization permission) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user expands Admin > Configuration in the navigation tree
    And the user opens the Specialization screen URL directly
    Then 'Specialization' is not shown in the navigation tree
    And Direct URL access is denied and no Specialization data is displayed

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-1
  @TC_SP_171 @Negative @High @Automation
  Scenario: Verify a view-only user cannot create a Specialization Entry via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Viewer_User1                                        |
      | Payload | Misc Type List of Title, Code Prof., Name Professor |
    When the user sends a create request
    And the user checks the stored records
    Then Request is rejected (403) and no entry is created
    And No toaster is displayed

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_SP_172 @Negative @High @Automation
  Scenario: Verify an Edit-only user cannot create a Specialization Entry via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Editor_User1                                        |
      | Payload | Misc Type List of Title, Code Prof., Name Professor |
    When the user sends a create request
    And the user checks the stored records
    Then Request is rejected (403) and no entry is created

  # Ref: FRD 5.1 BR-3
  @TC_SP_173 @Negative @High @Automation
  Scenario: Verify a view-only user cannot update a Specialization Entry via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Viewer_User1         |
      | Payload | Row Mr., Name Mister |
    When the user sends an update request for 'Mr.'
    And the user checks the stored record
    Then Request is rejected (403) and the record is unchanged

  # Ref: FRD 5.1 BR-3
  @TC_SP_174 @Negative @High @Automation
  Scenario: Verify an Add-only user cannot update a Specialization Entry via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Adder_User1          |
      | Payload | Row Mr., Name Mister |
    When the user sends an update request for 'Mr.'
    And the user checks the stored record
    Then Request is rejected (403) and the record is unchanged

  # Ref: FRD 5.1 BR-3
  @TC_SP_175 @Negative @High @Automation
  Scenario: Verify a view-only user cannot delete a Specialization Entry via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
      | Row  | Sh. (unused) |
    When the user sends a delete request for 'Sh.'
    And the user checks the stored records
    Then Request is rejected (403) and 'Sh.' still exists

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-2
  @TC_SP_176 @Negative @High @Automation
  Scenario: Verify an Edit-only user cannot delete a Specialization Entry via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Editor_User1 |
      | Row  | Sh. (unused) |
    When the user sends a delete request for 'Sh.'
    And the user checks the stored records
    Then Request is rejected (403) and 'Sh.' still exists

  # Ref: FRD 5.1 BR-3; FRD 5.3 DS-5
  @TC_SP_177 @Negative @High @Automation
  Scenario: Verify a user without Edit permission cannot change the sequence via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | Adder_User1 |
      | Row          | Dr.         |
      | New position | 1           |
    When the user sends a sequence-change request moving 'Dr.' to position 1
    And the user reads the order
    Then Request is rejected (403) and the order is unchanged
    And No toaster is displayed

  # Ref: FRD 5.1 BR-3; FRD 5.1 BR-4
  @TC_SP_178 @Negative @High @Automation
  Scenario: Verify a user without View permission cannot read the Specialization list via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User      | NoAccess_User1 |
      | Misc Type | List of Title  |
    When the user sends a list request for 'List of Title'
    Then Request is rejected (403) and no Specialization Entries are returned

  # Ref: FRD 5.1 BR-3; FRD 7 T-ONLY
  @TC_SP_179 @Negative @Medium @Automation
  Scenario: Verify no toaster is displayed when a request without the required permission is rejected
    Given Viewer_User1 (Specialization: View only) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens the Specialization screen and replay a create request with the Viewer token
    And the user observes the screen
    Then Request is rejected and no toaster is displayed

  # Ref: FRD 5.1 BR-1; FRD 5.1 BR-2
  @TC_SP_180 @Negative @Medium @Automation
  Scenario: Verify Add permission removal from a role hides the 'Add' button after next login
    Given Admin changes the role of Adder_User1 so that Add permission is removed (View kept)
    And Adder_User1 logs out and in again
    And the following test data is used
      | User                   | Adder_User1 |
      | Role permission change | Add removed |
    When the user logs in as Adder_User1
    And the user opens Admin > Configuration > Specialization
    And the user observes the area above the list
    Then 'Add' button is not displayed (permissions follow the role, not the user)
