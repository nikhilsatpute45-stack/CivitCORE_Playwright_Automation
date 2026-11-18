@StandardsFormats @QuantityFormatView
Feature: Quantity Format View
  Automated scenarios for the "Quantity Format View" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-3; FRD 6.3 FB-3; FRD 6.2.1 F-ID
  @TC_SF_086 @Functional @High @Automation
  Scenario: Verify View shows the ID and all Quantity-specific attributes with values
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Standard Quantity (QF-0001) |
    When the user clicks View against 'Standard Quantity' (QF-0001)
    And the user compares the fields displayed with the baseline values
    Then Detail view displays: Quantity Formats ID, Culture, Name, Digit Group Symbol, Number Format, Negative Sign Symbol, Decimal Symbol, No. of Digits after Decimal, Positive Format, Negative Format, Leading Zero, Sample
    And Each field shows its stored value
