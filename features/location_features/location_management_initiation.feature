@location @initiation
Feature: Location Management Initiation

  @TC-Loc-001 @functional @high
  # Ref: FRD 6.1 FB-1/FB-2; 6.3 FB-1; US-1 AC-1
  Scenario: Verify Location List loads as the landing view of Location Management
    Given "Admin_User1" has valid credentials and Location Management permission
    When I login to CivitCORE as "Admin_User1"
    And I navigate to "System Configuration > Location"
    And I observe the page that loads
    Then the Location List should be displayed by default as the landing view
    And the Locations in the CivitCORE Location Master should be listed together with the hierarchical tree "Country > State/Territory > District > City"

  @TC-Loc-002 @functional @high
  # Ref: FRD 6.1 FB-2; 6.3 FB-1; US-1 AC-1
  Scenario: Verify Locations are displayed in parent-child hierarchy exactly as stored
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I open the Location List hierarchy tree
    And I expand "INDIA > Gujarat > Ahmedabad > Ahmedabad City"
    And I expand "INDIA > Maharashtra > Pune > Pune City"
    Then each child Location should be nested under its Parent Location exactly as stored in the Location Master
    And "Gujarat", "Maharashtra" and "Bihar" should appear as children of "INDIA"

  @TC-Loc-003 @functional @high
  # Ref: FRD 6.3 FB-1
  Scenario: Verify only Locations present in the CivitCORE Location Master are listed
    Given I am logged in as "Admin_User1"
    And I am on the Location List page
    And the baseline location data is loaded
    When I note the total record count in the Location Master via DB/API
    And I expand all tree nodes on the Location List and count the displayed Locations
    And I compare the counts and names
    Then the Location List should show exactly the 12 master records
      | INDIA        |
      | Gujarat      |
      | Maharashtra  |
      | Bihar        |
      | Ahmedabad    |
      | Ahmedabad City |
      | Surat        |
      | Mumbai       |
      | Pune         |
      | Pune City    |
      | Nashik       |
      | Patna        |
    And no extra, missing or deleted Locations should be displayed
