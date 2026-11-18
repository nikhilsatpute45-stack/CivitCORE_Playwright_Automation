@StandardsFormats @CurrencyFormatUpdate
Feature: Currency Format Update
  Automated scenarios for the "Currency Format Update" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-1; FRD 6.4 FB-3; FRD 6.4 FB-6; FRD Sec 8 Toaster #5
  @TC_SF_100 @Functional @High @Automation
  Scenario: Verify a Currency configuration is updated and the toaster is shown
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Currency' exists in the Currency tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record       | Spare Currency (CF-0003) |
      | Major Symbol | Rupees                   |
    When the user clicks Edit against 'Spare Currency'
    And the user changes Major Symbol from 'Rupee' to 'Rupees'
    And the user clicks Save
    Then Toaster 'Currency format updated successfully.' is displayed
    And The record shows Major Symbol = Rupees
    And Currency Formats ID CF-0003 is unchanged

  # Ref: FRD 6.4 BR-2; US-3 AC-1
  @TC_SF_101 @Functional @High @Automation
  Scenario: Verify the Currency update keeps the ID and does not create a new record
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Currency' exists in the Currency tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record   | CF-0003             |
      | New Name | Renamed Currency 01 |
    When the user notes the record count in the tab
    And the user edits 'Spare Currency' and change the Name to 'Renamed Currency 01'
    And the user clicks Save
    And the user compares the record count and the ID
    Then Record count is unchanged
    And The renamed record keeps ID CF-0003; no new identity is created

  # Ref: US-3 AC-3; FRD 6.4 BR-3; FRD 6.6 BR-2
  @TC_SF_102 @Functional @High @Automation
  Scenario: Verify an Organization's reference continues to point to the same Currency ID after update
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Standard Currency (CF-0001) is selected by ORG-001 'Alpha Infra Pvt Ltd'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record       | Standard Currency (CF-0001) |
      | Major Symbol | Rupees                      |
    When the user edits 'Standard Currency' and change Major Symbol to 'Rupees'
    And the user clicks Save
    And the user opens ORG-001 in Organization Management
    And the user checks its Currency selection
    Then ORG-001 still has CF-0001 selected, now showing the updated values
    And The selection is not removed

  # Ref: FRD 6.2 BR-5; FRD 6.4 BR-4
  @TC_SF_112 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces are trimmed when a Currency Name is updated
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Currency' exists in the Currency tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | CF-0003            |
      | Name   | ' Edited Name 02 ' |
    When the user edits 'Spare Currency'
    And the user changes the Name to ' Edited Name 02 ' (2 leading/trailing spaces)
    And the user clicks Save
    And the user opens the record
    Then The Name is stored as 'Edited Name 02'

  # Ref: FRD 6.2.2 F-Symbol; FRD 6.4 BR-4
  @TC_SF_114 @Functional @Medium @Automation
  Scenario: Verify Symbol refreshes when Culture is changed during edit
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Currency' exists in the Currency tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record  | CF-0003                                     |
      | Culture | German (Germany) -> English (United States) |
    When the user edits 'Spare Currency'
    And the user changes Culture from 'German (Germany)' to 'English (United States)'
    And the user observes Symbol before saving
    Then Symbol refreshes to the symbol of English (United States) ($) and cannot be typed over

  # Ref: FRD 6.4 FB-4; FRD 6.4 BR-4
  @TC_SF_117 @Functional @High @Automation
  Scenario: Verify the same mandatory validation applies on update of a Currency configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Currency' exists in the Currency tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record        | CF-0003      |
      | Cleared field | Major Symbol |
    When the user edits 'Spare Currency'
    And the user clears Major Symbol
    And the user clicks Save
    Then Save is blocked and the message 'Major Symbol is required' is displayed; the stored record is unchanged

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4 BR-4; FRD 6.2 BR-4; FRD 6.2.2 F-Name
  @TC_SF_252 @Negative @High @Automation
  Scenario: Verify updating a Currency Name to an existing Name is rejected
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Currency' exists in the Currency tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record   | CF-0003           |
      | New Name | STANDARD CURRENCY |
    When the user edits 'Spare Currency'
    And the user changes Name to 'STANDARD CURRENCY'
    And the user clicks Save
    Then Save is blocked with 'Name already exists'; the record is unchanged

  # Ref: US-3 AC-2; FRD 6.4 BR-1; FRD 6.2 BR-2; FRD 6.2.2 F-ID
  @TC_SF_280 @Negative @High @Automation
  Scenario: Verify the Currency Formats ID cannot be changed through an update request
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Admin_User1 |
      | Record | CF-0003     |
      | New id | CF-9999     |
    When the user sends an update for CF-0003 with id 'CF-9999'
    And the user reads the record
    Then The update is rejected or the id is ignored; the record keeps ID CF-0003
