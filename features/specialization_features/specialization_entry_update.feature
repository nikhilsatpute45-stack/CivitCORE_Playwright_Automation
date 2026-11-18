@Specialization @SpecializationEntryUpdate
Feature: Specialization Entry Update
  Automated scenarios for the "Specialization Entry Update" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-1; FRD 5.5 FB-2
  @TC_SP_085 @Functional @High @Automation
  Scenario: Verify Edit pop-up opens pre-filled with editable Code, Name, Remark and read-only Misc Type
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Mr. / Mr. / Adult male title |
    When the user clicks the kebab icon on 'Mr.'
    And the user clicks Edit
    And the user observes the fields
    Then 'Edit Specialization Entry' pop-up opens with Code 'Mr.', Name 'Mr.' and Remark 'Adult male title'
    And Code, Name and Remark are editable
    And Misc Type 'List of Title' is read-only

  # Ref: US-5 AC-2; FRD 5.5 FB-4; FRD 7 T-2
  @TC_SP_086 @Functional @High @Automation
  Scenario: Verify Code can be updated and success toaster is shown
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row      | Miss |
      | New Code | Ms1  |
    When the user opens Edit for 'Miss'
    And the user changes Code to 'Ms1'
    And the user clicks Save
    Then Pop-up closes and toaster 'Specialization Entry updated successfully.' is displayed
    And List shows Code 'Ms1' for the row

  # Ref: US-5 AC-2; FRD 5.5 FB-4
  @TC_SP_087 @Functional @High @Automation
  Scenario: Verify Name can be updated and the change is reflected in the list
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row      | Smt.     |
      | New Name | Shrimati |
    When the user opens Edit for 'Smt.'
    And the user changes Name to 'Shrimati'
    And the user clicks Save
    Then List shows Name 'Shrimati' for the row

  # Ref: US-5 AC-2; FRD 5.3 FB-10
  @TC_SP_088 @Functional @Medium @Automation
  Scenario: Verify Remark can be updated and cleared
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Remark | Male title, then empty |
    When the user opens Edit for 'Mr.' and change Remark to 'Male title'
    And the user clicks Save
    And the user opens Edit again, clear Remark and click Save
    Then Remark shows 'Male title' after the first save and '-' after clearing

  # Ref: US-5 AC-2; FRD 5.3 FB-2
  @TC_SP_089 @Functional @Medium @Automation
  Scenario: Verify the list position does not change after Edit
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row      | Mrs.     |
      | New Name | Mistress |
    When the user opens Edit for 'Mrs.' (Sl. No. 2)
    And the user changes Name to 'Mistress'
    And the user clicks Save
    Then Row remains at Sl. No. 2

  # Ref: FRD 5.5 FB-4; FRD 5.4 FB-2
  @TC_SP_090 @Functional @Medium @Automation
  Scenario: Verify the Last Modified By and Last Modified On are recorded on update
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row  | Dr.         |
      | User | Admin_User1 |
    When the user opens Edit for 'Dr.' and change Remark to 'Doctor title'
    And the user clicks Save
    And the user opens View for 'Dr.'
    Then Last Modified By shows Admin_User1 and Last Modified On shows the current date-time

  # Ref: US-5 AC-3; FRD 5.5 BR-2
  @TC_SP_091 @Functional @High @Automation
  Scenario: Verify changing only the letter case of own Code is allowed
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row      | Mr. |
      | New Code | MR. |
    When the user opens Edit for 'Mr.'
    And the user changes Code to 'MR.'
    And the user clicks Save
    Then No duplicate error is shown
    And Toaster 'Specialization Entry updated successfully.' is displayed and Code shows 'MR.'

  # Ref: US-5 AC-3; FRD 5.5 BR-2
  @TC_SP_092 @Functional @High @Automation
  Scenario: Verify changing only the letter case of own Name is allowed
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row      | Miss |
      | New Name | MISS |
    When the user opens Edit for 'Miss'
    And the user changes Name to 'MISS'
    And the user clicks Save
    Then No duplicate error is shown
    And Toaster 'Specialization Entry updated successfully.' is displayed and Name shows 'MISS'

  # Ref: US-5 AC-4; FRD 5.5 BR-3
  @TC_SP_093 @Functional @High @Automation
  Scenario: Verify an entry used in transactions can be edited
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Mr.' is used in a Completed record
    And the following test data is used
      | Row      | Mr.    |
      | New Name | Mister |
    When the user opens Edit for 'Mr.'
    And the user changes Name to 'Mister'
    And the user clicks Save
    Then Update is allowed and toaster 'Specialization Entry updated successfully.' is displayed

  # Ref: FRD 5.5 BR-3; FRD 5.6 FB-3
  @TC_SP_094 @Functional @High @Automation
  Scenario: Verify edited Code and Name are shown in the transaction that uses the entry
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Mr.' is selected in a saved record of a CivitINFRA form
    And the following test data is used
      | Row      | Mr.    |
      | New Name | Mister |
    When the user edits 'Mr.' and change Name to 'Mister'
    And the user saves
    And the user opens the saved record that uses 'Mr.'
    Then The saved record shows 'Mister' for the Title field

  # Ref: FRD 5.6 BR-5; FRD 5.5 BR-3
  @TC_SP_095 @Functional @High @Automation
  Scenario: Verify transactions refer to the Specialization Entry by Internal ID and not Code or Name
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Mr.' is selected in a saved record of a CivitINFRA form
    And the following test data is used
      | Row      | Mr.    |
      | New Code | Mister |
    When the user queries the stored reference of the saved record for the Title field
    And the user edits Code of 'Mr.' to 'Mister'
    And the user queries the reference again
    Then Record stores the Internal ID of the entry, not the Code or Name
    And Reference is unchanged after the edit

  # Ref: FRD 5.2 BR-7
  @TC_SP_096 @Functional @High @Automation
  Scenario: Verify the Internal ID does not change after an update
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row      | Mr.    |
      | New Code | Mister |
    When the user notes the Internal ID of 'Mr.' in the stored record
    And the user edits Code to 'Mister' and Save
    And the user compares the Internal ID
    Then Internal ID is identical before and after the update

  # Ref: US-5 AC-5; FRD 5.5 FB-5
  @TC_SP_097 @Functional @High @Automation
  Scenario: Verify saving without any change closes the pop-up without update, toaster or audit entry
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Mr. |
    When the user opens Edit for 'Mr.'
    And the user does not change any field
    And the user clicks Save
    And the user checks the toaster, the record and the Activity Log
    Then Pop-up closes
    And No toaster is displayed, Last Modified fields are unchanged and no Activity Log entry is created

  # Ref: US-5 AC-6; FRD 5.5 FB-6
  @TC_SP_098 @Functional @Medium @Automation
  Scenario: Verify clicking Cancel on Edit closes the pop-up without saving
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row        | Mr.     |
      | Typed Name | Changed |
    When the user opens Edit for 'Mr.'
    And the user changes Name to 'Changed'
    And the user clicks Cancel
    And the user checks the list
    Then Pop-up closes and Name remains 'Mr.'

  # Ref: US-5 AC-6; FRD 5.5 FB-6
  @TC_SP_099 @Functional @Medium @Automation
  Scenario: Verify clicking the close (X) icon on Edit closes the pop-up without saving
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row        | Mr.     |
      | Typed Name | Changed |
    When the user opens Edit for 'Mr.'
    And the user changes Name to 'Changed'
    And the user clicks the close (X) icon
    And the user checks the list
    Then Pop-up closes and Name remains 'Mr.'

  # Ref: US-5 AC-2; FRD 5.6 FB-2
  @TC_SP_100 @Functional @High @Automation
  Scenario: Verify the edit is reflected in the form dropdown
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And A CivitINFRA form that uses 'List of Title' is available
    And the following test data is used
      | Row      | Miss     |
      | New Name | Ms. Miss |
    When the user edits 'Miss' and change Name to 'Ms. Miss'
    And the user saves
    And the user opens the form and open the Title dropdown
    Then Dropdown shows 'Ms. Miss' at the same position as before

  # Ref: FRD 5.5 BR-4; FRD 5.2 BR-3
  @TC_SP_101 @Functional @Medium @Automation
  Scenario: Verify Edit trims leading and trailing spaces in Code
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row      | Miss    |
      | New Code | ' Msx ' |
    When the user opens Edit for 'Miss'
    And the user changes Code to ' Msx '
    And the user clicks Save
    Then Entry is saved with Code 'Msx'

  # Ref: FRD 5.5 BR-4; FRD 5.2 BR-3
  @TC_SP_102 @Functional @Medium @Automation
  Scenario: Verify Edit reduces repeated internal spaces in Name
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row      | Smt.                   |
      | New Name | 'Shri Mati' (4 spaces) |
    When the user opens Edit for 'Smt.'
    And the user changes Name to 'Shri Mati'
    And the user clicks Save
    Then Entry is saved with Name 'Shri Mati'

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.5 FB-3; FRD 5.5 BR-4; FRD 7 E-1
  @TC_SP_217 @Negative @High @Automation
  Scenario: Verify Edit with blank Code shows 'Code is required.'
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row  | Mr.     |
      | Code | (empty) |
    When the user opens Edit for 'Mr.'
    And the user clears Code
    And the user clicks Save
    Then Field-level error 'Code is required.' is shown and the pop-up stays open

  # Ref: FRD 5.5 FB-3; FRD 5.5 BR-4; FRD 7 E-4
  @TC_SP_218 @Negative @High @Automation
  Scenario: Verify Edit with blank Name shows 'Name is required.'
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row  | Mr.     |
      | Name | (empty) |
    When the user opens Edit for 'Mr.'
    And the user clears Name
    And the user clicks Save
    Then Field-level error 'Name is required.' is shown and the pop-up stays open

  # Ref: FRD 5.5 BR-4; FRD 7 E-2
  @TC_SP_219 @Negative @High @Automation
  Scenario: Verify Edit with a space inside Code shows 'Code must not contain spaces.'
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row  | Mr. |
      | Code | M r |
    When the user opens Edit for 'Mr.'
    And the user changes Code to 'M r'
    And the user clicks Save
    Then Field-level error 'Code must not contain spaces.' is shown

  # Ref: US-5 AC-3; FRD 5.5 BR-2; FRD 7 E-3
  @TC_SP_220 @Negative @High @Automation
  Scenario: Verify Edit with another entry's Code shows the duplicate Code error
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row      | Mrs. |
      | New Code | mr.  |
    When the user opens Edit for 'Mrs.'
    And the user changes Code to 'mr.' (Code of 'Mr.')
    And the user clicks Save
    Then Field-level error 'A Specialization Entry with this code already exists for this field.' is shown and the record is not updated

  # Ref: US-5 AC-3; FRD 5.5 BR-2; FRD 7 E-5
  @TC_SP_221 @Negative @High @Automation
  Scenario: Verify Edit with another entry's Name shows the duplicate Name error
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row      | Mrs. |
      | New Name | MISS |
    When the user opens Edit for 'Mrs.'
    And the user changes Name to 'MISS' (Name of 'Miss')
    And the user clicks Save
    Then Field-level error 'A Specialization Entry with this name already exists for this field.' is shown and the record is not updated

  # Ref: FRD 5.5 BR-4; FRD 5.2 BR-8
  @TC_SP_222 @Negative @High @Automation
  Scenario: Verify the server rejects an update request with a duplicate Code
    Given API client authenticated as Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row  | Mrs. |
      | Code | MR.  |
    When the user sends an update request for 'Mrs.' that sets Code to 'MR.'
    And the user reads the entry
    Then Request is rejected and Code of 'Mrs.' is unchanged

  # Ref: FRD 5.5 BR-4; FRD 5.2 F-Code
  @TC_SP_223 @Negative @Medium @Automation
  Scenario: Verify the Edit pop-up cannot exceed the length limits
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed | ABCDEFGHIJKLMNOPQRSTU (21) |
    When the user opens Edit for 'Mr.'
    And the user types a 21-character Code
    And the user reads the Code value
    Then Code accepts only 20 characters
