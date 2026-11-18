@StandardsFormats @StandardsFormatsSearch
Feature: Standards & Formats Search
  Automated scenarios for the "Standards & Formats Search" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-2; FRD 6.3 FB-2
  @TC_SF_089 @Functional @Medium @Automation
  Scenario: Verify keyword search returns the configuration matching the full Name
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Tab         | Quantity          |
      | Search text | Standard Quantity |
    When the user enters 'Standard Quantity' in the keyword search
    And the user applies the search
    And the user observes the list
    Then Only 'Standard Quantity' (QF-0001) is listed

  # Ref: FRD 6.3 BR-2; US-2 AC-2
  @TC_SF_090 @Functional @Medium @Automation
  Scenario: Verify keyword search supports partial matching on Name
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Tab         | Quantity |
      | Search text | Stand    |
    When the user enters 'Stand' in the keyword search
    And the user applies the search
    And the user observes the list
    Then 'Standard Quantity' is listed (partial match on Name)

  # Ref: FRD 6.3 BR-2
  @TC_SF_091 @Functional @Medium @Automation
  Scenario: Verify keyword search is not case-sensitive
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Tab         | Quantity       |
      | Search text | sPaRe qUaNtItY |
    When the user enters 'sPaRe qUaNtItY' in the keyword search
    And the user applies the search
    And the user observes the list
    Then 'Spare Quantity' (QF-0003) is listed (search is not case-sensitive)

  # Ref: US-2 AC-2; FRD 6.3 FB-1
  @TC_SF_092 @Functional @Medium @Automation
  Scenario: Verify search in the Currency tab returns only Currency configurations
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Currency tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Tab         | Currency |
      | Search text | Standard |
    When the user enters 'Standard' in the keyword search
    And the user applies the search
    And the user observes the list
    Then Only 'Standard Currency' (CF-0001) is listed; 'Standard Quantity' and 'Standard Date Time' are not shown

  # Ref: FRD 6.3 BR-2; US-2 AC-2
  @TC_SF_093 @Functional @Medium @Automation
  Scenario: Verify partial case-insensitive search in the Date Time tab
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Date Time tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Tab         | Date Time |
      | Search text | date      |
    When the user enters 'date' in the keyword search
    And the user applies the search
    And the user observes the list
    Then 'Standard Date Time', 'US Date Time', 'Spare Date Time' and 'Euro Date Time' are listed (partial, case-insensitive)

  # Ref: FRD 6.3 FB-2
  @TC_SF_095 @Functional @Medium @Automation
  Scenario: Verify clearing the search restores the full list
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Tab  | Quantity     |
      | Data | Search text: |
    When the user searches for 'Spare'
    And the user clears the search box
    And the user observes the list
    Then The full Quantity list (QF-0001, QF-0002, QF-0003) is shown again after clearing the search

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.3 BR-2
  @TC_SF_301 @Negative @Medium @Automation
  Scenario: Verify search text with special characters does not break the list
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search text | '; DROP-- |
    When the user searches for "'; DROP--"
    Then No error or data exposure occurs; the list shows no matches and remains usable
