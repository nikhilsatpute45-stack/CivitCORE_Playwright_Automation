@region_management @region_multi_product
Feature: Region - Multi-Product Consumption
  As a Region Admin
  I want CivitBUILD and CivitINFRA to consume Regions from the CivitCORE Region Master
  So that a Region is maintained once and referenced everywhere by Region ID

  @TC-REG-053 @Integration @High
  Scenario: Verify consuming products reference CivitCORE Regions by Region ID
    Given CivitINFRA is configured for Region "Eastern Region" using the CivitCORE Region Master
    When I query the CivitINFRA record that references "Eastern Region"
    And I compare the stored key with the CivitCORE Region ID
    Then CivitINFRA should store the CivitCORE Region ID as the reference key

  @TC-REG-054 @Integration @High
  Scenario: Verify a new Region is available in CivitBUILD without re-creating it
    Given I am logged in as "Region Admin"
    And Region "Central Region" does not exist
    When I create Region "Central Region" in CivitCORE
    And I open the Region selection in CivitBUILD
    Then "Central Region" should be selectable in CivitBUILD immediately
    And no product-level creation should be required

  @TC-REG-055 @Integration @High
  Scenario: Verify a new Region is available in CivitINFRA without re-creating it
    Given I am logged in as "Region Admin"
    And Region "Central Region" does not exist
    When I create Region "Central Region" in CivitCORE
    And I open the Region selection in CivitINFRA
    Then "Central Region" should be selectable in CivitINFRA immediately
    And no product-level creation should be required

  @TC-REG-056 @Integration @High
  Scenario: Verify a Region rename is reflected in CivitBUILD
    Given I am logged in as "Region Admin"
    And Region "Western Region" is displayed in CivitBUILD
    When I rename Region "Western Region" to "West Zone" in CivitCORE
    And I open the screen in CivitBUILD that displays the Region
    Then CivitBUILD should show "West Zone"

  @TC-REG-057 @Integration @High
  Scenario: Verify a Region rename is reflected in CivitINFRA
    Given I am logged in as "Region Admin"
    And Region "Western Region" is displayed in CivitINFRA
    When I rename Region "Western Region" to "West Zone" in CivitCORE
    And I open the screen in CivitINFRA that displays the Region
    Then CivitINFRA should show "West Zone"

  @TC-REG-058 @Integration @High
  Scenario: Verify a product-level record keeps its Region ID reference after a rename
    Given a CivitINFRA record references Region "Western Region" by Region ID
    When I rename Region "Western Region" to "West Zone"
    And I query the CivitINFRA record and compare its stored Region ID
    Then the stored Region ID should be unchanged and still resolve to the Region
    And Region Name should not be used as the integration key

  @TC-REG-059 @Integration @Medium @API
  Scenario: Verify a product cannot create a disconnected Region that duplicates an existing CivitCORE Region
    Given I have product-level API or configuration access for CivitBUILD
    And Region "Northern Region" exists in CivitCORE
    When I attempt to create or register a Region named "Northern Region" at the CivitBUILD level
    And I compare the Region Master and the product's Region list
    Then no independent Region should be created
    And the product should continue to reference the single CivitCORE Region ID
