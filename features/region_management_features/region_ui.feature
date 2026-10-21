@region_management @region_ui
Feature: Region Management UI
  As a Region Admin
  I want the Region screens to present the specified columns, fields and controls
  So that Regions can be managed consistently

  @TC-REG-087 @UI_UX @Medium
  Scenario: Verify Region List column headers and order
    Given I am logged in as "Region Admin"
    And I am on the Region List screen
    And the list has multiple records
    When I read the grid column headers from left to right
    Then the column headers should be, in order: "Region ID", "Region Name", "Assigned With Offices", "Created By", "Created Date", "Actions"

  @TC-REG-088 @UI_UX @Medium
  Scenario: Verify a search input is available on the Region List
    Given I am logged in as "Region Admin"
    And I am on the Region List screen
    Then a search input for Region Name should be present and enabled

  @TC-REG-091 @UI_UX @Medium
  Scenario: Verify the Add Region form shows only the Region Name field
    Given I am logged in as "Region Admin"
    And I am on the Region List screen
    When I click "Add"
    Then the only user-entered field should be Region Name
    And no Region ID input should be present
    And no other attributes should be present

  @TC-REG-095 @UI_UX @High
  Scenario: Verify Region ID is shown as read-only on the Edit form
    Given I am logged in as "Region Admin"
    And Region "Southern Region" exists
    When I click "Edit" on Region "Southern Region"
    And I try to type into the Region ID control
    Then the Region ID should be displayed as read-only or disabled
    And the Region Name should be editable

  @TC-REG-099 @UI_UX @High
  Scenario: Verify the Region field in Office create/edit is a selection-only dropdown with no free text
    Given I am logged in as "Region Admin"
    And the Office Add form is open
    When I click into the Region field
    And I try to type the value "Mid Zone"
    Then the control should only allow choosing from the Region Master list
    And free-text entry should not be accepted

  @TC-REG-100 @UI_UX @High
  Scenario: Verify the Region field in Location create/edit is a selection-only dropdown with no free text
    Given I am logged in as "Region Admin"
    And the Location Add form is open
    When I click into the Region field
    And I try to type the value "Mid Zone"
    Then the control should only allow choosing from the Region Master list
    And free-text entry should not be accepted
