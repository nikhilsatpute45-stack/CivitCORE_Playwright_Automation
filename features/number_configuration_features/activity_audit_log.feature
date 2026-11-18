@NumberConfiguration @ActivityAuditLog
Feature: Activity / Audit Log
  Automated scenarios for the "Activity / Audit Log" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 7.1 A-Created; US-8 AC-1
  @TC_NC_101 @Functional @High @Automation
  Scenario: Verify a Created entry is logged with the required information
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process    | Purchase Order |
      | Separator  | /              |
      | Status     | InActive       |
      | Start With | 1              |
      | Digits     | 0001           |
      | Attribute  | Office         |
    When the user creates a Purchase Order configuration (Separator '/', Status InActive, Start With 1, Digits 0001, attribute Office OFF)
    And the user opens the Activity Log
    Then Entry 'Number Configuration Created' exists with User, Date/Time, Process and configuration details (Separator, Status, Start With, Digits, attribute sequence)

  # Ref: FRD 7.1 A-Updated; US-8 AC-1
  @TC_NC_102 @Functional @High @Automation
  Scenario: Verify an Updated entry is logged with Field Changed, Previous Value and New Value
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Digits | 0001 -> 00001 |
    When the user edits PO-Cfg-3 and change Digits from '0001' to '00001'
    And the user opens the Activity Log
    Then Entry 'Number Configuration Updated' has User, Date/Time, Process, Field Changed 'Digits', Previous '0001', New '00001'

  # Ref: FRD 7.1 A-Activated; US-8 AC-1
  @TC_NC_103 @Functional @High @Automation
  Scenario: Verify an Activated entry is logged with the previously Active configuration
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Activated | PO-Cfg-3 |
      | Previous  | PO-Cfg-1 |
    When the user activates PO-Cfg-3 (PO-Cfg-1 is Active) and confirm
    And the user opens the Activity Log
    Then Entry 'Number Configuration Activated' has User, Date/Time, Process, identifier PO-Cfg-3 and previously Active identifier PO-Cfg-1

  # Ref: FRD 7.1 A-Activated
  @TC_NC_104 @Functional @Medium @Automation
  Scenario: Verify an Activated entry is logged without a previous identifier when none was Active
    Given PO-Cfg-1 has been deactivated so no Purchase Order configuration is Active
    And API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Activated | PO-Cfg-3 |
      | Previous  | none     |
    When the user activates PO-Cfg-3
    And the user opens the Activity Log
    Then Entry has User, Date/Time, Process and PO-Cfg-3; previously-Active field is empty ('if any')

  # Ref: FRD 7.1 A-Deactivated; US-8 AC-1
  @TC_NC_105 @Functional @High @Automation
  Scenario: Verify a Deactivated entry is logged
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Deactivated | WO-Cfg-1 |
    When the user deactivates WO-Cfg-1
    And the user opens the Activity Log
    Then Entry 'Number Configuration Deactivated' has User, Date/Time, Process and identifier WO-Cfg-1

  # Ref: FRD 7.1 A-Deleted; FRD 6.6 FB-7; FRD 6.6 DT-4
  @TC_NC_106 @Functional @High @Automation
  Scenario: Verify a successful delete is recorded in the Activity Log
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Deleted | PO-Cfg-4 |
    When the user deletes PO-Cfg-4 and confirm
    And the user opens the Activity Log
    Then Entry 'Number Configuration Deleted' has User, Date/Time, Process and identifier PO-Cfg-4

  # Ref: FRD 7.1 A-DelBlocked; FRD 6.6 DT-1
  @TC_NC_107 @Functional @High @Automation
  Scenario: Verify a Deletion Blocked entry is logged with reason 'Active Status'
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-1 |
    When the user attempts to delete PO-Cfg-1 (Active)
    And the user opens the Activity Log
    Then Entry 'Number Configuration Deletion Blocked' has User, Date/Time, Process, identifier and Blocking Reason 'Active Status'

  # Ref: FRD 7.1 A-DelBlocked; FRD 6.6 DT-2
  @TC_NC_108 @Functional @High @Automation
  Scenario: Verify a Deletion Blocked entry is logged with reason 'Used at Transaction Level'
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-2 |
    When the user attempts to delete PO-Cfg-2 (InActive, used)
    And the user opens the Activity Log
    Then Entry 'Number Configuration Deletion Blocked' has User, Date/Time, Process, identifier and Blocking Reason 'Used at Transaction Level'

  # Ref: FRD 7 Intro
  @TC_NC_109 @Functional @Medium @Automation
  Scenario: Verify the Activity Log lists entries chronologically
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Actions | create, activate, deactivate |
    When the user creates, activate and then deactivate a configuration
    And the user opens the Activity Log
    Then Entries appear in chronological order by Date/Time (chronological direction per FRD §7)

  # Ref: US-8 AC-1; FRD 7 Intro
  @TC_NC_110 @Functional @High @Automation
  Scenario: Verify an Auditor can view the Activity Log in read-only mode
    Given Auditor_User1 (CivitCORE Auditor: Activity Log read access) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Auditor_User1 |
    When the user opens the Number Configuration Activity Log
    And the user inspects available controls on an entry
    Then Entries are visible
    And No edit or delete control is available

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 7 Intro; US-8 AC-1
  @TC_NC_226 @Negative @High @Automation
  Scenario: Verify Activity Log entries cannot be edited or deleted
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And An Activity Log entry exists
    And the following test data is used
      | User | Admin_User1 |
    When the user sends an update request for an Activity Log entry
    And the user sends a delete request for the same entry
    Then Both requests are rejected; the entry is unchanged (log is read-only)

  # Ref: FRD 6.6 DT-5; FRD 7.1 A-Deleted
  @TC_NC_227 @Negative @Medium @Automation
  Scenario: Verify a cancelled delete creates no Activity Log entry
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-4 |
    When the user opens the delete dialog for PO-Cfg-4 and cancel
    And the user opens the Activity Log
    Then No 'Deleted' or 'Deletion Blocked' entry is created

  # Ref: FRD 7.1 A-Created; FRD 6.2 BR-10
  @TC_NC_228 @Negative @Medium @Automation
  Scenario: Verify a validation-failed Save creates no Created entry
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attributes | none |
    When the user attempts to create a configuration with no attributes
    And the user opens the Activity Log
    Then No 'Created' entry is logged (record is not created)
