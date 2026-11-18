@StandardsFormats @QuantityFormatUpdate
Feature: Quantity Format Update
  Automated scenarios for the "Quantity Format Update" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-1; FRD 6.4 FB-3; FRD 6.4 FB-6; FRD Sec 8 Toaster #4
  @TC_SF_097 @Functional @High @Automation
  Scenario: Verify a Quantity configuration is updated and the toaster is shown
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record        | Spare Quantity (QF-0003) |
      | Number Format | 1.234.567,89             |
    When the user clicks Edit against 'Spare Quantity'
    And the user changes Number Format from '1,234,567.89' to '1.234.567,89'
    And the user clicks Save
    Then Toaster 'Quantity format updated successfully.' is displayed
    And The record shows Number Format = 1.234.567,89
    And Quantity Formats ID QF-0003 is unchanged

  # Ref: FRD 6.4 BR-2; US-3 AC-1
  @TC_SF_098 @Functional @High @Automation
  Scenario: Verify the Quantity update keeps the ID and does not create a new record
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record   | QF-0003             |
      | New Name | Renamed Quantity 01 |
    When the user notes the record count in the tab
    And the user edits 'Spare Quantity' and change the Name to 'Renamed Quantity 01'
    And the user clicks Save
    And the user compares the record count and the ID
    Then Record count is unchanged
    And The renamed record keeps ID QF-0003; no new identity is created

  # Ref: US-3 AC-3; FRD 6.4 BR-3; FRD 6.6 BR-2
  @TC_SF_099 @Functional @High @Automation
  Scenario: Verify an Organization's reference continues to point to the same Quantity ID after update
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Standard Quantity (QF-0001) is selected by ORG-001 'Alpha Infra Pvt Ltd'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record        | Standard Quantity (QF-0001) |
      | Number Format | 1.234.567,89                |
    When the user edits 'Standard Quantity' and change Number Format to '1.234.567,89'
    And the user clicks Save
    And the user opens ORG-001 in Organization Management
    And the user checks its Quantity selection
    Then ORG-001 still has QF-0001 selected, now showing the updated values
    And The selection is not removed

  # Ref: FRD 6.4 FB-5; FRD 6.6 BR-4
  @TC_SF_106 @Functional @High @Automation
  Scenario: Verify the updated configuration is immediately visible to every Organization that selected it
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And QF-0001 is selected by ORG-001 and ORG-002
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0001 |
      | Digits | 2 -> 3  |
    When the user edits 'Standard Quantity' and change No. of Digits after Decimal from 2 to 3
    And the user saves
    And the user opens ORG-001 and ORG-002 formatting defaults
    Then Both Organizations show 3 digits after decimal for Quantity without any further action

  # Ref: FRD 6.4 FB-1; FRD 6.4 FB-2
  @TC_SF_107 @Functional @High @Automation
  Scenario: Verify the Standards & Formats ID is shown read-only when editing from the list
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003 |
    When the user clicks Edit against 'Spare Quantity' in the list
    And the user observes the form
    Then The edit form opens with all type-specific fields editable and the Quantity Formats ID read-only

  # Ref: FRD 6.4 FB-1; FRD 6.4 FB-2
  @TC_SF_108 @Functional @Medium @Automation
  Scenario: Verify Edit can be started from the Detail view
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003 |
    When the user clicks View against 'Spare Quantity'
    And the user clicks Edit in the Detail view
    And the user observes the form
    Then The same edit form opens with editable fields and read-only ID

  # Ref: FRD 6.4 BR-4; FRD 6.2.1 F-Name
  @TC_SF_109 @Functional @High @Automation
  Scenario: Verify saving an edit without changing the Name does not raise 'Name already exists'
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003                    |
      | Name   | Spare Quantity (unchanged) |
    When the user edits 'Spare Quantity'
    And the user changes only Leading Zero from 0.7 to .7
    And the user clicks Save
    Then Save succeeds; the record is not treated as a duplicate of itself. Note: FRD does not state whether a record conflicts with itself on update (OQ-11)

  # Ref: FRD 6.4 BR-4; FRD 6.2.1 F-Name
  @TC_SF_110 @Functional @Low @Automation
  Scenario: Verify only the case of the Name can be changed on update
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003        |
      | Name   | SPARE QUANTITY |
    When the user edits 'Spare Quantity'
    And the user changes the Name to 'SPARE QUANTITY'
    And the user clicks Save
    Then Save succeeds with Name 'SPARE QUANTITY' (the record is not its own duplicate). Note: See OQ-11

  # Ref: FRD 6.2 BR-5; FRD 6.4 BR-4
  @TC_SF_111 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces are trimmed when a Quantity Name is updated
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003            |
      | Name   | ' Edited Name 02 ' |
    When the user edits 'Spare Quantity'
    And the user changes the Name to ' Edited Name 02 ' (2 leading/trailing spaces)
    And the user clicks Save
    And the user opens the record
    Then The Name is stored as 'Edited Name 02'

  # Ref: FRD 6.2.1 F-DecSym; FRD 6.4 FB-2
  @TC_SF_115 @Functional @Medium @Automation
  Scenario: Verify the Decimal Symbol refreshes when Number Format is changed during edit
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003 |
    When the user edits 'Spare Quantity'
    And the user changes Number Format to '1.234.567,89'
    And the user observes Decimal Symbol
    Then Decimal Symbol changes to ',' and remains non-editable

  # Ref: FRD 6.4 FB-4; FRD 6.4 BR-4
  @TC_SF_116 @Functional @High @Automation
  Scenario: Verify the same mandatory validation applies on update of a Quantity configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record        | QF-0003       |
      | Cleared field | Number Format |
    When the user edits 'Spare Quantity'
    And the user clears Number Format
    And the user clicks Save
    Then Save is blocked and the message 'Number Format is required' is displayed; the stored record is unchanged

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4 BR-4; FRD 6.2 BR-4; FRD 6.2.1 F-Name
  @TC_SF_251 @Negative @High @Automation
  Scenario: Verify updating a Quantity Name to an existing Name is rejected
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record   | QF-0003           |
      | New Name | STANDARD QUANTITY |
    When the user edits 'Spare Quantity'
    And the user changes Name to 'STANDARD QUANTITY'
    And the user clicks Save
    Then Save is blocked with 'Name already exists'; the record is unchanged

  # Ref: FRD 6.4 BR-4; FRD 6.2 BR-5
  @TC_SF_254 @Negative @Medium @Automation
  Scenario: Verify whitespace-only Name is rejected on update
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003 |
      | Name   | ' '     |
    When the user edits 'Spare Quantity'
    And the user replaces Name with 3 spaces
    And the user clicks Save
    Then Save is blocked with 'Name is required'; the record is unchanged

  # Ref: FRD 6.4 BR-4; FRD 6.2.1 F-Name
  @TC_SF_255 @Negative @Medium @Automation
  Scenario: Verify special characters in Name are rejected on update
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003    |
      | Name   | Spare$Qty! |
    When the user edits 'Spare Quantity'
    And the user changes Name to 'Spare$Qty!'
    And the user clicks Save
    Then Save is blocked; the record is unchanged

  # Ref: US-3 AC-2; FRD 6.4 BR-1; FRD 6.2 BR-2; FRD 6.2.1 F-ID
  @TC_SF_279 @Negative @High @Automation
  Scenario: Verify the Quantity Formats ID cannot be changed through an update request
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Admin_User1 |
      | Record | QF-0003     |
      | New id | QF-9999     |
    When the user sends an update for QF-0003 with id 'QF-9999'
    And the user reads the record
    Then The update is rejected or the id is ignored; the record keeps ID QF-0003
