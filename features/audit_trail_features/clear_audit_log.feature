@AuditTrail @ClearAuditLog
Feature: Clear Audit Log
  Automated scenarios for the "Clear Audit Log" area of the CivitCORE Audit Trail.
  Source: CivitCORE_AuditTrail_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-005 CivitCORE CORE Module - Audit Trail, Ver 1.0, 28-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-9 AC-1; FRD 6.4 FB-1; FRD 6.4 FB-2; FRD 6.4 FB-3; FRD 6.4 BR-3
  @TC_CP_060 @Functional @High @Automation
  Scenario: Verify Clear Log with a valid range validates the range and shows a confirmation dialog (Ref US-9 AC-1, FRD 6.4 FB-1)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 01-Sep-2026 |
      | To   | 30-Sep-2026 |
    When Set From Date = 01-Sep-2026
    And Set To Date = 30-Sep-2026
    And Click Clear Log
    Then Date range is validated successfully.
    And A confirmation dialog is displayed stating that audit log entries within the selected date range will be cleared.
    And No entry is removed before confirmation.

  # Ref: US-9 AC-2; FRD 6.4 FB-5
  @TC_CP_061 @Functional @High @Automation
  Scenario: Verify confirming Clear Log removes the entries within the selected range (Ref US-9 AC-2, FRD 6.4 FB-5)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Range | 01-Sep-2026 to 30-Sep-2026 |
    When Set From Date = 01-Sep-2026 and To Date = 30-Sep-2026
    And Click Clear Log
    And Click Confirm
    And Query the audit store for entries dated 01-Sep-2026 to 30-Sep-2026
    Then The 3 entries in the range (Office 25-Sep, Department 20-Sep, Standards & Formats 05-Sep) are removed.
    And Entries outside the range remain.

  # Ref: FRD 6.4 BR-1
  @TC_CP_062 @Functional @High @Automation
  Scenario: Verify Clear Log is not limited to the selected Function (Ref FRD 6.4 BR-1)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Function | Department |
      | Range    | 01-Sep-2026 to 30-Sep-2026 |
    When Select Function 'Department' (do not need to Search)
    And Set From Date = 01-Sep-2026 and To Date = 30-Sep-2026
    And Click Clear Log and confirm
    Then Entries of all Functions in the range (Office, Department, Standards & Formats) are cleared, not only Department.

  # Ref: US-9 AC-2; FRD 6.4 FB-5
  @TC_CP_063 @Functional @High @Automation
  Scenario: Verify the listing refreshes after a confirmed Clear Log (Ref US-9 AC-2, FRD 6.4 FB-5)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Range | 01-Sep-2026 to 30-Sep-2026 |
    When Set From Date = 01-Sep-2026 and To Date = 30-Sep-2026
    And Click Clear Log and confirm
    And Observe the Audit Trail listing
    Then Listing is refreshed to the default filter (All, 17-Oct-2026 to 16-Nov-2026) and shows the remaining records.
    And Note: US-9 AC-2 says 'Default to today's date range'; assumed to mean the default filter.

  # Ref: FRD 6.4 FB-5; US-11 AC-1
  @TC_CP_064 @Functional @Medium @Automation
  Scenario: Verify an appropriate message is shown when no records remain after Clear Log (Ref FRD 6.4 FB-5, US-11 AC-1)
    Given Admin_User1 is logged in
    And Only entries dated 05-Sep-2026 to 25-Sep-2026 exist in the Audit Trail (test environment seeded accordingly)
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Range | 01-Sep-2026 to 30-Sep-2026 |
    When Set From Date = 01-Sep-2026 and To Date = 30-Sep-2026
    And Click Clear Log and confirm
    And Observe the listing
    Then Listing is refreshed and an appropriate 'No records found' message is shown instead of rows.
    And Note: the Clear Log event is itself auditable (6.2 BR-4); confirm with BA whether it counts as a remaining record.

  # Ref: US-9 AC-2; FRD 6.4 FB-5
  @TC_CP_065 @Functional @High @Automation
  Scenario: Verify the cleared entries can no longer be retrieved (Ref US-9 AC-2, FRD 6.4 FB-5)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Range    | 01-Sep-2026 to 30-Sep-2026 |
      | Function | All |
    When Clear Log for 01-Sep-2026 to 30-Sep-2026 and confirm
    And Set From Date = 01-Sep-2026 and To Date = 30-Sep-2026
    And Click Search
    Then 'No records found' state is displayed for the cleared range.

  # Ref: FRD 6.4 BR-1; FRD 6.4 FB-1
  @TC_CP_066 @Functional @High @Automation
  Scenario: Verify Clear Log operates on the currently selected dates even if Search was not clicked (Ref FRD 6.4 BR-1, FRD 6.4 FB-1)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Range | 01-Sep-2026 to 30-Sep-2026 (applied range still default) |
    When Change From Date to 01-Sep-2026 and To Date to 30-Sep-2026 (do NOT click Search)
    And Click Clear Log and confirm
    Then Entries of 01-Sep-2026 to 30-Sep-2026 are cleared (the currently selected range), not the previously applied default range.

  # Ref: FRD 6.4 FB-5; FRD 6.3 BR-7
  @TC_CP_067 @Functional @Medium @Automation
  Scenario: Verify Clear Log for a single-day range removes only that day's entries (Ref FRD 6.4 FB-5, FRD 6.3 BR-7)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Range | 20-Sep-2026 to 20-Sep-2026 |
    When Set From Date = 20-Sep-2026 and To Date = 20-Sep-2026
    And Click Clear Log and confirm
    Then Only the Department entry of 20-Sep-2026 14:00 is removed; the entries of 25-Sep and 05-Sep remain.

  # Ref: FRD 6.4 BR-3; FRD 6.4 FB-3
  @TC_CP_069 @Functional @High @Automation
  Scenario: Verify Clear Log always requires explicit confirmation (no deletion before confirmation) (Ref FRD 6.4 BR-3, FRD 6.4 FB-3)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Range | 01-Sep-2026 to 30-Sep-2026 |
    When Set From Date = 01-Sep-2026 and To Date = 30-Sep-2026
    And Click Clear Log
    And While the dialog is open, query the audit store
    Then All entries are still present while the confirmation dialog is open; removal only occurs after the user confirms.

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-12 AC-3; FRD 6.4 BR-2; FRD 6.4 FB-2
  @TC_CP_114 @Negative @High @Automation
  Scenario: Verify Clear Log is blocked when From Date is later than To Date (Ref US-12 AC-3, FRD 6.4 BR-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 10-Nov-2026 |
      | To   | 05-Nov-2026 |
    When Set To Date = 05-Nov-2026 and From Date = 10-Nov-2026
    And Click Clear Log
    Then Operation is blocked with validation message 'From Date cannot be later than To Date' (consistent with Search).
    And No confirmation dialog; no entries removed.

  # Ref: US-12 AC-3; FRD 6.4 BR-2
  @TC_CP_115 @Negative @High @Automation
  Scenario: Verify Clear Log is blocked for a future To Date (Ref US-12 AC-3, FRD 6.4 BR-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | To | 17-Nov-2026 |
    When Set To Date = 17-Nov-2026
    And Click Clear Log
    Then Operation is blocked with validation message 'To Date cannot be future Date'.
    And No confirmation dialog; no entries removed.

  # Ref: US-12 AC-3; FRD 6.4 BR-2; FRD 6.3 F-From
  @TC_CP_116 @Negative @High @Automation
  Scenario: Verify Clear Log is blocked when From Date is empty (Ref US-12 AC-3, FRD 6.4 BR-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | (empty) |
    When Clear From Date
    And Click Clear Log
    Then Operation is blocked with validation message 'From Date is required'.
    And No entries removed.

  # Ref: US-12 AC-3; FRD 6.4 BR-2; FRD 6.3 F-To
  @TC_CP_117 @Negative @High @Automation
  Scenario: Verify Clear Log is blocked when To Date is empty (Ref US-12 AC-3, FRD 6.4 BR-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | To | (empty) |
    When Clear To Date
    And Click Clear Log
    Then Operation is blocked with validation message 'To Date is required'.
    And No entries removed.

  # Ref: FRD 6.4 BR-2; FRD 6.2 BR-4
  @TC_CP_118 @Negative @Medium @Automation
  Scenario: Verify an invalid-range Clear Log attempt creates no Clear Log audit entry (Ref FRD 6.4 BR-2, FRD 6.2 BR-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 10-Nov-2026 |
      | To   | 05-Nov-2026 |
    When Set From Date = 10-Nov-2026 and To Date = 05-Nov-2026
    And Click Clear Log
    And Query the audit store for Clear Log events
    Then No Clear Log entry is recorded because the operation was blocked.

  # Ref: US-10 AC-1; US-10 AC-2; FRD 6.4 FB-4; FRD 6.4 BR-4
  @TC_CP_119 @Negative @High @Automation
  Scenario: Verify cancelling the Clear Log confirmation with Cancel removes nothing (Ref US-10 AC-1, US-10 AC-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Range | 01-Sep-2026 to 30-Sep-2026 |
    When Set From Date = 01-Sep-2026 and To Date = 30-Sep-2026
    And Click Clear Log
    And Click Cancel in the dialog
    And Query the audit store and view the listing
    Then Dialog closes; no audit log entry is deleted.
    And Audit Trail listing remains unchanged.

  # Ref: US-10 AC-1; FRD 6.4 FB-4
  @TC_CP_120 @Negative @Medium @Automation
  Scenario: Verify closing the Clear Log dialog via the close (X) icon or Esc is treated as cancel (assumption) (Ref US-10 AC-1, FRD 6.4 FB-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Range | 01-Sep-2026 to 30-Sep-2026 |
    When Set a valid range and click Clear Log
    And Close the dialog using X, then repeat and press Esc
    Then No entries are removed in either case; listing unchanged. FRD does not define this explicitly.

  # Ref: FRD 6.4 BR-4; FRD 6.2 BR-4
  @TC_CP_121 @Negative @Medium @Automation
  Scenario: Verify cancelling Clear Log creates no Clear Log audit entry and no toaster (Ref FRD 6.4 BR-4, FRD 6.2 BR-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Range | 01-Sep-2026 to 30-Sep-2026 |
    When Set a valid range, click Clear Log and then Cancel
    And Query the audit store for Clear Log events
    Then No Clear Log entry is created and no success toaster is displayed.

  # Ref: FRD 6.4 FB-5; FRD 6.4 BR-1
  @TC_CP_122 @Negative @High @Automation
  Scenario: Verify entries just outside the cleared range are retained (no over-deletion) (Ref FRD 6.4 FB-5, FRD 6.4 BR-1)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Retained            | Office 31-Aug-2026 23:59:59 |
      | Post 01-Oct-2026 00 | 00:00 |
    When Set From Date = 01-Sep-2026 and To Date = 30-Sep-2026
    And Click Clear Log and confirm
    And Query the audit store for entries at 31-Aug-2026 23:59:59 and 01-Oct-2026 00:00:00
    Then Both boundary-adjacent entries still exist; only entries between the selected dates (inclusive) are cleared.

  # Ref: FRD 6.4 BR-3; FRD 6.2 BR-4
  @TC_CP_123 @Negative @Medium @Automation
  Scenario: Verify rapid double-click on Confirm clears once and logs a single Clear Log entry (Ref FRD 6.4 BR-3, FRD 6.2 BR-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Range | 01-Sep-2026 to 30-Sep-2026 |
    When Set From Date = 01-Sep-2026 and To Date = 30-Sep-2026
    And Click Clear Log
    And Double-click Confirm quickly
    And Query Clear Log events and observe toasters
    Then Operation executes once; exactly one Clear Log entry and one success toaster; no error.
