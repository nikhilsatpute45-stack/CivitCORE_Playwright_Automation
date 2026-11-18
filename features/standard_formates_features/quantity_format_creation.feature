@StandardsFormats @QuantityFormatCreation
Feature: Quantity Format Creation
  Automated scenarios for the "Quantity Format Creation" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-1; FRD 6.2 FB-1; FRD 6.2 FB-2; FRD 6.2 FB-4; FRD 6.2 FB-5; FRD 6.2 FB-6; FRD Sec 8 Toaster #1; FRD Fig 1
  @TC_SF_009 @Functional @High @Automation
  Scenario: Verify a Quantity configuration is created with all mandatory fields and toaster is shown
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)    |
      | Name                        | Metric Quantity 01 |
      | Digit Group Symbol          | ,                  |
      | Number Format               | 1,234,567.89       |
      | Negative Sign Symbol        | -                  |
      | No. of Digits after Decimal | 2                  |
      | Positive Format             | 1.1                |
      | Negative Format             | -1.1               |
      | Leading Zero                | 0.7                |
    When the user clicks 'Add'
    And the user selects the Culture
    And the user enters the Name
    And the user selects/enter all remaining mandatory fields
    And the user clicks Save
    Then System generates a unique Quantity Formats ID and creates the record in the Standards & Formats Master
    And Toaster 'Quantity format created successfully.' is displayed
    And The new record 'Metric Quantity 01' is visible in the Quantity list

  # Ref: FRD 6.2.1 F-Culture; FRD 6.2 FB-3
  @TC_SF_016 @Functional @High @Automation
  Scenario: Verify selecting a Culture loads culture-specific configuration options on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture | German (Germany) |
    When the user selects Culture 'German (Germany)'
    And the user observes the options/defaults of the remaining fields
    Then Culture-specific configuration options/defaults for German (Germany) are loaded into the remaining fields

  # Ref: FRD 6.2.1 F-DecSym; FRD 6.2.1 F-NumFmt
  @TC_SF_020 @Functional @High @Automation
  Scenario: Verify Decimal Symbol shows '.' when the selected Quantity Number Format uses '.'
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format | 1,234,567.89 |
    When the user selects Number Format '1,234,567.89'
    And the user observes Decimal Symbol
    Then Decimal Symbol displays '.' and is not editable

  # Ref: FRD 6.2.1 F-DecSym; FRD 6.2.1 F-NumFmt
  @TC_SF_021 @Functional @High @Automation
  Scenario: Verify Decimal Symbol shows ',' when the selected Quantity Number Format uses ','
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format | 1.234.567,89 |
    When the user selects Number Format '1.234.567,89'
    And the user observes Decimal Symbol
    Then Decimal Symbol displays ','

  # Ref: FRD 6.2.1 F-DecSym
  @TC_SF_022 @Functional @Medium @Automation
  Scenario: Verify Decimal Symbol refreshes whenever the Quantity Number Format is changed
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format | 1,234,567.89 -> 1.234.567,89 |
    When the user selects Number Format '1,234,567.89' and note Decimal Symbol
    And the user changes Number Format to '1.234.567,89'
    And the user observes Decimal Symbol again
    Then Decimal Symbol changes from '.' to ',' immediately after the change

  # Ref: FRD 6.2.1 F-Sample
  @TC_SF_026 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Number Format is changed on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format   | 1,234,567.89 -> 1.234.567,89 |
      | Digits          | 2                            |
      | Positive Format | 1.1                          |
      | Negative Format | -1.1                         |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Number Format as per Test Data
    And the user observes the Sample area without clicking Save
    Then Sample positive/negative switch to decimal separator ',' (e.g., 1.234.567,89 and -1.234.567,89) without saving
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.1 F-Sample
  @TC_SF_027 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when No. of Digits after Decimal is changed on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | No. of Digits after Decimal | 2 -> 4       |
      | Number Format               | 1,234,567.89 |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes No. of Digits after Decimal as per Test Data
    And the user observes the Sample area without clicking Save
    Then Sample shows four digits after the Decimal Symbol (e.g., 1,234,567.8900)
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.1 F-Sample
  @TC_SF_028 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Positive Format is changed on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Positive Format | 1.1 -> +1.1 |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Positive Format as per Test Data
    And the user observes the Sample area without clicking Save
    Then Positive sample is re-rendered in the new Positive Format (e.g., +1,234,567.89)
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.1 F-Sample
  @TC_SF_029 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Negative Format is changed on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Negative Format | -1.1 -> (1.1) |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Negative Format as per Test Data
    And the user observes the Sample area without clicking Save
    Then Negative sample is re-rendered in the new Negative Format (e.g., (1,234,567.89))
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.1 F-Sample
  @TC_SF_030 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Leading Zero is changed on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Leading Zero | 0.7 -> .7 |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Leading Zero as per Test Data
    And the user observes the Sample area without clicking Save
    Then Sample for values below 1 changes from '0.70' to '.70'
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.1 F-Sample; FRD 6.2 BR-6
  @TC_SF_046 @Functional @Medium @Automation
  Scenario: Verify Sample displays a Positive and a Negative value for the selected Quantity configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)    |
      | Name                        | Metric Quantity 01 |
      | Digit Group Symbol          | ,                  |
      | Number Format               | 1,234,567.89       |
      | Negative Sign Symbol        | -                  |
      | No. of Digits after Decimal | 2                  |
      | Positive Format             | 1.1                |
      | Negative Format             | -1.1               |
      | Leading Zero                | 0.7                |
    When the user fills all mandatory fields with Test Data
    And the user observes the Sample (Positive / Negative) area
    Then A Positive sample (e.g., 1,234,567.89) and a Negative sample (e.g., -1,234,567.89) are generated automatically

  # Ref: FRD 6.2 BR-6
  @TC_SF_048 @Functional @Medium @Automation
  Scenario: Verify the Sample preview alone persists no data
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)  |
      | Name                        | Preview Only Qty |
      | Digit Group Symbol          | ,                |
      | Number Format               | 1,234,567.89     |
      | Negative Sign Symbol        | -                |
      | No. of Digits after Decimal | 2                |
      | Positive Format             | 1.1              |
      | Negative Format             | -1.1             |
      | Leading Zero                | 0.7              |
    When the user fills all mandatory fields with Test Data (Name 'Preview Only Qty')
    And the user observes the Sample
    And the user navigates away from the form without clicking Save
    And the user searches the Quantity list for 'Preview Only Qty'
    Then No record 'Preview Only Qty' exists; no ID was generated and no Activity Log entry created

  # Ref: FRD 6.2.1 F-Name; FRD Sec 8 Toaster #1
  @TC_SF_049 @Functional @High @Automation
  Scenario: Verify Quantity Name accepts alphabetic characters, numbers and spaces
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)      |
      | Name                        | Format Set 2026 Plan |
      | Digit Group Symbol          | ,                    |
      | Number Format               | 1,234,567.89         |
      | Negative Sign Symbol        | -                    |
      | No. of Digits after Decimal | 2                    |
      | Positive Format             | 1.1                  |
      | Negative Format             | -1.1                 |
      | Leading Zero                | 0.7                  |
    When the user fills all mandatory fields
    And the user enters Name 'Format Set 2026 Plan'
    And the user clicks Save
    Then Record is saved with Name 'Format Set 2026 Plan'
    And Toaster 'Quantity format created successfully.' is displayed

  # Ref: FRD 6.2.1 F-Name
  @TC_SF_050 @Functional @Medium @Automation
  Scenario: Verify Quantity Name accepts uppercase and lowercase characters
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)      |
      | Name                        | UPPER lower Mixed 07 |
      | Digit Group Symbol          | ,                    |
      | Number Format               | 1,234,567.89         |
      | Negative Sign Symbol        | -                    |
      | No. of Digits after Decimal | 2                    |
      | Positive Format             | 1.1                  |
      | Negative Format             | -1.1                 |
      | Leading Zero                | 0.7                  |
    When the user fills all mandatory fields
    And the user enters Name 'UPPER lower Mixed 07'
    And the user clicks Save
    Then Record is saved and the Name is stored with the entered case

  # Ref: FRD 6.2 BR-5; FRD 6.2.1 F-Name
  @TC_SF_051 @Functional @High @Automation
  Scenario: Verify leading and trailing spaces in Quantity Name are trimmed before persistence
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India) |
      | Name                        | Trimmed Name 01 |
      | Digit Group Symbol          | ,               |
      | Number Format               | 1,234,567.89    |
      | Negative Sign Symbol        | -               |
      | No. of Digits after Decimal | 2               |
      | Positive Format             | 1.1             |
      | Negative Format             | -1.1            |
      | Leading Zero                | 0.7             |
    When the user fills all mandatory fields
    And the user enters Name ' Trimmed Name 01 ' (3 leading and 3 trailing spaces)
    And the user clicks Save
    And the user opens the record in View mode
    Then Record is saved and the stored Name is 'Trimmed Name 01' without leading/trailing spaces

  # Ref: FRD 6.2.1 F-Name
  @TC_SF_052 @Functional @Medium @Automation
  Scenario: Verify a single-character Quantity Name (minimum length) is accepted
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India) |
      | Name                        | Z               |
      | Digit Group Symbol          | ,               |
      | Number Format               | 1,234,567.89    |
      | Negative Sign Symbol        | -               |
      | No. of Digits after Decimal | 2               |
      | Positive Format             | 1.1             |
      | Negative Format             | -1.1            |
      | Leading Zero                | 0.7             |
    When the user fills all mandatory fields
    And the user enters Name 'Z'
    And the user clicks Save
    Then Record is saved with Name 'Z' (blank is the only invalid shorter value). Note: FRD defines no minimum length; 1 character assumed to be the minimum since blank is rejected (OQ-7)

  # Ref: FRD 6.2.1 F-Name
  @TC_SF_053 @Functional @Medium @Automation
  Scenario: Verify a 100-character Quantity Name (recommended maximum) is accepted
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)                                                                                      |
      | Name                        | Maxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
      | Digit Group Symbol          | ,                                                                                                    |
      | Number Format               | 1,234,567.89                                                                                         |
      | Negative Sign Symbol        | -                                                                                                    |
      | No. of Digits after Decimal | 2                                                                                                    |
      | Positive Format             | 1.1                                                                                                  |
      | Negative Format             | -1.1                                                                                                 |
      | Leading Zero                | 0.7                                                                                                  |
    When the user fills all mandatory fields
    And the user enters a 100-character Name
    And the user clicks Save
    Then Record is saved with the full 100-character Name

  # Ref: FRD 6.2 BR-4; FRD 6.2.2 F-Name
  @TC_SF_064 @Functional @High @Automation
  Scenario: Verify the same Name may be used in a different configuration type
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)   |
      | Name                        | Standard Quantity |
      | Digit Group Symbol          | ,                 |
      | Number Format               | 1,234,567.89      |
      | Negative Sign Symbol        | -                 |
      | No. of Digits after Decimal | 2                 |
      | Positive Format             | ₹1.1              |
      | Negative Format             | -₹1.1             |
      | Major Symbol                | Rupee             |
      | Minor Symbol                | Paise             |
      | Conversion Factor           | 100               |
    When the user clicks 'Add' on the Currency tab
    And the user fills all mandatory Currency fields
    And the user enters Name 'Standard Quantity' (an existing Quantity name)
    And the user clicks Save
    Then Currency format is saved; uniqueness is checked only within the Currency type (no 'Name already exists')

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-2; FRD 6.2.1 F-Culture; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_203 @Negative @High @Automation
  Scenario: Verify Save is blocked when Culture is left blank on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Culture                                                                                                                                                                                       |
      | Other fields | Name=Metric Quantity 01; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=1.1; Negative Format=-1.1; Leading Zero=0.7 |
    When the user fills every mandatory field except Culture
    And the user leaves Culture showing 'Select Culture'
    And the user clicks Save
    Then Save is blocked and the message 'Culture is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-2; FRD 6.2.1 F-Name; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_204 @Negative @High @Automation
  Scenario: Verify Save is blocked when Name is left blank on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Name                                                                                                                                                                                          |
      | Other fields | Culture=English (India); Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=1.1; Negative Format=-1.1; Leading Zero=0.7 |
    When the user fills every mandatory field except Name
    And the user leaves Name showing 'Enter Name'
    And the user clicks Save
    Then Save is blocked and the message 'Name is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-2; FRD 6.2.1 F-DGS; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_205 @Negative @High @Automation
  Scenario: Verify Save is blocked when Digit Group Symbol is left blank on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Digit Group Symbol                                                                                                                                                                               |
      | Other fields | Culture=English (India); Name=Metric Quantity 01; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=1.1; Negative Format=-1.1; Leading Zero=0.7 |
    When the user fills every mandatory field except Digit Group Symbol
    And the user leaves Digit Group Symbol showing 'Select Digit Group Symbol'
    And the user clicks Save
    Then Save is blocked and the message 'Digit Group Symbol is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-2; FRD 6.2.1 F-NumFmt; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_206 @Negative @High @Automation
  Scenario: Verify Save is blocked when Number Format is left blank on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Number Format                                                                                                                                                                              |
      | Other fields | Culture=English (India); Name=Metric Quantity 01; Digit Group Symbol=,; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=1.1; Negative Format=-1.1; Leading Zero=0.7 |
    When the user fills every mandatory field except Number Format
    And the user leaves Number Format showing 'Select Number Format'
    And the user clicks Save
    Then Save is blocked and the message 'Number Format is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-2; FRD 6.2.1 F-NegSign; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_207 @Negative @High @Automation
  Scenario: Verify Save is blocked when Negative Sign Symbol is left blank on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Negative Sign Symbol                                                                                                                                                                           |
      | Other fields | Culture=English (India); Name=Metric Quantity 01; Digit Group Symbol=,; Number Format=1,234,567.89; No. of Digits after Decimal=2; Positive Format=1.1; Negative Format=-1.1; Leading Zero=0.7 |
    When the user fills every mandatory field except Negative Sign Symbol
    And the user leaves Negative Sign Symbol showing 'Select Negative Sign Symbol'
    And the user clicks Save
    Then Save is blocked and the message 'Negative Sign Symbol is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-2; FRD 6.2.1 F-Digits; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_208 @Negative @High @Automation
  Scenario: Verify Save is blocked when No. of Digits after Decimal is left blank on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | No. of Digits after Decimal                                                                                                                                                             |
      | Other fields | Culture=English (India); Name=Metric Quantity 01; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; Positive Format=1.1; Negative Format=-1.1; Leading Zero=0.7 |
    When the user fills every mandatory field except No. of Digits after Decimal
    And the user leaves No. of Digits after Decimal showing 'Select No. of Digits after Decimal'
    And the user clicks Save
    Then Save is blocked and the message 'No. of Digits after Decimal is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-2; FRD 6.2.1 F-PosFmt; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_209 @Negative @High @Automation
  Scenario: Verify Save is blocked when Positive Format is left blank on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Positive Format                                                                                                                                                                                   |
      | Other fields | Culture=English (India); Name=Metric Quantity 01; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Negative Format=-1.1; Leading Zero=0.7 |
    When the user fills every mandatory field except Positive Format
    And the user leaves Positive Format showing 'Select Positive Format'
    And the user clicks Save
    Then Save is blocked and the message 'Positive Format is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-2; FRD 6.2.1 F-NegFmt; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_210 @Negative @High @Automation
  Scenario: Verify Save is blocked when Negative Format is left blank on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Negative Format                                                                                                                                                                                  |
      | Other fields | Culture=English (India); Name=Metric Quantity 01; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=1.1; Leading Zero=0.7 |
    When the user fills every mandatory field except Negative Format
    And the user leaves Negative Format showing 'Select Negative Format'
    And the user clicks Save
    Then Save is blocked and the message 'Negative Format is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-2; FRD 6.2.1 F-LeadZero; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_211 @Negative @High @Automation
  Scenario: Verify Save is blocked when Leading Zero is left blank on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Leading Zero                                                                                                                                                                                         |
      | Other fields | Culture=English (India); Name=Metric Quantity 01; Digit Group Symbol=,; Number Format=1,234,567.89; Negative Sign Symbol=-; No. of Digits after Decimal=2; Positive Format=1.1; Negative Format=-1.1 |
    When the user fills every mandatory field except Leading Zero
    And the user leaves Leading Zero showing 'Select Leading Zero'
    And the user clicks Save
    Then Save is blocked and the message 'Leading Zero is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: FRD 6.2 BR-5; FRD 6.2.1 F-Name
  @TC_SF_232 @Negative @High @Automation
  Scenario: Verify whitespace-only Name is rejected on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India) |
      | Name                        | ' ' (5 spaces)  |
      | Digit Group Symbol          | ,               |
      | Number Format               | 1,234,567.89    |
      | Negative Sign Symbol        | -               |
      | No. of Digits after Decimal | 2               |
      | Positive Format             | 1.1             |
      | Negative Format             | -1.1            |
      | Leading Zero                | 0.7             |
    When the user fills all mandatory fields
    And the user enters 5 spaces as Name
    And the user clicks Save
    Then Save is blocked with 'Name is required'; no record is created. Note: Whitespace-only treated as blank so the 'required' message is expected (OQ-1)

  # Ref: FRD 6.2 BR-4; FRD 6.2.1 F-Name
  @TC_SF_233 @Negative @High @Automation
  Scenario: Verify an exact duplicate Name is rejected on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)   |
      | Name                        | Standard Quantity |
      | Digit Group Symbol          | ,                 |
      | Number Format               | 1,234,567.89      |
      | Negative Sign Symbol        | -                 |
      | No. of Digits after Decimal | 2                 |
      | Positive Format             | 1.1               |
      | Negative Format             | -1.1              |
      | Leading Zero                | 0.7               |
    When the user fills all mandatory fields
    And the user enters Name 'Standard Quantity'
    And the user clicks Save
    Then Save is blocked with 'Name already exists'; no record is created

  # Ref: FRD 6.2 BR-4; FRD 6.2.1 F-Name
  @TC_SF_234 @Negative @High @Automation
  Scenario: Verify a Name differing only in case is treated as a duplicate on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)   |
      | Name                        | standard quantity |
      | Digit Group Symbol          | ,                 |
      | Number Format               | 1,234,567.89      |
      | Negative Sign Symbol        | -                 |
      | No. of Digits after Decimal | 2                 |
      | Positive Format             | 1.1               |
      | Negative Format             | -1.1              |
      | Leading Zero                | 0.7               |
    When the user fills all mandatory fields
    And the user enters Name 'standard quantity'
    And the user clicks Save
    Then Save is blocked with 'Name already exists' (case-insensitive uniqueness)

  # Ref: FRD 6.2 BR-5; FRD 6.2 BR-4; FRD 6.2.1 F-Name
  @TC_SF_235 @Negative @High @Automation
  Scenario: Verify a duplicate Name with surrounding spaces is rejected after trimming on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)   |
      | Name                        | Standard Quantity |
      | Digit Group Symbol          | ,                 |
      | Number Format               | 1,234,567.89      |
      | Negative Sign Symbol        | -                 |
      | No. of Digits after Decimal | 2                 |
      | Positive Format             | 1.1               |
      | Negative Format             | -1.1              |
      | Leading Zero                | 0.7               |
    When the user fills all mandatory fields
    And the user enters Name ' Standard Quantity '
    And the user clicks Save
    Then Spaces are trimmed before validation and 'Name already exists' is displayed

  # Ref: FRD 6.2.1 F-Name; FRD 6.2 FB-4
  @TC_SF_236 @Negative @High @Automation
  Scenario: Verify special characters in Name are rejected on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India) |
      | Name                        | Std@Qty#1       |
      | Digit Group Symbol          | ,               |
      | Number Format               | 1,234,567.89    |
      | Negative Sign Symbol        | -               |
      | No. of Digits after Decimal | 2               |
      | Positive Format             | 1.1             |
      | Negative Format             | -1.1            |
      | Leading Zero                | 0.7             |
    When the user fills all mandatory fields
    And the user enters Name 'Std@Qty#1'
    And the user clicks Save
    Then Save is blocked; special characters are not allowed and no record is created. Note: Error message text for invalid characters is not defined (OQ-2)

  # Ref: FRD 6.2.1 F-Name
  @TC_SF_250 @Negative @Medium @Automation
  Scenario: Verify a hyphen and underscore in Name are rejected
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture                     | English (India)      |
      | Name                        | Standard-Quantity_01 |
      | Digit Group Symbol          | ,                    |
      | Number Format               | 1,234,567.89         |
      | Negative Sign Symbol        | -                    |
      | No. of Digits after Decimal | 2                    |
      | Positive Format             | 1.1                  |
      | Negative Format             | -1.1                 |
      | Leading Zero                | 0.7                  |
    When the user fills all mandatory fields
    And the user enters Name 'Standard-Quantity_01'
    And the user clicks Save
    Then Save is blocked; only A-Z, a-z, 0-9 and spaces are allowed

  # Ref: FRD 6.2.1 F-Culture; FRD 6.2 FB-4
  @TC_SF_266 @Negative @High @Automation
  Scenario: Verify create is rejected when Culture is not from the configured list (Quantity, API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1        |
      | Culture | Klingon (Mars)     |
      | Data    | other fields valid |
    When the user sends a create-Quantity request with Culture set to an unsupported value
    And the user checks the Master
    Then Request is rejected with a validation error; no record is created

  # Ref: FRD 6.2.1 F-DGS; FRD 6.2 FB-4
  @TC_SF_267 @Negative @High @Automation
  Scenario: Verify create is rejected when Digit Group Symbol is not from the configured list (Quantity, API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User               | Admin_User1        |
      | Digit Group Symbol | #                  |
      | Data               | other fields valid |
    When the user sends a create-Quantity request with Digit Group Symbol set to an unsupported value
    And the user checks the Master
    Then Request is rejected with a validation error; no record is created

  # Ref: FRD 6.2.1 F-Digits; FRD 6.2 FB-4
  @TC_SF_268 @Negative @High @Automation
  Scenario: Verify create is rejected when No. of Digits after Decimal is not from the configured list (Quantity, API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User                        | Admin_User1        |
      | No. of Digits after Decimal | 25                 |
      | Data                        | other fields valid |
    When the user sends a create-Quantity request with No. of Digits after Decimal set to an unsupported value
    And the user checks the Master
    Then Request is rejected with a validation error; no record is created

  # Ref: FRD 6.2.1 F-Culture
  @TC_SF_273 @Negative @High @Automation
  Scenario: Verify create is rejected when Culture is null (Quantity, API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1        |
      | Culture | null               |
      | Data    | other fields valid |
    When the user sends a create-Quantity request with Culture null
    And the user checks the Master
    Then Request is rejected ('Culture is required'); no record is created (field shall not accept blank/null)

  # Ref: FRD 6.2.1 F-DecSym
  @TC_SF_276 @Negative @Medium @Automation
  Scenario: Verify a client-supplied Decimal Symbol is ignored for the Quantity format (API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format  | 1,234,567.89 |
      | Decimal Symbol | ,            |
    When the user sends create-Quantity with Number Format '1,234,567.89' and Decimal Symbol ','
    And the user reads the record
    Then Stored Decimal Symbol is '.' (derived from Number Format); the supplied value is ignored or rejected
