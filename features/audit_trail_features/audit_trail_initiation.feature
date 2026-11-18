@AuditTrail @AuditTrailInitiation
Feature: Audit Trail Initiation
  Automated scenarios for the "Audit Trail Initiation" area of the CivitCORE Audit Trail.
  Source: CivitCORE_AuditTrail_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-005 CivitCORE CORE Module - Audit Trail, Ver 1.0, 28-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-1; FRD 6.1 FB-1; FRD 6.1 FB-2; FRD 6.3 FB-1
  @TC_CP_001 @Functional @High @Automation
  Scenario: Verify Audit Trail listing screen loads for a user holding View Audit Trail (Ref US-1 AC-1, FRD 6.1 FB-1)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User        | Admin_User1 |
      | Permissions | View Audit Trail, Clear Audit Log |
    When Login to CivitCORE as Admin_User1
    And Navigate to Audit Trail
    And Observe the screen that loads
    Then Audit Trail listing screen is displayed with default Function and date range applied.
    And Screen contains a Functions dropdown, From Date picker, To Date picker, Search action, Clear Log action and the Audit Log grid.

  # Ref: FRD 6.1 FB-3; FRD 6.5 FB-2
  @TC_CP_002 @Functional @High @Automation
  Scenario: Verify Clear Log action is displayed to a user holding Clear Audit Log (Ref FRD 6.1 FB-3, FRD 6.5 FB-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User        | Admin_User1 |
      | Permissions | View Audit Trail, Clear Audit Log |
    When Navigate to Audit Trail
    And Inspect the action area next to Search
    Then Clear Log action is displayed and available to the authorized user.
