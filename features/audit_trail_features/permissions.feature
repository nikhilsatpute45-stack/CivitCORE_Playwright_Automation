@AuditTrail @AuditTrailPermissions
Feature: Audit Trail Permission / Access Control
  Automated scenarios for the "Audit Trail Permission / Access Control" area of the CivitCORE Audit Trail.
  Source: CivitCORE_AuditTrail_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-005 CivitCORE CORE Module - Audit Trail, Ver 1.0, 28-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-13 AC-1; FRD 6.5 BR-2; FRD 6.5 BR-3
  @TC_CP_070 @Functional @High @Automation
  Scenario: Verify View Audit Trail and Clear Audit Log are available as separately assignable permissions (Ref US-13 AC-1, FRD 6.5 BR-2)
    Given Admin user with Role Management access is logged in
    And the following test data is used
      | Role   | Audit_Viewer_Role |
      | Rights | View Audit Trail, Clear Audit Log |
    When Open a role in the CivitCORE role/entitlement configuration
    And Locate the Audit Trail rights
    And Assign only 'View Audit Trail', save, then reopen the role
    Then 'View Audit Trail' and 'Clear Audit Log' are listed as separate rights and can be saved independently.

  # Ref: US-13 AC-2; US-9 AC-3; FRD 6.5 FB-2
  @TC_CP_071 @Functional @High @Automation
  Scenario: Verify a user with View Audit Trail only can view and filter but not execute Clear Log (Ref US-13 AC-2, US-9 AC-3)
    Given Viewer_User1 (View Audit Trail only, no Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User     | Viewer_User1 |
      | Function | Post |
    When Open the Audit Trail screen
    And Select Function 'Post' and click Search
    And Inspect the Clear Log action
    Then Listing is viewable and filtering works.
    And Clear Log is not displayed (or is disabled) and cannot be executed.

  # Ref: US-9 AC-1; FRD 6.5 BR-3
  @TC_CP_072 @Functional @High @Automation
  Scenario: Verify a user with both permissions can view and execute Clear Log (Ref US-9 AC-1, FRD 6.5 BR-3)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User  | Admin_User1 |
      | Range | 20-Sep-2026 |
    When Open the Audit Trail screen
    And Set From Date = 20-Sep-2026 and To Date = 20-Sep-2026
    And Click Clear Log and confirm
    Then User can view the listing and execute Clear Log successfully.

  # Ref: FRD 6.5 BR-1; FRD 6.5 FB-1; US-1 AC-1
  @TC_CP_073 @Functional @High @Automation
  Scenario: Verify access follows the CivitCORE role/entitlement mechanism when the right is granted (Ref FRD 6.5 BR-1, FRD 6.5 FB-1)
    Given Admin user configures the role of NoAccess_User1 in Role Management
    And NoAccess_User1 currently has no Audit Trail right
    And the following test data is used
      | User          | NoAccess_User1 |
      | Right granted | View Audit Trail |
    When Assign 'View Audit Trail' to NoAccess_User1's role and save
    And Login as NoAccess_User1 (fresh session)
    And Open Audit Trail
    Then Audit Trail listing is displayed after the right is granted through the existing role/entitlement framework.

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-2; FRD 6.5 BR-4
  @TC_CP_094 @Negative @High @Automation
  Scenario: Verify a user without View Audit Trail cannot see the Audit Trail menu entry (Ref US-1 AC-2, FRD 6.5 BR-4)
    Given NoAccess_User1 (no Audit Trail permission) is logged in
    And Baseline audit data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When Inspect the navigation menu for Audit Trail
    Then Audit Trail entry is not displayed.

  # Ref: US-1 AC-2; FRD 6.1 BR-1; FRD 6.5 FB-1
  @TC_CP_095 @Negative @High @Automation
  Scenario: Verify direct URL access to Audit Trail is denied without View Audit Trail (Ref US-1 AC-2, FRD 6.1 BR-1)
    Given NoAccess_User1 (no Audit Trail permission) is logged in
    And Baseline audit data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When Enter the Audit Trail screen URL directly in the browser
    Then Audit Trail listing screen is not displayed and no audit data is exposed (access denied / redirected).

  # Ref: FRD 6.5 BR-4; FRD 6.5 FB-1
  @TC_CP_096 @Negative @High @Automation
  Scenario: Verify audit entries cannot be retrieved via API without View Audit Trail (Ref FRD 6.5 BR-4, FRD 6.5 FB-1)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User | NoAccess_User1 |
    When Send the get-audit-entries request (Function All, 17-Oct-2026 to 16-Nov-2026)
    And Check the response
    Then Request is rejected (403); no audit entries are returned.

  # Ref: FRD 6.5 BR-3; FRD 6.5 BR-4
  @TC_CP_097 @Negative @High @Automation
  Scenario: Verify a user with Clear Audit Log but without View Audit Trail cannot access the screen (Ref FRD 6.5 BR-3, FRD 6.5 BR-4)
    Given ClearOnly_User1 (Clear Audit Log only, no View Audit Trail) is logged in
    And Baseline audit data (see Summary) is loaded
    And the following test data is used
      | User | ClearOnly_User1 |
    When Look for Audit Trail in the menu
    And Open the Audit Trail URL directly
    Then Audit Trail screen is not displayed; Clear Audit Log does not imply View Audit Trail (permissions are independent).

  # Ref: US-9 AC-3; US-13 AC-2; FRD 6.5 BR-5; FRD 6.4 BR-5
  @TC_CP_098 @Negative @High @Automation
  Scenario: Verify view-only user cannot execute Clear Log from the screen (Ref US-9 AC-3, US-13 AC-2)
    Given Viewer_User1 (View Audit Trail only, no Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User | Viewer_User1 |
    When Open the Audit Trail screen
    And Look for Clear Log and try to activate it (including via keyboard/DOM interaction)
    Then Clear Log cannot be executed; no confirmation dialog appears and no entry is removed.

  # Ref: FRD 6.5 BR-5; FRD 6.4 BR-5; US-9 AC-3
  @TC_CP_099 @Negative @High @Automation
  Scenario: Verify view-only user cannot Clear Log via API (Ref FRD 6.5 BR-5, FRD 6.4 BR-5)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User  | Viewer_User1 |
      | Range | 01-Sep-2026 to 30-Sep-2026 |
    When Send the clear-audit-log request for 01-Sep-2026 to 30-Sep-2026
    And Query the audit store
    Then Request is rejected (403); entries of the range still exist; no Clear Log entry is created.

  # Ref: FRD 6.5 FB-1; FRD 6.5 BR-1
  @TC_CP_100 @Negative @Medium @Automation
  Scenario: Verify access is blocked after View Audit Trail is revoked during an active session (Ref FRD 6.5 FB-1, FRD 6.5 BR-1)
    Given Viewer_User1 has Audit Trail open
    And Admin removes 'View Audit Trail' from Viewer_User1's role
    And the following test data is used
      | User     | Viewer_User1 |
      | Function | Office |
    When As Viewer_User1 select Function 'Office' and click Search (or refresh the screen)
    Then Request is denied and listing data is not returned once the permission is revoked.
