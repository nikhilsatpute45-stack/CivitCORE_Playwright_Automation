@region_management @region_search_view
Feature: Region Search and View
  As a CivitCORE user
  I want to list, search and view Regions
  So that I can find Regions and see their associated Offices

  @TC-REG-019 @Functional @High
  Scenario: Verify Region List displays all Regions maintained in the Region Master by default
    Given I am logged in as "Region Admin"
    And the Region Master holds 5 Regions: "Northern Region", "Western Region", "Southern Region", "Delhi", "Eastern Region"
    When I navigate to the Region List
    Then 5 Regions should be listed without applying any search

  @TC-REG-020 @Functional @Medium
  Scenario: Verify Region ID and Region Name columns show the system ID and the master name
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists
    When I navigate to the Region List
    Then the Region ID cell for "Delhi" should show the system-generated identifier
    And the Region Name cell for "Delhi" should show "Delhi"

  @TC-REG-021 @Functional @High
  Scenario: Verify Assigned With Offices column shows the Office name for a Region with one Office
    Given I am logged in as "Region Admin"
    And Region "Western Region" has Office "Jodhpur" assigned
    When I navigate to the Region List
    Then the Assigned With Offices cell for "Western Region" should show "Jodhpur"

  @TC-REG-022 @Functional @High
  Scenario: Verify Assigned With Offices column lists all Offices for a Region with multiple Offices
    Given I am logged in as "Region Admin"
    And Region "Northern Region" has Offices "Corporate Headquarters" and "Agra"
    When I navigate to the Region List
    Then the Assigned With Offices cell for "Northern Region" should display "Corporate Headquarters" and "Agra"

  @TC-REG-023 @Functional @Medium
  Scenario: Verify Assigned With Offices is empty for a Region that has no Office
    Given I am logged in as "Region Admin"
    And Region "Delhi" has no Office assigned
    When I navigate to the Region List
    Then the Assigned With Offices cell for "Delhi" should be empty
    And no Office names should be shown for "Delhi"

  @TC-REG-024 @Functional @Medium
  Scenario: Verify Created By and Created Date columns show the creating user and creation date/time
    Given I am logged in as "Region Admin"
    And Region "Central Region" was created by user "Admin_User1" today
    When I navigate to the Region List
    Then the Created By cell for "Central Region" should show "Admin_User1"
    And the Created Date cell for "Central Region" should show the date and time the Region was created

  @TC-REG-025 @Functional @High
  Scenario: Verify search by partial Region Name returns matching Regions
    Given I am logged in as "Region Admin"
    And I am on the Region List screen
    When I enter "north" in the search box
    And I apply the search
    Then only "Northern Region" should be returned

  @TC-REG-026 @Functional @High
  Scenario: Verify search is case-insensitive
    Given I am logged in as "Region Admin"
    And I am on the Region List screen
    When I enter "NORTH" in the search box
    And I apply the search
    Then "Northern Region" should be returned
    When I clear the search box
    And I enter "nOrTh" in the search box
    And I apply the search
    Then "Northern Region" should be returned

  @TC-REG-027 @Functional @Medium
  Scenario: Verify search matches partial text anywhere within the Region Name
    Given I am logged in as "Region Admin"
    And I am on the Region List screen
    When I enter "ern" in the search box
    And I apply the search
    Then "Northern Region", "Southern Region", "Eastern Region" and "Western Region" should be returned
    And "Delhi" should not be returned

  @TC-REG-028 @Functional @Medium
  Scenario: Verify search with no matching Region returns an empty list
    Given I am logged in as "Region Admin"
    And I am on the Region List screen
    When I enter "Zzzz" in the search box
    And I apply the search
    Then no Region rows should be displayed
    And no error should occur

  @TC-REG-029 @Functional @Low
  Scenario: Verify clearing the search restores the full Region List
    Given I am logged in as "Region Admin"
    And I am on the Region List screen
    And a search for "north" has been applied
    When I clear the search box
    And I apply the search
    Then all Regions should be displayed again

  @TC-REG-030 @Functional @Low
  Scenario: Verify search filters on Region Name only, not on Office name
    Given I am logged in as "Region Admin"
    And Office "Corporate Headquarters" is assigned to "Northern Region"
    And I am on the Region List screen
    When I enter "Corporate Headquarters" in the search box
    And I apply the search
    Then no Region should be returned

  @TC-REG-031 @Functional @Medium
  Scenario: Verify a view-only user can search the Region List
    Given I am logged in as "Region Viewer"
    And I am on the Region List screen
    When I enter "south" in the search box
    And I apply the search
    Then "Southern Region" should be returned

  @TC-REG-032 @Functional @High
  Scenario: Verify View shows Region ID, Region Name and associated Office(s)
    Given I am logged in as "Region Admin"
    And Region "Northern Region" has Offices "Corporate Headquarters" and "Agra"
    When I click "View" on Region "Northern Region"
    Then the Region ID should be displayed
    And the Region Name should be "Northern Region"
    And the Offices "Corporate Headquarters" and "Agra" should be displayed
