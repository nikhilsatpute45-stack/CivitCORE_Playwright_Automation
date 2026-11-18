@AuditTrail @AuditLogReadOnly
Feature: Audit Log Read-Only
  Automated scenarios for the "Audit Log Read-Only" area of the CivitCORE Audit Trail.
  Source: CivitCORE_AuditTrail_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-005 CivitCORE CORE Module - Audit Trail, Ver 1.0, 28-Sep-2026

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-2; FRD 6.2 BR-6
  @TC_CP_131 @Negative @High @Automation
  Scenario: Verify audit fields cannot be edited from the Audit Trail screen (Ref US-5 AC-2, FRD 6.2 BR-6)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Row | first row |
    When Double-click the Message cell of the first row
    And Try to type into Function Name, Class Name and Client IP cells
    Then No cell enters edit mode; values remain unchanged.

  # Ref: US-5 AC-2; FRD 6.2 BR-6
  @TC_CP_132 @Negative @High @Automation
  Scenario: Verify an audit entry cannot be modified via API (Ref US-5 AC-2, FRD 6.2 BR-6)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User    | Admin_User1 |
      | Message | Tampered text |
    When Send PUT/PATCH to update the Message of an existing audit entry
    And Query the entry
    Then Request is rejected (403/405); the entry is unchanged.

  # Ref: FRD 6.2 BR-6
  @TC_CP_133 @Negative @High @Automation
  Scenario: Verify a single audit entry cannot be deleted via API (only Clear Log removes entries) (Ref FRD 6.2 BR-6)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User  | Admin_User1 |
      | Entry | Department 16-Nov-2026 09:30 |
    When Send DELETE for a single audit entry
    And Query the entry
    Then Request is rejected (403/405); the entry still exists.
