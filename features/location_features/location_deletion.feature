@location @deletion
Feature: Location Deletion

  @TC-Loc-043 @functional @high
  # Ref: FRD 6.7 FB-5/FB-6/FB-7; US-8 AC-1; Decision Table row 3
  Scenario: Verify delete confirmation dialog is displayed for a Location with no Office and no child
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Surat" which has no Office and no child
    Then the Office and hierarchy checks should pass
    And a delete confirmation dialog with confirm and cancel options should be displayed

  @TC-Loc-044 @functional @high
  # Ref: FRD 6.7 FB-8; Decision Table row 4; US-8 AC-2; FRD 8 #3
  Scenario: Verify confirming deletion removes the Location from the Location Master
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Surat"
    And I confirm in the dialog
    And I check the Location List and Master via DB/API
    Then "Surat" should be removed from the Location Master and the list
    And the toaster "Location deleted successfully." should be displayed

  @TC-Loc-045 @functional @medium
  # Ref: FRD 6.7 FB-1
  Scenario: Verify Delete can be initiated from the Location Detail view
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click View on "Surat"
    And I click Delete in the detail view
    And I confirm
    Then the behavior should be the same as list delete: a confirmation dialog, then the Location is deleted with a success toaster

  @TC-Loc-046 @functional @high
  # Ref: FRD 6.7 BR-4; US-7, US-8
  Scenario: Verify a parent becomes deletable after its last child is deleted
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Pune City"
    And I confirm
    Then "Pune City" should be deleted
    When I click Delete on "Pune"
    And I confirm
    Then the deletion of "Pune" should be allowed with the confirmation dialog shown
    And "Pune" should be deleted successfully

  @TC-Loc-047 @functional @high
  # Ref: FRD 6.5 FB-4; 6.7 BR-2/BR-3
  Scenario: Verify a Location becomes deletable after its Office is moved to another Location
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I move "Mumbai Regional Office" from "Mumbai" to "Nashik"
    And I click Delete on "Mumbai"
    And I confirm
    Then the Office dependency check should no longer find an association
    And the confirmation dialog should be shown
    And "Mumbai" should be deleted

  @TC-Loc-048 @functional @high
  # Ref: FRD 6.7 FB-2; BR-3; US-6 AC-2
  Scenario: Verify Office-dependency check is performed at the time of the delete action
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I open the Location List where "Nashik" has no Office
    And in another session I associate an Office with "Nashik"
    And in the first session I click Delete on "Nashik"
    Then the dependency check should use current data at click time
    And the deletion should be blocked with the Office message

  @TC-Loc-103 @negative @high
  # Ref: FRD 6.7 FB-3; BR-1; US-6 AC-1; Decision Table row 1
  Scenario: Verify deletion is blocked when the Location is associated with an Office
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Mumbai" which is associated with "Mumbai Regional Office"
    Then the deletion should be blocked and a message indicating the Location is in use by an Office should be displayed
    And no delete confirmation dialog should be displayed
    And "Mumbai" should remain in the Master

  @TC-Loc-104 @negative @high
  # Ref: FRD 6.7 FB-4; BR-4; US-7 AC-1; Decision Table row 2
  Scenario: Verify deletion is blocked when the Location has child Locations
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Pune" which has child "Pune City" and no Office
    Then the deletion should be blocked and a message indicating the Location has one or more child Locations should be displayed
    And no delete confirmation dialog should be displayed
    And "Pune" and "Pune City" should remain

  @TC-Loc-105 @negative @high
  # Ref: FRD 6.7 BR-4; Figure 3
  Scenario: Verify deletion is blocked when the Location has BOTH an Office and a child Location
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Ahmedabad" which has Office "Ahmedabad Airport Office" and child "Ahmedabad City"
    Then the deletion should be blocked with no confirmation dialog
    And the Office-dependency message should be shown first
    And the Block Reason should be logged as "Office Dependency"

  @TC-Loc-106 @negative @high
  # Ref: FRD 6.7 BR-1/BR-3; US-6 AC-2/AC-3
  Scenario: Verify Office-dependency delete is blocked server-side when the UI is bypassed
    Given an API client is authenticated as "Admin_User1"
    When I send a direct delete request for "Mumbai"
    Then the request should be rejected with the Office-dependency error
    And "Mumbai" should still exist
    And "Location Deletion Blocked" should be logged

  @TC-Loc-107 @negative @high
  # Ref: FRD 6.7 BR-4; US-7 AC-1/AC-2
  Scenario: Verify child-dependency delete is blocked server-side when the UI is bypassed
    Given an API client is authenticated as "Admin_User1"
    When I send a direct delete request for "Pune"
    Then the request should be rejected with the hierarchy-dependency error
    And "Pune" and "Pune City" should still exist
    And "Location Deletion Blocked" should be logged

  @TC-Loc-108 @negative @high
  # Ref: FRD 6.7 FB-9; US-8 AC-3; Decision Table row 5
  Scenario: Verify Cancel on the delete confirmation leaves the Location unchanged and creates no Activity Log entry
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Nashik"
    And I click Cancel on the delete confirmation
    And I check the Location List and Master
    And I open the Activity Log for "Nashik"
    Then the dialog should close
    And "Nashik" should not be deleted and should remain unchanged
    And no success toaster should be shown
    And no "Location Deleted" or "Location Deletion Blocked" entry should be created for the cancelled action
