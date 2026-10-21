@region_management @region_office_location_association
Feature: Region - Office and Location Association
  As a Region Admin
  I want Offices and Locations to reference Regions from the Region Master by Region ID
  So that associations stay consistent when Regions change

  # ---------------------------------------------------------------
  # Functional / Integration
  # ---------------------------------------------------------------

  @TC-REG-044 @Integration @High
  Scenario: Verify the Region lookup in Office create is populated from the Region Master
    Given I am logged in as "Region Admin"
    And the Region Master holds 5 Regions
    When I open Office Management and click "Add"
    And I open the Region lookup
    Then the lookup should list exactly "Northern Region", "Western Region", "Southern Region", "Delhi" and "Eastern Region"

  @TC-REG-045 @Integration @High
  Scenario: Verify an Office-to-Region association is stored by Region ID
    Given I am logged in as "Region Admin"
    When I create Office "Jaipur" and select Region "Delhi"
    And I save the Office
    And I query the Office-Region association in the data layer
    Then the association should store the Region ID of "Delhi" and not the Region Name

  @TC-REG-046 @Integration @High
  Scenario: Verify Assigned With Offices reflects a new Office assignment
    Given I am logged in as "Region Admin"
    And Region "Delhi" has no Office
    When I create Office "Jaipur" with Region "Delhi" and save
    And I open the Region List
    Then "Jaipur" should appear under Assigned With Offices for "Delhi"

  @TC-REG-047 @Integration @High
  Scenario: Verify the Region lookup in Location create is populated from the Region Master
    Given I am logged in as "Region Admin"
    And the Region Master holds 5 Regions
    When I open Location Management and click "Add"
    And I open the Region lookup
    Then the lookup should list exactly the Regions in the CivitCORE Region Master

  @TC-REG-048 @Integration @High
  Scenario: Verify a Location-to-Region association is stored by Region ID
    Given I am logged in as "Region Admin"
    When I create Location "Nashik" and select Region "Western Region"
    And I save the Location
    And I query the Location-Region association in the data layer
    Then the association should store the Region ID of "Western Region" and not its name

  @TC-REG-049 @Functional @Medium
  Scenario: Verify the selected Region is displayed wherever the Location's Region information is shown
    Given I am logged in as "Region Admin"
    And Location "Nashik" is saved with Region "Western Region"
    When I open Location "Nashik" in view mode
    And I open the Location list
    Then "Western Region" should be displayed on the Location view
    And "Western Region" should be displayed on the Location list

  @TC-REG-050 @Integration @High
  Scenario: Verify changing an Office's Region updates the reference and the Assigned With Offices columns
    Given I am logged in as "Region Admin"
    And Office "Jodhpur" is assigned to "Western Region"
    And Region "Delhi" has no Office
    When I edit Office "Jodhpur" and change Region to "Delhi"
    And I save the Office
    Then Office "Jodhpur" should reference "Delhi"
    And "Jodhpur" should be removed from Assigned With Offices for "Western Region"
    And "Jodhpur" should be shown under Assigned With Offices for "Delhi"

  # Assumption stated in the test case: Region is optional on the Office form
  @TC-REG-051 @Integration @Medium
  Scenario: Verify removing the Region from an Office removes it from Assigned With Offices
    Given I am logged in as "Region Admin"
    And Office "Jodhpur" is assigned to "Western Region"
    And the Office form allows the Region to be cleared
    When I edit Office "Jodhpur" and clear the Region
    And I save the Office
    Then "Jodhpur" should no longer be listed against "Western Region"

  @TC-REG-052 @Integration @High
  Scenario: Verify changing a Location's Region updates the Location reference
    Given I am logged in as "Region Admin"
    And Location "Pune" is assigned to "Southern Region"
    When I edit Location "Pune" and change Region to "Delhi"
    And I save the Location
    And I reopen Location "Pune"
    Then Location "Pune" should reference "Delhi"

  # ---------------------------------------------------------------
  # Negative
  # ---------------------------------------------------------------

  @TC-REG-125 @Negative @High @API
  Scenario: Verify an Office cannot be saved with a free-text Region not in the Region Master
    Given I have API access as "Region Admin"
    When I send a create-Office request for "Jaipur" with Region value "Mid Zone"
    Then the request should be rejected

  @TC-REG-126 @Negative @High @API
  Scenario: Verify an Office cannot reference a non-existent Region ID
    Given I have API access as "Region Admin"
    When I send a create-Office request for "Jaipur" with Region ID "REG-0000"
    Then the request should be rejected

  @TC-REG-127 @Negative @High @API
  Scenario: Verify a Location cannot be saved with a free-text Region not in the Region Master
    Given I have API access as "Region Admin"
    When I send a create-Location request for "Nashik" with Region value "Mid Zone"
    Then the request should be rejected

  @TC-REG-128 @Negative @High @API
  Scenario: Verify an Office cannot be associated with a Region that has been deleted
    Given I have API access as "Region Admin"
    And Region "Delhi" was deleted and its old Region ID is known
    When I send a create-Office request for "Jaipur" with the deleted Region's ID
    Then the request should be rejected
