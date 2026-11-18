@StandardsFormats @ConsumptionByProducts
Feature: Consumption by Products
  Automated scenarios for the "Consumption by Products" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.5 BR-1; FRD 6.5 FB-1
  @TC_SF_122 @Functional @High @Automation
  Scenario: Verify the Standards & Formats ID is the integration key when a configuration is renamed
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And A product transaction references QF-0001
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record   | QF-0001                   |
      | New Name | Standard Quantity Renamed |
    When the user renames 'Standard Quantity' to 'Standard Quantity Renamed'
    And the user opens the product transaction that references QF-0001
    Then The product still resolves the configuration through ID QF-0001 and shows the new Name; nothing breaks

  # Ref: FRD 6.5 BR-3; FRD 6.6 FB-3
  @TC_SF_123 @Functional @Medium @Automation
  Scenario: Verify CivitCORE exposes the dependency check for a configuration to consuming products
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | IDs | QF-0001 (in use by ORG-001, ORG-002), QF-0003 (unused) |
    When the user calls the dependency-check capability for QF-0001
    And the user calls it for QF-0003
    Then QF-0001 is reported as in use by Organization(s); QF-0003 as having no Organization dependency. Note: Interface and response format of the dependency-check capability are not defined (OQ-12)
