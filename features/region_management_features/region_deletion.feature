@region_management @region_deletion
Feature: Region Deletion
  As a Region Admin
  I want to delete unused Regions and be blocked from deleting Regions in use
  So that Offices and Locations never reference a non-existent Region

  # ---------------------------------------------------------------
  # Functional
  # ---------------------------------------------------------------

  @TC-REG-061 @Functional @High
  Scenario: Verify a delete confirmation prompt is shown for a Region with no Office or Location association
    Given I am logged in as "Region Admin"
    And Region "Delhi" has no Office or Location association
    When I click "Delete" on Region "Delhi"
    Then the dependency check should pass
    And a delete confirmation prompt should be displayed

  @TC-REG-062 @Functional @High
  Scenario: Verify confirming the prompt permanently removes the Region from the Region Master
    Given I am logged in as "Region Admin"
    And Region "Delhi" has no Office or Location association
    When I click "Delete" on Region "Delhi"
    And I confirm the prompt
    Then "Delhi" should be removed from the Region List and the Region Master
    And the record should not be retrievable by name or Region ID

  @TC-REG-063 @Functional @High
  Scenario: Verify Cancel on the delete confirmation leaves the Region unchanged
    Given I am logged in as "Region Admin"
    And Region "Delhi" has no Office or Location association
    When I click "Delete" on Region "Delhi"
    And I click "Cancel" on the confirmation prompt
    Then "Delhi" should remain unchanged in the Region List and Region Master

  @TC-REG-064 @Functional @Medium
  Scenario: Verify Delete can be started from the Region Detail view
    Given I am logged in as "Region Admin"
    And Region "Delhi" has no Office or Location association
    When I click "View" on Region "Delhi"
    And I click "Delete" on the Region detail view
    And I confirm the prompt
    Then a confirmation prompt should have appeared
    And "Delhi" should be deleted

  @TC-REG-065 @Integration @High
  Scenario: Verify a deleted Region no longer appears in the Office Region lookup
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists with no Office or Location association
    When I delete Region "Delhi" and confirm
    And I open Office Management, click "Add" and open the Region lookup
    Then "Delhi" should be absent from the Office Region lookup

  @TC-REG-066 @Integration @High
  Scenario: Verify a deleted Region no longer appears in the Location Region lookup
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists with no Office or Location association
    When I delete Region "Delhi" and confirm
    And I open Location Management, click "Add" and open the Region lookup
    Then "Delhi" should be absent from the Location Region lookup

  @TC-REG-067 @Integration @Medium
  Scenario: Verify a deleted Region is no longer available for new product-level reference
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists with no Office or Location association
    When I delete Region "Delhi" and confirm
    And I open the Region selection in CivitBUILD and CivitINFRA
    Then "Delhi" should not be available for selection in any consuming product

  @TC-REG-068 @Functional @High
  Scenario: Verify product consumption alone does not block deletion
    Given I am logged in as "Region Admin"
    And Region "Eastern Region" has no Office or Location
    And Region "Eastern Region" is referenced in CivitINFRA product configuration
    When I click "Delete" on Region "Eastern Region"
    And I confirm the prompt
    Then deletion should be allowed
    And "Eastern Region" should be removed

  @TC-REG-069 @Functional @High
  Scenario: Verify deletion is allowed after the last Office association is removed (real-time check)
    Given I am logged in as "Region Admin"
    And Region "Western Region" has only Office "Jodhpur" and no Location
    When I edit Office "Jodhpur" and change its Region to "Delhi"
    And I return to the Region List
    And I click "Delete" on Region "Western Region"
    And I confirm the prompt
    Then the dependency check should be re-evaluated at delete time and find no association
    And the confirmation prompt should appear
    And "Western Region" should be deleted

  # ---------------------------------------------------------------
  # Negative
  # ---------------------------------------------------------------

  @TC-REG-129 @Negative @High
  Scenario: Verify deletion is blocked for a Region assigned to an Office
    Given I am logged in as "Region Admin"
    And Region "Western Region" has Office "Jodhpur" and no Location
    When I click "Delete" on Region "Western Region"
    Then the deletion should not be performed
    And "Western Region" should remain in the Region List and Region Master

  @TC-REG-131 @Negative @High
  Scenario: Verify no delete confirmation prompt appears when an Office dependency blocks deletion
    Given I am logged in as "Region Admin"
    And Region "Western Region" has Office "Jodhpur"
    When I click "Delete" on Region "Western Region"
    Then only the dependency message should be shown
    And no delete confirmation dialog should be displayed

  @TC-REG-132 @Negative @High
  Scenario: Verify deletion is blocked for a Region assigned to a Location
    Given I am logged in as "Region Admin"
    And Region "Southern Region" has Location "Pune" and no Office
    When I click "Delete" on Region "Southern Region"
    Then the deletion should not be performed
    And "Southern Region" should remain in the Region List and Region Master

  @TC-REG-134 @Negative @High
  Scenario: Verify no delete confirmation prompt appears when a Location dependency blocks deletion
    Given I am logged in as "Region Admin"
    And Region "Southern Region" has Location "Pune"
    When I click "Delete" on Region "Southern Region"
    Then only the dependency message should be shown
    And no delete confirmation dialog should be displayed

  @TC-REG-135 @Negative @Medium
  Scenario: Verify the Office dependency is reported first when a Region has both Office and Location associations
    Given I am logged in as "Region Admin"
    And Region "Northern Region" has Offices and Location "Nagpur"
    When I click "Delete" on Region "Northern Region"
    Then the deletion should be blocked with the Office-dependency message
    # Office check precedes the Location check per Figure 3

  @TC-REG-136 @Negative @High
  Scenario: Verify the dependency check is real-time when the list is stale
    Given I am logged in as "Region Admin" in Session A
    And the Region List in Session A shows "Delhi" with no associations
    When in Session B I assign Office "Jaipur" to Region "Delhi"
    And in Session A, without refreshing, I click "Delete" on Region "Delhi"
    Then the deletion should be blocked with the Office-dependency message

  @TC-REG-137 @Negative @High @API
  Scenario: Verify a view-only user cannot delete a Region through the API
    Given I have API access as "Region Viewer"
    And Region "Delhi" exists with no Office or Location association
    When I send a delete request for "Delhi"
    Then the request should be denied
    And "Delhi" should remain in the Region Master

  @TC-REG-138 @Negative @High @API
  Scenario: Verify the API rejects deletion of a Region that has Office or Location dependencies
    Given I have API access as "Region Admin"
    And Region "Western Region" has Office "Jodhpur"
    And Region "Southern Region" has Location "Pune"
    When I send delete requests directly to the API for "Western Region" and "Southern Region"
    Then both requests should be rejected
    And neither Region should be deleted

  @TC-REG-139 @Negative @High
  Scenario: Verify a blocked deletion leaves Office and Location records referencing the Region (no orphan)
    Given I am logged in as "Region Admin"
    And Region "Northern Region" has Offices "Corporate Headquarters" and "Agra" and Location "Nagpur"
    When I attempt to delete Region "Northern Region"
    And I open Offices "Corporate Headquarters" and "Agra" and Location "Nagpur"
    Then all three records should still reference "Northern Region"
    And none should reference an orphaned or non-existent Region
