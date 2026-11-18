@StandardsFormats @CurrencyFormatCreation
Feature: Currency Format Creation
  Automated scenarios for the "Currency Format Creation" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-1; FRD 6.2 FB-1; FRD 6.2 FB-2; FRD 6.2 FB-4; FRD 6.2 FB-5; FRD 6.2 FB-6; FRD Sec 8 Toaster #2; FRD Fig 1
  @TC_SF_010 @Functional @High @Automation
  Scenario: Verify a Currency configuration is created with all mandatory fields and toaster is shown
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Currency tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 100                 |
    When the user clicks 'Add'
    And the user selects the Culture
    And the user enters the Name
    And the user selects/enter all remaining mandatory fields
    And the user clicks Save
    Then System generates a unique Currency Formats ID and creates the record in the Standards & Formats Master
    And Toaster 'Currency format created successfully.' is displayed
    And The new record 'Indian Rupee Retail' is visible in the Currency list

  # Ref: FRD 6.2.2 F-Culture; FRD 6.2.2 F-Symbol; FRD 6.2 FB-3
  @TC_SF_017 @Functional @High @Automation
  Scenario: Verify selecting a Culture loads culture-specific defaults including the currency Symbol
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture | English (India) |
    When the user selects Culture 'English (India)'
    And the user observes the Symbol and other defaults
    Then Culture-specific defaults load and Symbol shows the configured currency symbol of English (India) (₹)

  # Ref: FRD 6.2.2 F-Symbol
  @TC_SF_019 @Functional @High @Automation
  Scenario: Verify Symbol is auto-refreshed when Culture is changed
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture | English (India) -> English (United States) |
    When the user selects Culture 'English (India)' and note the Symbol
    And the user changes Culture to 'English (United States)'
    And the user observes the Symbol
    Then Symbol changes from ₹ to $ automatically without user input

  # Ref: FRD 6.2.2 F-DecSym; FRD 6.2.2 F-NumFmt
  @TC_SF_023 @Functional @High @Automation
  Scenario: Verify Decimal Symbol shows '.' when the selected Currency Number Format uses '.'
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format | 1,234,567.89 |
    When the user selects Number Format '1,234,567.89'
    And the user observes Decimal Symbol
    Then Decimal Symbol displays '.' and is not editable

  # Ref: FRD 6.2.2 F-DecSym; FRD 6.2.2 F-NumFmt
  @TC_SF_024 @Functional @High @Automation
  Scenario: Verify Decimal Symbol shows ',' when the selected Currency Number Format uses ','
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format | 1.234.567,89 |
    When the user selects Number Format '1.234.567,89'
    And the user observes Decimal Symbol
    Then Decimal Symbol displays ','

  # Ref: FRD 6.2.2 F-DecSym
  @TC_SF_025 @Functional @Medium @Automation
  Scenario: Verify Decimal Symbol refreshes whenever the Currency Number Format is changed
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format | 1,234,567.89 -> 1.234.567,89 |
    When the user selects Number Format '1,234,567.89' and note Decimal Symbol
    And the user changes Number Format to '1.234.567,89'
    And the user observes Decimal Symbol again
    Then Decimal Symbol changes from '.' to ',' immediately after the change

  # Ref: FRD 6.2.2 F-Sample
  @TC_SF_031 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Culture is changed on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture | English (India) -> English (United States) |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Culture as per Test Data
    And the user observes the Sample area without clicking Save
    Then Sample shows the symbol of the new culture (e.g., $1,234,567.89)
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.2 F-Sample
  @TC_SF_032 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Number Format is changed on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format | 1,234,567.89 -> 1.234.567,89 |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Number Format as per Test Data
    And the user observes the Sample area without clicking Save
    Then Sample uses ',' as decimal separator (e.g., ₹1.234.567,89)
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.2 F-Sample
  @TC_SF_033 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when No. of Digits after Decimal is changed on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | No. of Digits after Decimal | 2 -> 3 |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes No. of Digits after Decimal as per Test Data
    And the user observes the Sample area without clicking Save
    Then Sample shows three digits after Decimal Symbol (e.g., ₹1,234,567.890)
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.2 F-Sample
  @TC_SF_034 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Positive Format is changed on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Positive Format | ₹1.1 -> 1.1₹ |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Positive Format as per Test Data
    And the user observes the Sample area without clicking Save
    Then Positive sample moves the symbol per the new Positive Format
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.2 F-Sample
  @TC_SF_035 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Negative Format is changed on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Negative Format | -₹1.1 -> (₹1.1) |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Negative Format as per Test Data
    And the user observes the Sample area without clicking Save
    Then Negative sample is re-rendered per the new Negative Format
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.2 F-Sample
  @TC_SF_036 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Major Symbol is changed on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Major Symbol | Rupee -> Rupees |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Major Symbol as per Test Data
    And the user observes the Sample area without clicking Save
    Then Sample is regenerated using Major Symbol 'Rupees'
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.2 F-Sample
  @TC_SF_037 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Minor Symbol is changed on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Minor Symbol | Paise -> Paisa |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Minor Symbol as per Test Data
    And the user observes the Sample area without clicking Save
    Then Sample is regenerated using Minor Symbol 'Paisa'
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.2 F-Sample
  @TC_SF_038 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Conversion Factor is changed on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Conversion Factor | 100 -> 1000 |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Conversion Factor as per Test Data
    And the user observes the Sample area without clicking Save
    Then Sample is regenerated using Conversion Factor 1000
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.2 F-Name; FRD Sec 8 Toaster #2
  @TC_SF_054 @Functional @High @Automation
  Scenario: Verify Currency Name accepts alphabetic characters, numbers and spaces
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)      |
      | Name                        | Format Set 2026 Plan |
      | Digit Group Symbol          | ,                    |
      | Number Format               | 1,234,567.89         |
      | Negative Sign Symbol        | -                    |
      | No. of Digits after Decimal | 2                    |
      | Positive Format             | ₹1.1                 |
      | Negative Format             | -₹1.1                |
      | Major Symbol                | Rupee                |
      | Minor Symbol                | Paise                |
      | Conversion Factor           | 100                  |
    When the user fills all mandatory fields
    And the user enters Name 'Format Set 2026 Plan'
    And the user clicks Save
    Then Record is saved with Name 'Format Set 2026 Plan'
    And Toaster 'Currency format created successfully.' is displayed

  # Ref: FRD 6.2.2 F-Name
  @TC_SF_055 @Functional @Medium @Automation
  Scenario: Verify Currency Name accepts uppercase and lowercase characters
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)      |
      | Name                        | UPPER lower Mixed 07 |
      | Digit Group Symbol          | ,                    |
      | Number Format               | 1,234,567.89         |
      | Negative Sign Symbol        | -                    |
      | No. of Digits after Decimal | 2                    |
      | Positive Format             | ₹1.1                 |
      | Negative Format             | -₹1.1                |
      | Major Symbol                | Rupee                |
      | Minor Symbol                | Paise                |
      | Conversion Factor           | 100                  |
    When the user fills all mandatory fields
    And the user enters Name 'UPPER lower Mixed 07'
    And the user clicks Save
    Then Record is saved and the Name is stored with the entered case

  # Ref: FRD 6.2 BR-5; FRD 6.2.2 F-Name
  @TC_SF_056 @Functional @High @Automation
  Scenario: Verify leading and trailing spaces in Currency Name are trimmed before persistence
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India) |
      | Name                        | Trimmed Name 01 |
      | Digit Group Symbol          | ,               |
      | Number Format               | 1,234,567.89    |
      | Negative Sign Symbol        | -               |
      | No. of Digits after Decimal | 2               |
      | Positive Format             | ₹1.1            |
      | Negative Format             | -₹1.1           |
      | Major Symbol                | Rupee           |
      | Minor Symbol                | Paise           |
      | Conversion Factor           | 100             |
    When the user fills all mandatory fields
    And the user enters Name ' Trimmed Name 01 ' (3 leading and 3 trailing spaces)
    And the user clicks Save
    And the user opens the record in View mode
    Then Record is saved and the stored Name is 'Trimmed Name 01' without leading/trailing spaces

  # Ref: FRD 6.2.2 F-Name
  @TC_SF_057 @Functional @Medium @Automation
  Scenario: Verify a single-character Currency Name (minimum length) is accepted
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India) |
      | Name                        | Z               |
      | Digit Group Symbol          | ,               |
      | Number Format               | 1,234,567.89    |
      | Negative Sign Symbol        | -               |
      | No. of Digits after Decimal | 2               |
      | Positive Format             | ₹1.1            |
      | Negative Format             | -₹1.1           |
      | Major Symbol                | Rupee           |
      | Minor Symbol                | Paise           |
      | Conversion Factor           | 100             |
    When the user fills all mandatory fields
    And the user enters Name 'Z'
    And the user clicks Save
    Then Record is saved with Name 'Z' (blank is the only invalid shorter value). Note: FRD defines no minimum length; 1 character assumed to be the minimum since blank is rejected (OQ-7)

  # Ref: FRD 6.2.2 F-Name
  @TC_SF_058 @Functional @Medium @Automation
  Scenario: Verify a 100-character Currency Name (recommended maximum) is accepted
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)                                                                                      |
      | Name                        | Maxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
      | Digit Group Symbol          | ,                                                                                                    |
      | Number Format               | 1,234,567.89                                                                                         |
      | Negative Sign Symbol        | -                                                                                                    |
      | No. of Digits after Decimal | 2                                                                                                    |
      | Positive Format             | ₹1.1                                                                                                 |
      | Negative Format             | -₹1.1                                                                                                |
      | Major Symbol                | Rupee                                                                                                |
      | Minor Symbol                | Paise                                                                                                |
      | Conversion Factor           | 100                                                                                                  |
    When the user fills all mandatory fields
    And the user enters a 100-character Name
    And the user clicks Save
    Then Record is saved with the full 100-character Name

  # Ref: FRD 6.2.2 F-Major
  @TC_SF_066 @Functional @Medium @Automation
  Scenario: Verify Major Symbol accepts alphabetic characters, numbers and spaces
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee 1             |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters Major Symbol 'Rupee 1'
    And the user clicks Save
    Then Record is saved with Major Symbol 'Rupee 1'

  # Ref: FRD 6.2.2 F-Major
  @TC_SF_067 @Functional @Low @Automation
  Scenario: Verify Major Symbol accepts uppercase and lowercase characters
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | RUPEE               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters Major Symbol 'RUPEE' and save a first record
    And the user creates a second record with Major Symbol 'rupee'
    Then Both records are accepted; Major Symbol values are stored in the entered case

  # Ref: FRD 6.2.2 F-Major
  @TC_SF_068 @Functional @Medium @Automation
  Scenario: Verify Major Symbol accepts a special character that is part of the currency representation
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | €                   |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters Major Symbol '€'
    And the user clicks Save
    Then Record is saved with Major Symbol '€' (special characters allowed where part of the currency representation)

  # Ref: FRD 6.2.2 F-Major
  @TC_SF_069 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces in Major Symbol are trimmed
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters Major Symbol ' Rupee ' (2 leading and 2 trailing spaces)
    And the user clicks Save
    And the user opens the record
    Then Major Symbol is stored as 'Rupee' without surrounding spaces

  # Ref: FRD 6.2.2 F-Major
  @TC_SF_070 @Functional @Medium @Automation
  Scenario: Verify a 50-character Major Symbol (recommended maximum) is accepted
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)                                    |
      | Name                        | Indian Rupee Retail                                |
      | Digit Group Symbol          | ,                                                  |
      | Number Format               | 1,234,567.89                                       |
      | Negative Sign Symbol        | -                                                  |
      | No. of Digits after Decimal | 2                                                  |
      | Positive Format             | ₹1.1                                               |
      | Negative Format             | -₹1.1                                              |
      | Major Symbol                | RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR |
      | Minor Symbol                | Paise                                              |
      | Conversion Factor           | 100                                                |
    When the user fills all mandatory fields
    And the user enters a 50-character Major Symbol
    And the user clicks Save
    Then Record is saved with the full 50-character Major Symbol

  # Ref: FRD 6.2.2 F-Minor
  @TC_SF_071 @Functional @Medium @Automation
  Scenario: Verify Minor Symbol accepts alphabetic characters, numbers and spaces
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise 1             |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters Minor Symbol 'Paise 1'
    And the user clicks Save
    Then Record is saved with Minor Symbol 'Paise 1'

  # Ref: FRD 6.2.2 F-Minor
  @TC_SF_072 @Functional @Low @Automation
  Scenario: Verify Minor Symbol accepts uppercase and lowercase characters
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | PAISE               |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters Minor Symbol 'PAISE' and save a first record
    And the user creates a second record with Minor Symbol 'paise'
    Then Both records are accepted; Minor Symbol values are stored in the entered case

  # Ref: FRD 6.2.2 F-Minor
  @TC_SF_073 @Functional @Medium @Automation
  Scenario: Verify Minor Symbol accepts a special character that is part of the currency representation
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | ¢                   |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters Minor Symbol '¢'
    And the user clicks Save
    Then Record is saved with Minor Symbol '¢' (special characters allowed where part of the currency representation)

  # Ref: FRD 6.2.2 F-Minor
  @TC_SF_074 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces in Minor Symbol are trimmed
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters Minor Symbol ' Paise ' (2 leading and 2 trailing spaces)
    And the user clicks Save
    And the user opens the record
    Then Minor Symbol is stored as 'Paise' without surrounding spaces

  # Ref: FRD 6.2.2 F-Minor
  @TC_SF_075 @Functional @Medium @Automation
  Scenario: Verify a 50-character Minor Symbol (recommended maximum) is accepted
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)                                    |
      | Name                        | Indian Rupee Retail                                |
      | Digit Group Symbol          | ,                                                  |
      | Number Format               | 1,234,567.89                                       |
      | Negative Sign Symbol        | -                                                  |
      | No. of Digits after Decimal | 2                                                  |
      | Positive Format             | ₹1.1                                               |
      | Negative Format             | -₹1.1                                              |
      | Major Symbol                | Rupee                                              |
      | Minor Symbol                | RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR |
      | Conversion Factor           | 100                                                |
    When the user fills all mandatory fields
    And the user enters a 50-character Minor Symbol
    And the user clicks Save
    Then Record is saved with the full 50-character Minor Symbol

  # Ref: FRD 6.2.2 F-Conv
  @TC_SF_076 @Functional @Medium @Automation
  Scenario: Verify Conversion Factor accepts a whole number
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters Conversion Factor '100'
    And the user clicks Save
    Then Record is saved with Conversion Factor 100

  # Ref: FRD 6.2.2 F-Conv
  @TC_SF_077 @Functional @Medium @Automation
  Scenario: Verify Conversion Factor accepts a decimal value
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 0.01                |
    When the user fills all mandatory fields
    And the user enters Conversion Factor '0.01'
    And the user clicks Save
    Then Record is saved; decimal values are permitted (0.01)

  # Ref: FRD 6.2.2 F-Conv
  @TC_SF_078 @Functional @Medium @Automation
  Scenario: Verify Conversion Factor accepts the smallest positive decimal boundary value
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 0.0001              |
    When the user fills all mandatory fields
    And the user enters Conversion Factor '0.0001'
    And the user clicks Save
    Then Record is saved with Conversion Factor 0.0001 (greater than 0). Note: Decimal precision limit is not stated in the FRD (OQ-9)

  # Ref: FRD 6.2.2 F-Conv
  @TC_SF_079 @Functional @Medium @Automation
  Scenario: Verify Conversion Factor accepts a value with leading/trailing spaces (trimmed)
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters Conversion Factor ' 100 '
    And the user clicks Save
    Then Record is saved; Conversion Factor is stored as 100 without spaces

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-3; FRD 6.2.2 F-Culture; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_212 @Negative @High @Automation
  Scenario: Verify Save is blocked when Culture is left blank on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Culture                                                                                                                                                                                                                                       |
      | Other fields | Name=Indian Rupee Retail; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=₹1.1; Negative Format=-₹1.1; Major Symbol=Rupee; Minor Symbol=Paise; Conversion Factor=100 |
    When the user fills every mandatory field except Culture
    And the user leaves Culture showing 'Select Culture'
    And the user clicks Save
    Then Save is blocked and the message 'Culture is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-3; FRD 6.2.2 F-Name; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_213 @Negative @High @Automation
  Scenario: Verify Save is blocked when Name is left blank on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Name                                                                                                                                                                                                                                         |
      | Other fields | Culture=English (India); Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=₹1.1; Negative Format=-₹1.1; Major Symbol=Rupee; Minor Symbol=Paise; Conversion Factor=100 |
    When the user fills every mandatory field except Name
    And the user leaves Name showing 'Enter Name'
    And the user clicks Save
    Then Save is blocked and the message 'Name is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-3; FRD 6.2.2 F-DGS; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_214 @Negative @High @Automation
  Scenario: Verify Save is blocked when Digit Group Symbol is left blank on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Digit Group Symbol                                                                                                                                                                                                                               |
      | Other fields | Culture=English (India); Name=Indian Rupee Retail; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=₹1.1; Negative Format=-₹1.1; Major Symbol=Rupee; Minor Symbol=Paise; Conversion Factor=100 |
    When the user fills every mandatory field except Digit Group Symbol
    And the user leaves Digit Group Symbol showing 'Select Digit Group Symbol'
    And the user clicks Save
    Then Save is blocked and the message 'Digit Group Symbol is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-3; FRD 6.2.2 F-NumFmt; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_215 @Negative @High @Automation
  Scenario: Verify Save is blocked when Number Format is left blank on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Number Format                                                                                                                                                                                                                              |
      | Other fields | Culture=English (India); Name=Indian Rupee Retail; Digit Group Symbol=,; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=₹1.1; Negative Format=-₹1.1; Major Symbol=Rupee; Minor Symbol=Paise; Conversion Factor=100 |
    When the user fills every mandatory field except Number Format
    And the user leaves Number Format showing 'Select Number Format'
    And the user clicks Save
    Then Save is blocked and the message 'Number Format is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-3; FRD 6.2.2 F-NegSign; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_216 @Negative @High @Automation
  Scenario: Verify Save is blocked when Negative Sign Symbol is left blank on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Negative Sign Symbol                                                                                                                                                                                                                           |
      | Other fields | Culture=English (India); Name=Indian Rupee Retail; Digit Group Symbol=,; Number Format=1,234,567.89; No. of Digits after Decimal=2; Positive Format=₹1.1; Negative Format=-₹1.1; Major Symbol=Rupee; Minor Symbol=Paise; Conversion Factor=100 |
    When the user fills every mandatory field except Negative Sign Symbol
    And the user leaves Negative Sign Symbol showing 'Select Negative Sign Symbol'
    And the user clicks Save
    Then Save is blocked and the message 'Negative Sign Symbol is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-3; FRD 6.2.2 F-Digits; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_217 @Negative @High @Automation
  Scenario: Verify Save is blocked when No. of Digits after Decimal is left blank on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | No. of Digits after Decimal                                                                                                                                                                                                             |
      | Other fields | Culture=English (India); Name=Indian Rupee Retail; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; Positive Format=₹1.1; Negative Format=-₹1.1; Major Symbol=Rupee; Minor Symbol=Paise; Conversion Factor=100 |
    When the user fills every mandatory field except No. of Digits after Decimal
    And the user leaves No. of Digits after Decimal showing 'Select No. of Digits after Decimal'
    And the user clicks Save
    Then Save is blocked and the message 'No. of Digits after Decimal is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-3; FRD 6.2.2 F-PosFmt; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_218 @Negative @High @Automation
  Scenario: Verify Save is blocked when Positive Format is left blank on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Positive Format                                                                                                                                                                                                                                  |
      | Other fields | Culture=English (India); Name=Indian Rupee Retail; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Negative Format=-₹1.1; Major Symbol=Rupee; Minor Symbol=Paise; Conversion Factor=100 |
    When the user fills every mandatory field except Positive Format
    And the user leaves Positive Format showing 'Select Positive Format'
    And the user clicks Save
    Then Save is blocked and the message 'Positive Format is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-3; FRD 6.2.2 F-NegFmt; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_219 @Negative @High @Automation
  Scenario: Verify Save is blocked when Negative Format is left blank on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Negative Format                                                                                                                                                                                                                                 |
      | Other fields | Culture=English (India); Name=Indian Rupee Retail; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=₹1.1; Major Symbol=Rupee; Minor Symbol=Paise; Conversion Factor=100 |
    When the user fills every mandatory field except Negative Format
    And the user leaves Negative Format showing 'Select Negative Format'
    And the user clicks Save
    Then Save is blocked and the message 'Negative Format is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-3; FRD 6.2.2 F-Major; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_220 @Negative @High @Automation
  Scenario: Verify Save is blocked when Major Symbol is left blank on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Major Symbol                                                                                                                                                                                                                                       |
      | Other fields | Culture=English (India); Name=Indian Rupee Retail; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=₹1.1; Negative Format=-₹1.1; Minor Symbol=Paise; Conversion Factor=100 |
    When the user fills every mandatory field except Major Symbol
    And the user leaves Major Symbol showing 'Enter Major Symbol'
    And the user clicks Save
    Then Save is blocked and the message 'Major Symbol is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-3; FRD 6.2.2 F-Minor; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_221 @Negative @High @Automation
  Scenario: Verify Save is blocked when Minor Symbol is left blank on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Minor Symbol                                                                                                                                                                                                                                       |
      | Other fields | Culture=English (India); Name=Indian Rupee Retail; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=₹1.1; Negative Format=-₹1.1; Major Symbol=Rupee; Conversion Factor=100 |
    When the user fills every mandatory field except Minor Symbol
    And the user leaves Minor Symbol showing 'Enter Minor Symbol'
    And the user clicks Save
    Then Save is blocked and the message 'Minor Symbol is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-3; FRD 6.2.2 F-Conv; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_222 @Negative @High @Automation
  Scenario: Verify Save is blocked when Conversion Factor is left blank on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Conversion Factor                                                                                                                                                                                                                               |
      | Other fields | Culture=English (India); Name=Indian Rupee Retail; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=₹1.1; Negative Format=-₹1.1; Major Symbol=Rupee; Minor Symbol=Paise |
    When the user fills every mandatory field except Conversion Factor
    And the user leaves Conversion Factor showing 'Enter Conversion Factor'
    And the user clicks Save
    Then Save is blocked and the message 'Conversion Factor is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: FRD 6.2 BR-5; FRD 6.2.2 F-Name
  @TC_SF_238 @Negative @High @Automation
  Scenario: Verify whitespace-only Name is rejected on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India) |
      | Name                        | ' ' (5 spaces)  |
      | Digit Group Symbol          | ,               |
      | Number Format               | 1,234,567.89    |
      | Negative Sign Symbol        | -               |
      | No. of Digits after Decimal | 2               |
      | Positive Format             | ₹1.1            |
      | Negative Format             | -₹1.1           |
      | Major Symbol                | Rupee           |
      | Minor Symbol                | Paise           |
      | Conversion Factor           | 100             |
    When the user fills all mandatory fields
    And the user enters 5 spaces as Name
    And the user clicks Save
    Then Save is blocked with 'Name is required'; no record is created. Note: Whitespace-only treated as blank so the 'required' message is expected (OQ-1)

  # Ref: FRD 6.2 BR-4; FRD 6.2.2 F-Name
  @TC_SF_239 @Negative @High @Automation
  Scenario: Verify an exact duplicate Name is rejected on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)   |
      | Name                        | Standard Currency |
      | Digit Group Symbol          | ,                 |
      | Number Format               | 1,234,567.89      |
      | Negative Sign Symbol        | -                 |
      | No. of Digits after Decimal | 2                 |
      | Positive Format             | ₹1.1              |
      | Negative Format             | -₹1.1             |
      | Major Symbol                | Rupee             |
      | Minor Symbol                | Paise             |
      | Conversion Factor           | 100               |
    When the user fills all mandatory fields
    And the user enters Name 'Standard Currency'
    And the user clicks Save
    Then Save is blocked with 'Name already exists'; no record is created

  # Ref: FRD 6.2 BR-4; FRD 6.2.2 F-Name
  @TC_SF_240 @Negative @High @Automation
  Scenario: Verify a Name differing only in case is treated as a duplicate on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)   |
      | Name                        | standard currency |
      | Digit Group Symbol          | ,                 |
      | Number Format               | 1,234,567.89      |
      | Negative Sign Symbol        | -                 |
      | No. of Digits after Decimal | 2                 |
      | Positive Format             | ₹1.1              |
      | Negative Format             | -₹1.1             |
      | Major Symbol                | Rupee             |
      | Minor Symbol                | Paise             |
      | Conversion Factor           | 100               |
    When the user fills all mandatory fields
    And the user enters Name 'standard currency'
    And the user clicks Save
    Then Save is blocked with 'Name already exists' (case-insensitive uniqueness)

  # Ref: FRD 6.2 BR-5; FRD 6.2 BR-4; FRD 6.2.2 F-Name
  @TC_SF_241 @Negative @High @Automation
  Scenario: Verify a duplicate Name with surrounding spaces is rejected after trimming on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)   |
      | Name                        | Standard Currency |
      | Digit Group Symbol          | ,                 |
      | Number Format               | 1,234,567.89      |
      | Negative Sign Symbol        | -                 |
      | No. of Digits after Decimal | 2                 |
      | Positive Format             | ₹1.1              |
      | Negative Format             | -₹1.1             |
      | Major Symbol                | Rupee             |
      | Minor Symbol                | Paise             |
      | Conversion Factor           | 100               |
    When the user fills all mandatory fields
    And the user enters Name ' Standard Currency '
    And the user clicks Save
    Then Spaces are trimmed before validation and 'Name already exists' is displayed

  # Ref: FRD 6.2.2 F-Name; FRD 6.2 FB-4
  @TC_SF_242 @Negative @High @Automation
  Scenario: Verify special characters in Name are rejected on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India) |
      | Name                        | Std@Qty#1       |
      | Digit Group Symbol          | ,               |
      | Number Format               | 1,234,567.89    |
      | Negative Sign Symbol        | -               |
      | No. of Digits after Decimal | 2               |
      | Positive Format             | ₹1.1            |
      | Negative Format             | -₹1.1           |
      | Major Symbol                | Rupee           |
      | Minor Symbol                | Paise           |
      | Conversion Factor           | 100             |
    When the user fills all mandatory fields
    And the user enters Name 'Std@Qty#1'
    And the user clicks Save
    Then Save is blocked; special characters are not allowed and no record is created. Note: Error message text for invalid characters is not defined (OQ-2)

  # Ref: FRD 6.2.2 F-Major
  @TC_SF_256 @Negative @High @Automation
  Scenario: Verify whitespace-only Major Symbol is rejected
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | ' ' (3 spaces)      |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters 3 spaces as Major Symbol
    And the user clicks Save
    Then Save is blocked with 'Major Symbol is required'; no record is created. Note: See OQ-1

  # Ref: FRD 6.2.2 F-Minor
  @TC_SF_258 @Negative @High @Automation
  Scenario: Verify whitespace-only Minor Symbol is rejected
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | ' ' (3 spaces)      |
      | Conversion Factor           | 100                 |
    When the user fills all mandatory fields
    And the user enters 3 spaces as Minor Symbol
    And the user clicks Save
    Then Save is blocked with 'Minor Symbol is required'; no record is created. Note: See OQ-1

  # Ref: FRD 6.2.2 F-Conv
  @TC_SF_260 @Negative @High @Automation
  Scenario: Verify Conversion Factor is rejected when it is zero
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | '0'                 |
    When the user fills all mandatory fields
    And the user enters Conversion Factor '0'
    And the user clicks Save
    Then Save is blocked and 'Invalid Conversion Factor' is displayed; no record is created. Note: Message text for this case inferred from FRD (OQ-17)

  # Ref: FRD 6.2.2 F-Conv
  @TC_SF_261 @Negative @High @Automation
  Scenario: Verify Conversion Factor is rejected when it is a negative number
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | '-5'                |
    When the user fills all mandatory fields
    And the user enters Conversion Factor '-5'
    And the user clicks Save
    Then Save is blocked and 'Invalid Conversion Factor' is displayed; no record is created

  # Ref: FRD 6.2.2 F-Conv
  @TC_SF_262 @Negative @High @Automation
  Scenario: Verify Conversion Factor is rejected when it is alphabetic characters
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | 'abc'               |
    When the user fills all mandatory fields
    And the user enters Conversion Factor 'abc'
    And the user clicks Save
    Then Save is blocked and 'Invalid Conversion Factor' is displayed; no record is created

  # Ref: FRD 6.2.2 F-Conv
  @TC_SF_263 @Negative @High @Automation
  Scenario: Verify Conversion Factor is rejected when it is an unsupported special character
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | '10@'               |
    When the user fills all mandatory fields
    And the user enters Conversion Factor '10@'
    And the user clicks Save
    Then Save is blocked and 'Invalid Conversion Factor' is displayed; no record is created

  # Ref: FRD 6.2.2 F-Conv
  @TC_SF_264 @Negative @High @Automation
  Scenario: Verify Conversion Factor is rejected when it is multiple decimal points
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | '1.2.3'             |
    When the user fills all mandatory fields
    And the user enters Conversion Factor '1.2.3'
    And the user clicks Save
    Then Save is blocked and 'Invalid Conversion Factor' is displayed; no record is created

  # Ref: FRD 6.2.2 F-Conv
  @TC_SF_265 @Negative @High @Automation
  Scenario: Verify Conversion Factor is rejected when it is whitespace only
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)     |
      | Name                        | Indian Rupee Retail |
      | Digit Group Symbol          | ,                   |
      | Number Format               | 1,234,567.89        |
      | Negative Sign Symbol        | -                   |
      | No. of Digits after Decimal | 2                   |
      | Positive Format             | ₹1.1                |
      | Negative Format             | -₹1.1               |
      | Major Symbol                | Rupee               |
      | Minor Symbol                | Paise               |
      | Conversion Factor           | ' '                 |
    When the user fills all mandatory fields
    And the user enters Conversion Factor ' '
    And the user clicks Save
    Then Save is blocked and 'Conversion Factor is required' is displayed; no record is created. Note: Message text for this case inferred from FRD (OQ-17)

  # Ref: FRD 6.2.2 F-Culture; FRD 6.2 FB-4
  @TC_SF_269 @Negative @High @Automation
  Scenario: Verify create is rejected when Culture is not from the configured list (Currency, API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1        |
      | Culture | Klingon (Mars)     |
      | Data    | other fields valid |
    When the user sends a create-Currency request with Culture set to an unsupported value
    And the user checks the Master
    Then Request is rejected with a validation error; no record is created

  # Ref: FRD 6.2.2 F-NumFmt; FRD 6.2 FB-4
  @TC_SF_270 @Negative @High @Automation
  Scenario: Verify create is rejected when Number Format is not from the configured list (Currency, API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User          | Admin_User1        |
      | Number Format | 9~999~999^99       |
      | Data          | other fields valid |
    When the user sends a create-Currency request with Number Format set to an unsupported value
    And the user checks the Master
    Then Request is rejected with a validation error; no record is created

  # Ref: FRD 6.2.2 F-Culture
  @TC_SF_274 @Negative @High @Automation
  Scenario: Verify create is rejected when Culture is null (Currency, API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1        |
      | Culture | null               |
      | Data    | other fields valid |
    When the user sends a create-Currency request with Culture null
    And the user checks the Master
    Then Request is rejected ('Culture is required'); no record is created (field shall not accept blank/null)

  # Ref: FRD 6.2.2 F-Symbol
  @TC_SF_277 @Negative @Medium @Automation
  Scenario: Verify a client-supplied Symbol is ignored for the Currency format (API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture | English (India) |
      | Symbol  | $               |
    When the user sends create-Currency with Culture 'English (India)' and Symbol '$'
    And the user reads the record
    Then Stored Symbol is '₹' (derived from Culture); the supplied value is ignored or rejected

  # Ref: FRD 6.2.2 F-DecSym
  @TC_SF_278 @Negative @Medium @Automation
  Scenario: Verify a client-supplied Decimal Symbol is ignored for the Currency format (API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format  | 1.234.567,89 |
      | Decimal Symbol | .            |
    When the user sends create-Currency with Number Format '1.234.567,89' and Decimal Symbol '.'
    And the user reads the record
    Then Stored Decimal Symbol is ',' (derived)
