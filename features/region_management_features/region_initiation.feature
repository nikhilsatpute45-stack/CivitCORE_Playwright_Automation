@region_management @region_initiation
Feature: Region Management Initiation
  As a CivitCORE user
  I want to reach Region Management and see the actions my role permits
  So that only authorized users can create, edit or delete Regions

  @TC-REG-001 @Functional @High
  Scenario: Verify Region Management is reachable from the System Configuration area for an authorized user
    Given I am logged in as "Region Admin"
    When I expand "System Configuration" in the left menu
    And I click "Region"
    Then the Region Management screen should open
    And no access-denied or error message should be displayed

  @TC-REG-002 @Functional @High
  Scenario: Verify Region List is the landing view with an 'Add' action for an authorized user
    Given I am logged in as "Region Admin"
    When I navigate to "System Configuration" > "Region"
    Then the Region List should be displayed by default as the landing view
    And the "Add" action should be visible and enabled

  @TC-REG-003 @Functional @High
  Scenario: Verify View, Edit and Delete actions are displayed against each Region row for an authorized user
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists with no Office or Location association
    When I navigate to "System Configuration" > "Region"
    Then the "Delhi" row should display the "View", "Edit" and "Delete" actions

  @TC-REG-004 @Functional @High
  Scenario: Verify a view-only user can open Region Management and see the Region List
    Given I am logged in as "Region Viewer"
    When I navigate to "System Configuration" > "Region"
    Then the Region List should be displayed
    And all Regions in the Region Master should be listed

  @TC-REG-005 @Functional @High
  Scenario: Verify 'Add' action is not available to a view-only user
    Given I am logged in as "Region Viewer"
    And I am on the Region List screen
    Then the "Add" action should be hidden or disabled

  @TC-REG-006 @Functional @High
  Scenario: Verify 'Edit' action is not available to a view-only user
    Given I am logged in as "Region Viewer"
    And Region "Delhi" exists
    And I am on the Region List screen
    When I locate the "Delhi" row
    Then the "Edit" action should be hidden or disabled

  @TC-REG-007 @Functional @High
  Scenario: Verify 'Delete' action is not available to a view-only user
    Given I am logged in as "Region Viewer"
    And Region "Delhi" exists
    And I am on the Region List screen
    When I locate the "Delhi" row
    Then the "Delete" action should be hidden or disabled
