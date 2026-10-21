@location @search_view
Feature: Location Search/View

  @TC-Loc-018 @functional @medium
  # Ref: FRD 6.3 FB-2; US-3 AC-1
  Scenario: Verify search by Location ID returns the matching Location
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I copy the Location ID of "Surat" from the Master
    And I enter the copied Location ID in the search box
    And I search
    Then only "Surat" should be returned

  @TC-Loc-019 @functional @medium
  # Ref: FRD 6.3 BR-2; US-3 AC-1
  Scenario: Verify search by partial Name and partial Short Name returns all matching Locations
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I enter "ahmed" in the search box
    And I search
    Then the search should return "Ahmedabad" and "Ahmedabad City" as a partial match on Name
    When I clear the search box
    And I enter "PU" in the search box
    And I search
    Then the search should return "Pune" (PUN) and "Pune City" (PUNC) as a partial match on Short Name

  @TC-Loc-020 @functional @medium
  # Ref: FRD 6.3 FB-2; US-3 AC-1
  Scenario: Verify search/filter by Location Category
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I search or filter by Location Category "District"
    Then only Locations of category "District" should be returned
      | Ahmedabad |
      | Surat     |
      | Mumbai    |
      | Pune      |
      | Nashik    |
      | Patna     |

  @TC-Loc-021 @functional @high
  # Ref: FRD 6.3 BR-2; US-3 AC-1
  Scenario: Verify search is not case-sensitive
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I search "GUJARAT"
    And I search "gujarat"
    And I search "GuJaRaT"
    Then all three searches should return the same result set containing "Gujarat"

  @TC-Loc-023 @functional @high
  # Ref: FRD 6.3 FB-3; US-4 AC-1
  Scenario: Verify View shows Location ID and all creation attributes in read-only mode
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I click View on "Surat"
    And I observe the displayed attributes
    And I try to type in each field
    Then the following attributes should be displayed
      | Location ID                | <system-generated ID of Surat> |
      | Location Category          | District                       |
      | Name                       | Surat                          |
      | Short Name                 | SRT                            |
      | Region                     | Western Region                 |
      | Parent Location Category   | State/Territory                |
      | Parent Location            | Gujarat                        |
    And all fields should be non-editable in View mode

  @TC-Loc-024 @functional @high
  # Ref: FRD 6.3 BR-1; US-4 AC-2
  Scenario: Verify a view-only user can open Location details
    Given I am logged in as "Viewer_User1" with view access only
    And the baseline location data is loaded
    When I open Location Management
    And I click View on "Surat"
    Then the Location details should open, independent of create, edit or delete permission

  @TC-Loc-025 @functional @medium
  # Ref: FRD 6.3 Columns table; US-3 AC-2
  Scenario: Verify Created By and Created Date are captured correctly
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I create Location "Rajkot" under Parent Location "Gujarat" as "Admin_User1" and note the time
    And I find "Rajkot" in the Location List
    And I read Created By and Created Date
    Then Created By should be "Admin_User1"
    And Created Date should show the date and time of creation

  @TC-Loc-092 @negative @medium
  # Ref: FRD 6.3 FB-2; US-3 AC-1 (negative)
  Scenario: Verify search with no matching records
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I enter "ZZZ-NoMatch-999" in the search box
    And I search
    Then no records should be displayed
    And no error or exception should occur
