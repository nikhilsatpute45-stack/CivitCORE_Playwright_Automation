@StandardsFormats @StandardsFormatsId
Feature: Standards & Formats ID
  Automated scenarios for the "Standards & Formats ID" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-5; FRD 6.2 BR-1; FRD 6.2.1 F-ID
  @TC_SF_012 @Functional @High @Automation
  Scenario: Verify Standards & Formats IDs generated for two new Quantity configurations are unique
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Names                       | Metric Quantity 01, Metric Quantity 02 |
      | other fields                | Digit Group Symbol: ,                  |
      | Number Format               | 1,234,567.89                           |
      | Negative Sign Symbol        | -                                      |
      | No. of Digits after Decimal | 2                                      |
      | Positive Format             | 1.1                                    |
      | Negative Format             | -1.1                                   |
      | Leading Zero                | 0.7                                    |
    When the user creates Quantity format 'Metric Quantity 01'
    And the user notes the generated ID
    And the user creates Quantity format 'Metric Quantity 02'
    And the user notes the generated ID and compare
    Then Two different IDs are generated; each is system-generated
    And Neither ID was entered by the user

  # Ref: FRD 6.2 BR-1; FRD 6.2.1 F-ID; FRD 6.2.2 F-ID; FRD 6.2.3 F-ID
  @TC_SF_013 @Functional @High @Automation
  Scenario: Verify the Standards & Formats ID is unique across configuration types
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Names   | Metric Quantity 03 |
      | Data    | Rupee Currency 03  |
      | Data    | India Date Time 03 |
      | Culture | English (India)    |
    When the user creates Quantity format 'Metric Quantity 03'
    And the user creates Currency format 'Rupee Currency 03'
    And the user creates Date & Time format 'India Date Time 03'
    And the user compares the three generated IDs
    Then All three IDs are different (unique across CivitCORE)

  # Ref: FRD 6.2 BR-1
  @TC_SF_014 @Functional @Medium @Automation
  Scenario: Verify the generated ID is stable and does not change after viewing or re-opening the record
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Standard Quantity (QF-0001) |
    When the user notes the ID of 'Standard Quantity'
    And the user opens the record in View mode
    And the user logs out, log in again and re-open the record
    And the user compares the ID
    Then The ID remains QF-0001 each time (stable reference)

  # Ref: FRD 6.2 BR-1; FRD 6.2 BR-2; FRD 6.2.1 F-ID
  @TC_SF_015 @Functional @High @Automation
  Scenario: Verify a client-supplied ID in the create payload is ignored or rejected and a system ID is generated
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User       | Admin_User1                                       |
      | Payload id | QF-9999                                           |
      | Name       | Metric Quantity 04                                |
      | Data       | other mandatory fields as per valid Quantity data |
    When the user sends a create-Quantity request that includes an 'id' value
    And the user reads the created record
    Then The record is created with a system-generated ID (or the request is rejected); the supplied value 'QF-9999' is not used
