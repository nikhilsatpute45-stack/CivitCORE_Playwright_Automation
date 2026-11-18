@StandardsFormats @DateTimeFormatView
Feature: Date & Time Format View
  Automated scenarios for the "Date & Time Format View" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-3; FRD 6.3 FB-3; FRD 6.2.3 F-ID
  @TC_SF_088 @Functional @High @Automation
  Scenario: Verify View shows the ID and all Date & Time-specific attributes with values
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Date Time tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Standard Date Time (DF-0001) |
    When the user clicks View against 'Standard Date Time' (DF-0001)
    And the user compares the fields displayed with the baseline values
    Then Detail view displays: Date & Time Formats ID, Culture, Name, Long Date Format, Date Separator, Short Date Format, Time Separator, AM Symbol, PM Symbol, Time Format, Sample
    And Each field shows its stored value
