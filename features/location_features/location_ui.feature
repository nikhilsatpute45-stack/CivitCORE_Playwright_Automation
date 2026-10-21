@location @ui
Feature: Location UI

  @TC-Loc-057 @ui @medium
  # Ref: FRD 6.1 FB-2/FB-3; US-1 AC-1/AC-3; 6.3 Columns
  Scenario: Verify Add action and View, Edit and Delete row actions are displayed for a user with full permission
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I observe the Location List toolbar
    And I observe the Actions for the rows "Surat" and "Mumbai"
    Then the "Add" action should be visible and enabled
    And the View, Edit and Delete actions should be shown for each row
    # Note: FRD 6.3 Columns lists only 'Edit, Delete' while US-1 AC-3 and 6.1 list View too - confirm

  @TC-Loc-058 @ui @high
  # Ref: FRD 6.1 BR-1; US-1 AC-2
  Scenario: Verify Add/Edit/Delete actions are NOT displayed to a view-only user
    Given I am logged in as "Viewer_User1" with view access only
    And the baseline location data is loaded
    When I open Location Management
    And I inspect the toolbar and row actions
    Then the Add, Edit and Delete actions should not be displayed
    And only the View action should remain available

  @TC-Loc-059 @ui @high
  # Ref: FRD 6.1 BR-1; US-1 AC-2/AC-3
  Scenario: Verify an Edit-only user sees Edit but not Add or Delete
    Given I am logged in as "Editor_User1" with View and Edit access
    And the baseline location data is loaded
    When I open Location Management
    And I inspect the toolbar and row actions
    Then the Edit action should be available
    And the Add and Delete actions should not be displayed

  @TC-Loc-061 @ui @high
  # Ref: FRD 6.2 BR-10; Fields (Location ID)
  Scenario: Verify Location ID is system-generated and not editable on the Add form
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I observe the Location ID field or label
    And I try to click and type in it
    Then Location ID should not be editable (read-only, auto-generated indicator, or not shown) at creation

  @TC-Loc-062 @ui @high
  # Ref: FRD 6.2 Fields (Location Category, Region: 'Manual entry shall not be allowed')
  Scenario: Verify Location Category, Region, Parent Location Category and Parent Location are dropdown-only with no free-text entry
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I click each of the Location Category, Region, Parent Location Category and Parent Location dropdowns and try typing the value "Village" which is not in the list
    And I press Enter or Tab
    Then the typed text should not be committed
    And only listed values should be selectable for all four dropdowns

  @TC-Loc-063 @ui @high
  # Ref: FRD 6.4 FB-1/FB-2; BR-1; US-5 AC-3
  Scenario: Verify Edit form is pre-populated and Location ID is displayed read-only
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click Edit on "Surat"
    And I observe the fields
    And I try to type in the Location ID
    Then the existing values should be pre-filled
    And the Location ID should be shown read-only (greyed or disabled) and should not be editable
