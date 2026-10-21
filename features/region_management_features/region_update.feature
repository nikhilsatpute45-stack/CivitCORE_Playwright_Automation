@region_management @region_update
Feature: Region Update
  As a Region Admin
  I want to rename Regions without affecting their identity or associations
  So that Offices, Locations and consuming products keep working

  # ---------------------------------------------------------------
  # Functional
  # ---------------------------------------------------------------

  @TC-REG-033 @Functional @High
  Scenario: Verify Edit opens from the Region List with Region Name editable
    Given I am logged in as "Region Admin"
    And Region "Southern Region" exists
    When I click "Edit" on Region "Southern Region"
    And I type into the Region Name field
    Then the Edit form should open pre-filled with "Southern Region"
    And the Region Name should be editable

  @TC-REG-034 @Functional @Medium
  Scenario: Verify Edit can be started from the Region Detail view
    Given I am logged in as "Region Admin"
    And Region "Southern Region" exists
    When I click "View" on Region "Southern Region"
    And I click "Edit" on the Region detail view
    Then the Edit form should open for "Southern Region"

  @TC-REG-035 @Functional @High
  Scenario: Verify Region Name update is saved
    Given I am logged in as "Region Admin"
    And Region "Western Region" exists
    When I click "Edit" on Region "Western Region"
    And I change Region Name to "West Zone"
    And I click "Save"
    Then the Region Name should be persisted as "West Zone"

  @TC-REG-036 @Functional @High
  Scenario: Verify the Region ID is unchanged and no new Region is created after a rename
    Given I am logged in as "Region Admin"
    And Region "Western Region" exists
    And I note the Region ID of "Western Region" and the total Region count of 5
    When I rename Region "Western Region" to "West Zone" and save
    Then the Region ID should be identical to the original
    And the total Region count should remain 5

  @TC-REG-037 @Functional @High
  Scenario: Verify existing Region-to-Office association is preserved after rename
    Given I am logged in as "Region Admin"
    And Region "Western Region" has Office "Jodhpur"
    When I rename Region "Western Region" to "West Zone" and save
    And I open Office "Jodhpur" and check its Region
    Then Office "Jodhpur" should reference the same Region ID and show "West Zone"
    And the Assigned With Offices cell for "West Zone" should list "Jodhpur"

  @TC-REG-038 @Functional @High
  Scenario: Verify existing Region-to-Location association is preserved after rename
    Given I am logged in as "Region Admin"
    And Region "Southern Region" is assigned to Location "Pune"
    When I rename Region "Southern Region" to "South Zone" and save
    And I open Location "Pune" and check its Region
    Then Location "Pune" should still reference the same Region ID

  @TC-REG-039 @Integration @High
  Scenario: Verify the updated Region Name is visible in Office Management
    Given I am logged in as "Region Admin"
    And Region "Western Region" is assigned to Office "Jodhpur"
    When I rename Region "Western Region" to "West Zone" and save
    And I open Office "Jodhpur" and the Office Region lookup
    Then Office "Jodhpur" should display Region "West Zone"
    And the Region lookup should list "West Zone"

  @TC-REG-040 @Integration @High
  Scenario: Verify the updated Region Name is reflected on the Location's Region display
    Given I am logged in as "Region Admin"
    And Region "Southern Region" is assigned to Location "Pune"
    When I rename Region "Southern Region" to "South Zone" and save
    And I open Location "Pune" and view its Region information
    Then Location "Pune" should display Region "South Zone"

  @TC-REG-041 @Functional @Medium
  Scenario: Verify leading and trailing spaces are trimmed on Region update
    Given I am logged in as "Region Admin"
    And Region "Western Region" exists
    When I click "Edit" on Region "Western Region"
    And I change Region Name to "  West Zone  "
    And I click "Save"
    Then the Region Name should be stored as "West Zone"

  @TC-REG-042 @Functional @Medium
  Scenario: Verify a Region can be saved with only a case change to its own name
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists
    When I click "Edit" on Region "Delhi"
    And I change Region Name to "DELHI"
    And I click "Save"
    Then the save should succeed
    And no duplicate-name error should be displayed

  @TC-REG-043 @Functional @Low
  Scenario: Verify saving an Edit form without changing the Region Name does not raise a duplicate error
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists
    When I click "Edit" on Region "Delhi"
    And I do not change the Region Name
    And I click "Save"
    Then the save should succeed without a duplicate-name error

  # ---------------------------------------------------------------
  # Negative
  # ---------------------------------------------------------------

  @TC-REG-118 @Negative @High
  Scenario: Verify update is blocked when Region Name is cleared
    Given I am logged in as "Region Admin"
    And Region "Southern Region" exists
    When I click "Edit" on Region "Southern Region"
    And I clear the Region Name
    And I click "Save"
    Then the save should be blocked with the message "Region Name is required"
    And the stored name should remain "Southern Region"

  @TC-REG-119 @Negative @High
  Scenario: Verify update is blocked when Region Name contains only spaces
    Given I am logged in as "Region Admin"
    And Region "Southern Region" exists
    When I click "Edit" on Region "Southern Region"
    And I change Region Name to "    "
    And I click "Save"
    Then the save should be blocked with the message "Region Name is required"
    And the stored name should remain "Southern Region"

  @TC-REG-120 @Negative @High
  Scenario: Verify renaming to another Region's name differing only by case and spaces is blocked
    Given I am logged in as "Region Admin"
    And Regions "Eastern Region" and "Northern Region" exist
    When I click "Edit" on Region "Eastern Region"
    And I change Region Name to " northern region "
    And I click "Save"
    Then the update should be blocked with the duplicate-name message

  @TC-REG-121 @Negative @Medium
  Scenario: Verify renaming to a name with a special character is rejected
    Given I am logged in as "Region Admin"
    And Region "Eastern Region" exists
    When I click "Edit" on Region "Eastern Region"
    And I change Region Name to "East@Zone"
    And I click "Save"
    Then the update should be blocked

  @TC-REG-122 @Negative @High @API
  Scenario: Verify a modified Region ID in an update request is rejected
    Given I have API access as "Region Admin"
    And Region "Eastern Region" exists
    When I send an update request for "Eastern Region" that changes the Region ID to "REG-9999"
    And I read Region "Eastern Region"
    Then the request should be rejected or the Region ID change should be ignored
    And the Region ID should remain unchanged

  @TC-REG-123 @Negative @High @API
  Scenario: Verify a view-only user cannot update a Region through the API
    Given I have API access as "Region Viewer"
    And Region "Eastern Region" exists
    When I send an update request renaming "Eastern Region" to "East Zone"
    Then the request should be denied
    And the Region Name should remain "Eastern Region"

  @TC-REG-124 @Negative @Medium
  Scenario: Verify a rejected rename leaves the name and Office/Location associations unchanged
    Given I am logged in as "Region Admin"
    And Region "Western Region" has Office "Jodhpur"
    And Region "Delhi" exists
    When I click "Edit" on Region "Western Region"
    And I change Region Name to "Delhi"
    And I click "Save"
    Then the save should be blocked
    And the Region Name should remain "Western Region"
    And Office "Jodhpur" should still reference the Region
