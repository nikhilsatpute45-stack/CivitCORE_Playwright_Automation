@StandardsFormats @OrganizationUsage
Feature: Organization Usage
  Automated scenarios for the "Organization Usage" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.2 FB-7; FRD 6.6 FB-1; FRD Fig 1
  @TC_SF_081 @Functional @High @Automation
  Scenario: Verify a new Quantity configuration is immediately available for Organization selection
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New record | Metric Quantity 01 |
      | Org        | new Organization   |
    When the user creates Quantity format 'Metric Quantity 01'
    And the user opens Organization Management and click Add Organization
    And the user opens the Quantity Format dropdown
    Then 'Metric Quantity 01' is listed in the Organization's Quantity selection without any extra setup

  # Ref: FRD 6.2 FB-7; FRD 6.6 FB-1; FRD Fig 1
  @TC_SF_082 @Functional @High @Automation
  Scenario: Verify a new Currency configuration is immediately available for Organization selection
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New record | Indian Rupee Retail |
      | Org        | new Organization    |
    When the user creates Currency format 'Indian Rupee Retail'
    And the user opens Organization Management and click Add Organization
    And the user opens the Currency Format dropdown
    Then 'Indian Rupee Retail' is listed in the Organization's Currency selection without any extra setup

  # Ref: FRD 6.2 FB-7; FRD 6.6 FB-1; FRD Fig 1
  @TC_SF_083 @Functional @High @Automation
  Scenario: Verify a new Date & Time configuration is immediately available for Organization selection
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New record | India Date Time 01 |
      | Org        | new Organization   |
    When the user creates Date & Time format 'India Date Time 01'
    And the user opens Organization Management and click Add Organization
    And the user opens the Date & Time Format dropdown
    Then 'India Date Time 01' is listed in the Organization's Date & Time selection without any extra setup

  # Ref: FRD 6.6 FB-1; FRD 6.6 FB-2; FRD 6.6 BR-1
  @TC_SF_126 @Functional @High @Automation
  Scenario: Verify an Organization is saved with exactly one Quantity, one Currency and one Date & Time configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Org       | Gamma Projects               |
      | Quantity  | Standard Quantity (QF-0001)  |
      | Currency  | Standard Currency (CF-0001)  |
      | Date Time | Standard Date Time (DF-0001) |
    When the user opens Organization Management and click Add Organization
    And the user enters Organization Name 'Gamma Projects'
    And the user selects Quantity 'Standard Quantity', Currency 'Standard Currency' and Date Time 'Standard Date Time'
    And the user clicks Save
    Then Organization is saved and the associations are stored against IDs QF-0001, CF-0001 and DF-0001

  # Ref: FRD 6.6 FB-1; FRD 6.6 FB-2
  @TC_SF_127 @Functional @High @Automation
  Scenario: Verify an Organization can edit its formatting defaults by selecting other configurations
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And ORG-002 exists
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Org      | ORG-002            |
      | Quantity | QF-0001 -> QF-0002 |
    When the user opens ORG-002 for edit
    And the user changes Quantity to 'Euro Quantity'
    And the user clicks Save
    And the user re-opens ORG-002
    Then ORG-002 shows Quantity 'Euro Quantity' (QF-0002); Currency and Date Time selections are unchanged

  # Ref: FRD 6.6 BR-2; FRD 6.6 FB-2
  @TC_SF_128 @Functional @High @Automation
  Scenario: Verify the Organization association is stored by ID and survives a Name change
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And ORG-001 uses DF-0001 'Standard Date Time'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record   | DF-0001                    |
      | New Name | Standard Date Time Renamed |
    When the user renames 'Standard Date Time' to 'Standard Date Time Renamed'
    And the user opens ORG-001
    Then ORG-001 still references DF-0001 and displays the new Name

  # Ref: FRD 6.6 FB-4
  @TC_SF_129 @Functional @High @Automation
  Scenario: Verify an Office inherits the Organization's Quantity, Currency and Date & Time configurations
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And ORG-001 selects QF-0001, CF-0001, DF-0001
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Org    | ORG-001           |
      | Office | Alpha Head Office |
    When the user creates Office 'Alpha Head Office' under ORG-001
    And the user opens the Office formatting details
    Then The Office uses QF-0001, CF-0001 and DF-0001 inherited from ORG-001 with no Office-level selection

  # Ref: FRD 6.6 FB-3; FRD 6.6 BR-3
  @TC_SF_130 @Functional @High @Automation
  Scenario: Verify Organization-to-configuration associations are queryable for the dependency check
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | QF-0001 |
    When the user queries the Organizations that select QF-0001
    Then ORG-001 and ORG-002 are returned for QF-0001 (independent, queryable association)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.6 BR-1
  @TC_SF_293 @Negative @High @Automation
  Scenario: Verify an Organization cannot be saved without a Quantity configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Org       | Delta Works |
      | Quantity  | blank       |
      | Currency  | CF-0001     |
      | Date Time | DF-0001     |
    When the user opens Add Organization
    And the user enters Name 'Delta Works'
    And the user selects Currency and Date Time but leave Quantity blank
    And the user clicks Save
    Then The Organization is not saved. Note: Message text not defined (OQ-18)

  # Ref: FRD 6.6 BR-1
  @TC_SF_294 @Negative @High @Automation
  Scenario: Verify an Organization cannot be saved without a Currency configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Org       | Delta Works |
      | Quantity  | QF-0001     |
      | Currency  | blank       |
      | Date Time | DF-0001     |
    When the user opens Add Organization
    And the user enters Name 'Delta Works'
    And the user selects Quantity and Date Time but leave Currency blank
    And the user clicks Save
    Then The Organization is not saved. Note: See OQ-18

  # Ref: FRD 6.6 BR-1
  @TC_SF_295 @Negative @High @Automation
  Scenario: Verify an Organization cannot be saved without a Date & Time configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Org       | Delta Works |
      | Quantity  | QF-0001     |
      | Currency  | CF-0001     |
      | Date Time | blank       |
    When the user opens Add Organization
    And the user enters Name 'Delta Works'
    And the user selects Quantity and Currency but leave Date Time blank
    And the user clicks Save
    Then The Organization is not saved. Note: See OQ-18
