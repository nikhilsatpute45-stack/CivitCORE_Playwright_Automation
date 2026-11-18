@WorkType @WorkTypeView
Feature: Work Type View
  Automated scenarios for the "Work Type View" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-1; FRD 5.4 FB-1; FRD 5.4 FB-2
  @TC_WT_056 @Functional @High @Automation
  Scenario: Verify the View pop-up shows all six details in read-only mode for a modified Work Type
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type        | Taxiway Main |
      | Data             | Roads        |
      | Created By       | Admin_User1  |
      | Last Modified By | Admin_User1  |
    When the user edits 'Taxiway' changing its name to 'Taxiway Main' and save
    And the user opens View for 'Taxiway Main' from the kebab menu
    Then View pop-up shows Work Type Name, Work Type, Created By, Created On, Last Modified By and Last Modified On
    And Last Modified By and Last Modified On show the editing user and date-time; no field is editable

  # Ref: FRD 5.4 FB-2
  @TC_WT_057 @Functional @High @Automation
  Scenario: Verify Last Modified By and Last Modified On show '-' for a never-modified Work Type
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Boundary Wall |
    When the user opens View for 'Boundary Wall' (never modified)
    Then Last Modified By shows '-' and Last Modified On shows '-'

  # Ref: US-3 AC-2; FRD 5.4 FB-3; FRD 5.5 FB-1
  @TC_WT_058 @Functional @High @Automation
  Scenario: Verify the 'Edit' button on the View pop-up opens the Edit pop-up of the same Work Type for a user with Edit permission
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'View Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway     |
      | User      | Admin_User1 |
    When the user clicks 'Edit' on the View pop-up
    Then 'Edit Work Type' pop-up opens for 'Taxiway' pre-filled with its current values

  # Ref: US-3 AC-2; FRD 5.4 FB-4
  @TC_WT_059 @Functional @Medium @Automation
  Scenario: Verify 'Close' returns to the list on the same page with the same column search values
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And the following test data is used
      | Name search | Bulk WT 0 |
      | Page        | 2         |
    When the user types 'Bulk WT 0' in the Name search and go to page 2
    And the user opens View for the first row
    And the user clicks 'Close'
    Then View pop-up closes; list is shown on page 2 with Name search 'Bulk WT 0' unchanged

  # Ref: FRD 5.4 FB-4
  @TC_WT_060 @Functional @Medium @Automation
  Scenario: Verify the close (X) icon on the View pop-up returns to the list on the same page with the same column search values
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And the following test data is used
      | Work Type search | Roads |
      | Page             | 2     |
    When the user selects 'Roads' in the Work Type search and go to page 2
    And the user opens View for the first row
    And the user clicks the close (X) icon
    Then View pop-up closes; list remains on page 2 with the 'Roads' filter

  # Ref: FRD 5.4 BR-1
  @TC_WT_061 @Functional @High @Automation
  Scenario: Verify View does not change data and does not create an Activity Log entry
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user notes the Activity Log entry count for 'Taxiway'
    And the user opens View for 'Taxiway' and close it
    And the user re-checks the record data and Activity Log
    Then Record data (including Last Modified fields) is unchanged
    And No Activity Log entry is created
