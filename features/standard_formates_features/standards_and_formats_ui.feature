@StandardsFormats @StandardsFormatsUi
Feature: Standards & Formats UI
  Automated scenarios for the "Standards & Formats UI" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.2 FB-2; FRD 6.2.1 F-ID; FRD 6.2.1 F-Culture; FRD 6.2.1 F-Name
  @TC_SF_169 @UIVisual @High @Automation
  Scenario: Verify the Quantity Format form shows all fields defined in the FRD
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Form | Quantity Format |
    When the user clicks 'Add'
    And the user inspects the fields on the form
    Then Fields displayed: Quantity Formats ID, Culture, Name, Digit Group Symbol, Number Format, Negative Sign Symbol, Decimal Symbol, No. of Digits after Decimal, Positive Format, Negative Format, Leading Zero, Sample (Positive / Negative). Note: Field order on screen is not stated in the FRD; FRD table order assumed (OQ-16)

  # Ref: FRD 6.2 BR-2; FRD 6.2.1 F-ID
  @TC_SF_172 @UIVisual @High @Automation
  Scenario: Verify the Quantity Formats ID is shown as read-only on the Add form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Value | Auto-generated |
    When the user observes the ID field
    And the user clicks inside it and try to type
    Then The field is read-only/disabled and cannot be edited

  # Ref: FRD 6.4 FB-2; FRD 6.4 BR-1; US-3 AC-2; FRD 6.2.1 F-ID
  @TC_SF_173 @UIVisual @High @Automation
  Scenario: Verify the Quantity Formats ID is displayed read-only on the Edit form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003 |
    When the user clicks Edit against 'Spare Quantity'
    And the user tries to modify the ID field
    Then The ID is displayed as read-only and cannot be modified

  # Ref: FRD 6.2.1 F-Sample
  @TC_SF_174 @UIVisual @Medium @Automation
  Scenario: Verify the Sample area on the Quantity Format form is read-only
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Form | Quantity Format |
    When the user fills the form until a sample is shown
    And the user clicks inside the Sample area and try to type
    Then The Sample area is display-only and cannot be edited

  # Ref: FRD 6.2.1 F-Culture
  @TC_SF_175 @UIVisual @Medium @Automation
  Scenario: Verify dropdown fields on the Quantity Format form allow selection only and not free text
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Dropdowns | Culture, Digit Group Symbol, Number Format, Negative Sign Symbol, No. of Digits after Decimal, Positive Format, Negative Format, Leading Zero |
    When the user clicks each dropdown field
    And the user tries to type a custom value
    Then Only values from the configured list can be selected; typed values are not accepted

  # Ref: FRD 6.2 FB-2; FRD 6.2.2 F-ID; FRD 6.2.2 F-Culture; FRD 6.2.2 F-Name
  @TC_SF_176 @UIVisual @High @Automation
  Scenario: Verify the Currency Format form shows all fields defined in the FRD
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Form | Currency Format |
    When the user clicks 'Add'
    And the user inspects the fields on the form
    Then Fields displayed: Currency Formats ID, Culture, Name, Symbol, Digit Group Symbol, Number Format, Negative Sign Symbol, Decimal Symbol, No. of Digits after Decimal, Positive Format, Negative Format, Major Symbol, Minor Symbol, Conversion Factor, Sample (Positive / Negative). Note: Field order on screen is not stated in the FRD; FRD table order assumed (OQ-16)

  # Ref: FRD 6.2 BR-2; FRD 6.2.2 F-ID
  @TC_SF_179 @UIVisual @High @Automation
  Scenario: Verify the Currency Formats ID is shown as read-only on the Add form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Value | Auto-generated |
    When the user observes the ID field
    And the user clicks inside it and try to type
    Then The field is read-only/disabled and cannot be edited

  # Ref: FRD 6.4 FB-2; FRD 6.4 BR-1; US-3 AC-2; FRD 6.2.2 F-ID
  @TC_SF_180 @UIVisual @High @Automation
  Scenario: Verify the Currency Formats ID is displayed read-only on the Edit form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Currency' exists in the Currency tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | CF-0003 |
    When the user clicks Edit against 'Spare Currency'
    And the user tries to modify the ID field
    Then The ID is displayed as read-only and cannot be modified

  # Ref: FRD 6.2.2 F-Sample
  @TC_SF_181 @UIVisual @Medium @Automation
  Scenario: Verify the Sample area on the Currency Format form is read-only
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Form | Currency Format |
    When the user fills the form until a sample is shown
    And the user clicks inside the Sample area and try to type
    Then The Sample area is display-only and cannot be edited

  # Ref: FRD 6.2.2 F-Culture
  @TC_SF_182 @UIVisual @Medium @Automation
  Scenario: Verify dropdown fields on the Currency Format form allow selection only and not free text
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Dropdowns | Culture, Digit Group Symbol, Number Format, Negative Sign Symbol, No. of Digits after Decimal, Positive Format, Negative Format |
    When the user clicks each dropdown field
    And the user tries to type a custom value
    Then Only values from the configured list can be selected; typed values are not accepted

  # Ref: FRD 6.2 FB-2; FRD 6.2.3 F-ID; FRD 6.2.3 F-Culture; FRD 6.2.3 F-Name
  @TC_SF_183 @UIVisual @High @Automation
  Scenario: Verify the Date Time Format form shows all fields defined in the FRD
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Form | Date Time Format |
    When the user clicks 'Add'
    And the user inspects the fields on the form
    Then Fields displayed: Date & Time Formats ID, Culture, Name, Long Date Format, Date Separator, Short Date Format, Time Separator, AM Symbol, PM Symbol, Time Format, Sample (Long Date / Short Date / Time). Note: Field order on screen is not stated in the FRD; FRD table order assumed (OQ-16)

  # Ref: FRD 6.2 BR-2; FRD 6.2.3 F-ID
  @TC_SF_186 @UIVisual @High @Automation
  Scenario: Verify the Date & Time Formats ID is shown as read-only on the Add form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Value | Auto-generated |
    When the user observes the ID field
    And the user clicks inside it and try to type
    Then The field is read-only/disabled and cannot be edited

  # Ref: FRD 6.4 FB-2; FRD 6.4 BR-1; US-3 AC-2; FRD 6.2.3 F-ID
  @TC_SF_187 @UIVisual @High @Automation
  Scenario: Verify the Date & Time Formats ID is displayed read-only on the Edit form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Date Time' exists in the Date Time tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | DF-0003 |
    When the user clicks Edit against 'Spare Date Time'
    And the user tries to modify the ID field
    Then The ID is displayed as read-only and cannot be modified

  # Ref: FRD 6.2.3 F-Sample
  @TC_SF_188 @UIVisual @Medium @Automation
  Scenario: Verify the Sample area on the Date Time Format form is read-only
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Form | Date Time Format |
    When the user fills the form until a sample is shown
    And the user clicks inside the Sample area and try to type
    Then The Sample area is display-only and cannot be edited

  # Ref: FRD 6.2.3 F-Culture
  @TC_SF_189 @UIVisual @Medium @Automation
  Scenario: Verify dropdown fields on the Date Time Format form allow selection only and not free text
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Dropdowns | Culture, Long Date Format, Date Separator, Short Date Format, Time Separator, AM Symbol, PM Symbol, Time Format |
    When the user clicks each dropdown field
    And the user tries to type a custom value
    Then Only values from the configured list can be selected; typed values are not accepted

  # Ref: FRD 6.2.1 F-DecSym
  @TC_SF_190 @UIVisual @Medium @Automation
  Scenario: Verify Decimal Symbol is display-only on the Quantity form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format | 1,234,567.89 |
    When the user selects Number Format '1,234,567.89'
    And the user tries to change Decimal Symbol
    Then Decimal Symbol shows '.' as non-editable text

  # Ref: FRD 6.2.2 F-DecSym
  @TC_SF_191 @UIVisual @Medium @Automation
  Scenario: Verify Decimal Symbol is display-only on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Number Format | 1.234.567,89 |
    When the user selects Number Format '1.234.567,89'
    And the user tries to change Decimal Symbol
    Then Decimal Symbol shows ',' as non-editable text

  # Ref: FRD 6.2.2 F-Symbol
  @TC_SF_192 @UIVisual @Medium @Automation
  Scenario: Verify Symbol is display-only on the Currency form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Currency Format form (Currency tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture | English (India) |
    When the user selects Culture 'English (India)'
    And the user tries to type in the Symbol field
    Then Symbol shows '₹' and cannot be typed over or modified

  # Ref: FRD 6.1 BR-1; FRD 6.3 BR-1; FRD 6.3 C-Actions
  @TC_SF_194 @UIVisual @High @Automation
  Scenario: Verify Add, Edit and Delete are not displayed to a view-only user
    Given Viewer_User1 (Standards & Formats: view access only) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens each tab
    And the user inspects the toolbar and row actions
    Then 'Add', Edit and Delete are not displayed or are disabled; only view/search remains

  # Ref: FRD 6.1 FB-3; FRD 6.1 FB-4
  @TC_SF_195 @UIVisual @Medium @Automation
  Scenario: Verify all actions and tools are displayed to a user with Standards & Formats Management permission
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1 |
    When the user inspects the toolbar and row actions
    Then 'Add', search, Filter and View/Edit/Delete row actions are displayed
