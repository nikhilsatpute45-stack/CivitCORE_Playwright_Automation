@StandardsFormats @DateTimeFormatUpdate
Feature: Date & Time Format Update
  Automated scenarios for the "Date & Time Format Update" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-1; FRD 6.4 FB-3; FRD 6.4 FB-6; FRD Sec 8 Toaster #6
  @TC_SF_103 @Functional @High @Automation
  Scenario: Verify a Date & Time configuration is updated and the toaster is shown
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Date Time' exists in the Date Time tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record      | Spare Date Time (DF-0003) |
      | Time Format | HH:mm:ss                  |
    When the user clicks Edit against 'Spare Date Time'
    And the user changes Time Format from 'hh:mm:ss tt' to 'HH:mm:ss'
    And the user clicks Save
    Then Toaster 'Date & Time format updated successfully.' is displayed
    And The record shows Time Format = HH:mm:ss
    And Date & Time Formats ID DF-0003 is unchanged

  # Ref: FRD 6.4 BR-2; US-3 AC-1
  @TC_SF_104 @Functional @High @Automation
  Scenario: Verify the Date & Time update keeps the ID and does not create a new record
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Date Time' exists in the Date Time tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record   | DF-0003                |
      | New Name | Renamed Date & Time 01 |
    When the user notes the record count in the tab
    And the user edits 'Spare Date Time' and change the Name to 'Renamed Date & Time 01'
    And the user clicks Save
    And the user compares the record count and the ID
    Then Record count is unchanged
    And The renamed record keeps ID DF-0003; no new identity is created

  # Ref: US-3 AC-3; FRD 6.4 BR-3; FRD 6.6 BR-2
  @TC_SF_105 @Functional @High @Automation
  Scenario: Verify an Organization's reference continues to point to the same Date & Time ID after update
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Standard Date Time (DF-0001) is selected by ORG-001 'Alpha Infra Pvt Ltd'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record      | Standard Date Time (DF-0001) |
      | Time Format | HH:mm:ss                     |
    When the user edits 'Standard Date Time' and change Time Format to 'HH:mm:ss'
    And the user clicks Save
    And the user opens ORG-001 in Organization Management
    And the user checks its Date & Time selection
    Then ORG-001 still has DF-0001 selected, now showing the updated values
    And The selection is not removed

  # Ref: FRD 6.2 BR-5; FRD 6.4 BR-4
  @TC_SF_113 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces are trimmed when a Date & Time Name is updated
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Date Time' exists in the Date Time tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | DF-0003            |
      | Name   | ' Edited Name 02 ' |
    When the user edits 'Spare Date Time'
    And the user changes the Name to ' Edited Name 02 ' (2 leading/trailing spaces)
    And the user clicks Save
    And the user opens the record
    Then The Name is stored as 'Edited Name 02'

  # Ref: FRD 6.4 FB-4; FRD 6.4 BR-4
  @TC_SF_118 @Functional @High @Automation
  Scenario: Verify the same mandatory validation applies on update of a Date & Time configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Date Time' exists in the Date Time tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record        | DF-0003     |
      | Cleared field | Time Format |
    When the user edits 'Spare Date Time'
    And the user clears Time Format
    And the user clicks Save
    Then Save is blocked and the message 'Time Format is required' is displayed; the stored record is unchanged

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4 BR-4; FRD 6.2 BR-4; FRD 6.2.3 F-Name
  @TC_SF_253 @Negative @High @Automation
  Scenario: Verify updating a Date & Time Name to an existing Name is rejected
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Date Time' exists in the Date Time tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record   | DF-0003            |
      | New Name | STANDARD DATE TIME |
    When the user edits 'Spare Date Time'
    And the user changes Name to 'STANDARD DATE TIME'
    And the user clicks Save
    Then Save is blocked with 'Name already exists'; the record is unchanged

  # Ref: US-3 AC-2; FRD 6.4 BR-1; FRD 6.2 BR-2; FRD 6.2.3 F-ID
  @TC_SF_281 @Negative @High @Automation
  Scenario: Verify the Date & Time Formats ID cannot be changed through an update request
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Admin_User1 |
      | Record | DF-0003     |
      | New id | DF-9999     |
    When the user sends an update for DF-0003 with id 'DF-9999'
    And the user reads the record
    Then The update is rejected or the id is ignored; the record keeps ID DF-0003
