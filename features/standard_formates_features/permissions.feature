@StandardsFormats @Permissions
Feature: Permissions
  Automated scenarios for the "Permissions" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1 FB-1; FRD 6.1 BR-1
  @TC_SF_282 @Negative @High @Automation
  Scenario: Verify a user without Standards & Formats permission cannot access the module
    Given NoAccess_User1 (no Standards & Formats permission) is logged in
    And the following test data is used
      | User | NoAccess_User1 |
    When the user checks System Configuration for Standards & Formats
    And the user opens the Standards & Formats URL directly
    Then The menu entry is not displayed and direct access is denied; no configuration data is exposed

  # Ref: FRD 6.3 BR-1; FRD 6.1 BR-1
  @TC_SF_283 @Negative @High @Automation
  Scenario: Verify a user without permission cannot list configurations via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | NoAccess_User1 |
    When the user sends a list-Quantity request
    Then Request is rejected (403); no data returned

  # Ref: FRD 6.1 BR-1
  @TC_SF_284 @Negative @High @Automation
  Scenario: Verify a view-only user cannot create a Quantity configuration via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User                        | Viewer_User1             |
      | Payload                     | Culture: English (India) |
      | Name                        | Viewer Attempt 01        |
      | Digit Group Symbol          | ,                        |
      | Number Format               | 1,234,567.89             |
      | Negative Sign Symbol        | -                        |
      | No. of Digits after Decimal | 2                        |
      | Positive Format             | 1.1                      |
      | Negative Format             | -1.1                     |
      | Leading Zero                | 0.7                      |
    When the user sends a create-Quantity request
    And the user checks the Master
    Then Request is rejected (403); no record is created

  # Ref: FRD 6.1 BR-1
  @TC_SF_285 @Negative @High @Automation
  Scenario: Verify a view-only user cannot create a Currency configuration via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User                        | Viewer_User1             |
      | Payload                     | Culture: English (India) |
      | Name                        | Viewer Attempt 01        |
      | Digit Group Symbol          | ,                        |
      | Number Format               | 1,234,567.89             |
      | Negative Sign Symbol        | -                        |
      | No. of Digits after Decimal | 2                        |
      | Positive Format             | ₹1.1                     |
      | Negative Format             | -₹1.1                    |
      | Major Symbol                | Rupee                    |
      | Minor Symbol                | Paise                    |
      | Conversion Factor           | 100                      |
    When the user sends a create-Currency request
    And the user checks the Master
    Then Request is rejected (403); no record is created

  # Ref: FRD 6.1 BR-1
  @TC_SF_286 @Negative @High @Automation
  Scenario: Verify a view-only user cannot create a Date & Time configuration via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User              | Viewer_User1             |
      | Payload           | Culture: English (India) |
      | Name              | Viewer Attempt 01        |
      | Long Date Format  | dd MMMM yyyy             |
      | Date Separator    | /                        |
      | Short Date Format | dd/MM/yyyy               |
      | Time Separator    | :                        |
      | AM Symbol         | AM                       |
      | PM Symbol         | PM                       |
      | Time Format       | hh:mm:ss tt              |
    When the user sends a create-Date & Time request
    And the user checks the Master
    Then Request is rejected (403); no record is created

  # Ref: FRD 6.1 BR-1
  @TC_SF_287 @Negative @High @Automation
  Scenario: Verify a view-only user cannot update a configuration via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User          | Viewer_User1 |
      | Record        | QF-0003      |
      | Number Format | 1.234.567,89 |
    When the user sends an update request for QF-0003
    Then Request is rejected (403); the record is unchanged

  # Ref: FRD 6.1 BR-1
  @TC_SF_288 @Negative @High @Automation
  Scenario: Verify a view-only user cannot delete a configuration via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1 |
      | Record | QF-0003      |
    When the user sends a delete request for QF-0003
    Then Request is rejected (403); 'Spare Quantity' still exists
