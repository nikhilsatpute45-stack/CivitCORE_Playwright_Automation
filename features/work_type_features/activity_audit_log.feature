@WorkType @ActivityAuditLog
Feature: Activity / Audit Log
  Automated scenarios for the "Activity / Audit Log" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-7 AC-1; FRD 6 FB-1; FRD 6.1 Work Type Created; FRD 5.2 FB-5
  @TC_WT_107 @Functional @High @Automation
  Scenario: Verify an Activity Log entry 'Work Type Created' is created with required information
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | Building       |
      | User           | Admin_User1    |
    When the user creates a Work Type
    And the user opens the Activity Log section and find the entry
    Then Entry 'Work Type Created' exists with User (Admin_User1), Date-Time, Work Type Name 'Cargo Terminal' and Work Type 'Building'

  # Ref: US-7 AC-2; FRD 6 FB-3; FRD 6.1 Work Type Updated
  @TC_WT_108 @Functional @High @Automation
  Scenario: Verify an Activity Log entry 'Work Type Updated' captures the changed Work Type Name with previous and new value
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Taxiway -> Taxiway East |
    When the user changes Work Type Name and Save
    And the user opens the Activity Log section
    Then Entry 'Work Type Updated' has User, Date-Time, Work Type Name and one changed field: Field Name 'Work Type Name', Previous 'Taxiway', New 'Taxiway East'

  # Ref: US-7 AC-2; FRD 6.1 Work Type Updated
  @TC_WT_109 @Functional @High @Automation
  Scenario: Verify an Activity Log entry for an update of the Work Type value captures previous and new value
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Roads -> Other |
    When the user changes Work Type and Save
    And the user opens the Activity Log section
    Then Entry 'Work Type Updated' lists one changed field: 'Work Type', Previous 'Roads', New 'Other'; Work Type Name is not listed as a changed field

  # Ref: US-7 AC-2; FRD 6.1 Work Type Updated
  @TC_WT_110 @Functional @High @Automation
  Scenario: Verify an update of both fields lists each changed field with its previous and new value
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Data | Taxiway/Roads -> Taxiway Bay/Building |
    When the user changes Work Type Name and Work Type, then Save
    And the user opens the Activity Log section
    Then Entry lists two changed fields: Work Type Name (Taxiway -> Taxiway Bay) and Work Type (Roads -> Building)

  # Ref: US-7 AC-1; FRD 6.1 Work Type Deleted; FRD 5.8 FB-5
  @TC_WT_111 @Functional @High @Automation
  Scenario: Verify an Activity Log entry 'Work Type Deleted' is created with required information
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway (Roads) |
      | User      | Admin_User1     |
    When the user deletes 'Taxiway' and confirm 'Yes'
    And the user opens the Activity Log section
    Then Entry 'Work Type Deleted' exists with User, Date-Time, Work Type Name 'Taxiway' and Work Type 'Roads'

  # Ref: US-7 AC-1; FRD 6.1 Work Type Deletion Blocked; FRD 5.8 FB-3
  @TC_WT_112 @Functional @High @Automation
  Scenario: Verify an Activity Log entry 'Work Type Deletion Blocked' with reason Work is created
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Terminal Building (used in WRK-0002) |
    When the user selects Delete on 'Terminal Building'
    And the user opens the Activity Log section
    Then Entry 'Work Type Deletion Blocked' exists with User, Date-Time, Work Type Name 'Terminal Building' and Reason 'Work'

  # Ref: US-7 AC-1; FRD 6.1 Work Type Deletion Blocked; FRD 5.8 Deletion Rule row 2
  @TC_WT_113 @Functional @High @Automation
  Scenario: Verify an Activity Log entry 'Work Type Deletion Blocked' with reason Sub Work Type is created
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Hanger (has Sub Work Type 'Hanger Roofing') |
    When the user selects Delete on 'Hanger'
    And the user opens the Activity Log section
    Then Entry 'Work Type Deletion Blocked' exists with Work Type Name 'Hanger' and Reason 'Sub Work Type'

  # Ref: FRD 5.8 Deletion Rule row 3; FRD 6.1 Work Type Deletion Blocked
  @TC_WT_114 @Functional @High @Automation
  Scenario: Verify the Deletion Blocked entry has reason Work when a Work Type is used in Works and has Sub Work Types
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Runway (Work + Sub Work Type) |
    When the user selects Delete on 'Runway'
    And the user opens the Activity Log section
    Then Only one entry 'Work Type Deletion Blocked' is created with Reason 'Work'

  # Ref: FRD 6 FB-2; FRD 5.2 BR-7
  @TC_WT_115 @Functional @Medium @Automation
  Scenario: Verify Activity Log entries remain linked to the Work Type by Internal ID after it is renamed
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Data | Taxiway -> Taxiway East |
    When the user renames the Work Type and Save
    And the user queries the Activity Log entries of this Work Type by Internal ID
    Then The 'Work Type Created' and 'Work Type Updated' entries are both linked to the same Internal ID

  # Ref: FRD 6 FB-4
  @TC_WT_116 @Functional @Medium @Automation
  Scenario: Verify Activity Log entries are displayed most recent first
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Cargo Terminal |
    When the user creates 'Cargo Terminal', then edit it, then delete it
    And the user opens the Activity Log section
    Then Entries are listed in order: Deleted, Updated, Created (most recent first)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-6 AC-3; FRD 5.8 Deletion Rule row 5
  @TC_WT_206 @Negative @High @Automation
  Scenario: Verify no Activity Log entry is created when the delete confirmation is declined
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user selects Delete on 'Taxiway'
    And the user clicks 'No'
    And the user opens the Activity Log section
    Then No 'Work Type Deleted' and no 'Work Type Deletion Blocked' entry exists for this action

  # Ref: FRD 6 FB-4; US-7 AC-1
  @TC_WT_207 @Negative @High @Automation
  Scenario: Verify Activity Log entries cannot be edited via API
    Given API client is authenticated with the token of Admin_User1 (Work Type: View/Add/Edit/Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Entry | 'Work Type Created' for Taxiway |
    When the user sends an update request to modify an existing Activity Log entry
    Then Request is rejected; the entry is unchanged

  # Ref: FRD 6 FB-4; US-7 AC-1
  @TC_WT_208 @Negative @High @Automation
  Scenario: Verify Activity Log entries cannot be deleted via API
    Given API client is authenticated with the token of Admin_User1 (Work Type: View/Add/Edit/Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Entry | 'Work Type Created' for Taxiway |
    When the user sends a delete request for an existing Activity Log entry
    Then Request is rejected; the entry still exists
