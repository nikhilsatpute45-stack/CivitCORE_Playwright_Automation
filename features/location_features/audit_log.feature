@location @audit_log
Feature: Audit Log

  @TC-Loc-049 @functional @high
  # Ref: FRD 7 FB-2; 7.1 (Location Created); US-9 AC-1
  Scenario: Verify Activity Log entry is created on Location creation with required details
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I create Location "Rajkot" with Short Name "RJK" under Parent Location "Gujarat" as "Admin_User1"
    And I open the Activity Log for "Rajkot"
    Then a "Location Created" entry should exist with User "Admin_User1", Date/Time, Location ID, Name, Short Name and key creation attributes

  @TC-Loc-050 @functional @high
  # Ref: FRD 7.1 (Location Updated); US-9 AC-1
  Scenario: Verify Activity Log entry on update captures Field Changed, Previous Value and New Value
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Nashik" is open
    And the baseline location data is loaded
    When I change Name from "Nashik" to "Nasik"
    And I click Save
    And I open the Activity Log for the Location
    Then a "Location Updated" entry should exist with User, Date/Time, Location ID
    And the entry should show Field Changed "Name", Previous Value "Nashik" and New Value "Nasik"

  @TC-Loc-051 @functional @high
  # Ref: FRD 7.1 (Location Deleted); 6.7 FB-8; US-9 AC-1
  Scenario: Verify Activity Log entry is created on successful deletion
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Surat"
    And I confirm in the dialog
    And I open the Activity Log for the deleted Location
    Then a "Location Deleted" entry should exist with User, Date/Time, Location ID and Name

  @TC-Loc-052 @functional @high
  # Ref: FRD 7.1; 6.7 Decision Table row 1; US-6 AC-3
  Scenario: Verify 'Location Deletion Blocked' entry is recorded for Office dependency
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Mumbai" which is associated with "Mumbai Regional Office"
    And I open the Activity Log for "Mumbai"
    And I check the log for a "Location Deleted" entry
    Then a "Location Deletion Blocked" entry should exist with User, Date/Time, Location ID, Name and Block Reason "Office Dependency"
    And no "Location Deleted" entry should be created for the blocked action

  @TC-Loc-053 @functional @high
  # Ref: FRD 7.1; 6.7 Decision Table row 2; US-7 AC-2
  Scenario: Verify 'Location Deletion Blocked' entry is recorded for Hierarchy dependency
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Pune" which has child "Pune City" and no Office
    And I open the Activity Log for "Pune"
    Then a "Location Deletion Blocked" entry should exist with User, Date/Time, Location ID, Name and Block Reason "Hierarchy Dependency"

  @TC-Loc-054 @functional @high
  # Ref: FRD 7 FB-4; US-9 AC-2
  Scenario: Verify Activity Log is displayed in reverse chronological order
    Given I am logged in as "Auditor_User1"
    And Location "Rajkot" has been created, renamed and deleted in that order
    And the baseline location data is loaded
    When I open the Activity Log for the Location
    Then the entries should be listed most recent first
      | Deleted |
      | Updated |
      | Created |

  @TC-Loc-055 @functional @high
  # Ref: FRD 7 FB-4; US-9 AC-2
  Scenario: Verify Activity Log is read-only
    Given I am logged in as "Auditor_User1"
    And the Activity Log has entries
    And the baseline location data is loaded
    When I open the Activity Log
    And I look for edit and delete controls
    And I attempt PUT and DELETE on a log entry via API
    Then no edit or delete controls should be present
    And the API modification attempts should be rejected

  @TC-Loc-056 @functional @medium
  # Ref: FRD 7.1 (closing note)
  Scenario: Verify Activity Log is retained after Location deletion where retention policy requires
    Given I am logged in as "Auditor_User1"
    And "Surat" was deleted earlier
    And the platform retention policy is enabled
    When I search the Activity Log for the deleted Location ID
    Then the historical entries (Created, Updated, Deleted) should remain retrievable for audit
