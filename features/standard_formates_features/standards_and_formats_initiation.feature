@StandardsFormats @StandardsFormatsInitiation
Feature: Standards & Formats Initiation
  Automated scenarios for the "Standards & Formats Initiation" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1 FB-1; FRD 6.1 FB-2; US-2 AC-1
  @TC_SF_001 @Functional @High @Automation
  Scenario: Verify Standards & Formats Management opens with Quantity, Currency and Date Time tabs
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in to CivitCORE. Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1                                |
      | Menu | System Configuration > Standards & Formats |
    When the user logs in to CivitCORE as Admin_User1
    And the user navigates to System Configuration > Standards & Formats
    And the user observes the tabs shown on the screen
    Then Standards & Formats Management screen opens
    And Three tabs are displayed: 'Quantity', 'Currency' and 'Date Time'

  # Ref: US-2 AC-1; FRD 6.3 FB-1; FRD 6.1 FB-2
  @TC_SF_002 @Functional @High @Automation
  Scenario: Verify the Quantity tab lists only Quantity configurations
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Tab                       | Quantity                                                                 |
      | Expected baseline records | QF-0001 Standard Quantity, QF-0002 Euro Quantity, QF-0003 Spare Quantity |
    When the user clicks the 'Quantity' tab
    And the user observes the records listed
    And the user compares with the baseline records of the other two types
    Then The list shows the Quantity configurations (QF-0001, QF-0002, QF-0003)
    And No configuration of another type appears in this list

  # Ref: US-2 AC-1; FRD 6.3 FB-1; FRD 6.1 FB-2
  @TC_SF_003 @Functional @High @Automation
  Scenario: Verify the Currency tab lists only Currency configurations
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Tab                       | Currency                                                                 |
      | Expected baseline records | CF-0001 Standard Currency, CF-0004 Euro Currency, CF-0003 Spare Currency |
    When the user clicks the 'Currency' tab
    And the user observes the records listed
    And the user compares with the baseline records of the other two types
    Then The list shows the Currency configurations (CF-0001, CF-0004, CF-0003)
    And No configuration of another type appears in this list

  # Ref: US-2 AC-1; FRD 6.3 FB-1; FRD 6.1 FB-2
  @TC_SF_004 @Functional @High @Automation
  Scenario: Verify the Date Time tab lists only Date & Time configurations
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Tab                       | Date Time                                                                   |
      | Expected baseline records | DF-0001 Standard Date Time, DF-0004 Euro Date Time, DF-0003 Spare Date Time |
    When the user clicks the 'Date Time' tab
    And the user observes the records listed
    And the user compares with the baseline records of the other two types
    Then The list shows the Date & Time configurations (DF-0001, DF-0004, DF-0003)
    And No configuration of another type appears in this list

  # Ref: FRD 6.1 FB-3; FRD 6.3 FB-2
  @TC_SF_005 @Functional @High @Automation
  Scenario: Verify each tab shows an 'Add' action and search/filter tools
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Tabs | Quantity, Currency, Date Time |
    When the user opens the Quantity tab and note the toolbar
    And the user opens the Currency tab and note the toolbar
    And the user opens the Date Time tab and note the toolbar
    Then 'Add' action, keyword search box and Filter are displayed in every tab for the authorized user

  # Ref: FRD 6.1 FB-4; FRD 6.3 C-Actions
  @TC_SF_006 @Functional @High @Automation
  Scenario: Verify View, Edit and Delete actions are shown against each record for an authorized user
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Quantity tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1      |
      | Records | QF-0001, QF-0003 |
    When the user observes the Actions column of each record in the Quantity tab
    Then View, Edit and Delete actions are available against each record (Delete subject to the dependency check at click time, FRD 6.7). Note: FRD 6.3 Actions column lists Edit/Delete only while 6.1 FB-4 and US-2 AC-3 mention View (OQ-4)

  # Ref: FRD 6.1 BR-1; FRD 6.3 BR-1
  @TC_SF_007 @Functional @High @Automation
  Scenario: Verify a view-only user can view and search configurations but not create, edit or delete
    Given Viewer_User1 (Standards & Formats: view access only) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Viewer_User1 |
      | Search text | Standard     |
      | Record      | QF-0001      |
    When the user opens Standards & Formats Management > Quantity tab
    And the user searches for 'Standard' in the list
    And the user opens record 'Standard Quantity' (QF-0001) in View mode
    And the user inspects the actions available
    Then The list is visible and search returns 'Standard Quantity'
    And Record details can be viewed
    And Add, Edit and Delete actions are not available
