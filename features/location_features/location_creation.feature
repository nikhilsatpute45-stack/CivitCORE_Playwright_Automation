@location @creation
Feature: Location Creation

  @TC-Loc-004 @functional @high
  # Ref: FRD 6.2 FB-4/FB-5/FB-6; 6.3 FB-1; US-2 AC-1
  Scenario: Verify Location is created with all attributes under a Parent Location and appears in the hierarchy
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I select Parent Location Category "State/Territory"
    And I select Parent Location "Gujarat"
    And I select Location Category "District"
    And I enter Name "Rajkot"
    And I enter Short Name "RJK"
    And I select Region "Western Region"
    And I click Save
    And I expand "INDIA > Gujarat" on the Location List
    Then validation should pass and the Location should be created in the CivitCORE Location Master
    And a unique, system-generated Location ID should be created for it
    And the toaster "Location created successfully." should be displayed
    And "Rajkot" should be displayed as a child of "Gujarat" in the hierarchy

  @TC-Loc-005 @functional @high
  # Ref: FRD 6.2 BR-1; US-2 AC-3; FRD 1
  Scenario: Verify Location is created at top level (L1) when no Parent Location Category/Parent Location is selected
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I leave Parent Location Category and Parent Location unselected
    And I select Location Category "Country"
    And I enter Name "Bhutan"
    And I enter Short Name "BTN"
    And I select Region "Northern Region"
    And I click Save
    Then the Location should be saved at top level (L1) without any parent mapping
    And the toaster "Location created successfully." should be displayed

  @TC-Loc-006 @functional @high
  # Ref: FRD 6.2 BR-9; Field table (Location ID); US-2 AC-6
  Scenario: Verify Location ID is system-generated and unique for every new Location
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I create the following Locations under Parent Location "Gujarat" one after another
      | Name      | Short Name |
      | Jamnagar  | JMN        |
      | Bhavnagar | BHV        |
      | Junagadh  | JNG        |
    And I record the Location ID of each from the Location List
    And I check the Location Master for duplicate IDs
    Then each Location should be assigned a different system-generated Location ID
    And no two Locations in the Master should share a Location ID
    And the Location ID should not be entered by the user

  @TC-Loc-007 @functional @high
  # Ref: FRD 6.2 BR-4; Name and Short Name field validation
  Scenario: Verify leading and trailing spaces in Name and Short Name are trimmed before persistence
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter Name "  Anand  "
    And I enter Short Name "  AND  "
    And I select Parent Location "Gujarat"
    And I select Location Category "District"
    And I select Region "Western Region"
    And I click Save
    And I open the saved Location
    Then the Location should be saved with Name "Anand" and Short Name "AND" with no leading or trailing spaces

  @TC-Loc-008 @functional @medium
  # Ref: FRD 6.2 Field table - Name, Short Name
  Scenario: Verify multiple consecutive spaces in Name and Short Name are normalized
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter Name "Banas   Kantha"
    And I enter Short Name "BNS   KNT"
    And I select Parent Location "Gujarat"
    And I select Location Category "District"
    And I select Region "Western Region"
    And I click Save
    And I open the saved Location
    Then the Location should be saved with Name "Banas Kantha" and Short Name "BNS KNT" using a single space

  @TC-Loc-009 @functional @medium
  # Ref: FRD 6.2 Field table - Name
  Scenario: Verify Name accepts approved special characters - hyphen, apostrophe, period, ampersand, parentheses
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter Name "St. John's (East) - Dist & Co"
    And I enter Short Name "SJE"
    And I select Parent Location "Gujarat"
    And I select Location Category "District"
    And I select Region "Western Region"
    And I click Save
    Then the save should succeed and the Name should be stored exactly as entered
    And the toaster "Location created successfully." should be displayed

  @TC-Loc-010 @functional @medium
  # Ref: FRD 6.2 Field table - Short Name
  Scenario: Verify Short Name accepts alphabets, numbers, space, hyphen, period and underscore
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter Name "Valsad"
    And I enter Short Name "GJ_VL-1.A 2"
    And I select Parent Location "Gujarat"
    And I select Location Category "District"
    And I select Region "Western Region"
    And I click Save
    Then the save should succeed and the Short Name should be stored as entered
    And the toaster "Location created successfully." should be displayed

  @TC-Loc-011 @functional @medium
  # Ref: FRD 6.2 Field table - Name (min 2), Short Name (min 2)
  Scenario: Verify Name and Short Name minimum length boundary (2 characters) is accepted
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter Name "Du"
    And I enter Short Name "DU"
    And I select Parent Location "Gujarat"
    And I select Location Category "District"
    And I select Region "Western Region"
    And I click Save
    Then the Location should be created
    And a 2-character Name and a 2-character Short Name should be valid

  @TC-Loc-012 @functional @medium
  # Ref: FRD 6.2 Field table - Name (max 100), Short Name (max 30)
  Scenario: Verify Name (100 characters) and Short Name (30 characters) maximum length boundaries are accepted
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter Name "Sabarmati Riverfront Development Area Ahmedabad West Zone Sabarmati Riverfront Development Area Ahme"
    And I enter Short Name "GUJARAT_RURAL_DISTRICT_ZONE_01"
    And I select Parent Location "Gujarat"
    And I select Location Category "District"
    And I select Region "Western Region"
    And I click Save
    And I open the saved Location
    Then the Location should be created
    And the full 100-character Name and the full 30-character Short Name should be stored without truncation

  @TC-Loc-013 @functional @high
  # Ref: FRD 6.2 BR-3; Name and Short Name field validation
  Scenario: Verify the same Name and Short Name are allowed under a different Parent (uniqueness is per Parent context)
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I create Location "Aurangabad" with Short Name "AUR" under Parent Location "Maharashtra" with Location Category "District" and Region "Western Region"
    And I create Location "Aurangabad" with Short Name "AUR" under Parent Location "Bihar" with Location Category "District" and Region "Eastern Region"
    Then both Locations should be created successfully, each with its own Location ID
    And no "Name already exists" or "Short Name already exists" message should be shown

  @TC-Loc-014 @functional @high
  # Ref: FRD 6.2 Field table - Parent Location
  Scenario: Verify Parent Location dropdown is populated based on the selected Parent Location Category
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I select Parent Location Category "State/Territory"
    And I open the Parent Location dropdown and note the values
    Then only Locations belonging to the selected Parent Location Category should be listed
      | Gujarat     |
      | Maharashtra |
      | Bihar       |
    When I change Parent Location Category to "District"
    And I open the Parent Location dropdown and note the values again
    Then the Parent Location list should refresh and list only Locations belonging to "District"
      | Ahmedabad |
      | Surat     |
      | Mumbai    |
      | Pune      |
      | Nashik    |
      | Patna     |

  @TC-Loc-015 @functional @medium
  # Ref: FRD 6.2 Field table - Location Category
  Scenario: Verify Location Category dropdown lists values from the active Location Category Master
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I open the Location Category dropdown
    And I compare the options to the active Location Category Master via DB/API
    Then only active master categories should be listed
      | Country         |
      | State/Territory |
      | District        |
      | City            |

  @TC-Loc-016 @functional @medium
  # Ref: FRD 6.2 Field table - Region; BR-8
  Scenario: Verify Region dropdown lists only valid values from the active Region Master
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I open the Region dropdown
    And I compare the options to the active Region Master via DB/API
    Then only valid, active Region Master values should be listed
      | Northern Region |
      | Western Region  |
      | Southern Region |
      | Eastern Region  |

  @TC-Loc-017 @functional @high
  # Ref: FRD 6.2 BR-2; BR-8
  Scenario: Verify Region selected at creation is captured and persisted with the Location
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I create Location "Rajkot" with Short Name "RJK" under Parent Location "Gujarat" with Region "Southern Region"
    And I open the saved Location
    And I check the Master record via DB/API
    Then Region "Southern Region" should be stored against the Location
    And Region "Southern Region" should be displayed in its details

  @TC-Loc-068 @negative @high
  # Ref: FRD 6.2 Fields (Error State); US-2 AC-2
  Scenario: Verify creation is blocked when Name is blank
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I leave Name blank
    And I enter Short Name "RJK"
    And I select Location Category "District"
    And I select Region "Western Region"
    And I select Parent Location "Gujarat"
    And I click Save
    Then the save should be blocked and the message "Name is required" should be displayed
    And no Location should be created and no Location ID should be generated

  @TC-Loc-069 @negative @high
  # Ref: FRD 6.2 Fields (Error State); US-2 AC-2
  Scenario: Verify creation is blocked when Short Name is blank
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I leave Short Name blank
    And I enter Name "Rajkot"
    And I select Location Category "District"
    And I select Region "Western Region"
    And I select Parent Location "Gujarat"
    And I click Save
    Then the save should be blocked and the message "Short Name is required" should be displayed
    And no Location should be created and no Location ID should be generated

  @TC-Loc-070 @negative @high
  # Ref: FRD 6.2 Fields (Error State); US-2 AC-2
  Scenario: Verify creation is blocked when Location Category is blank
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I leave Location Category unselected
    And I enter Name "Rajkot"
    And I enter Short Name "RJK"
    And I select Region "Western Region"
    And I select Parent Location "Gujarat"
    And I click Save
    Then the save should be blocked and the message "Location Category is required" should be displayed
    And no Location should be created and no Location ID should be generated

  @TC-Loc-071 @negative @high
  # Ref: FRD 6.2 Fields (Region); US-2 AC-2
  Scenario: Verify creation is blocked when Region is blank
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I leave Region unselected
    And I enter Name "Rajkot"
    And I enter Short Name "RJK"
    And I select Location Category "District"
    And I select Parent Location "Gujarat"
    And I click Save
    Then the save should be blocked with a Region validation message
    And no Location should be created
    # Note: FRD defines only 'Invalid Region' - confirm exact text

  @TC-Loc-072 @negative @high
  # Ref: FRD 6.2 Fields - Parent Location
  Scenario: Verify creation is blocked when Parent Location Category is selected but Parent Location is blank
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I select Parent Location Category "State/Territory"
    And I leave Parent Location blank
    And I enter Name "Rajkot"
    And I enter Short Name "RJK"
    And I fill the other fields with valid values
    And I click Save
    Then the save should be blocked with "Parent Location is required"
    And no Location should be created

  @TC-Loc-073 @negative @medium
  # Ref: FRD 6.2 Fields - Parent Location Category
  Scenario: Verify creation is blocked when a Parent Location is sent without Parent Location Category (API)
    Given an API client is authenticated as "Admin_User1"
    When I send a create request with parentId "Gujarat" but no parentCategoryId with payload
      """
      {name:'Rajkot', shortName:'RJK', parentId:Gujarat}
      """
    Then the request should be rejected with "Parent Location Category is required"
    And no Location should be created

  @TC-Loc-074 @negative @high
  # Ref: FRD 6.2 BR-4
  Scenario: Verify whitespace-only Name and Short Name are rejected
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter 5 spaces in Name "     "
    And I enter 5 spaces in Short Name "     "
    And I fill the other fields with valid values
    And I click Save
    Then the save should be blocked with "Name is required" and "Short Name is required"
    And no Location should be created

  @TC-Loc-075 @negative @medium
  # Ref: FRD 6.2 Fields - Name (min 2)
  Scenario: Verify Name below minimum length (1 character) is rejected
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter Name "A"
    And I enter Short Name "AB"
    And I fill the other fields with valid values
    And I click Save
    Then the save should be blocked
    And the Name should be rejected as it is below the minimum of 2 characters
    # Note: message text not defined

  @TC-Loc-076 @negative @medium
  # Ref: FRD 6.2 Fields - Name (max 100)
  Scenario: Verify Name above maximum length (101 characters) is rejected
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter the 101-character Name "Sabarmati Riverfront Development Area Ahmedabad West Zone Sabarmati Riverfront Development Area Ahmex"
    And I fill the other fields with valid values
    And I click Save
    Then the save should be blocked or the input should be limited to 100 characters
    And no Location with a 101-character Name should be stored

  @TC-Loc-077 @negative @medium
  # Ref: FRD 6.2 Fields - Short Name (min 2)
  Scenario: Verify Short Name below minimum length (1 character) is rejected
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter Short Name "R"
    And I fill the other fields with valid values
    And I click Save
    Then the save should be blocked
    And the Short Name should be rejected as it is below the minimum of 2 characters

  @TC-Loc-078 @negative @medium
  # Ref: FRD 6.2 Fields - Short Name (max 30)
  Scenario: Verify Short Name above maximum length (31 characters) is rejected
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter the 31-character Short Name "GUJARAT_RURAL_DISTRICT_ZONE_012"
    And I fill the other fields with valid values
    And I click Save
    Then the save should be blocked or the input should be limited to 30 characters
    And no 31-character Short Name should be stored

  @TC-Loc-079 @negative @medium
  # Ref: FRD 6.2 Fields - Name (approved characters)
  Scenario: Verify Name with unapproved characters is rejected - 'Rajkot@#'
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter Name "Rajkot@#"
    And I fill the other fields with valid values
    And I click Save
    Then the save should be blocked
    And "@" and "#" should be treated as not approved characters

  @TC-Loc-080 @negative @medium
  # Ref: FRD 6.2 Fields - Short Name (approved characters)
  Scenario: Verify Short Name with unapproved characters is rejected - 'RJ@1'
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter Short Name "RJ@1"
    And I fill the other fields with valid values
    And I click Save
    Then the save should be blocked
    And "@" should be treated as not allowed

  @TC-Loc-081 @negative @high
  # Ref: FRD 6.2 Fields - Name, Short Name; Org input-validation standard
  Scenario: Verify script/HTML and SQL injection strings in Name and Short Name are rejected or safely encoded (security)
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I enter Name "<script>alert(1)</script>"
    And I fill the other fields with valid values
    And I click Save
    And I enter Short Name "x'; DROP TABLE Location;--" with a valid Name and other fields
    And I click Save
    Then both inputs should be rejected by character validation
    And no script should execute
    And nothing should be stored
    And the Location Master should remain intact

  @TC-Loc-082 @negative @high
  # Ref: FRD FRD 6.2 BR-3
  Scenario: Verify creation is blocked for exact duplicate Name under the same Parent
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I select Parent Location Category "State/Territory"
    And I select Parent Location "Gujarat"
    And I enter Name "Surat"
    And I enter Short Name "SRT2"
    And I select a valid Location Category and a valid Region
    And I click Save
    Then the save should be blocked and "Name already exists" should be displayed
    And no new Location or Location ID should be created

  @TC-Loc-083 @negative @high
  # Ref: FRD US-2 AC-4; 6.2 BR-3/BR-4
  Scenario: Verify creation is blocked for duplicate Name differing only by case and trailing space ('gujarat ' vs 'Gujarat')
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I select Parent Location Category "Country"
    And I select Parent Location "INDIA"
    And I enter Name "gujarat "
    And I enter Short Name "GJ2"
    And I select a valid Location Category and a valid Region
    And I click Save
    Then the save should be blocked and "Name already exists" should be displayed
    And no new Location or Location ID should be created

  @TC-Loc-084 @negative @high
  # Ref: FRD 6.2 BR-3; Short Name field validation
  Scenario: Verify creation is blocked for exact duplicate Short Name under the same Parent
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I select Parent Location Category "State/Territory"
    And I select Parent Location "Gujarat"
    And I enter Name "Surat Rural"
    And I enter Short Name "SRT"
    And I select Location Category "District"
    And I select Region "Western Region"
    And I click Save
    Then the save should be blocked and "Short Name already exists" should be displayed
    And no new Location should be created

  @TC-Loc-085 @negative @high
  # Ref: FRD 6.2 BR-3; BR-1
  Scenario: Verify duplicate top-level Name is blocked (no-parent context) ('india' vs 'INDIA')
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I leave Parent Location Category and Parent Location empty
    And I enter Name "india"
    And I enter Short Name "IND2"
    And I select Location Category "Country"
    And I select Region "Northern Region"
    And I click Save
    Then the save should be blocked with "Name already exists"
    And top-level Locations should be checked for uniqueness together

  @TC-Loc-086 @negative @high
  # Ref: FRD 6.2 BR-3; BR-9
  Scenario: Verify concurrent creation of the same Name under the same Parent results in only one Location
    Given two API sessions as "Admin_User1"
    When I send two create requests for Name "Rajkot" and Short Name "RJK" under Parent Location "Gujarat" at the same time
    Then exactly one Location should be created
    And the other request should fail with "Name already exists"

  @TC-Loc-087 @negative @high
  # Ref: FRD 6.2 BR-8; Fields - Region
  Scenario: Verify invalid Region value is rejected (API)
    Given an API client is authenticated as "Admin_User1"
    When I send a create request with regionId "Mars Region" which is not in the master with payload
      """
      {regionId:'Mars Region', ...}
      """
    Then the request should be rejected with "Invalid Region"
    And no Location should be created

  @TC-Loc-088 @negative @high
  # Ref: FRD 6.2 BR-5
  Scenario: Verify non-existent Parent Location Category is rejected (API)
    Given an API client is authenticated as "Admin_User1"
    When I send a create request with a parentCategoryId not in the Location Category Master with payload
      """
      {parentCategoryId:'ZZZ'}
      """
    Then the request should be rejected
    And no Location should be created

  @TC-Loc-089 @negative @high
  # Ref: FRD 6.2 BR-6
  Scenario: Verify non-existent Parent Location ID is rejected (API)
    Given an API client is authenticated as "Admin_User1"
    When I send a create request with parentId "LOC-999999" which is non-existent with payload
      """
      {parentId:'LOC-999999'}
      """
    Then the request should be rejected with "Invalid Parent Location"
    And no Location should be created

  @TC-Loc-090 @negative @high
  # Ref: FRD 6.2 BR-6; US-2 AC-5
  Scenario: Verify Parent Location not belonging to the selected Parent Location Category is rejected
    Given I am logged in as "Admin_User1"
    And the Add Location form is open
    And the baseline location data is loaded
    When I select Parent Location Category "District"
    And via API I send parentId "Gujarat" which is a State/Territory with that category
    And I click Save
    Then the save should be blocked with "Invalid Parent Location"
    And no Location should be created

  @TC-Loc-091 @negative @high
  # Ref: FRD 6.2 BR-9/BR-10
  Scenario: Verify Location ID supplied by the client in a create request is ignored/rejected
    Given an API client is authenticated as "Admin_User1"
    When I send a create request including locationId "LOC-ABC" with payload
      """
      {locationId:'LOC-ABC', name:'Rajkot', ...}
      """
    Then the client-supplied ID should not be used and the system should generate the Location ID, or the request should be rejected
