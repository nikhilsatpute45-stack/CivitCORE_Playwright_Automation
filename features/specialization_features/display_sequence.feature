@Specialization @DisplaySequence
Feature: Display Sequence
  Automated scenarios for the "Display Sequence" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-1; FRD 5.3 DS-1; FRD 5.3 DS-2
  @TC_SP_065 @Functional @High @Automation
  Scenario: Verify dragging a row to a new position saves the order immediately
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row           | Dr. |
      | From position | 4   |
      | To position   | 1   |
    When the user drags row 'Dr.' (Sl. No. 4) and drop it at position 1
    And the user observes the list without clicking any Save button
    And the user refreshes the page
    Then 'Dr.' is shown as Sl. No. 1 and the other rows move down by one (Mr. 2, Mrs. 3, Miss 4)
    And Order is saved immediately and persists after refresh

  # Ref: US-3 AC-1; FRD 7 T-5
  @TC_SP_066 @Functional @High @Automation
  Scenario: Verify success toaster is shown after a successful drag and drop
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Dr. |
    When the user drags row 'Dr.' (Sl. No. 4) and drop it at position 1
    And the user observes the toaster
    Then Toaster 'Sequence updated successfully.' is displayed

  # Ref: FRD 5.3 DS-1
  @TC_SP_067 @Functional @Medium @Automation
  Scenario: Verify dragging a row downwards moves the rows in between up by one
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row  | Mr. |
      | From | 1   |
      | To   | 4   |
    When the user drags row 'Mr.' (Sl. No. 1) and drop it at position 4
    And the user observes the order
    Then Order is Mrs., Miss, Dr., Mr., Smt., Sh., Ms. with Sl. No. 1 to 7

  # Ref: FRD 5.3 DS-2
  @TC_SP_068 @Functional @Medium @Automation
  Scenario: Verify Sl. No. is re-sequenced after drag and drop
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row  | Ms. |
      | From | 7   |
      | To   | 2   |
    When the user drags row 'Ms.' (Sl. No. 7) and drop it at position 2
    And the user reads the Sl. No. column from top to bottom
    Then Sl. No. reads 1 to 7 continuously with 'Ms.' at Sl. No. 2

  # Ref: US-3 AC-2; FRD 5.3 DS-4
  @TC_SP_069 @Functional @High @Automation
  Scenario: Verify a row can be dropped only within the current page
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row    | Q001                 |
      | Target | Sl. No. 50 on page 1 |
    When the user selects 'List of Qualification'
    And the user drags row 'Q001' (Sl. No. 1) to the last position of page 1
    And the user observes the page and order
    Then 'Q001' is placed at Sl. No. 50 on page 1
    And No row moves to or from page 2

  # Ref: FRD 5.3 DS-4
  @TC_SP_070 @Functional @Medium @Automation
  Scenario: Verify dropping a row outside the grid leaves the order unchanged
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Dr. |
    When the user drags row 'Dr.' and drop it outside the grid (on the page header area)
    And the user observes the order and toasters
    Then Order is unchanged and no sequence toaster is displayed

  # Ref: US-3 AC-6; FRD 5.3 DS-3; FRD 7 T-6
  @TC_SP_071 @Functional @High @Automation
  Scenario: Verify rows return to the previous order and error toaster is shown when the sequence cannot be saved
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And The sequence-save request is configured to fail (network blocked)
    And the following test data is used
      | Row  | Dr. |
      | From | 4   |
      | To   | 1   |
    When the user drags row 'Dr.' (Sl. No. 4) and drop it at position 1
    And the user observes the order and toaster
    Then Rows return to the previous order ('Dr.' at Sl. No. 4)
    And Toaster 'Unable to update the sequence. Please try again.' is displayed

  # Ref: US-3 AC-3; FRD 5.6 FB-1; FRD 5.3 DS-6
  @TC_SP_072 @Functional @High @Automation
  Scenario: Verify form dropdown follows the new display sequence
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded. 'Dr.' was dragged to position 1
    And A CivitINFRA form that uses 'List of Title' is available
    And the following test data is used
      | Expected order | Dr., Mr., Mrs., Miss, Smt., Sh., Ms. |
    When the user opens the CivitINFRA form with the Title field
    And the user opens the Title dropdown
    And the user reads the options
    Then Dropdown lists the Names in the same order as the Specialization list

  # Ref: FRD 5.3 DS-6
  @TC_SP_073 @Functional @Medium @Automation
  Scenario: Verify the display sequence is kept separately per Misc Type
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row               | Dr.           |
      | Misc Type checked | List of Grade |
    When the user drags 'Dr.' to position 1 in 'List of Title'
    And the user selects 'List of Grade'
    And the user reads the order of 'List of Grade'
    Then 'List of Grade' order is unchanged

  # Ref: US-3 AC-4; FRD 5.2 FB-5
  @TC_SP_074 @Functional @Medium @Automation
  Scenario: Verify a new entry is placed at the top without disturbing the custom order
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded. 'Dr.' was dragged to position 1 (order Dr., Mr., Mrs., Miss, Smt., Sh., Ms.)
    And the following test data is used
      | Code | Prof.     |
      | Name | Professor |
    When the user adds Code 'Prof.' with Name 'Professor'
    And the user reads the order
    Then 'Prof.' is Sl. No. 1 and the remaining order is Dr., Mr., Mrs., Miss, Smt., Sh., Ms. (Sl. No. 2 to 8)

  # Ref: US-3 AC-1; FRD 5.3 C-Drag
  @TC_SP_075 @Functional @High @Automation
  Scenario: Verify drag handle is enabled for a user with Edit permission and no search active
    Given Editor_User1 (Specialization: View/Edit) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Editor_User1 |
    When the user observes the drag handle of each row
    And the user drags row 'Dr.' to position 1
    Then Drag handles are enabled and the row can be moved

  # Ref: US-5 AC-2; FRD 5.3 FB-2
  @TC_SP_076 @Functional @Medium @Automation
  Scenario: Verify the list stays in sequence after editing a Specialization Entry
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row    | Dr.          |
      | Remark | Doctor title |
    When the user edits 'Dr.' (Sl. No. 4) and change Remark to 'Doctor title'
    And the user clicks Save
    And the user observes the position of 'Dr.'
    Then 'Dr.' remains at Sl. No. 4
