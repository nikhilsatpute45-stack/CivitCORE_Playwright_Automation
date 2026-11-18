@AuditTrail @AuditLogging
Feature: Audit Logging
  Automated scenarios for the "Audit Logging" area of the CivitCORE Audit Trail.
  Source: CivitCORE_AuditTrail_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-005 CivitCORE CORE Module - Audit Trail, Ver 1.0, 28-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-6 AC-1; FRD 6.2 FB-2; FRD 7.1 A-Create; FRD 6.2 BR-2
  @TC_CP_041 @Functional @High @Automation
  Scenario: Verify a successful Creation in Department is logged automatically (Ref US-6 AC-1, FRD 6.2 FB-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Department |
      | Record   | Civil Works |
    When Open the Department module
    And Create a new record 'Civil Works' and save successfully
    And Open Audit Trail with default filters
    And Locate the new entry
    Then An entry is created automatically with Function Name 'Department', current Log Date & Time, backend-configured Class Name, Client IP and Message 'Department created successfully.' (format '[Entity] created successfully.').
    And No manual logging action was required.

  # Ref: US-6 AC-1; FRD 6.2 FB-2; FRD 7.1 A-Create; FRD 6.2 BR-2
  @TC_CP_042 @Functional @High @Automation
  Scenario: Verify a successful Creation in Office is logged automatically (Ref US-6 AC-1, FRD 6.2 FB-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Office |
      | Record   | Pune Site Office |
    When Open the Office module
    And Create a new record 'Pune Site Office' and save successfully
    And Open Audit Trail with default filters
    And Locate the new entry
    Then An entry is created automatically with Function Name 'Office', current Log Date & Time, backend-configured Class Name, Client IP and Message 'Office created successfully.' (format '[Entity] created successfully.').
    And No manual logging action was required.

  # Ref: US-6 AC-1; FRD 6.2 FB-2; FRD 7.1 A-Create; FRD 6.2 BR-2
  @TC_CP_043 @Functional @High @Automation
  Scenario: Verify a successful Creation in Organization is logged automatically (Ref US-6 AC-1, FRD 6.2 FB-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Organization |
      | Record   | SoftTech Infra Pvt Ltd |
    When Open the Organization module
    And Create a new record 'SoftTech Infra Pvt Ltd' and save successfully
    And Open Audit Trail with default filters
    And Locate the new entry
    Then An entry is created automatically with Function Name 'Organization', current Log Date & Time, backend-configured Class Name, Client IP and Message 'Organization created successfully.' (format '[Entity] created successfully.').
    And No manual logging action was required.

  # Ref: US-6 AC-1; FRD 6.2 FB-2; FRD 7.1 A-Create; FRD 6.2 BR-2
  @TC_CP_044 @Functional @High @Automation
  Scenario: Verify a successful Creation in Post is logged automatically (Ref US-6 AC-1, FRD 6.2 FB-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Post |
      | Record   | Site Supervisor |
    When Open the Post module
    And Create a new record 'Site Supervisor' and save successfully
    And Open Audit Trail with default filters
    And Locate the new entry
    Then An entry is created automatically with Function Name 'Post', current Log Date & Time, backend-configured Class Name, Client IP and Message 'Post created successfully.' (format '[Entity] created successfully.').
    And No manual logging action was required.

  # Ref: US-6 AC-1; FRD 6.2 FB-2; FRD 7.1 A-Create; FRD 6.2 BR-2
  @TC_CP_045 @Functional @High @Automation
  Scenario: Verify a successful Creation in Standards & Formats is logged automatically (Ref US-6 AC-1, FRD 6.2 FB-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Standards & Formats |
      | Record   | Daily Progress Report Format |
    When Open the Standards & Formats module
    And Create a new record 'Daily Progress Report Format' and save successfully
    And Open Audit Trail with default filters
    And Locate the new entry
    Then An entry is created automatically with Function Name 'Standards & Formats', current Log Date & Time, backend-configured Class Name, Client IP and Message 'Standards & Formats created successfully.' (format '[Entity] created successfully.').
    And No manual logging action was required.

  # Ref: US-7 AC-1; FRD 7.1 A-Update; FRD 6.2 FB-2
  @TC_CP_046 @Functional @High @Automation
  Scenario: Verify a successful Updation is logged automatically (Ref US-7 AC-1, FRD 7.1 A-Update)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Department |
      | Record   | Civil Works |
    When Open the Department module
    And Edit Department 'Civil Works' (change description) and save successfully
    And Open Audit Trail
    Then An entry is created automatically with Function 'Department' and Message 'Department updated successfully.' (format '[Entity] updated successfully.').

  # Ref: US-8 AC-1; FRD 7.1 A-Delete; FRD 6.2 FB-2
  @TC_CP_047 @Functional @High @Automation
  Scenario: Verify a successful Deletion is logged automatically (Ref US-8 AC-1, FRD 7.1 A-Delete)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Office |
      | Record   | Pune Site Office |
    When Open the Office module
    And Delete Office 'Pune Site Office' (no dependency) and confirm
    And Open Audit Trail
    Then An entry is created automatically with Function 'Office' and Message 'Office deleted successfully.' (format '[Entity] deleted successfully.').

  # Ref: US-8 AC-2; FRD 6.2 FB-6; FRD 6.2 BR-3; FRD 7.1 A-Blocked
  @TC_CP_048 @Functional @High @Automation
  Scenario: Verify a Deletion attempt blocked by the source module's dependency check is logged (Ref US-8 AC-2, FRD 6.2 FB-6)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Post |
      | Record   | Site Supervisor (assigned to EMP-101) |
    When Open the Post module
    And Attempt to delete Post 'Site Supervisor' which is assigned to an employee
    And Observe the block
    And Open Audit Trail
    Then Deletion is blocked by the source module.
    And An Audit Trail entry is created for Function 'Post' with Message 'Post deletion blocked as its used in further processes.' (format '[Entity] deletion blocked as its used in further processes.').

  # Ref: FRD 6.2 FB-2; FRD 6.2 FB-5
  @TC_CP_049 @Functional @High @Automation
  Scenario: Verify an audit entry is created immediately after the transaction completes (Ref FRD 6.2 FB-2, FRD 6.2 FB-5)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Department |
      | Record   | Quality Control |
    When Note the time, then create Department 'Quality Control' and save
    And Immediately open Audit Trail and Search
    And Compare the entry's Log Date & Time with the completion time
    Then Entry is available right after completion and its Log Date & Time matches the transaction completion time (no later manual step needed).

  # Ref: FRD 6.2 FB-3; FRD 6.2 BR-5
  @TC_CP_050 @Functional @High @Automation
  Scenario: Verify Function Name, Class Name and Message are resolved from backend configuration (Ref FRD 6.2 FB-3, FRD 6.2 BR-5)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Department |
      | Record   | Planning |
    When Read the backend mapping row for Function 'Department'
    And Create Department 'Planning'
    And Compare the new audit entry with the mapping row
    Then Function Name, Class Name and Message of the entry equal the values configured in the backend mapping; none is user-entered.

  # Ref: FRD 6.2 FB-4
  @TC_CP_051 @Functional @High @Automation
  Scenario: Verify Log Date & Time is captured at the time the entry is created (Ref FRD 6.2 FB-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Department |
      | Record   | Stores |
    When Record server time T1 and create Department 'Stores'
    And Record server time T2 after save
    And Open the new audit entry
    Then Log Date & Time is between T1 and T2 (captured by the system, not editable by the user).

  # Ref: FRD 6.2 FB-4; FRD 6.3 C-IP
  @TC_CP_052 @Functional @High @Automation
  Scenario: Verify Client IP is captured from the network of the client performing the transaction (Ref FRD 6.2 FB-4, FRD 6.3 C-IP)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Clients | 192.168.1.25 and 10.10.5.40 |
    When From a client with IP 192.168.1.25 create Department 'Accounts'
    And From a second client with IP 10.10.5.40 create Department 'Purchase'
    And Open both audit entries
    Then Entry for 'Accounts' shows Client IP 192.168.1.25.
    And Entry for 'Purchase' shows Client IP 10.10.5.40.

  # Ref: FRD 6.2 FB-1; FRD 6.2 BR-2
  @TC_CP_054 @Functional @High @Automation
  Scenario: Verify Create, Update and Delete of the same record generate three discrete entries (Ref FRD 6.2 FB-1, FRD 6.2 BR-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Office |
      | Record   | Mumbai Office |
    When Create Office 'Mumbai Office'
    And Update its address
    And Delete it
    And Open Audit Trail and filter Function 'Office' for today
    Then Three separate entries exist (created, updated, deleted), each with its own Log Date & Time and Message, ordered most recent first.

  # Ref: FRD 7 FB-2; FRD 6.2 FB-5
  @TC_CP_055 @Functional @High @Automation
  Scenario: Verify the stored entry captures Function Name, Log Date & Time, Class Name, Client IP and Message (Ref FRD 7 FB-2, FRD 6.2 FB-5)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Post |
      | Record   | Safety Officer |
    When Create Post 'Safety Officer'
    And Query the audit store (DB/API) for the new entry
    Then Stored entry contains all five attributes: Function Name, Log Date & Time, Class Name, Client IP, Message.

  # Ref: FRD 6.2 BR-7
  @TC_CP_056 @Functional @Medium @Automation
  Scenario: Verify audit entries persist indefinitely (no retention/expiry) (Ref FRD 6.2 BR-7)
    Given Admin_User1 is logged in
    And Baseline contains Department entry dated 01-Jan-2025 08:00:00 (older than 400 days)
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | From | 01-Jan-2025 |
      | To   | 31-Jan-2025 |
    When Open Audit Trail
    And Set From Date = 01-Jan-2025 and To Date = 31-Jan-2025
    And Click Search
    Then The old entry is still returned; entries are not removed automatically by any retention job.

  # Ref: FRD 6.2 BR-6; US-5 AC-2
  @TC_CP_057 @Functional @High @Automation
  Scenario: Verify an audit entry can be removed only through Clear Log (Ref FRD 6.2 BR-6, US-5 AC-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Range | 01-Sep-2026 to 30-Sep-2026 |
    When Open Audit Trail and review all available row/screen actions
    And Clear Log for 01-Sep-2026 to 30-Sep-2026 and confirm
    Then No per-entry edit/delete exists; entries in the range are removed only through the Clear Log operation.

  # Ref: FRD 6.2 BR-4; FRD 7.1 A-Clear; FRD 7 FB-1
  @TC_CP_058 @Functional @High @Automation
  Scenario: Verify the Clear Log operation is itself logged in the Audit Trail (Ref FRD 6.2 BR-4, FRD 7.1 A-Clear)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Range | 01-Sep-2026 to 30-Sep-2026 |
      | User  | Admin_User1 |
    When Set From Date = 01-Sep-2026 and To Date = 30-Sep-2026
    And Click Clear Log and confirm
    And Query the Audit Trail / audit store for the Clear Log entry
    Then An entry exists with User = Admin_User1, current Date/Time, Selected Date Range (From 01-Sep-2026, To 30-Sep-2026) and Message 'Audit log cleared successfully for the selected date range.' (system-generated; exact stored text to be confirmed).
    And See Notes: how this entry is shown in the grid is not defined in the FRD.

  # Ref: FRD 6.2 FB-2; FRD 6.4 FB-5
  @TC_CP_059 @Functional @Medium @Automation
  Scenario: Verify audit logging continues for new transactions after a Clear Log (Ref FRD 6.2 FB-2, FRD 6.4 FB-5)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Record | Post Clear Dept |
    When Clear Log for 01-Sep-2026 to 30-Sep-2026 and confirm
    And Create Department 'Post Clear Dept'
    And Open Audit Trail
    Then A new entry for the creation is logged and displayed; Clear Log does not disable audit logging.

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-6 AC-2; FRD 6.2 BR-3; FRD 6.2 FB-6
  @TC_CP_134 @Negative @High @Automation
  Scenario: Verify a failed Creation (unexpected error) does not create an audit entry (Ref US-6 AC-2, FRD 6.2 BR-3)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Department |
      | Record   | Fail Create Dept |
    When Simulate an unexpected server/DB error during Department creation
    And Attempt to create Department 'Fail Create Dept' and observe the failure
    And Open Audit Trail
    Then No audit entry exists for the failed attempt.

  # Ref: US-7 AC-2; FRD 6.2 BR-3
  @TC_CP_135 @Negative @High @Automation
  Scenario: Verify a failed Updation (unexpected error) does not create an audit entry (Ref US-7 AC-2, FRD 6.2 BR-3)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Department |
      | Record   | Civil Works |
    When Simulate an unexpected error during update of Department 'Civil Works'
    And Attempt the update and observe the failure
    And Open Audit Trail
    Then No audit entry exists for the failed update.

  # Ref: FRD 6.2 FB-6; FRD 6.2 BR-3
  @TC_CP_136 @Negative @High @Automation
  Scenario: Verify a failed Deletion unrelated to dependency (unexpected error) does not create an audit entry (Ref FRD 6.2 FB-6, FRD 6.2 BR-3)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Office |
      | Record   | Mumbai Office |
    When Simulate an unexpected error while deleting Office 'Mumbai Office' (no dependency)
    And Attempt the delete
    And Open Audit Trail
    Then No audit entry is created for this failure (only dependency-blocked deletions are logged).

  # Ref: FRD 6.2 FB-6; FRD 6.2 BR-3
  @TC_CP_137 @Negative @Medium @Automation
  Scenario: Verify a validation-rejected Creation does not create an audit entry (Ref FRD 6.2 FB-6, FRD 6.2 BR-3)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Department |
      | Name     | (blank) |
    When Open Department creation and submit with mandatory fields blank
    And Observe the validation error
    And Open Audit Trail
    Then No audit entry is created for the rejected submission.

  # Ref: US-8 AC-2; FRD 7.1 A-Blocked; FRD 6.2 FB-6
  @TC_CP_138 @Negative @High @Automation
  Scenario: Verify a blocked Deletion is not logged as a successful deletion (Ref US-8 AC-2, FRD 7.1 A-Blocked)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Post |
      | Record   | Site Supervisor |
    When Attempt to delete Post 'Site Supervisor' (assigned to EMP-101) and get blocked
    And Open Audit Trail and read the new entry's Message
    Then Entry Message is 'Post deletion blocked as its used in further processes.' and not 'Post deleted successfully.'.
    And Note: US-8 AC-2 says a 'successful-deletion' entry is created; this conflicts with FRD 6.2 / 7.1 and is flagged for BA.

  # Ref: FRD 6.2 BR-3; FRD 6.2 FB-6
  @TC_CP_139 @Negative @Medium @Automation
  Scenario: Verify cancelling a delete confirmation in the source module creates no audit entry (Ref FRD 6.2 BR-3, FRD 6.2 FB-6)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | Office |
      | Record   | Pune Site Office |
    When Open the Office module and start deleting Office 'Pune Site Office'
    And Cancel at the confirmation
    And Open Audit Trail
    Then No entry is created because no deletion was completed or blocked.

  # Ref: FRD 6.2 BR-2
  @TC_CP_140 @Negative @Medium @Automation
  Scenario: Verify viewing and searching the Audit Trail do not create audit entries (Ref FRD 6.2 BR-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Actions | view / search only |
    When Note the count of entries in the audit store
    And Open Audit Trail, change filters and click Search several times
    And Re-count entries
    Then Entry count is unchanged; only Creation, Updation, Deletion, Deletion Blocked and Clear Log are auditable.
