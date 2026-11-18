@WorkSubType @WorkSubTypeDeletion
Feature: Work Sub Type Deletion
  Automated scenarios for the "Work Sub Type Deletion" module of Work Sub Type.
  Source: CivitINFRA_WorkSubType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-006_CivitINFRA Configuration_Work Sub Type.pdf (PRD Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-7 AC-1; FRD 5.7 FB-4; FRD 5.7 BR-3; FRD 5.7 DR-4; FRD 5.7 FB-1; FRD 5.7 FB-2
  @TC_WST_117 @Functional @High @Automation
  Scenario: Verify the confirmation dialog with exact text and Yes/No buttons is shown for a Work Sub Type with no dependency
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH - State Highway (no Works, no children) |
    When the user clicks kebab (⋮) of 'SH - State Highway'
    And the user selects Delete
    Then Confirmation dialog "Are you sure you want to delete the Work Sub Type “SH – State Highway”?" is displayed with 'Yes' and 'No' buttons

  # Ref: US-7 AC-2; FRD 5.7 FB-5; FRD 7 T-3; FRD Fig 2; FRD 5.7 DR-4
  @TC_WST_118 @Functional @High @Automation
  Scenario: Verify clicking Yes deletes the Work Sub Type, shows the success toaster and refreshes the list
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen with 'SH - State Highway' visible
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH - State Highway |
    When the user selects Delete for 'SH - State Highway'
    And the user clicks Yes
    Then Toaster "Work Sub Type deleted successfully." is displayed
    And 'SH' is removed from the list and the list is refreshed

  # Ref: US-7 AC-2; FRD 5.3 BR-3
  @TC_WST_119 @Functional @High @Automation
  Scenario: Verify Sl. No. is re-sequenced under the parent after deletion
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Deleted   | SH (Sl. No. 1) |
      | Remaining | NH             |
    When the user selects Delete for unused Level 1 record 'SH - State Highway' (Sl. No. 1 under Road) and click Yes
    And the user observes Sl. No. of 'NH' and its children
    Then 'NH' (previously Sl. No. 2) is now Sl. No. 1 and its children become 1.1 and 1.2

  # Ref: US-7 AC-2; FRD 5.6 FB-4
  @TC_WST_120 @Functional @High @Automation
  Scenario: Verify a deleted Work Sub Type is no longer available in Work creation
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Deleted | RB-APT |
    When the user deletes 'RB-APT - Apartments' (confirm Yes)
    And the user opens the Create Work form and select Work Type 'Building'
    Then 'RB-APT' is not offered in the Work Sub Type selection

  # Ref: US-7 AC-3; FRD 5.7 FB-6; FRD 5.7 DR-5
  @TC_WST_121 @Functional @High @Automation
  Scenario: Verify clicking No on the confirmation dialog leaves the Work Sub Type unchanged with no deletion entry
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH - State Highway |
    When the user selects Delete for 'SH - State Highway'
    And the user clicks No
    Then The dialog closes, 'SH' remains and no 'Work Sub Type Deleted' Activity Log entry is created

  # Ref: US-7 AC-3; FRD 5.7 FB-6
  @TC_WST_122 @Functional @Medium @Automation
  Scenario: Verify closing the confirmation dialog with the close (X) icon leaves the Work Sub Type unchanged
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH - State Highway |
    When the user selects Delete for 'SH - State Highway'
    And the user clicks the close (X) icon
    Then The dialog closes, 'SH' remains and no deletion entry is recorded

  # Ref: FRD 5.7 FB-6
  @TC_WST_123 @Functional @Medium @Automation
  Scenario: Verify pressing Esc on the confirmation dialog leaves the Work Sub Type unchanged
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH - State Highway |
    When the user selects Delete for 'SH - State Highway'
    And the user presses Esc
    Then The dialog closes, 'SH' remains and no deletion entry is recorded

  # Ref: US-7 AC-4
  @TC_WST_124 @Functional @High @Automation
  Scenario: Verify the Work Type row stays and shows 'No Work Sub Types added.' after its last Level 1 Work Sub Type is deleted
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record    | WS-DIST      |
      | Work Type | Water Supply |
    When the user selects Delete for 'WS-DIST - Distribution Network' (only Level 1 record under 'Water Supply')
    And the user clicks Yes
    Then Work Type 'Water Supply' row remains and shows "No Work Sub Types added."

  # Ref: US-7 AC-4; FRD 5.6 BR-2
  @TC_WST_125 @Functional @Medium @Automation
  Scenario: Verify the Work Type can be deleted in the Work Type screen after its last Work Sub Type is deleted (if not used in any Work)
    Given WS-DIST under 'Water Supply' has been deleted
    And Admin_User1 is on the Work Type screen (CIC-F-005)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Water Supply (not used in any Work) |
    When the user selects Delete for Work Type 'Water Supply'
    And the user confirms the deletion
    Then 'Water Supply' is deleted because it has no Work Sub Types and is not used in any Work

  # Ref: FRD 5.6 BR-2
  @TC_WST_126 @Functional @High @Automation
  Scenario: Verify a Work Type that has Work Sub Types cannot be deleted in the Work Type screen
    Given Admin_User1 is logged in and on the Work Type screen (CIC-F-005)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Road (has Work Sub Types) |
    When the user selects Delete for Work Type 'Road'
    Then Deletion of 'Road' is not allowed per CIC-F-005 Section 5.8 as it has Work Sub Types

  # Ref: US-7 AC-5; FRD 5.7 BR-5
  @TC_WST_127 @Functional @High @Automation
  Scenario: Verify Code and Name of a deleted Work Sub Type can be reused for a new Work Sub Type
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code        | SH            |
      | Name        | State Highway |
      | Parent Work | Road          |
    When the user deletes 'SH - State Highway' (Yes)
    And the user clicks Add and enter Code 'SH', Name 'State Highway', Parent Work 'Road'
    And the user clicks Save
    Then The new Work Sub Type is saved without any duplicate error

  # Ref: US-6 AC-1; FRD 5.7 BR-1; FRD 5.7 DR-1; FRD 7 T-4; FRD 5.6 BR-3
  @TC_WST_128 @Functional @High @Automation
  Scenario: Verify deletion is blocked with an error toaster when a Work Sub Type is used in a Draft Work
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH-BYP          |
      | Work   | WRK-001 (Draft) |
    When the user selects Delete for 'NH-BYP - NH Bypass' (used in WRK-001, Draft)
    Then Toaster "This Work Sub Type is used in one or more Works and cannot be deleted." is displayed
    And Confirmation dialog is NOT displayed and the record remains

  # Ref: US-6 AC-1; FRD 5.7 FB-2
  @TC_WST_129 @Functional @Medium @Automation
  Scenario: Verify deletion is blocked when a Work Sub Type is used in an In Progress Work
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | IB-FAC                |
      | Work   | WRK-005 (In Progress) |
    When the user selects Delete for 'IB-FAC - Factories' (used in WRK-005, In Progress; no children)
    Then Toaster "This Work Sub Type is used in one or more Works and cannot be deleted." is displayed and no confirmation dialog appears

  # Ref: US-6 AC-1; FRD 5.7 FB-2
  @TC_WST_130 @Functional @Medium @Automation
  Scenario: Verify deletion is blocked when a Work Sub Type is used in a Completed Work
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | OB                  |
      | Work   | WRK-003 (Completed) |
    When the user selects Delete for 'OB - Office Building' (used in WRK-003, Completed)
    Then Toaster "This Work Sub Type is used in one or more Works and cannot be deleted." is displayed and no confirmation dialog appears

  # Ref: US-6 AC-1; FRD 5.7 FB-2
  @TC_WST_131 @Functional @Medium @Automation
  Scenario: Verify deletion is blocked when a Work Sub Type is used in a Closed Work
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | IB               |
      | Work   | WRK-004 (Closed) |
    When the user selects Delete for 'IB - Industrial Building' (used in WRK-004, Closed)
    Then Toaster "This Work Sub Type is used in one or more Works and cannot be deleted." is displayed and no confirmation dialog appears

  # Ref: US-6 AC-2; FRD 5.7 BR-2; FRD 5.7 DR-2; FRD 7 T-5
  @TC_WST_132 @Functional @High @Automation
  Scenario: Verify deletion is blocked with the child message when a Work Sub Type has children and is not used in any Work
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | RB (child: RB-APT) |
    When the user selects Delete for 'RB - Residential Building' (child RB-APT, not used in a Work)
    Then Toaster "This Work Sub Type has one or more child Work Sub Types and cannot be deleted." is displayed
    And No confirmation dialog is shown and RB remains

  # Ref: US-6 AC-3; FRD 5.7 DR-3; FRD 5.7 FB-2
  @TC_WST_133 @Functional @High @Automation
  Scenario: Verify only the 'used in Works' message is shown when a Work Sub Type is used in Works and also has children
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH-SEC |
    When the user selects Delete for 'NH-SEC - NH Sections' (used in WRK-002 and has child NH-SEC-A)
    Then Only toaster "This Work Sub Type is used in one or more Works and cannot be deleted." is displayed; the child message is not displayed

  # Ref: FRD 5.7 FB-2; FRD 5.7 FB-3
  @TC_WST_134 @Functional @Medium @Automation
  Scenario: Verify the dependency check runs in order: used in Work first, then child Work Sub Types
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH-SEC |
    When the user selects Delete for 'NH-SEC' (both dependencies exist)
    And the user removes the Work link (WRK-002) via backend and select Delete again
    Then First attempt shows the Works message; second attempt shows the child Work Sub Type message

  # Ref: FRD 5.7 BR-2; US-6 AC-2
  @TC_WST_135 @Functional @High @Automation
  Scenario: Verify children must be deleted first, starting from the lowest level
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Records | RB-APT (child), RB (parent) |
    When the user tries to delete 'RB' (blocked: child message)
    And the user deletes child 'RB-APT' (confirm Yes)
    And the user deletes 'RB' again and confirm Yes
    Then Deleting 'RB' is blocked while 'RB-APT' exists; after 'RB-APT' is deleted, 'RB' can be deleted after confirmation

  # Ref: US-6 AC-4; FRD 5.7 FB-5; FRD 5.7 DR-6
  @TC_WST_136 @Functional @High @Automation
  Scenario: Verify the server repeats the dependency check on Yes and blocks deletion when a dependency was created after the Delete click
    Given Admin_User1 is logged in
    And A Work is available to select 'SH - State Highway' (created via backend/API) once the dialog is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record   | SH                       |
      | New Work | WRK-005 (Draft) using SH |
    When the user selects Delete for 'SH - State Highway' (confirmation dialog appears)
    And the user creates a Work that uses 'SH' (via API)
    And the user clicks Yes
    Then The server blocks the deletion and displays "This Work Sub Type is used in one or more Works and cannot be deleted."; 'SH' remains

  # Ref: FRD 5.7 FB-7
  @TC_WST_137 @Functional @Medium @Automation
  Scenario: Verify the list is refreshed without a toaster when the Work Sub Type was already deleted by another user
    Given Admin_User1 (Session A) and Admin_User2 (Session B) are logged in on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH |
    When In Session B delete 'SH - State Highway'
    And In Session A select Delete for 'SH - State Highway'
    Then The list is refreshed and 'SH' is no longer shown
    And No toaster message is displayed

  # Ref: FRD 5.7 BR-5
  @TC_WST_139 @Functional @Medium @Automation
  Scenario: Verify deletion is permanent
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | SH |
    When the user deletes 'SH - State Highway' (Yes)
    And the user reloads the screen and search for 'SH'
    Then 'SH' is not found; the deletion is not reversible

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.7 FB-5; FRD 5.7 BR-1; US-6 AC-4
  @TC_WST_233 @Negative @High @Automation
  Scenario: Verify deletion of a used Work Sub Type via API is rejected by the server and the record remains
    Given API client authenticated with the token of Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | NH-BYP |
    When the user sends a delete request for 'NH-BYP' (used in WRK-001)
    And the user queries the record
    Then Server rejects the deletion; the 'Used in Works' message is returned and 'NH-BYP' still exists

  # Ref: FRD 5.7 BR-2; US-6 AC-4
  @TC_WST_234 @Negative @High @Automation
  Scenario: Verify deletion of a Work Sub Type with children via API is rejected by the server
    Given API client authenticated with the token of Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | RB |
    When the user sends a delete request for 'RB' (has child RB-APT)
    And the user queries the record
    Then Server rejects the deletion with the child message; 'RB' still exists

  # Ref: FRD 5.7 BR-6; FRD 5.1 FB-5
  @TC_WST_235 @Negative @Medium @Automation
  Scenario: Verify Work Type rows cannot be deleted from the Work Sub Type screen
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Bridge (Work Type) |
    When the user inspects the 'Bridge' Work Type row for any Delete option
    Then No Delete option is available for Work Type rows on this screen
