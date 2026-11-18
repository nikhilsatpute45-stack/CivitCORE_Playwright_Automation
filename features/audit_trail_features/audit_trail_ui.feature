@AuditTrail @AuditTrailUI
Feature: Audit Trail UI
  Automated scenarios for the "Audit Trail UI" area of the CivitCORE Audit Trail.
  Source: CivitCORE_AuditTrail_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-005 CivitCORE CORE Module - Audit Trail, Ver 1.0, 28-Sep-2026

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.3 F-Functions; US-3 AC-3
  @TC_CP_075 @UI @Medium @Automation
  Scenario: Verify Functions control is a dropdown only (no free-text entry) (Ref FRD 6.3 F-Functions, US-3 AC-3)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Typed text | Invoice Register |
    When Click inside the Functions control
    And Try typing 'Invoice Register' using the keyboard
    Then Control behaves as a selection-only dropdown; typed free text is not accepted and the selected value is unchanged.

  # Ref: US-5 AC-1; US-5 AC-2; FRD 6.2 BR-6
  @TC_CP_080 @UI @High @Automation
  Scenario: Verify the grid has no edit/delete row actions (Ref US-5 AC-1, US-5 AC-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Grid | default listing |
    When Hover over and right-click grid rows
    And Inspect for action icons, menus or an Actions column
    Then No Edit, Delete or other row action is available; the list is strictly view-only.

  # Ref: FRD 6.5 FB-2; US-13 AC-2; US-9 AC-3
  @TC_CP_081 @UI @High @Automation
  Scenario: Verify the Clear Log action is not available to a view-only user (visual) (Ref FRD 6.5 FB-2, US-13 AC-2)
    Given Viewer_User1 (View Audit Trail only, no Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User | Viewer_User1 |
    When Open the Audit Trail screen
    And Inspect the toolbar next to Search
    Then Clear Log is hidden or disabled; no clickable Clear Log control is exposed.
