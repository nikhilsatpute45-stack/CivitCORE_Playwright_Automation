@WorkType @WorkTypeUi
Feature: Work Type UI
  Automated scenarios for the "Work Type UI" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.3 FB-3
  @TC_WT_121 @UIVisual @Medium @Automation
  Scenario: Verify column search boxes: Work Type Name has a text box, Work Type has a dropdown, Sl. No. and Actions have none
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Columns | Sl. No., Work Type Name, Work Type, Actions |
    When the user observes the area directly below each column header
    Then A text box sits directly below 'Work Type Name' and a dropdown (default All) below 'Work Type'
    And No search box is shown below 'Sl. No.' or 'Actions'

  # Ref: FRD 5.1 FB-4; FRD 5.3 Columns
  @TC_WT_123 @UIVisual @Medium @Automation
  Scenario: Verify a kebab (⋮) icon is displayed in the Actions column of every row
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Baseline | 9 records |
    When the user observes the Actions column for every row
    Then Every row shows a kebab icon in Actions

  # Ref: US-1 AC-3; FRD 5.3 Empty State Add button
  @TC_WT_125 @UIVisual @High @Automation
  Scenario: Verify the empty state for a user without Add permission shows illustration, heading and message but no Add button
    Given Viewer_User1 (Work Type: View only) is logged in
    And No Work Type exists in the system
    And the following test data is used
      | User | Viewer_User1 |
    When the user navigates to Admin > Configuration > Work Category > Work Type
    And the user observes the screen
    Then Illustration, heading 'No Work Types added yet' and message 'Click Add to create your first Work Type.' are displayed
    And 'Add' button is not displayed anywhere

  # Ref: US-1 AC-3; FRD 5.1 BR-2
  @TC_WT_126 @UIVisual @High @Automation
  Scenario: Verify the 'Add' button is not displayed on the list for a user without Add permission
    Given Viewer_User1 (Work Type: View only) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user observes the area above the grid
    Then 'Add' button is not displayed

  # Ref: FRD 5.2 FB-3; FRD 5.2 F-Save
  @TC_WT_128 @UIVisual @Medium @Automation
  Scenario: Verify Save is enabled when the Add pop-up opens with empty fields
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Form | Add Work Type (empty) |
    When the user clicks 'Add'
    And the user observes the Save button without entering data
    Then 'Save' is enabled

  # Ref: FRD 5.2 BR-6; FRD 5.2 F-Type
  @TC_WT_130 @UIVisual @Medium @Automation
  Scenario: Verify the Work Type dropdown does not allow free-text entry
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed text | Custom |
    When the user clicks into the Work Type dropdown
    And the user types 'Custom'
    Then Typed text is not accepted as a value; only the listed options can be selected

  # Ref: FRD 5.2 BR-7; Sec 3 Terminology
  @TC_WT_131 @UIVisual @Medium @Automation
  Scenario: Verify the Internal ID is not displayed on any screen
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user observes the list columns
    And the user opens View and Edit pop-ups for 'Taxiway'
    And the user opens the Add pop-up
    Then No Internal ID is displayed on the list, View, Edit or Add pop-ups

  # Ref: US-3 AC-2; FRD 5.1 BR-2; FRD 5.4 FB-3
  @TC_WT_133 @UIVisual @High @Automation
  Scenario: Verify the 'Edit' button is not displayed on the View pop-up for a user without Edit permission
    Given Viewer_User1 (Work Type: View only) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens View for 'Taxiway' from the kebab menu
    Then 'Edit' button is not displayed; only 'Close' is available

  # Ref: US-1 AC-4; FRD 5.1 BR-2
  @TC_WT_142 @UIVisual @High @Automation
  Scenario: Verify Add/Edit/Delete options are not displayed to a view-only user in the kebab menu
    Given Viewer_User1 (Work Type: View only) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user clicks the kebab on any row
    And the user inspects the options
    Then Only 'View' is displayed

  # Ref: FRD 5.3 FB-6
  @TC_WT_143 @UIVisual @Low @Automation
  Scenario: Verify the Work Type Name search box is displayed with its entered text retained after pagination
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in and on the Work Type List page
    And Dataset 'Bulk' is loaded instead of the baseline: 120 Work Types 'Bulk WT 001' to 'Bulk WT 120' (created in that order, Work Type alternating Other/Building/Roads)
    And the following test data is used
      | Name search | Bulk WT 0 |
    When the user types 'Bulk WT 0' in Work Type Name search
    And the user clicks 'Next' and then 'Previous'
    Then Search text 'Bulk WT 0' remains in the search box on both pages
