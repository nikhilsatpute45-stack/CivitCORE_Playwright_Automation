@location @product_consumption
Feature: Product Consumption

  @TC-Loc-037 @functional @high
  # Ref: FRD 6.6 FB-1; 6.6 BR-1
  Scenario: Verify CivitBUILD and CivitINFRA references Location by Location ID
    Given I am logged in as "Admin_User1"
    And "Admin_User1" has access to CivitBUILD
    And the baseline location data is loaded
    When in CivitBUILD I open a feature that uses Location and select "Pune"
    And I inspect the stored reference via DB/API
    And I repeat the same check in CivitINFRA
    Then the stored reference should be the Location ID of "Pune", not its Name or Short Name

  @TC-Loc-038 @functional @high
  # Ref: FRD 6.6 FB-3
  Scenario: Verify a new Location is immediately available in CivitBUILD and CivitINFRA without re-creation
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I create Location "Rajkot" under Parent Location "Gujarat" in CivitCORE
    And I open the Location selection in CivitBUILD
    And I repeat the same check in CivitINFRA
    Then "Rajkot" should be available for reference in both CivitBUILD and CivitINFRA with the same Location ID
    And no product-level re-creation should be needed

  @TC-Loc-039 @functional @high
  # Ref: FRD 6.6 FB-4; BR-2; 6.4 BR-6
  Scenario: Verify an updated Location is reflected in CivitBUILD and CivitINFRA
    Given I am logged in as "Admin_User1"
    And the Edit Location form for "Nashik" is open
    And the baseline location data is loaded
    When I rename "Nashik" to "Nasik" in CivitCORE
    And I click Save
    And I open the CivitBUILD screen that displays Nashik's Location
    And I repeat the same check in CivitINFRA
    Then both CivitBUILD and CivitINFRA should show the current CivitCORE value "Nasik"
    And the reference should still point to the same Location ID

  @TC-Loc-040 @functional @high
  # Ref: FRD 6.6 BR-3; 6.7 BR-5
  Scenario: Verify product-level consumption is NOT a deletion blocker
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When in CivitBUILD I reference "Patna" which has no Office and no child
    And in CivitCORE I click Delete on "Patna"
    And I confirm the dialog
    Then the delete confirmation dialog should be displayed and the Location should be deleted
    And consumption by a product should not block deletion

  @TC-Loc-041 @functional @high
  # Ref: FRD 6.7 FB-10
  Scenario: Verify a deleted Location is no longer available for new product-level reference
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Delete on "Patna"
    And I confirm the deletion
    And I open the Location selection in CivitBUILD and CivitINFRA or call the Location lookup API
    Then "Patna" should not be available for new product references in either product
    And lookup by its ID should return not found

  @TC-Loc-042 @functional @medium
  # Ref: FRD 6.6 FB-5; 6.4 BR-5
  Scenario: Verify product-specific configuration is stored in the product and not in the CivitCORE Location Master
    Given I am logged in as "Admin_User1"
    And "Admin_User1" has access to CivitBUILD
    And the baseline location data is loaded
    When in CivitBUILD I configure a product-specific setting for "Pune"
    And I inspect the CivitCORE Location Master record for "Pune" via DB/API
    Then the Location Master record should contain no product-specific fields or values
    And the setting should be stored in CivitBUILD

  @TC-Loc-102 @negative @high
  # Ref: FRD 6.6 FB-2; 6.1 BR-2
  Scenario: Verify a consuming product cannot create an independent Location disconnected from CivitCORE
    Given an API client is authenticated for "CivitBUILD"
    When I attempt to create Location "Rajkot" via a CivitBUILD endpoint
    Then no product-local Location should be created
    And the product should only be able to reference CivitCORE Locations by Location ID
