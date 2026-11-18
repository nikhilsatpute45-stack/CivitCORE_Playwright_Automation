@Specialization @ActivityAuditLog
Feature: Activity / Audit Log
  Automated scenarios for the "Activity / Audit Log" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-8 AC-1; FRD 6.1 AA-1; FRD 6 AL-1
  @TC_SP_128 @Functional @High @Automation
  Scenario: Verify an Activity Log entry is written on creation with User, Date-Time, Misc Type, Code, Name and Remark
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code   | Prof.          |
      | Name   | Professor      |
      | Remark | Academic title |
      | User   | Admin_User1    |
    When the user adds Code 'Prof.', Name 'Professor', Remark 'Academic title'
    And the user opens the Activity Log section
    And the user opens the latest entry
    Then Entry 'Specialization Entry Created' shows Admin_User1, date-time, Misc Type 'List of Title', Code 'Prof.', Name 'Professor' and Remark 'Academic title'

  # Ref: US-8 AC-2; FRD 6.1 AA-2; FRD 6 AL-3
  @TC_SP_129 @Functional @High @Automation
  Scenario: Verify an Activity Log entry on update lists each changed field with previous and new value
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Miss > Ms1          |
      | Name | Miss > Miss Updated |
    When the user edits 'Miss': change Code to 'Ms1' and Name to 'Miss Updated'
    And the user clicks Save
    And the user opens the latest Activity Log entry
    Then Entry 'Specialization Entry Updated' lists Field Name, Previous Value and New Value for Code (Miss > Ms1) and Name (Miss > Miss Updated), plus User, Date-Time, Misc Type, Code, Name

  # Ref: US-8 AC-2; FRD 6.1 AA-2
  @TC_SP_130 @Functional @Medium @Automation
  Scenario: Verify an update of a single field lists only that field in the Activity Log
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Remark | (blank) > Title for married women |
    When the user edits 'Smt.': change only Remark to 'Title for married women'
    And the user clicks Save
    And the user opens the latest Activity Log entry
    Then Entry lists only the Remark field with Previous Value blank and New Value 'Title for married women'

  # Ref: US-8 AC-1; FRD 6.1 AA-3; FRD 5.7 FB-5
  @TC_SP_131 @Functional @High @Automation
  Scenario: Verify an Activity Log entry is written on deletion
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Adv.' / 'Advocate' exists and is unused
    And the following test data is used
      | Row | Adv. / Advocate |
    When the user deletes 'Adv.' and confirm Yes
    And the user opens the latest Activity Log entry
    Then Entry 'Specialization Entry Deleted' shows User, Date-Time, Misc Type 'List of Title', Code 'Adv.' and Name 'Advocate'

  # Ref: US-8 AC-1; FRD 6.1 AA-4
  @TC_SP_132 @Functional @High @Automation
  Scenario: Verify an Activity Log entry is written on sequence change with previous and new position
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row               | Dr. |
      | Previous position | 4   |
      | New position      | 1   |
    When the user drags 'Dr.' from Sl. No. 4 to Sl. No. 1
    And the user opens the latest Activity Log entry
    Then Entry 'Sequence Changed' shows User, Date-Time, Misc Type, Code 'Dr.', Name 'Dr.', previous position 4 and new position 1

  # Ref: US-8 AC-1; FRD 6.1 AA-5
  @TC_SP_133 @Functional @High @Automation
  Scenario: Verify the Deletion Blocked Activity Log entry captures the Reason (Transaction)
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Ms.' is used in a Draft record
    And the following test data is used
      | Row | Ms. |
    When the user attempts to delete 'Ms.'
    And the user opens the latest Activity Log entry
    Then Entry shows User, Date-Time, Misc Type 'List of Title', Code 'Ms.', Name 'Ms.' and Reason 'Transaction'

  # Ref: FRD 6 AL-2
  @TC_SP_134 @Functional @High @Automation
  Scenario: Verify each Activity Log entry is linked to the Internal ID and Misc Type
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Prof.     |
      | Name | Professor |
    When the user adds Code 'Prof.' with Name 'Professor'
    And the user queries the latest Activity Log record
    Then Log record references the Internal ID of the new entry and the Misc Type 'List of Title'

  # Ref: FRD 6 AL-4
  @TC_SP_135 @Functional @Medium @Automation
  Scenario: Verify Activity Log entries are displayed most recent first
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Activity Log has entries for Create, Update and Delete of 'Prof.' in that order
    And the following test data is used
      | Activities | Created, Updated, Deleted (in that time order) |
    When the user opens the Activity Log section
    And the user reads the order of the entries
    Then Entries are listed most recent first: Deleted, Updated, Created

  # Ref: FRD 5.2 FB-7
  @TC_SP_136 @Functional @Medium @Automation
  Scenario: Verify no Activity Log entry is created when Add is cancelled
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | Prof. |
    When the user clicks 'Add', enter Code 'Prof.' and Name 'Professor'
    And the user clicks Cancel
    And the user opens the Activity Log
    Then No log entry exists for 'Prof.'

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6 AL-4
  @TC_SP_227 @Negative @High @Automation
  Scenario: Verify Activity Log entries cannot be edited via API
    Given API client authenticated as Admin_User1
    And An Activity Log entry exists for 'Prof.' creation
    And the following test data is used
      | Entry | Specialization Entry Created / Prof. |
    When the user sends an update request for the Activity Log entry
    And the user reads the entry
    Then Request is rejected and the entry is unchanged

  # Ref: FRD 6 AL-4
  @TC_SP_228 @Negative @High @Automation
  Scenario: Verify Activity Log entries cannot be deleted via API
    Given API client authenticated as Admin_User1
    And An Activity Log entry exists for 'Prof.' creation
    And the following test data is used
      | Entry | Specialization Entry Created / Prof. |
    When the user sends a delete request for the Activity Log entry
    And the user reads the Activity Log
    Then Request is rejected and the entry still exists
