@Specialization @SpecializationEntryDeletion
Feature: Specialization Entry Deletion
  Automated scenarios for the "Specialization Entry Deletion" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-7 AC-1; FRD 5.7 FB-4
  @TC_SP_109 @Functional @High @Automation
  Scenario: Verify the confirmation dialog is shown for an unused entry with the exact text
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry Code 'Adv.', Name 'Advocate' exists in 'List of Title' and is not used in any transaction
    And the following test data is used
      | Row       | Adv. / Advocate |
      | Misc Type | List of Title   |
    When the user clicks the kebab icon on 'Adv.'
    And the user clicks Delete
    And the user reads the dialog
    Then Dialog shows “Are you sure you want to delete “Adv. – Advocate” from List of Title?” with 'Yes' and 'No' buttons

  # Ref: US-6 AC-2; FRD 5.7 FB-2; FRD 5.7 FB-1
  @TC_SP_110 @Functional @High @Automation
  Scenario: Verify the dependency check is run when Delete is selected
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Ms.' is used in a Draft record
    And the following test data is used
      | Row | Ms. |
    When the user clicks the kebab icon on 'Ms.'
    And the user clicks Delete
    And the user observes the response and the dependency check call
    Then Dependency check is executed immediately on selecting Delete (before any dialog)

  # Ref: US-7 AC-2; FRD 5.7 FB-5; FRD 7 T-3; FRD 5.7 DR-2; FRD 5.7 BR-2
  @TC_SP_111 @Functional @High @Automation
  Scenario: Verify the entry is deleted when Yes is clicked and the success toaster is shown
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Adv.' / 'Advocate' exists and is unused
    And the following test data is used
      | Row | Adv. / Advocate |
    When the user opens Delete for 'Adv.'
    And the user clicks Yes
    Then Toaster 'Specialization Entry deleted successfully.' is displayed
    And 'Adv.' is removed from the list

  # Ref: US-7 AC-2; FRD 5.7 FB-5; FRD 5.3 BR-2
  @TC_SP_112 @Functional @Medium @Automation
  Scenario: Verify Sl. No. is re-sequenced after delete
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Miss |
    When the user deletes 'Miss' (Sl. No. 3, unused) and confirm Yes
    And the user reads Sl. No. of all rows
    Then Sl. No. reads 1 to 6 continuously and 'Dr.' moves from Sl. No. 4 to 3

  # Ref: FRD 5.7 BR-4
  @TC_SP_113 @Functional @High @Automation
  Scenario: Verify the deleted entry is permanently removed from storage
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Adv.' / 'Advocate' exists and is unused
    And the following test data is used
      | Row | Adv. / Advocate |
    When the user deletes 'Adv.' and confirm Yes
    And the user queries the stored records for 'Adv.'
    Then No record for 'Adv.' exists in storage

  # Ref: US-7 AC-3; FRD 5.7 FB-6
  @TC_SP_114 @Functional @High @Automation
  Scenario: Verify the entry remains unchanged when No is clicked
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Adv.' / 'Advocate' exists and is unused
    And the following test data is used
      | Row | Adv. |
    When the user opens Delete for 'Adv.'
    And the user clicks No
    And the user checks the list and the Activity Log
    Then Dialog closes, 'Adv.' remains and no deletion entry is recorded in the Activity Log

  # Ref: US-7 AC-3; FRD 5.7 FB-6
  @TC_SP_115 @Functional @Medium @Automation
  Scenario: Verify the entry remains unchanged when the dialog is closed with the X icon
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Adv.' / 'Advocate' exists and is unused
    And the following test data is used
      | Row | Adv. |
    When the user opens Delete for 'Adv.'
    And the user clicks the close (X) icon of the dialog
    And the user checks the list and the Activity Log
    Then Dialog closes, 'Adv.' remains and no deletion entry is recorded in the Activity Log

  # Ref: FRD 5.7 FB-6; FRD 5.7 DR-3
  @TC_SP_116 @Functional @Medium @Automation
  Scenario: Verify the entry remains unchanged when the dialog is closed with Esc
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Adv.' / 'Advocate' exists and is unused
    And the following test data is used
      | Row | Adv. |
      | Key | Esc  |
    When the user opens Delete for 'Adv.'
    And the user presses Esc
    And the user checks the list and the Activity Log
    Then Dialog closes, 'Adv.' remains and no deletion entry is recorded in the Activity Log

  # Ref: US-7 AC-4; FRD 5.7 FB-5
  @TC_SP_117 @Functional @High @Automation
  Scenario: Verify the empty state is shown when the last entry of a Misc Type is deleted
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Firm Type' selected
    And Baseline data (see Summary) is loaded. 'List of Firm Type' contains only one entry: Code 'PVT', Name 'Private Limited' (unused)
    And the following test data is used
      | Row | PVT / Private Limited |
    When the user opens Delete for 'PVT'
    And the user clicks Yes
    Then Toaster 'Specialization Entry deleted successfully.' is displayed
    And Empty state with heading 'No Specialization Entries added yet' is shown

  # Ref: FRD 5.7 FB-5
  @TC_SP_118 @Functional @Medium @Automation
  Scenario: Verify the previous page is shown when the current page becomes empty after delete
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Grade' selected
    And Baseline data (see Summary) is loaded. 'List of Grade' has 51 entries (G51 added); page 2 holds only 1 entry
    And the following test data is used
      | Misc Type | List of Grade (51 entries) |
    When the user clicks Next to open page 2
    And the user opens Delete for the single row on page 2 and click Yes
    And the user observes the page
    Then Previous page (page 1) is shown with 50 rows

  # Ref: US-7 AC-5; FRD 5.7 BR-4
  @TC_SP_119 @Functional @High @Automation
  Scenario: Verify Code and Name of a deleted entry can be used again in the same Misc Type
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Adv.' / 'Advocate' exists and is unused
    And the following test data is used
      | Code | Adv.     |
      | Name | Advocate |
    When the user deletes 'Adv.' and confirm Yes
    And the user clicks 'Add'
    And the user enters Code 'Adv.' and Name 'Advocate'
    And the user clicks Save
    Then Entry is saved without a duplicate error and toaster 'Specialization Entry added successfully.' is displayed

  # Ref: US-6 AC-1; FRD 5.7 FB-3; FRD 7 T-4
  @TC_SP_120 @Functional @High @Automation
  Scenario: Verify deletion is blocked for an entry used in a Completed transaction
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Mr.' is used in a saved record with status Completed
    And the following test data is used
      | Row                | Mr.       |
      | Transaction status | Completed |
    When the user clicks the kebab icon on 'Mr.'
    And the user clicks Delete
    Then Error toaster 'This Specialization Entry is used in one or more transactions and cannot be deleted.' is displayed
    And Confirmation dialog is not displayed
    And 'Mr.' remains in the list

  # Ref: US-6 AC-1; FRD 5.7 BR-1
  @TC_SP_121 @Functional @High @Automation
  Scenario: Verify deletion is blocked for an entry used in a Draft transaction
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Ms.' is used in a saved record with status Draft
    And the following test data is used
      | Row                | Ms.   |
      | Transaction status | Draft |
    When the user clicks the kebab icon on 'Ms.'
    And the user clicks Delete
    Then Error toaster 'This Specialization Entry is used in one or more transactions and cannot be deleted.' is displayed and no confirmation dialog is shown

  # Ref: FRD 5.7 FB-2; FRD 5.7 DR-1
  @TC_SP_122 @Functional @High @Automation
  Scenario: Verify deletion is blocked for an entry used in an In Progress transaction
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Mrs.' is used in a saved record with status In Progress
    And the following test data is used
      | Row                | Mrs.        |
      | Transaction status | In Progress |
    When the user clicks the kebab icon on 'Mrs.'
    And the user clicks Delete
    Then Error toaster 'This Specialization Entry is used in one or more transactions and cannot be deleted.' is displayed and no confirmation dialog is shown

  # Ref: FRD 5.7 FB-2; FRD 5.7 DR-1
  @TC_SP_123 @Functional @High @Automation
  Scenario: Verify deletion is blocked for an entry used in a Closed transaction
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Dr.' is used in a saved record with status Closed
    And the following test data is used
      | Row                | Dr.    |
      | Transaction status | Closed |
    When the user clicks the kebab icon on 'Dr.'
    And the user clicks Delete
    Then Error toaster 'This Specialization Entry is used in one or more transactions and cannot be deleted.' is displayed and no confirmation dialog is shown

  # Ref: US-6 AC-1; FRD 5.7 DR-1
  @TC_SP_124 @Functional @Medium @Automation
  Scenario: Verify deletion is blocked when the entry is used in more than one transaction
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Mr.' is used in 3 saved records of different forms
    And the following test data is used
      | Row     | Mr.       |
      | Used in | 3 records |
    When the user clicks the kebab icon on 'Mr.'
    And the user clicks Delete
    Then Error toaster 'This Specialization Entry is used in one or more transactions and cannot be deleted.' is displayed and the entry remains

  # Ref: FRD 5.7 FB-3; FRD 5.7 DR-1
  @TC_SP_125 @Functional @High @Automation
  Scenario: Verify the Deletion Blocked event is written to the Activity Log
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Ms.' is used in a Draft record
    And the following test data is used
      | Row | Ms. |
    When the user clicks the kebab icon on 'Ms.' and click Delete
    And the user opens the Activity Log section
    Then Activity Log has entry 'Specialization Entry Deletion Blocked' for 'Ms.'

  # Ref: FRD 5.7 DR-4; US-6 AC-2
  @TC_SP_126 @Functional @High @Automation
  Scenario: Verify the server re-checks dependency on Yes when the entry became used after the dialog opened
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Adv.' is unused
    And A second session saves a record that uses 'Adv.' after the dialog opens
    And the following test data is used
      | Row               | Adv.                    |
      | Concurrent action | record saved using Adv. |
    When the user opens Delete for 'Adv.' (dialog shown)
    And In another session, save a record selecting 'Adv.'
    And the user clicks Yes in the dialog
    Then Deletion is blocked and message 'This Specialization Entry is used in one or more transactions and cannot be deleted.' is displayed
    And 'Adv.' remains in the list

  # Ref: FRD 5.7 FB-7
  @TC_SP_127 @Functional @Medium @Automation
  Scenario: Verify list refreshes without a toaster when the entry was already deleted by another user
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Sh.' was deleted by another user after this list was loaded
    And the following test data is used
      | Row | Sh. (already deleted) |
    When the user clicks the kebab icon on the stale row 'Sh.'
    And the user clicks Delete
    And the user observes the screen
    Then List is refreshed and 'Sh.' is no longer shown
    And No toaster is displayed

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-6 AC-1; FRD 5.7 FB-3
  @TC_SP_224 @Negative @High @Automation
  Scenario: Verify the confirmation dialog is not displayed when deletion is blocked
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Mr.' is used in a Completed record
    And the following test data is used
      | Row | Mr. |
    When the user clicks the kebab icon on 'Mr.'
    And the user clicks Delete
    And the user observes the screen
    Then No confirmation dialog appears; only the error toaster is shown

  # Ref: US-6 AC-2; FRD 5.7 BR-1
  @TC_SP_225 @Negative @High @Automation
  Scenario: Verify the server rejects a delete request for an entry used in a transaction
    Given API client authenticated as Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Mr. |
    When the user sends a delete request for 'Mr.' (used in a Completed record)
    And the user checks the stored records
    Then Request is rejected by the server dependency check and 'Mr.' still exists

  # Ref: FRD 5.7 DR-1; FRD 6.1 AA-5
  @TC_SP_226 @Negative @Medium @Automation
  Scenario: Verify no deletion entry is recorded when deletion is blocked
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Ms.' is used in a Draft record
    And the following test data is used
      | Row | Ms. |
    When the user attempts to delete 'Ms.'
    And the user searches the Activity Log for 'Specialization Entry Deleted' for 'Ms.'
    Then Only 'Specialization Entry Deletion Blocked' exists; no 'Specialization Entry Deleted' entry is created
