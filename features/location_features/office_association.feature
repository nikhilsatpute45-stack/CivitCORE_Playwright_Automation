@location @office_association
Feature: Office Association

  @TC-Loc-031 @functional @high
  # Ref: FRD 6.5 FB-1
  Scenario: Verify Office creation lookup is populated from the CivitCORE Location Master
    Given I am logged in as "Admin_User1"
    And the Add Office screen is open
    And the baseline location data is loaded
    When I open the Location lookup on the Add Office screen
    And I compare the options to the Location Master
    Then the lookup should list the Locations from the Location Master (same set of 12 records)

  @TC-Loc-032 @functional @high
  # Ref: FRD 6.5 FB-2; 6.5 BR-2
  Scenario: Verify Office-Location association is stored using Location ID, not Location Name
    Given I am logged in as "Admin_User1"
    And the Add Office screen is open
    And the baseline location data is loaded
    When I create Office "Surat Airport Office" and select Location "Surat"
    And I click Save
    And I check the stored association via DB/API
    Then the association should store the Location ID of "Surat"
    And no Location Name should be used as the reference

  @TC-Loc-033 @functional @high
  # Ref: FRD 6.5 FB-3; BR-3
  Scenario: Verify the association is exposed as a queryable Office <-> Location dependency
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I query the dependency check via API/DB for Location "Mumbai"
    And I query the dependency check via API/DB for Location "Nashik"
    Then "Mumbai" should return an Office dependency (count >= 1)
    And "Nashik" should return no Office dependency

  @TC-Loc-034 @functional @high
  # Ref: FRD 6.5 FB-4
  Scenario: Verify moving an Office to a different Location updates the association
    Given I am logged in as "Admin_User1"
    And the Edit Office screen for "Mumbai Regional Office" is open
    And the baseline location data is loaded
    When I change the Location from "Mumbai" to "Nashik"
    And I click Save
    And I check the associations of "Mumbai" and "Nashik"
    Then the Office should be associated with "Nashik" only
    And "Mumbai" should have no associated Office

  @TC-Loc-035 @functional @high
  # Ref: FRD 6.2 FB-7; 6.5 FB-1
  Scenario: Verify newly created Location is immediately available in the Office Location lookup
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I create Location "Rajkot" under Parent Location "Gujarat"
    And without logging out I open Add Office and open the Location lookup
    Then "Rajkot" should be available for selection immediately

  @TC-Loc-036 @functional @high
  # Ref: FRD 6.7 FB-10; US-8 AC-4
  Scenario: Verify a successfully deleted Location no longer appears in the Office Location lookup
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Surat" which has no Office and no child
    And I confirm the deletion
    And I open Add Office and open the Location lookup
    Then "Surat" should not be listed in the lookup

  @TC-Loc-100 @negative @high
  # Ref: FRD 6.5 BR-1
  Scenario: Verify free-text/product-local Location entry is not allowed in Office creation
    Given I am logged in as "Admin_User1"
    And the Add Office screen is open
    And the baseline location data is loaded
    When I try typing "Rajkot-Free-Text" into the Location field
    And I try saving the Office
    Then only lookup values should be selectable
    And free text should not be accepted
    And the Office should not be saved with it

  @TC-Loc-101 @negative @high
  # Ref: FRD 6.5 BR-1; Obj (no orphaned Location)
  Scenario: Verify Office creation with a non-existent Location ID is rejected (API)
    Given an API client is authenticated as "Admin_User1"
    When I send a create-Office request with locationId "LOC-999999" with payload
      """
      {office:'Test Office', locationId:'LOC-999999'}
      """
    Then the request should be rejected
    And no orphan Office-Location association should be created
