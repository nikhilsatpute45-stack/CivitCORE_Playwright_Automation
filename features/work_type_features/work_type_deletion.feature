@WorkType @WorkTypeDeletion
Feature: Work Type Deletion
  Automated scenarios for the "Work Type Deletion" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-1; FRD 5.8 FB-3; FRD 5.8 BR-1; FRD 5.8 Deletion Rule row 1; Sec 7 T4
  @TC_WT_094 @Functional @High @Automation
  Scenario: Verify deletion is blocked for a Work Type used only in a Work with status Completed
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Terminal Building            |
      | Data      | Used in WRK-0002 (Completed) |
      | Data      | No Sub Work Types            |
    When the user clicks the kebab on the row and select 'Delete'
    And the user observes the message and whether a dialog appears
    Then Error toaster 'This Work Type is used in one or more Works and cannot be deleted.' is displayed
    And No confirmation dialog is shown and the Work Type remains in the list

  # Ref: US-5 AC-1; FRD 5.8 FB-3; FRD 5.8 BR-1; FRD 5.8 Deletion Rule row 1; Sec 7 T4
  @TC_WT_095 @Functional @High @Automation
  Scenario: Verify deletion is blocked for a Work Type used only in a Work with status Draft
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Control Tower            |
      | Data      | Used in WRK-0003 (Draft) |
      | Data      | No Sub Work Types        |
    When the user clicks the kebab on the row and select 'Delete'
    And the user observes the message and whether a dialog appears
    Then Error toaster 'This Work Type is used in one or more Works and cannot be deleted.' is displayed
    And No confirmation dialog is shown and the Work Type remains in the list

  # Ref: US-5 AC-1; FRD 5.8 FB-3; FRD 5.8 BR-1; FRD 5.8 Deletion Rule row 1; Sec 7 T4
  @TC_WT_096 @Functional @High @Automation
  Scenario: Verify deletion is blocked for a Work Type used only in a Work with status In Progress
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Fuel Farm                      |
      | Data      | Used in WRK-0004 (In Progress) |
      | Data      | No Sub Work Types              |
    When the user clicks the kebab on the row and select 'Delete'
    And the user observes the message and whether a dialog appears
    Then Error toaster 'This Work Type is used in one or more Works and cannot be deleted.' is displayed
    And No confirmation dialog is shown and the Work Type remains in the list

  # Ref: US-5 AC-1; FRD 5.8 FB-3; FRD 5.8 BR-1; FRD 5.8 Deletion Rule row 1; Sec 7 T4
  @TC_WT_097 @Functional @High @Automation
  Scenario: Verify deletion is blocked for a Work Type used only in a Work with status Closed
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Parking Bay               |
      | Data      | Used in WRK-0005 (Closed) |
      | Data      | No Sub Work Types         |
    When the user clicks the kebab on the row and select 'Delete'
    And the user observes the message and whether a dialog appears
    Then Error toaster 'This Work Type is used in one or more Works and cannot be deleted.' is displayed
    And No confirmation dialog is shown and the Work Type remains in the list

  # Ref: US-5 AC-2; FRD 5.8 FB-3; FRD 5.8 BR-2; Sec 7 T5
  @TC_WT_098 @Functional @High @Automation
  Scenario: Verify deletion is blocked for a Work Type that has Sub Work Types and is not used in any Work
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type     | Hanger         |
      | Sub Work Type | Hanger Roofing |
      | Data          | No Works       |
    When the user clicks the kebab on 'Hanger' and select 'Delete'
    Then Error toaster 'This Work Type has one or more Sub Work Types and cannot be deleted.' is displayed
    And No confirmation dialog is shown and 'Hanger' remains in the list

  # Ref: US-5 AC-3; FRD 5.8 FB-2; FRD 5.7 BR-2; FRD 5.8 Deletion Rule row 3
  @TC_WT_099 @Functional @High @Automation
  Scenario: Verify only the Works message is displayed when a Work Type is used in Works and also has Sub Work Types
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type     | Runway           |
      | Data          | Used in WRK-0001 |
      | Sub Work Type | Runway Lighting  |
    When the user clicks the kebab on 'Runway' and select 'Delete'
    Then Only the toaster 'This Work Type is used in one or more Works and cannot be deleted.' is displayed; the Sub Work Type message is not displayed
    And No confirmation dialog is shown

  # Ref: US-5 AC-4; FRD 5.8 FB-2
  @TC_WT_100 @Functional @High @Automation
  Scenario: Verify the dependency check is performed when Delete is selected
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type         | Taxiway          |
      | New Sub Work Type | Taxiway Markings |
    When the user creates a Sub Work Type under 'Taxiway' (via Sub Work Type screen)
    And the user clicks the kebab on 'Taxiway' and select 'Delete'
    Then Error toaster 'This Work Type has one or more Sub Work Types and cannot be deleted.' is displayed immediately on selecting Delete without a confirmation dialog

  # Ref: US-6 AC-1; FRD 5.8 FB-1; FRD 5.8 FB-4; FRD 5.8 BR-3; FRD 5.8 Deletion Rule row 4
  @TC_WT_101 @Functional @High @Automation
  Scenario: Verify the confirmation dialog shows the Work Type name with Yes and No buttons when there is no dependency
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user clicks the kebab on 'Taxiway' and select 'Delete'
    Then Dialog 'Are you sure you want to delete the Work Type “Taxiway”?' is displayed with buttons 'Yes' and 'No'

  # Ref: US-6 AC-2; FRD 5.8 FB-5; Sec 7 T3
  @TC_WT_102 @Functional @High @Automation
  Scenario: Verify confirming 'Yes' deletes the Work Type, shows the toaster and re-sequences Sl. No.
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user clicks the kebab on 'Taxiway' (Sl. No. 3) and select 'Delete'
    And the user clicks 'Yes'
    And the user observes the list
    Then Toaster 'Work Type deleted successfully.' is displayed
    And 'Taxiway' no longer appears; the list refreshes and Sl. No. is re-sequenced (Parking Bay becomes Sl. No. 3; last row Sl. No. 8)

  # Ref: FRD 5.8 BR-5
  @TC_WT_103 @Functional @Medium @Automation
  Scenario: Verify the deleted Work Type is permanently removed (not present after page refresh)
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user deletes 'Taxiway' and confirm 'Yes'
    And the user refreshes the browser page
    And the user searches 'Taxiway' in the Work Type Name search
    Then 'Taxiway' is not found after refresh; deletion is permanent

  # Ref: US-6 AC-4; FRD 5.8 FB-5
  @TC_WT_104 @Functional @High @Automation
  Scenario: Verify the empty state is shown after the last remaining Work Type is deleted
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and only one Work Type 'Taxiway' (no dependency) exists
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway (only record) |
    When the user deletes 'Taxiway' and confirm 'Yes'
    Then Toaster 'Work Type deleted successfully.' is displayed
    And Empty state 'No Work Types added yet' is shown

  # Ref: FRD 5.8 FB-5
  @TC_WT_105 @Functional @High @Automation
  Scenario: Verify the previous page is shown when the current page becomes empty after deletion
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the list is displayed on page 2; dataset 'Page51' is loaded (51 Work Types, page 2 holds only 'Page WT 001')
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Records | 51 -> 50 |
    When the user goes to page 2
    And the user deletes 'Page WT 001' and confirm 'Yes'
    Then Toaster 'Work Type deleted successfully.' is displayed
    And Page 1 is shown with 50 records; pagination controls are hidden (50 records)

  # Ref: US-6 AC-5; FRD 5.8 BR-5
  @TC_WT_106 @Functional @High @Automation
  Scenario: Verify a deleted Work Type Name can be reused for a new Work Type
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Taxiway |
      | Work Type      | Roads   |
    When the user deletes 'Taxiway' and confirm 'Yes'
    And the user clicks 'Add' and create a Work Type with the same name
    Then New Work Type is saved without a duplicate error and appears at Sl. No. 1

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-6 AC-3; FRD 5.8 FB-6
  @TC_WT_194 @Negative @High @Automation
  Scenario: Verify clicking 'No' on the delete confirmation leaves the Work Type unchanged and creates no Activity Log entry
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user selects Delete on 'Taxiway'
    And the user clicks 'No'
    And the user checks the list and Activity Log
    Then Dialog closes; 'Taxiway' remains unchanged; no 'Work Type Deleted' entry is recorded

  # Ref: US-6 AC-3; FRD 5.8 FB-6
  @TC_WT_195 @Negative @High @Automation
  Scenario: Verify closing the delete confirmation with the close (X) icon leaves the Work Type unchanged
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user selects Delete on 'Taxiway'
    And the user clicks the close (X) icon of the dialog
    And the user checks the list and Activity Log
    Then Dialog closes; 'Taxiway' remains; no deletion entry is recorded

  # Ref: FRD 5.8 FB-6
  @TC_WT_196 @Negative @Medium @Automation
  Scenario: Verify pressing Esc on the delete confirmation leaves the Work Type unchanged
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user selects Delete on 'Taxiway'
    And the user presses Esc
    And the user checks the list
    Then Dialog closes; 'Taxiway' remains unchanged

  # Ref: US-5 AC-4; FRD 5.8 Deletion Rule row 6
  @TC_WT_197 @Negative @High @Automation
  Scenario: Verify the server blocks deletion when a Work is created between Delete click and 'Yes'
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway  |
      | New Work  | WRK-0006 |
    When In session A select Delete on 'Taxiway' and keep the dialog open
    And In session B (Admin_User2) create Work WRK-0006 selecting 'Taxiway'
    And In session A click 'Yes'
    Then Server check on Yes blocks the deletion and displays 'This Work Type is used in one or more Works and cannot be deleted.'; 'Taxiway' remains in the list

  # Ref: US-5 AC-4; FRD 5.8 Deletion Rule row 6
  @TC_WT_198 @Negative @High @Automation
  Scenario: Verify the server blocks deletion when a Sub Work Type is created between Delete click and 'Yes'
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type         | Apron         |
      | New Sub Work Type | Apron Marking |
    When In session A select Delete on 'Apron' and keep the dialog open
    And In session B create Sub Work Type 'Apron Marking' under 'Apron'
    And In session A click 'Yes'
    Then Server check on Yes blocks the deletion and displays 'This Work Type has one or more Sub Work Types and cannot be deleted.'; 'Apron' remains

  # Ref: FRD 5.8 FB-4; FRD 5.8 BR-1; US-5 AC-4
  @TC_WT_199 @Negative @High @Automation
  Scenario: Verify the server blocks a delete request for a Work Type used in a Work when called directly
    Given API client is authenticated with the token of Admin_User1 (Work Type: View/Add/Edit/Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Terminal Building (used in WRK-0002) |
    When the user sends a delete request for 'Terminal Building'
    Then Request is rejected by the server; 'Terminal Building' still exists

  # Ref: FRD 5.8 BR-2; US-5 AC-4
  @TC_WT_200 @Negative @High @Automation
  Scenario: Verify the server blocks a delete request for a Work Type with Sub Work Types when called directly
    Given API client is authenticated with the token of Admin_User1 (Work Type: View/Add/Edit/Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Hanger (Sub Work Type: Hanger Roofing) |
    When the user sends a delete request for 'Hanger'
    Then Request is rejected; 'Hanger' still exists

  # Ref: FRD 5.8 FB-7
  @TC_WT_201 @Negative @Medium @Automation
  Scenario: Verify no toaster is shown when deleting a Work Type that was already deleted by another user
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When In session A select Delete on 'Taxiway' and keep the dialog open
    And In session B delete 'Taxiway'
    And In session A click 'Yes'
    Then List is refreshed; no toaster is displayed

  # Ref: FRD 5.4 BR-2
  @TC_WT_202 @Negative @Medium @Automation
  Scenario: Verify no toaster is shown when View is opened for a Work Type already deleted by another user
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When In session B delete 'Taxiway'
    And In session A (list not yet refreshed) select View on 'Taxiway'
    Then List is refreshed and 'Taxiway' is no longer shown; no toaster is displayed

  # Ref: FRD 5.8 BR-1; FRD 5.7 FB-5
  @TC_WT_204 @Negative @Medium @Automation
  Scenario: Verify deletion blocked for a Work Type does not remove it from the Sub Work Type screen or the Create Work form
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Terminal Building |
    When the user selects Delete on 'Terminal Building' (blocked)
    And the user opens the Sub Work Type screen and the Create Work form
    Then 'Terminal Building' is still offered in both places

  # Ref: FRD 5.8 BR-1; FRD 5.8 BR-2; FRD 5.1 BR-3
  @TC_WT_205 @Negative @High @Automation
  Scenario: Verify a Delete-permitted user cannot bypass the dependency rules through the API
    Given API client is authenticated with the token of Deleter_User1 (Work Type: View+Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Runway |
    When the user sends a delete request for 'Runway' (used in Works and has Sub Work Types)
    Then Request is rejected by the dependency check; 'Runway' still exists
