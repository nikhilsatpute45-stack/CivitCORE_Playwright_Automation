@Specialization @ToasterMessages
Feature: Toaster Messages
  Automated scenarios for the "Toaster Messages" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 7 T-AUTO; FRD 7 T-1
  @TC_SP_137 @Functional @Medium @Automation
  Scenario: Verify success toaster closes automatically after 5 seconds
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Toaster | Specialization Entry added successfully. |
    When the user adds Code 'Prof.' with Name 'Professor' and Save
    And the user starts a timer when the toaster appears
    And the user observes the toaster without clicking
    Then Toaster closes automatically after 5 seconds

  # Ref: FRD 7 T-AUTO; FRD 7 T-4
  @TC_SP_138 @Functional @Medium @Automation
  Scenario: Verify error toaster closes automatically after 5 seconds
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Ms.' is used in a Draft record
    And the following test data is used
      | Toaster | This Specialization Entry is used in one or more transactions and cannot be deleted. |
    When the user opens Delete for 'Ms.'
    And the user starts a timer when the error toaster appears
    And the user observes the toaster without clicking
    Then Toaster closes automatically after 5 seconds

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-5; FRD 7 T-ONLY
  @TC_SP_229 @Negative @Medium @Automation
  Scenario: Verify no toaster is displayed when saving an Edit with no changes
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Mr. |
    When the user opens Edit for 'Mr.'
    And the user clicks Save without changes
    And the user observes the screen for 6 seconds
    Then Pop-up closes and no toaster appears

  # Ref: FRD 5.7 FB-7; FRD 7 T-ONLY
  @TC_SP_230 @Negative @Medium @Automation
  Scenario: Verify no toaster is displayed when the entry was already deleted by another user
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Sh.' was deleted by another user after this list was loaded
    And the following test data is used
      | Row | Sh. |
    When the user clicks Delete on the stale row 'Sh.'
    And the user observes the screen for 6 seconds
    Then List refreshes and no toaster appears
