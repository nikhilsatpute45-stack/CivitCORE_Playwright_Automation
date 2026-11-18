@Specialization @SpecializationEntryView
Feature: Specialization Entry View
  Automated scenarios for the "Specialization Entry View" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-4 AC-1; FRD 5.4 FB-2; FRD 5.4 FB-1
  @TC_SP_077 @Functional @High @Automation
  Scenario: Verify View pop-up shows all details in read-only mode
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Mr.' was created by Admin_User1 and has been modified once by Admin_User1
    And the following test data is used
      | Row | Mr. |
    When the user clicks the kebab icon on 'Mr.'
    And the user clicks View
    And the user reads the pop-up
    Then 'View Specialization Entry' pop-up shows Misc Type, Code, Name, Remark, Created By, Created On, Last Modified By and Last Modified On
    And All values are read-only

  # Ref: FRD 5.4 FB-2
  @TC_SP_078 @Functional @Medium @Automation
  Scenario: Verify blank Remark and never-modified fields show '-' in View
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Miss' has blank Remark and was never modified
    And the following test data is used
      | Row | Miss |
    When the user opens View for 'Miss'
    And the user reads Remark, Last Modified By and Last Modified On
    Then Remark, Last Modified By and Last Modified On each show '-'

  # Ref: US-4 AC-2; FRD 5.4 FB-3
  @TC_SP_079 @Functional @High @Automation
  Scenario: Verify Edit button on View is shown to a user with Edit permission
    Given Editor_User1 (Specialization: View/Edit) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Editor_User1 |
    When the user opens View for 'Mr.'
    And the user observes the buttons
    Then 'Edit' button and 'Close' are displayed

  # Ref: FRD 5.4 FB-3; FRD 5.5 FB-1
  @TC_SP_080 @Functional @Medium @Automation
  Scenario: Verify clicking Edit on the View pop-up opens Edit for the same entry
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Mr. |
    When the user opens View for 'Mr.'
    And the user clicks Edit
    Then 'Edit Specialization Entry' pop-up opens pre-filled with Code 'Mr.' and the Name/Remark of the same entry

  # Ref: US-4 AC-2; FRD 5.4 FB-4
  @TC_SP_081 @Functional @Medium @Automation
  Scenario: Verify Close on View returns to the list with the same Misc Type, page and search
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And Misc Type 'List of Qualification', page 2, Code search 'Q'
    And the following test data is used
      | Search | Q |
      | Page   | 2 |
    When the user opens View for the first row
    And the user clicks Close
    And the user observes the list state
    Then Same Misc Type, page 2 and Code search 'Q' are retained

  # Ref: FRD 5.4 FB-4
  @TC_SP_082 @Functional @Low @Automation
  Scenario: Verify the close (X) icon on View returns to the list with the same state
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And Misc Type 'List of Qualification', page 2, Code search 'Q'
    And the following test data is used
      | Search | Q |
      | Page   | 2 |
    When the user opens View for the first row
    And the user clicks the close (X) icon
    And the user observes the list state
    Then Same Misc Type, page 2 and Code search 'Q' are retained

  # Ref: FRD 5.4 BR-1; FRD 6.1 AA-1
  @TC_SP_083 @Functional @High @Automation
  Scenario: Verify View neither changes data nor creates an Activity Log entry
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Mr. |
    When the user notes the number of Activity Log entries for 'Mr.'
    And the user opens View for 'Mr.' and click Close
    And the user checks the Activity Log and the record
    Then Record is unchanged
    And No new Activity Log entry is created

  # Ref: FRD 5.4 BR-2
  @TC_SP_084 @Functional @Medium @Automation
  Scenario: Verify list refreshes without a toaster when the entry was deleted by another user before View
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Sh.' was deleted by another user after this list was loaded
    And the following test data is used
      | Row | Sh. (already deleted) |
    When the user clicks the kebab icon on the stale row 'Sh.'
    And the user clicks View
    And the user observes the screen
    Then List is refreshed and no longer shows 'Sh.'
    And No toaster is displayed
