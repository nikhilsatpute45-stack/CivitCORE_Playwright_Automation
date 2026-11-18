@Specialization @ConsumptionMiscellaneousMasterLink
Feature: Consumption & Miscellaneous Master Link
  Automated scenarios for the "Consumption & Miscellaneous Master Link" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.6 FB-1; FRD 5.6 BR-5
  @TC_SP_103 @Functional @High @Automation
  Scenario: Verify the form dropdown offers Names in the display sequence set on the Specialization screen
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And A CivitINFRA form that uses 'List of Title' is available
    And the following test data is used
      | Expected | Mr., Mrs., Miss, Dr., Smt., Sh., Ms. |
    When the user opens the CivitINFRA form with the Title field
    And the user opens the Title dropdown
    Then Dropdown lists the Name of every Specialization Entry in the display sequence

  # Ref: FRD 5.6 FB-2; FRD 5.2 FB-5
  @TC_SP_104 @Functional @High @Automation
  Scenario: Verify a newly added entry is offered on forms after reopening, without extra configuration
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And A CivitINFRA form that uses 'List of Title' is available
    And the following test data is used
      | Code | Prof.     |
      | Name | Professor |
    When the user adds Code 'Prof.' with Name 'Professor'
    And the user opens (or refresh) the CivitINFRA form
    And the user opens the Title dropdown
    Then 'Professor' is listed first in the Title dropdown

  # Ref: US-7 AC-2; FRD 5.6 FB-4
  @TC_SP_105 @Functional @High @Automation
  Scenario: Verify a deleted entry is no longer offered in the form dropdown
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Sh.' is unused
    And A CivitINFRA form that uses 'List of Title' is available
    And the following test data is used
      | Row | Sh. |
    When the user deletes 'Sh.' and confirm Yes
    And the user opens the CivitINFRA form
    And the user opens the Title dropdown
    Then 'Sh.' is not listed in the Title dropdown

  # Ref: FRD 5.6 BR-1
  @TC_SP_106 @Functional @High @Automation
  Scenario: Verify unchecking Display removes the Misc Type from the dropdown but keeps its entries
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And In the Miscellaneous Master, Display is unchecked for 'List of Title'
    And the following test data is used
      | Title | List of Title |
    When the user opens the Specialization screen and open the Misc Type dropdown
    And the user checks the stored Specialization Entries of 'List of Title'
    Then 'List of Title' is not in the dropdown and cannot be added to, edited, deleted or re-ordered on this screen
    And The 7 stored entries are kept

  # Ref: FRD 5.6 BR-2
  @TC_SP_107 @Functional @High @Automation
  Scenario: Verify forms continue to offer existing entries in the last saved sequence when Display is unchecked
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded. 'Dr.' was dragged to position 1 and Display of 'List of Title' is then unchecked
    And A form using 'List of Title' is available
    And the following test data is used
      | Expected order | Dr., Mr., Mrs., Miss, Smt., Sh., Ms. |
    When the user opens the CivitINFRA form with the Title field
    And the user opens the Title dropdown
    Then Dropdown still offers all 7 entries in the last saved display sequence

  # Ref: FRD 5.6 BR-2
  @TC_SP_108 @Functional @Medium @Automation
  Scenario: Verify checking Display again restores the Misc Type and its entries unchanged
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And Display of 'List of Title' was unchecked and is checked again
    And the following test data is used
      | Title | List of Title |
    When the user opens the Specialization screen
    And the user selects 'List of Title'
    Then 'List of Title' reappears in the dropdown with its 7 entries in the same sequence
