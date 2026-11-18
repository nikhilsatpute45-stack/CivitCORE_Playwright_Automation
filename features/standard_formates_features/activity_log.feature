@StandardsFormats @ActivityLog
Feature: Activity Log
  Automated scenarios for the "Activity Log" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 7.1 A-Created; FRD 7 FB-1; FRD 7 FB-2; US-6 AC-1; FRD 6.2 FB-6
  @TC_SF_149 @Functional @High @Automation
  Scenario: Verify 'Standard & Format Created' is logged when a Quantity configuration is created
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
    When the user creates Quantity format 'Metric Quantity 01'
    And the user opens the Activity Log of the new record
    Then An entry 'Standard & Format Created' exists with User 'Admin_User1', Date/Time, the generated ID, Configuration Type 'Quantity' and Name 'Metric Quantity 01'

  # Ref: FRD 7.1 A-Updated; FRD 7 FB-3; US-6 AC-1; FRD 6.4 FB-6
  @TC_SF_150 @Functional @High @Automation
  Scenario: Verify 'Standard & Format Updated' captures Field Changed, Previous Value and New Value for a Quantity update
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record          | QF-0003     |
      | Positive Format | 1.1 -> +1.1 |
    When the user edits 'Spare Quantity'
    And the user changes Positive Format from '1.1' to '+1.1'
    And the user saves
    And the user opens the Activity Log
    Then An entry 'Standard & Format Updated' exists with User, Date/Time, QF-0003, Configuration Type 'Quantity', Field Changed 'Positive Format', Previous Value '1.1', New Value '+1.1'

  # Ref: FRD 7.1 A-Deleted; US-6 AC-1; FRD 6.7 FB-5; FRD 6.7 DT-3
  @TC_SF_151 @Functional @High @Automation
  Scenario: Verify 'Standard & Format Deleted' is logged when a Quantity configuration is deleted
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Spare Quantity (QF-0003) |
    When the user deletes 'Spare Quantity' and confirm
    And the user opens the Activity Log for that ID
    Then An entry 'Standard & Format Deleted' exists with User, Date/Time, QF-0003, Configuration Type 'Quantity' and Name 'Spare Quantity'

  # Ref: FRD 7.1 A-Blocked; US-6 AC-1; US-6 AC-2; FRD 6.7 DT-1
  @TC_SF_152 @Functional @High @Automation
  Scenario: Verify 'Standard/Format Deletion Blocked' identifies the Organization dependency for a Quantity configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in. 'Standard Quantity' (QF-0001) is selected by ORG-001
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record     | Standard Quantity (QF-0001) |
      | Dependency | ORG-001                     |
    When the user clicks Delete against 'Standard Quantity' (blocked)
    And the user opens the Activity Log for that ID
    Then An entry 'Standard/Format Deletion Blocked' exists with User, Date/Time, QF-0001, Configuration Type 'Quantity', Name 'Standard Quantity' and Blocking Dependency 'Organization Dependency'

  # Ref: FRD 7.1 A-Created; FRD 7 FB-1; FRD 7 FB-2; US-6 AC-1; FRD 6.2 FB-6
  @TC_SF_153 @Functional @High @Automation
  Scenario: Verify 'Standard & Format Created' is logged when a Currency configuration is created
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
    When the user creates Currency format 'Indian Rupee Retail'
    And the user opens the Activity Log of the new record
    Then An entry 'Standard & Format Created' exists with User 'Admin_User1', Date/Time, the generated ID, Configuration Type 'Currency' and Name 'Indian Rupee Retail'

  # Ref: FRD 7.1 A-Updated; FRD 7 FB-3; US-6 AC-1; FRD 6.4 FB-6
  @TC_SF_154 @Functional @High @Automation
  Scenario: Verify 'Standard & Format Updated' captures Field Changed, Previous Value and New Value for a Currency update
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Currency' exists in the Currency tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record       | CF-0003        |
      | Minor Symbol | Paise -> Paisa |
    When the user edits 'Spare Currency'
    And the user changes Minor Symbol from 'Paise' to 'Paisa'
    And the user saves
    And the user opens the Activity Log
    Then An entry 'Standard & Format Updated' exists with User, Date/Time, CF-0003, Configuration Type 'Currency', Field Changed 'Minor Symbol', Previous Value 'Paise', New Value 'Paisa'

  # Ref: FRD 7.1 A-Deleted; US-6 AC-1; FRD 6.7 FB-5; FRD 6.7 DT-3
  @TC_SF_155 @Functional @High @Automation
  Scenario: Verify 'Standard & Format Deleted' is logged when a Currency configuration is deleted
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Currency' exists in the Currency tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Spare Currency (CF-0003) |
    When the user deletes 'Spare Currency' and confirm
    And the user opens the Activity Log for that ID
    Then An entry 'Standard & Format Deleted' exists with User, Date/Time, CF-0003, Configuration Type 'Currency' and Name 'Spare Currency'

  # Ref: FRD 7.1 A-Blocked; US-6 AC-1; US-6 AC-2; FRD 6.7 DT-1
  @TC_SF_156 @Functional @High @Automation
  Scenario: Verify 'Standard/Format Deletion Blocked' identifies the Organization dependency for a Currency configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in. 'Standard Currency' (CF-0001) is selected by ORG-001
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record     | Standard Currency (CF-0001) |
      | Dependency | ORG-001                     |
    When the user clicks Delete against 'Standard Currency' (blocked)
    And the user opens the Activity Log for that ID
    Then An entry 'Standard/Format Deletion Blocked' exists with User, Date/Time, CF-0001, Configuration Type 'Currency', Name 'Standard Currency' and Blocking Dependency 'Organization Dependency'

  # Ref: FRD 7.1 A-Created; FRD 7 FB-1; FRD 7 FB-2; US-6 AC-1; FRD 6.2 FB-6
  @TC_SF_157 @Functional @High @Automation
  Scenario: Verify 'Standard & Format Created' is logged when a Date & Time configuration is created
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Date Time tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India)    |
      | Name              | India Date Time 01 |
      | Long Date Format  | dd MMMM yyyy       |
      | Date Separator    | /                  |
      | Short Date Format | dd/MM/yyyy         |
      | Time Separator    | :                  |
      | AM Symbol         | AM                 |
      | PM Symbol         | PM                 |
      | Time Format       | hh:mm:ss tt        |
    When the user creates Date & Time format 'India Date Time 01'
    And the user opens the Activity Log of the new record
    Then An entry 'Standard & Format Created' exists with User 'Admin_User1', Date/Time, the generated ID, Configuration Type 'Date & Time' and Name 'India Date Time 01'

  # Ref: FRD 7.1 A-Updated; FRD 7 FB-3; US-6 AC-1; FRD 6.4 FB-6
  @TC_SF_158 @Functional @High @Automation
  Scenario: Verify 'Standard & Format Updated' captures Field Changed, Previous Value and New Value for a Date & Time update
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Date Time' exists in the Date Time tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record         | DF-0003 |
      | Date Separator | / -> -  |
    When the user edits 'Spare Date Time'
    And the user changes Date Separator from '/' to '-'
    And the user saves
    And the user opens the Activity Log
    Then An entry 'Standard & Format Updated' exists with User, Date/Time, DF-0003, Configuration Type 'Date & Time', Field Changed 'Date Separator', Previous Value '/', New Value '-'

  # Ref: FRD 7.1 A-Deleted; US-6 AC-1; FRD 6.7 FB-5; FRD 6.7 DT-3
  @TC_SF_159 @Functional @High @Automation
  Scenario: Verify 'Standard & Format Deleted' is logged when a Date & Time configuration is deleted
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Date Time' exists in the Date Time tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Spare Date Time (DF-0003) |
    When the user deletes 'Spare Date Time' and confirm
    And the user opens the Activity Log for that ID
    Then An entry 'Standard & Format Deleted' exists with User, Date/Time, DF-0003, Configuration Type 'Date & Time' and Name 'Spare Date Time'

  # Ref: FRD 7.1 A-Blocked; US-6 AC-1; US-6 AC-2; FRD 6.7 DT-1
  @TC_SF_160 @Functional @High @Automation
  Scenario: Verify 'Standard/Format Deletion Blocked' identifies the Organization dependency for a Date & Time configuration
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in. 'Standard Date Time' (DF-0001) is selected by ORG-001
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record     | Standard Date Time (DF-0001) |
      | Dependency | ORG-001                      |
    When the user clicks Delete against 'Standard Date Time' (blocked)
    And the user opens the Activity Log for that ID
    Then An entry 'Standard/Format Deletion Blocked' exists with User, Date/Time, DF-0001, Configuration Type 'Date & Time', Name 'Standard Date Time' and Blocking Dependency 'Organization Dependency'

  # Ref: FRD 7 FB-2
  @TC_SF_161 @Functional @Medium @Automation
  Scenario: Verify each update entry is associated with the Standards & Formats ID of the record
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Records | QF-0003, QF-0002 |
    When the user updates 'Spare Quantity' and 'Euro Quantity'
    And the user opens the Activity Log of each
    Then Each entry appears only against its own ID

  # Ref: FRD 7 FB-4
  @TC_SF_162 @Functional @Medium @Automation
  Scenario: Verify the Activity Log lists entries most recent first
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003 |
    When the user edits 'Spare Quantity' twice (Digits 2->3, then 3->2)
    And the user opens the Activity Log
    Then Entries are listed in chronological order with the most recent update first

  # Ref: FRD 7 FB-4
  @TC_SF_163 @Functional @High @Automation
  Scenario: Verify the Activity Log is read-only
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003 |
    When the user opens the Activity Log of 'Spare Quantity'
    And the user looks for edit or delete options on entries
    Then Entries cannot be edited or deleted

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 7 FB-1
  @TC_SF_297 @Negative @Medium @Automation
  Scenario: Verify a blocked save due to validation does not create an Activity Log entry
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Quantity Format form (Quantity tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field | Culture |
    When the user leaves Culture blank
    And the user clicks Save (blocked)
    And the user checks Activity Log for new entries
    Then No 'Standard & Format Created' entry is created

  # Ref: FRD 7 FB-1; FRD 6.7 FB-6
  @TC_SF_298 @Negative @Medium @Automation
  Scenario: Verify a cancelled delete does not create a deletion entry
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Euro Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0002 |
    When the user clicks Delete against 'Euro Quantity'
    And the user clicks Cancel
    And the user checks the Activity Log
    Then No 'Standard & Format Deleted' entry is created

  # Ref: FRD 7 FB-4
  @TC_SF_299 @Negative @High @Automation
  Scenario: Verify Activity Log entries cannot be modified via API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Admin_User1       |
      | Record | QF-0003 log entry |
    When the user sends an update to an existing log entry of QF-0003
    And the user sends a delete for the same entry
    Then Both requests are rejected; the log is read-only
