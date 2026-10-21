@region_management @region_creation
Feature: Region Creation
  As a Region Admin
  I want to create Regions with a valid, unique Region Name
  So that Regions can be used by Office, Location and consuming products

  # ---------------------------------------------------------------
  # Functional
  # ---------------------------------------------------------------

  @TC-REG-009 @Functional @High
  Scenario: Verify clicking 'Add' opens the Region creation form
    Given I am logged in as "Region Admin"
    And I am on the Region List screen
    When I click "Add"
    Then the Region creation form should be displayed with the Region Name input

  @TC-REG-010 @Functional @High
  Scenario: Verify a Region is created and persisted with a valid unique Region Name
    Given I am logged in as "Region Admin"
    And no Region named "Central Region" exists
    When I click "Add"
    And I enter Region Name "Central Region"
    And I click "Save"
    Then the Region should be created in the Region Master
    And the Region Master should contain exactly one record named "Central Region"

  @TC-REG-011 @Functional @High
  Scenario: Verify a unique, system-generated Region ID is assigned on successful creation
    Given I am logged in as "Region Admin"
    And no Region named "Central Region" exists
    When I create Region "Central Region" and save
    And I open Region "Central Region" from the Region List
    Then a non-empty Region ID should be generated automatically
    And the Region ID should be unique across the Region Master
    And the Region ID should be read-only

  @TC-REG-012 @Functional @High
  Scenario: Verify a newly created Region is immediately visible in the Region List
    Given I am logged in as "Region Admin"
    And no Region named "Central Region" exists
    When I create Region "Central Region" and save
    Then "Central Region" should be listed in the Region List immediately after the success confirmation

  @TC-REG-013 @Integration @High
  Scenario: Verify a newly created Region is immediately selectable in the Office Region lookup
    Given I am logged in as "Region Admin"
    And no Region named "Central Region" exists
    When I create Region "Central Region" and save
    And I open Office Management and click "Add"
    And I open the Region lookup
    Then "Central Region" should appear in the Office Region lookup

  @TC-REG-014 @Integration @High
  Scenario: Verify a newly created Region is immediately selectable in the Location Region lookup
    Given I am logged in as "Region Admin"
    And no Region named "Central Region" exists
    When I create Region "Central Region" and save
    And I open Location Management and click "Add"
    And I open the Region lookup
    Then "Central Region" should appear in the Location Region lookup

  @TC-REG-015 @Functional @High
  Scenario: Verify Region Name accepts alphanumeric characters and spaces
    Given I am logged in as "Region Admin"
    And no Region named "Zone 5 North" exists
    When I click "Add"
    And I enter Region Name "Zone 5 North"
    And I click "Save"
    Then the Region should be saved successfully

  @TC-REG-016 @Functional @Medium
  Scenario: Verify Region Name accepts both uppercase and lowercase characters
    Given I am logged in as "Region Admin"
    And no Region named "Island Region" exists
    When I click "Add"
    And I enter Region Name "ISLAND region"
    And I click "Save"
    Then the Region should be saved
    And the Region Name should be stored and displayed as "ISLAND region"

  @TC-REG-017 @Functional @High
  Scenario: Verify leading and trailing spaces are trimmed before the Region Name is persisted
    Given I am logged in as "Region Admin"
    And no Region named "Coastal Region" exists
    When I click "Add"
    And I enter Region Name "  Coastal Region  "
    And I click "Save"
    Then the saved Region Name should be "Coastal Region"

  @TC-REG-018 @Functional @Medium
  Scenario: Verify a Region Name can be re-used after the original Region has been deleted
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists with no Office or Location association
    When I delete Region "Delhi" and confirm
    And I click "Add"
    And I enter Region Name "Delhi"
    And I click "Save"
    Then a new Region "Delhi" should be created with a new Region ID

  # ---------------------------------------------------------------
  # Negative / Boundary
  # ---------------------------------------------------------------

  @TC-REG-104 @Negative @High
  Scenario: Verify creation is blocked when Region Name is left blank
    Given I am logged in as "Region Admin"
    And the Add Region form is open
    When I leave Region Name empty
    And I click "Save"
    Then the save should be prevented
    And the message "Region Name is required" should be displayed
    And no Region record should be created

  @TC-REG-105 @Negative @High
  Scenario: Verify creation is blocked when Region Name contains only spaces
    Given I am logged in as "Region Admin"
    And the Add Region form is open
    When I enter Region Name "     "
    And I click "Save"
    Then the save should be prevented
    And the message "Region Name is required" should be displayed
    And no Region record should be created

  @TC-REG-106 @Negative @High
  Scenario: Verify an exact duplicate Region Name is blocked
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists
    When I click "Add"
    And I enter Region Name "Delhi"
    And I click "Save"
    Then the message "A Region with this name already exists." should be displayed
    And the Region count should be unchanged

  @TC-REG-107 @Negative @High
  Scenario: Verify a duplicate differing only by case and a trailing space is blocked
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists
    When I click "Add"
    And I enter Region Name "delhi "
    And I click "Save"
    Then the message "A Region with this name already exists." should be displayed

  @TC-REG-108 @Negative @High
  Scenario: Verify Region Name containing a special character '@' is rejected
    Given I am logged in as "Region Admin"
    And the Add Region form is open
    When I enter Region Name "North@Region"
    And I click "Save"
    Then the save should be blocked
    And no Region record should be created

  @TC-REG-109 @Negative @High
  Scenario: Verify a SQL-injection style Region Name is rejected and the Region Master is unaffected
    Given I am logged in as "Region Admin"
    And the Add Region form is open
    When I enter Region Name "North'; DROP TABLE Region;--"
    And I click "Save"
    And I reload the Region List
    Then the value should be rejected by the special-character rule
    And no database error should be displayed
    And the Region Master and Region List should be intact

  @TC-REG-110 @Negative @High
  Scenario: Verify a script-injection Region Name is rejected and no script executes
    Given I am logged in as "Region Admin"
    And the Add Region form is open
    When I enter Region Name "<script>alert(1)</script>"
    And I click "Save"
    And I open the Region List
    Then the value should be rejected by the special-character rule
    And no alert should be executed
    And no record should be stored or displayed for that name

  @TC-REG-111 @Boundary @High
  Scenario: Verify a Region Name of 101 characters is not accepted
    Given I am logged in as "Region Admin"
    And the Add Region form is open
    When I enter a Region Name of 101 "A" characters
    And I click "Save"
    Then the name should be prevented by being blocked or the input capped at 100 characters
    And no 101-character Region Name should be persisted

  @TC-REG-112 @Boundary @High
  Scenario: Verify a Region Name of exactly 100 characters is accepted
    Given I am logged in as "Region Admin"
    And the Add Region form is open
    When I enter a Region Name of 100 "B" characters
    And I click "Save"
    Then the Region should be saved with all 100 characters

  @TC-REG-113 @Boundary @Low
  Scenario: Verify a single-character Region Name is accepted
    Given I am logged in as "Region Admin"
    And no Region named "Q" exists
    And the Add Region form is open
    When I enter Region Name "Q"
    And I click "Save"
    Then the Region should be saved

  @TC-REG-114 @Negative @High @API
  Scenario: Verify a client-supplied Region ID is not honoured at creation
    Given I have API access as "Region Admin"
    And no Region named "Gulf Region" exists
    When I send a create-Region request with Region Name "Gulf Region" and Region ID "REG-9999"
    And I read the created record
    Then the request should be rejected or the custom Region ID should be ignored
    And the Region ID should be system-generated and not equal "REG-9999"

  @TC-REG-115 @Negative @High @API
  Scenario: Verify a view-only user cannot create a Region through the API
    Given I have API access as "Region Viewer"
    When I send a create-Region request for "Gulf Region"
    Then the request should be denied with an authorization failure
    And no Region should be created

  @TC-REG-116 @Negative @High
  Scenario: Verify a user without any Region Management access cannot open the Region List
    Given I am logged in as "No-Access User"
    When I try to open "System Configuration" > "Region"
    And I try to open the Region List URL directly
    Then access should be denied
    And no Region data should be displayed

  @TC-REG-117 @Negative @Medium
  Scenario: Verify simultaneous creation of the same Region Name results in only one Region
    Given two "Region Admin" sessions are open on the Add Region form
    And no Region named "Gulf Region" exists
    When I enter Region Name "Gulf Region" in both sessions
    And I click "Save" in both sessions at the same time
    Then exactly one Region "Gulf Region" should exist
    And the other request should be rejected with "A Region with this name already exists."
