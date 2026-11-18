@AuditTrail @AuditTrailDateValidation
Feature: Audit Trail Date Validation
  Automated scenarios for the "Audit Trail Date Validation" area of the CivitCORE Audit Trail.
  Source: CivitCORE_AuditTrail_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-005 CivitCORE CORE Module - Audit Trail, Ver 1.0, 28-Sep-2026

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-12 AC-1; FRD 6.3 BR-7; FRD 6.3 BR-9; FRD 6.3 F-From; FRD 6.3 FB-5
  @TC_CP_101 @Negative @High @Automation
  Scenario: Verify Search is blocked when From Date is later than To Date (Ref US-12 AC-1, FRD 6.3 BR-7)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 10-Nov-2026 |
      | To   | 05-Nov-2026 |
    When Set To Date = 05-Nov-2026 first, then set From Date = 10-Nov-2026
    And Click Search
    Then Search is blocked with validation message 'From Date cannot be later than To Date'.
    And Grid does not show new or undefined results.

  # Ref: US-12 AC-2; FRD 6.3 BR-8; FRD 6.3 BR-9; FRD 6.3 F-To
  @TC_CP_102 @Negative @High @Automation
  Scenario: Verify Search is blocked when To Date is earlier than From Date (Ref US-12 AC-2, FRD 6.3 BR-8)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 10-Nov-2026 |
      | To   | 05-Nov-2026 |
    When Set From Date = 10-Nov-2026
    And Change To Date to 05-Nov-2026
    And Click Search
    Then Search is blocked with validation message 'To Date cannot be earlier than From Date'.
    And Grid does not show new or undefined results.

  # Ref: US-12 AC-2; FRD 6.3 BR-8; FRD 6.3 F-To
  @TC_CP_103 @Negative @High @Automation
  Scenario: Verify Search is blocked for a future To Date (tomorrow) (Ref US-12 AC-2, FRD 6.3 BR-8)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | To | 17-Nov-2026 |
    When Set To Date = 17-Nov-2026 (T + 1)
    And Click Search
    Then Search is blocked with validation message 'To Date cannot be future Date'.
    And Grid is unchanged.

  # Ref: FRD 6.3 BR-8; FRD 6.3 F-To
  @TC_CP_104 @Negative @Low @Automation
  Scenario: Verify Search is blocked for a far-future To Date (Ref FRD 6.3 BR-8, FRD 6.3 F-To)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | To | 31-Dec-2099 |
    When Set To Date = 31-Dec-2099
    And Click Search
    Then Search is blocked with validation message 'To Date cannot be future Date'.

  # Ref: US-12 AC-2; FRD 6.3 F-From; FRD 6.3 BR-9
  @TC_CP_105 @Negative @High @Automation
  Scenario: Verify Search is blocked for a future-dated From Date (Ref US-12 AC-2, FRD 6.3 F-From)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 20-Nov-2026 |
      | To   | 16-Nov-2026 |
    When Set From Date = 20-Nov-2026 (future)
    And Click Search
    Then Search is blocked with a validation message (the From Date error state is 'From Date cannot be later than To Date'; FRD has no separate text for future From Date).
    And Grid is unchanged.

  # Ref: FRD 6.3 F-From; FRD 6.3 BR-9
  @TC_CP_106 @Negative @High @Automation
  Scenario: Verify From Date is mandatory (Ref FRD 6.3 F-From, FRD 6.3 BR-9)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | (empty) |
      | To   | 16-Nov-2026 |
    When Clear the From Date field
    And Click Search
    Then Search is blocked with validation message 'From Date is required'.

  # Ref: FRD 6.3 F-To; FRD 6.3 BR-9
  @TC_CP_107 @Negative @High @Automation
  Scenario: Verify To Date is mandatory (Ref FRD 6.3 F-To, FRD 6.3 BR-9)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 17-Oct-2026 |
      | To   | (empty) |
    When Clear the To Date field
    And Click Search
    Then Search is blocked with validation message 'To Date is required'.

  # Ref: FRD 6.3 F-From; FRD 6.3 F-To
  @TC_CP_108 @Negative @Medium @Automation
  Scenario: Verify Search is blocked when both dates are empty (Ref FRD 6.3 F-From, FRD 6.3 F-To)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | (empty) |
      | To   | (empty) |
    When Clear From Date and To Date
    And Click Search
    Then Search is blocked; messages 'From Date is required' and 'To Date is required' are displayed.

  # Ref: FRD 6.3 F-From
  @TC_CP_109 @Negative @Medium @Automation
  Scenario: Verify From Date rejects an invalid calendar date (Ref FRD 6.3 F-From)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 31-Nov-2026 |
    When Type From Date = 31-Nov-2026 (non-existent date)
    And Click Search
    Then Invalid date is not accepted; Search is blocked and no results are shown.

  # Ref: FRD 6.3 F-To
  @TC_CP_110 @Negative @Medium @Automation
  Scenario: Verify To Date rejects an invalid calendar date (Ref FRD 6.3 F-To)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | To | 30-Feb-2026 |
    When Type To Date = 30-Feb-2026 (non-existent date)
    And Click Search
    Then Invalid date is not accepted; Search is blocked and no results are shown.

  # Ref: FRD 6.3 F-From
  @TC_CP_111 @Negative @Medium @Automation
  Scenario: Verify From Date rejects an incomplete date value (Ref FRD 6.3 F-From)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 17-Oct- |
    When Type From Date = '17-Oct-' (incomplete)
    And Click Search
    Then Incomplete date is not accepted; Search is blocked.

  # Ref: FRD 6.3 F-To
  @TC_CP_112 @Negative @Medium @Automation
  Scenario: Verify To Date rejects non-date text (Ref FRD 6.3 F-To)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | To | abcd |
    When Type To Date = 'abcd'
    And Click Search
    Then Non-date text is not accepted; Search is blocked.

  # Ref: FRD 6.3 BR-9; US-12 AC-1
  @TC_CP_113 @Negative @High @Automation
  Scenario: Verify an invalid date range does not display misleading results (Ref FRD 6.3 BR-9, US-12 AC-1)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 10-Nov-2026 |
      | To   | 05-Nov-2026 |
    When Note the currently displayed grid
    And Set From Date = 10-Nov-2026 and To Date = 05-Nov-2026
    And Click Search
    Then Grid keeps the previous valid result (or stays empty) and does not show undefined/partial data; no API result is applied.
