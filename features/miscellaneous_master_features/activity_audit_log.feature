@MiscellaneousMaster @ActivityAuditLog
Feature: Activity / Audit Log
  Automated scenarios for the "Activity / Audit Log" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1 AL-1; Section 4 AC-AU-1; FRD 6 FB-1; FRD 6 FB-3
  @TC_MM_127 @Functional @High @Automation
  Scenario: Verify a Title Created entry is written with user, date-time, Enum ID, Field Title, Parent Title and Display
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title  | Vendor Rating Scale |
      | Parent Title | List of Firm Type   |
      | Enum ID      | 401                 |
      | Display      | checked             |
    When As Admin_User1 create the Title
    And As Auditor_User1 open the Activity Log section and find the entry
    Then Entry 'Title Created' shows User Admin_User1, Date-Time, Enum ID 401, Field Title 'Vendor Rating Scale', Parent Title 'List of Firm Type' and Display checked

  # Ref: FRD 6.1 AL-2; Section 4 AC-AU-2
  @TC_MM_128 @Functional @High @Automation
  Scenario: Verify a Title Updated entry records the previous and new value of the changed field
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | List of Operator -> List of Operators |
    When As Admin_User1 edit 'List of Operator' and change Field Title
    And As Auditor_User1 open the Activity Log and find the entry
    Then Entry 'Title Updated' shows User, Date-Time, Enum ID 104 and Field Name 'Field Title' with Previous Value 'List of Operator' and New Value 'List of Operators'

  # Ref: Section 4 AC-AU-2; FRD 6.1 AL-2
  @TC_MM_129 @Functional @High @Automation
  Scenario: Verify a Title Updated entry captures every changed field when several fields change
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Data    | Draft Field -> Draft Field Updated |
      | Parent  | none -> List of Title              |
      | Enum ID | blank -> 506                       |
      | Display | unchecked -> checked               |
    When As Admin_User1 edit 'Draft Field' and change Field Title, Parent Title, Enum ID and Display together, then Save
    And As Auditor_User1 find the entry
    Then The entry lists Field Title, Parent Title, Enum ID and Display, each with Previous Value and New Value

  # Ref: FRD 6.1 AL-3; FRD 5.6 FB-2; Section 4 AC-AU-1
  @TC_MM_130 @Functional @High @Automation
  Scenario: Verify a Display Changed entry is written when Display is changed from the list
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Specialization (Enum ID 103) |
      | Display | unchecked -> checked                 |
    When As Admin_User1 check Display of 'List of Specialization' in the list
    And As Auditor_User1 find the entry
    Then Entry 'Display Changed' shows User, Date-Time, Enum ID 103, Field Title 'List of Specialization', Previous Value 'Unchecked' and New Value 'Checked'

  # Ref: FRD 6.1 AL-2; FRD 5.6 BR-2
  @TC_MM_131 @Functional @Medium @Automation
  Scenario: Verify a Display change made from the Edit form is recorded as a Title Updated entry for the Display field
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Specialization |
      | Display | unchecked -> checked   |
    When As Admin_User1 edit 'List of Specialization' and check Display only; Save
    And As Auditor_User1 find the entry
    Then Entry 'Title Updated' lists Field Name 'Display' with Previous Value and New Value (Assumption A-9)

  # Ref: FRD 6.1 AL-4; Section 4 AC-AU-1; FRD 5.8 FB-5
  @TC_MM_132 @Functional @High @Automation
  Scenario: Verify a Title Deleted entry is written when a Title is deleted
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Legacy Field (Enum ID 601) |
    When As Admin_User1 delete 'Legacy Field' and click Yes
    And As Auditor_User1 find the entry
    Then Entry 'Title Deleted' shows User, Date-Time, Enum ID 601 and Field Title 'Legacy Field'

  # Ref: FRD 6.1 AL-5; FRD 5.8 DR-1; FRD 5.8 FB-3
  @TC_MM_133 @Functional @High @Automation
  Scenario: Verify a Title Deletion Blocked entry with reason Transaction is written
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Site Category (Enum ID 107) |
    When As Admin_User1 select Delete on 'Site Category'
    And As Auditor_User1 find the entry
    Then Entry 'Title Deletion Blocked' shows User, Date-Time, Enum ID 107, Field Title 'Site Category' and Reason 'Transaction'

  # Ref: FRD 6.1 AL-5; FRD 5.8 DR-2; FRD 5.8 FB-3
  @TC_MM_134 @Functional @High @Automation
  Scenario: Verify a Title Deletion Blocked entry with reason Parent Title is written
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Measurement Groups |
    When As Admin_User1 select Delete on 'Measurement Groups'
    And As Auditor_User1 find the entry
    Then Entry 'Title Deletion Blocked' shows Reason 'Parent Title'

  # Ref: FRD 6.1 AL-5; FRD 5.8 DR-3; FRD 5.8 FB-3
  @TC_MM_135 @Functional @High @Automation
  Scenario: Verify a Title Deletion Blocked entry with reason Specialization Master is written
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Zone Type (Enum ID 108) |
    When As Admin_User1 select Delete on 'Zone Type'
    And As Auditor_User1 find the entry
    Then Entry 'Title Deletion Blocked' shows Reason 'Specialization Master'

  # Ref: FRD 6 FB-2
  @TC_MM_136 @Functional @Medium @Automation
  Scenario: Verify each entry is linked to the Title by Internal ID and shows the Enum ID where one exists
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Titles | Contractor Category (no Enum ID), Vendor Rating Scale (401) |
    When As Admin_User1 create Title 'Contractor Category' without Enum ID and Title 'Vendor Rating Scale' with Enum ID 401
    And As Auditor_User1 open both entries
    Then Both entries reference their Title's Internal ID; the Enum ID 401 is shown on the second entry and no Enum ID is shown on the first

  # Ref: FRD 6 FB-2; FRD 5.2 BR-9
  @TC_MM_137 @Functional @Medium @Automation
  Scenario: Verify an Activity Log entry remains linked to the same Title after it is renamed
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | List of Operator -> List of Operators |
    When As Admin_User1 rename 'List of Operator' to 'List of Operators'
    And As Auditor_User1 compare the Internal ID on the earlier entries and the new entry
    Then All entries show the same Title Internal ID

  # Ref: FRD 6 FB-4
  @TC_MM_138 @Functional @Medium @Automation
  Scenario: Verify Activity Log entries are displayed most recent first
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Contractor Category |
    When As Admin_User1 create Title 'Contractor Category', then edit it, then delete it
    And As Auditor_User1 open the Activity Log
    Then Entries are listed most recent first: Title Deleted, Title Updated, Title Created

  # Ref: FRD 5.4 BR-1
  @TC_MM_139 @Functional @Medium @Automation
  Scenario: Verify View does not create an Activity Log entry
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | List of Operator |
    When the user notes the entry count for 'List of Operator' in the Activity Log
    And As Admin_User1 open View for 'List of Operator' and close it
    And the user rechecks the entry count
    Then No new Activity Log entry is created and no data is changed

  # Ref: Section 4 AC-ED-4; FRD 5.5 FB-5; FRD 6 FB-1
  @TC_MM_140 @Functional @High @Automation
  Scenario: Verify saving an Edit form without changes does not create an Activity Log entry
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | List of Operator |
    When As Admin_User1 open Edit on 'List of Operator' and click Save without changes
    And As Auditor_User1 check the Activity Log
    Then No Activity Log entry is created

  # Ref: FRD 6 FB-4
  @TC_MM_141 @Functional @High @Automation
  Scenario: Verify Activity Log entries cannot be edited or deleted by any user
    Given Admin_User1 performs the actions and Auditor_User1 (Activity Log section access) views the log
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User  | Auditor_User1             |
      | Entry | any 'Title Created' entry |
    When As Auditor_User1 open the Activity Log and look for edit/delete controls
    And the user sends an update and a delete request for an entry using the API
    Then No edit or delete control exists
    And Both API requests are rejected and the entry remains unchanged
