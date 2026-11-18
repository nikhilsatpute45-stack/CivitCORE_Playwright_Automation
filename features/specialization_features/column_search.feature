@Specialization @ColumnSearch
Feature: Column Search
  Automated scenarios for the "Column Search" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.3 FB-5
  @TC_SP_054 @Functional @High @Automation
  Scenario: Verify Code search matches partial text ignoring letter case
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code search | mr |
    When the user types 'mr' in the Code search box
    And the user observes the list
    Then 'Mr.' and 'Mrs.' are shown; other entries are hidden

  # Ref: FRD 5.3 FB-5
  @TC_SP_055 @Functional @Medium @Automation
  Scenario: Verify the list is filtered as the user types without pressing Enter
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code search | D then Dr |
    When the user types 'D' in the Code search box and observe
    And the user types 'r' to make 'Dr'
    And the user observes the list without pressing Enter
    Then List filters after each character typed; 'Dr' leaves only 'Dr.'

  # Ref: FRD 5.3 FB-4; FRD 5.3 FB-5
  @TC_SP_056 @Functional @Medium @Automation
  Scenario: Verify Name column search matches partial text ignoring letter case
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Name search | MIS |
    When the user types 'MIS' in the Name search box
    And the user observes the list
    Then Only 'Miss' is shown; all other rows are hidden

  # Ref: FRD 5.3 FB-4; FRD 5.3 FB-5
  @TC_SP_057 @Functional @Medium @Automation
  Scenario: Verify Remark column search matches partial text ignoring letter case
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry 'Mr.' has Remark 'Adult male title' and 'Mrs.' has Remark 'Married woman'
    And the following test data is used
      | Remark search | MALE |
    When the user types 'MALE' in the Remark search box
    And the user observes the list
    Then Only the entry with Remark 'Adult male title' ('Mr.') is shown

  # Ref: FRD 5.3 FB-5
  @TC_SP_058 @Functional @High @Automation
  Scenario: Verify records must match all active column searches
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code search | m    |
      | Name search | miss |
    When the user types 'm' in the Code search box
    And the user types 'miss' in the Name search box
    And the user observes the list
    Then Only rows matching both searches are shown: 'Miss' alone ('Mr.', 'Mrs.', 'Smt.' and 'Ms.' match Code but not Name)

  # Ref: FRD 5.3 FB-6
  @TC_SP_059 @Functional @Medium @Automation
  Scenario: Verify clearing one column search removes only that filter
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Code search 'm' and Name search 'miss' are active
    And the following test data is used
      | Code search | m (kept)  |
      | Name search | (cleared) |
    When the user clears the Name search box
    And the user observes the list
    Then List filters by Code 'm' only ('Mr.', 'Mrs.', 'Miss', 'Smt.', 'Ms.' are shown)

  # Ref: FRD 5.3 FB-6
  @TC_SP_060 @Functional @Medium @Automation
  Scenario: Verify clearing all column searches shows the full list on page 1
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And Misc Type 'List of Qualification' with Code search 'Q02' active
    And the following test data is used
      | Cleared search | Q02 |
    When the user clears the Code search box
    And the user observes the list and page indicator
    Then Full list of 120 entries is shown on page 1 with indicator '1 / 3'

  # Ref: FRD 5.3 FB-7; FRD 5.3 C-SlNo
  @TC_SP_061 @Functional @Medium @Automation
  Scenario: Verify filtered results start at Sl. No. 1 as a running number
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code search | Q02 (matches Q020 to Q029) |
    When the user types 'Q02' in the Code search box
    And the user observes Sl. No. and row count
    Then 10 rows are shown with Sl. No. 1 to 10 (running number of the result set, not the original positions)

  # Ref: FRD 5.3 FB-7
  @TC_SP_062 @Functional @Medium @Automation
  Scenario: Verify filtered results are paginated starting from page 1
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code search | Q (matches all 120 entries) |
    When the user types 'Q' in the Code search box
    And the user observes the page indicator and Sl. No. on page 1
    And the user clicks Next
    Then Result opens on page 1 with indicator '1 / 3' and Sl. No. 1 to 50
    And Page 2 starts at Sl. No. 51

  # Ref: FRD 5.3 FB-9; FRD 5.3 ES-3
  @TC_SP_063 @Functional @High @Automation
  Scenario: Verify 'No records found.' is shown when no entry matches the search
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code search | zzz |
    When the user types 'zzz' in the Code search box
    And the user observes the grid
    Then Grid stays visible with message 'No records found.' and no illustration

  # Ref: FRD 5.3 FB-5
  @TC_SP_064 @Functional @Low @Automation
  Scenario: Verify the search treats special characters as plain text
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And Entry Code 'Dr.(Prof)' exists in 'List of Title'
    And the following test data is used
      | Code search | ( |
    When the user types '(' in the Code search box
    And the user observes the list
    Then Only entries whose Code contains '(' are shown (Dr.(Prof)); no error occurs
