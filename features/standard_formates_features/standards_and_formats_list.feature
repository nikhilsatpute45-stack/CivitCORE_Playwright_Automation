@StandardsFormats @StandardsFormatsList
Feature: Standards & Formats List
  Automated scenarios for the "Standards & Formats List" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.3 C-CreatedBy; FRD 6.3 C-CreatedDate
  @TC_SF_080 @Functional @Medium @Automation
  Scenario: Verify Created By and Created Date are captured for a newly created configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)    |
      | Name                        | Metric Quantity 05 |
      | Digit Group Symbol          | ,                  |
      | Number Format               | 1,234,567.89       |
      | Negative Sign Symbol        | -                  |
      | No. of Digits after Decimal | 2                  |
      | Positive Format             | 1.1                |
      | Negative Format             | -1.1               |
      | Leading Zero                | 0.7                |
    When the user creates Quantity format 'Metric Quantity 05'
    And the user observes the new row in the Quantity list
    Then Created By shows 'Admin_User1' and Created Date shows the current date/time of creation
