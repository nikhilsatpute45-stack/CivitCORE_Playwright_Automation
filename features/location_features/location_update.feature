@location @update
Feature: Location Update

  @TC-Loc-026 @functional @high
  # Ref: FRD 6.4 FB-3; 6.4 BR-1/BR-2; US-5 AC-1/AC-3; FRD 8 #2
  Scenario: Verify Location Name and Short Name can be updated and persisted, and Location ID is unchanged
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Nashik" is open
    And the baseline location data is loaded
    When I note the Location ID of "Nashik" from the Master
    And I change Name from "Nashik" to "Nasik"
    And I change Short Name from "NSK" to "NSK1"
    And I click Save
    And I re-open the Location and compare the Location ID
    Then the update should be persisted and the toaster "Location updated successfully." should be displayed
    And Name should show "Nasik" and Short Name should show "NSK1"
    And the Location ID should be identical before and after the update

  @TC-Loc-027 @functional @high
  # Ref: FRD 6.4 FB-4; US-5 AC-4
  Scenario: Verify Parent Location can be changed to another valid Parent and hierarchy is re-validated
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Nashik" is open
    And the baseline location data is loaded
    When I keep Parent Location Category "State/Territory"
    And I change Parent Location from "Maharashtra" to "Gujarat"
    And I click Save
    And I expand the hierarchy
    Then the system should re-validate the hierarchy and accept the change with no circular reference
    And "Nashik" should be displayed under "Gujarat"

  @TC-Loc-028 @functional @high
  # Ref: FRD 6.4 FB-4
  Scenario: Verify saving without changing Name/Short Name does not raise a false duplicate error
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Surat" is open
    And the baseline location data is loaded
    When I change only Region from "Western Region" to "Southern Region"
    And I leave Name "Surat" and Short Name "SRT" untouched
    And I click Save
    Then the save should succeed
    And no "Name already exists" or "Short Name already exists" message should be shown

  @TC-Loc-029 @functional @medium
  # Ref: FRD 6.4 BR-4; 6.2 BR-4
  Scenario: Verify leading/trailing space trimming and space normalization apply on update
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Nashik" is open
    And the baseline location data is loaded
    When I change Name to "  Nasik   Rural  "
    And I click Save
    And I re-open the Location
    Then the Name should be stored as "Nasik Rural" (trimmed and normalized)

  @TC-Loc-030 @functional @high
  # Ref: FRD 6.4 FB-5; 6.4 BR-3; US-5 AC-1/AC-5
  Scenario: Verify Office <-> Location association is preserved after the Location is renamed
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Mumbai" is open
    And the baseline location data is loaded
    When I note that "Mumbai Regional Office" is associated with "Mumbai"
    And I change Name from "Mumbai" to "Mumbai City"
    And I click Save
    And I open "Mumbai Regional Office" in Office Management
    Then the Office should still reference the same Location ID and display "Mumbai City"
    And no association should be removed or altered

  @TC-Loc-093 @negative @high
  # Ref: FRD 6.4 BR-4; 6.2 Fields
  Scenario: Verify update is blocked when Name is cleared
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Surat" is open
    And the baseline location data is loaded
    When I clear the Name field
    And I click Save
    Then the save should be blocked and "Name is required" should be displayed
    And the Location should retain its previous values

  @TC-Loc-094 @negative @high
  # Ref: FRD 6.4 FB-4; US-5 AC-2
  Scenario: Verify update is blocked when Name duplicates another Location under the same Parent
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Nashik" is open
    And the baseline location data is loaded
    When I change Parent Location from "Maharashtra" to "Gujarat" and Name from "Nashik" to "Surat" where Gujarat already has "Surat"
    And I click Save
    Then the save should be blocked with "Name already exists"
    And the original values should be retained

  @TC-Loc-095 @negative @high
  # Ref: FRD 6.4 FB-4; US-5 AC-2
  Scenario: Verify update is blocked when Short Name duplicates another Location under the same Parent
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Surat" is open
    And the baseline location data is loaded
    When I change Short Name from "SRT" to "AHM" which is the Short Name of "Ahmedabad" under the same parent "Gujarat"
    And I click Save
    Then the save should be blocked with "Short Name already exists"
    And the original values should be retained

  @TC-Loc-096 @negative @high
  # Ref: FRD 6.4 BR-1; 6.2 BR-10
  Scenario: Verify Location ID change via API request is rejected/ignored
    Given an API client is authenticated as "Admin_User1"
    When I send an update request for "Surat" with locationId changed to "LOC-ABC" with payload
      """
      {locationId:'LOC-ABC', name:'Surat'}
      """
    And I re-read the record
    Then the Location ID should remain unchanged
    And the request should be rejected or the ID field should be ignored

  @TC-Loc-097 @negative @high
  # Ref: FRD 6.2 BR-7; Fields - Parent Location; US-2 AC-5
  Scenario: Verify setting a Location as its own Parent is blocked
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Gujarat" is open
    And the baseline location data is loaded
    When I select Parent Location Category "State/Territory"
    And I select Parent Location "Gujarat" which is itself, or send it via API
    And I click Save
    Then the option should not be offered in the dropdown
    And if forced via API, the save should be blocked with "Invalid Parent Location"

  @TC-Loc-098 @negative @high
  # Ref: FRD 6.2 BR-7; 6.4 FB-4; US-5 AC-4
  Scenario: Verify setting a deeper descendant as Parent (multi-level circular) is blocked
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "INDIA" is open
    And the baseline location data is loaded
    When I select Parent Location Category "City"
    And I select Parent Location "Ahmedabad City" in the path INDIA > Gujarat > Ahmedabad > Ahmedabad City
    And I click Save
    Then the save should be blocked with "Invalid Parent Location"
    And the hierarchy should be unchanged

  @TC-Loc-099 @negative @high
  # Ref: FRD 6.4 BR-3/BR-4; 7 FB-1
  Scenario: Verify a failed update leaves the record and Office association unchanged and creates no log entry
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Mumbai" is open
    And the baseline location data is loaded
    When I change Name from "Mumbai" to "Pune" which is a duplicate in "Maharashtra"
    And I click Save
    And I re-open "Mumbai"
    And I check the Office association and the Activity Log
    Then the update should be blocked
    And "Mumbai" should keep its values
    And "Mumbai Regional Office" should remain associated
    And no "Location Updated" entry should be created
