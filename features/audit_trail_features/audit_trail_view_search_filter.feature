@AuditTrail @AuditTrailViewSearchFilter
Feature: Audit Trail View / Search / Filter
  Automated scenarios for the "Audit Trail View / Search / Filter" area of the CivitCORE Audit Trail.
  Source: CivitCORE_AuditTrail_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-005 CivitCORE CORE Module - Audit Trail, Ver 1.0, 28-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-2; FRD 6.3 BR-2; FRD 6.3 F-Functions
  @TC_CP_004 @Functional @High @Automation
  Scenario: Verify Functions filter defaults to 'All' on screen load (Ref US-2 AC-2, FRD 6.3 BR-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | All (default) |
    When Open the Audit Trail screen
    And Read the selected value of the Functions dropdown
    Then Functions dropdown shows 'All' by default.

  # Ref: US-2 AC-1; FRD 6.3 BR-3; FRD 6.3 F-To; FRD 6.3 FB-2
  @TC_CP_005 @Functional @High @Automation
  Scenario: Verify To Date defaults to today's date on screen load (Ref US-2 AC-1, FRD 6.3 BR-3)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | To Date | 16-Nov-2026 (T) |
    When Open the Audit Trail screen
    And Read the To Date value
    Then To Date is set to today's date (16-Nov-2026).

  # Ref: US-2 AC-1; FRD 6.3 BR-4; FRD 6.3 F-From; FRD 6.3 FB-2
  @TC_CP_006 @Functional @High @Automation
  Scenario: Verify From Date defaults to exactly 30 calendar days before today (Ref US-2 AC-1, FRD 6.3 BR-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | From Date | 17-Oct-2026 (T minus 30) |
      | To Date   | 16-Nov-2026 |
    When Open the Audit Trail screen
    And Read the From Date value
    And Compare it with To Date
    Then From Date is set to 17-Oct-2026, exactly 30 calendar days before To Date (today).

  # Ref: FRD 6.3 BR-5; FRD 6.3 BR-4
  @TC_CP_007 @Functional @Medium @Automation
  Scenario: Verify default From Date counts calendar days, not business days (From Date falls on a Saturday) (Ref FRD 6.3 BR-5, FRD 6.3 BR-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | From Date | 17-Oct-2026 (Saturday) |
      | To Date   | 16-Nov-2026 (Monday) |
    When Open the Audit Trail screen
    And Read the From Date value (17-Oct-2026 is a Saturday)
    And Confirm it is not shifted to the previous Friday or the next Monday
    Then From Date remains 17-Oct-2026; no weekend/business-day adjustment is applied.

  # Ref: FRD 6.3 BR-4; FRD 6.3 BR-5; US-2 AC-1
  @TC_CP_008 @Functional @Medium @Automation
  Scenario: Verify default From Date across a year boundary (Ref FRD 6.3 BR-4, FRD 6.3 BR-5)
    Given Admin_User1 is logged in
    And System date is set to 10-Jan-2027
    And the following test data is used
      | System date        | 10-Jan-2027 |
      | Expected From Date | 11-Dec-2026 |
    When Open the Audit Trail screen
    And Read From Date and To Date
    Then To Date = 10-Jan-2027 and From Date = 11-Dec-2026 (30 calendar days before).

  # Ref: FRD 6.3 BR-4; FRD 6.3 BR-5
  @TC_CP_009 @Functional @Low @Automation
  Scenario: Verify default From Date in a non-leap-year February (Ref FRD 6.3 BR-4, FRD 6.3 BR-5)
    Given Admin_User1 is logged in
    And System date is set to 01-Mar-2027
    And the following test data is used
      | System date        | 01-Mar-2027 |
      | Expected From Date | 30-Jan-2027 |
    When Open the Audit Trail screen
    And Read From Date and To Date
    Then To Date = 01-Mar-2027 and From Date = 30-Jan-2027 (28-day February handled correctly).

  # Ref: FRD 6.3 BR-4; FRD 6.3 BR-5
  @TC_CP_010 @Functional @Low @Automation
  Scenario: Verify default From Date in a leap-year February (Ref FRD 6.3 BR-4, FRD 6.3 BR-5)
    Given Admin_User1 is logged in
    And System date is set to 01-Mar-2028
    And the following test data is used
      | System date        | 01-Mar-2028 |
      | Expected From Date | 31-Jan-2028 |
    When Open the Audit Trail screen
    And Read From Date and To Date
    Then To Date = 01-Mar-2028 and From Date = 31-Jan-2028 (29-day February handled correctly).

  # Ref: US-2 AC-3; FRD 6.3 FB-2
  @TC_CP_011 @Functional @High @Automation
  Scenario: Verify default listing shows entries for All functions in the default range, most recent on top (Ref US-2 AC-3, FRD 6.3 FB-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | All |
      | Range    | 17-Oct-2026 to 16-Nov-2026 |
    When Open the Audit Trail screen
    And Observe the Audit Log grid without changing any filter
    Then Grid shows exactly 7 entries, ordered most recent first: 16-Nov 09:30 Department; 14-Nov 15:10 Post; 12-Nov 11:45 Office; 10-Nov 16:20 Department; 01-Nov 10:05 Office; 20-Oct 13:40 Organization; 17-Oct 00:00 Post.
    And Entries dated before 17-Oct-2026 (e.g., 16-Oct 23:59:59) are not shown.

  # Ref: FRD 6.3 FB-3
  @TC_CP_012 @Functional @Medium @Automation
  Scenario: Verify Search action is inactive on initial load (Ref FRD 6.3 FB-3)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Filters | unchanged defaults |
    When Open the Audit Trail screen
    And Inspect the Search action state without changing any filter
    Then Search action is inactive (disabled).

  # Ref: FRD 6.3 FB-3; FRD 6.3 F-Functions
  @TC_CP_013 @Functional @Medium @Automation
  Scenario: Verify Search becomes active when the Functions selection changes (Ref FRD 6.3 FB-3, FRD 6.3 F-Functions)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Function | Department |
    When Change Functions from 'All' to 'Department'
    And Inspect the Search action state
    Then Search action becomes active.

  # Ref: FRD 6.3 FB-3; FRD 6.3 F-From
  @TC_CP_014 @Functional @Medium @Automation
  Scenario: Verify Search becomes active when From Date changes (Ref FRD 6.3 FB-3, FRD 6.3 F-From)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From Date | 01-Nov-2026 |
    When Change From Date from 17-Oct-2026 to 01-Nov-2026
    And Inspect the Search action state
    Then Search action becomes active.

  # Ref: FRD 6.3 FB-3; FRD 6.3 F-To
  @TC_CP_015 @Functional @Medium @Automation
  Scenario: Verify Search becomes active when To Date changes (Ref FRD 6.3 FB-3, FRD 6.3 F-To)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | To Date | 12-Nov-2026 |
    When Change To Date from 16-Nov-2026 to 12-Nov-2026
    And Inspect the Search action state
    Then Search action becomes active.

  # Ref: FRD 6.3 FB-3; FRD 6.3 FB-4
  @TC_CP_016 @Functional @Low @Automation
  Scenario: Verify Search returns to inactive after the filter is applied and values equal the applied values (assumption) (Ref FRD 6.3 FB-3, FRD 6.3 FB-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Function | Department |
    When Change Functions to 'Department' (Search becomes active)
    And Click Search
    And Inspect the Search action state
    Then Filter is applied; Search action is inactive again because the selection equals the currently applied values.
    And Note: FRD wording 'from their currently applied values' implies this; confirm with BA.

  # Ref: US-3 AC-1; FRD 6.3 FB-4
  @TC_CP_017 @Functional @High @Automation
  Scenario: Verify filtering by a specific Function (Department) returns only that Function's entries (Ref US-3 AC-1, FRD 6.3 FB-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Function | Department |
      | Range    | 17-Oct-2026 to 16-Nov-2026 |
    When Select Function 'Department'
    And Click Search
    Then Grid shows only 2 Department entries: 16-Nov-2026 09:30 and 10-Nov-2026 16:20.
    And No entries of other Functions are displayed.

  # Ref: US-3 AC-1; FRD 6.3 FB-4
  @TC_CP_018 @Functional @High @Automation
  Scenario: Verify filtering by a specific Function (Post) returns only that Function's entries (Ref US-3 AC-1, FRD 6.3 FB-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Function | Post |
      | Range    | 17-Oct-2026 to 16-Nov-2026 |
    When Select Function 'Post'
    And Click Search
    Then Grid shows only 2 Post entries: 14-Nov-2026 15:10 (deletion blocked) and 17-Oct-2026 00:00.

  # Ref: US-3 AC-2; FRD 6.3 FB-4
  @TC_CP_019 @Functional @High @Automation
  Scenario: Verify selecting 'All' and applying the filter returns entries of all Functions (Ref US-3 AC-2, FRD 6.3 FB-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Function | Post then All |
      | Range    | default |
    When Select Function 'Post' and click Search
    And Select Function 'All'
    And Click Search
    Then Grid shows all 7 entries across Department, Office, Organization and Post for the selected date range.

  # Ref: US-3 AC-3; FRD 6.3 BR-10; FRD 6.3 F-Functions
  @TC_CP_020 @Functional @High @Automation
  Scenario: Verify Functions dropdown lists only configured Function values (Ref US-3 AC-3, FRD 6.3 BR-10)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Expected list | All, Department, Office, Organization, Post, Standards & Formats |
    When Open the Functions dropdown
    And Compare the listed values with the backend Function/Class Name/Message configuration
    Then Dropdown lists 'All' plus only the Functions configured in the backend mapping; no unconfigured value is listed.

  # Ref: FRD 6.3 BR-10; FRD 6.2 BR-5
  @TC_CP_021 @Functional @High @Automation
  Scenario: Verify every function generating audit-eligible transactions is configured in the Audit Trail mapping (go-live prerequisite) (Ref FRD 6.3 BR-10, FRD 6.2 BR-5)
    Given Backend configuration and the inventory of CRUD functions of CivitCORE and applicable Civit products are accessible to the tester
    And the following test data is used
      | Functions | Department, Office, Organization, Post, Standards & Formats |
    When Export the list of functions that perform Creation/Updation/Deletion
    And Export the Audit Trail Function/Class Name/Message mapping
    And Compare both lists
    Then Every audit-eligible function has a Function, Class Name and Message mapping; no function is missing from the Audit Trail configuration.

  # Ref: US-4 AC-1; FRD 6.3 BR-6; FRD 6.3 F-From; FRD 6.3 F-To
  @TC_CP_022 @Functional @High @Automation
  Scenario: Verify filtering by a modified valid date range (Ref US-4 AC-1, FRD 6.3 BR-6)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From     | 01-Nov-2026 |
      | To       | 12-Nov-2026 |
      | Function | All |
    When Set From Date = 01-Nov-2026
    And Set To Date = 12-Nov-2026
    And Keep Function = All and click Search
    Then Grid shows 3 entries: 12-Nov 11:45 Office; 10-Nov 16:20 Department; 01-Nov 10:05 Office.
    And Entries outside the range are not displayed.

  # Ref: US-4 AC-2
  @TC_CP_023 @Functional @High @Automation
  Scenario: Verify results of the new range replace the default-range results (Ref US-4 AC-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 01-Nov-2026 |
      | To   | 12-Nov-2026 |
    When Note the 7 default entries
    And Change From Date to 01-Nov-2026 and To Date to 12-Nov-2026
    And Click Search
    Then Previously displayed default-range results are replaced by the 3 entries of the new range.

  # Ref: FRD 6.3 BR-6; US-4 AC-1
  @TC_CP_024 @Functional @Medium @Automation
  Scenario: Verify a range wider than the default 30 days returns older entries (Ref FRD 6.3 BR-6, US-4 AC-1)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From     | 01-Sep-2026 |
      | To       | 16-Nov-2026 |
      | Function | All |
    When Set From Date = 01-Sep-2026
    And Keep To Date = 16-Nov-2026
    And Click Search
    Then Grid also contains the older entries (e.g., 25-Sep Office, 20-Sep Department, 05-Sep Standards & Formats, 01-Oct Post, 16-Oct Post).

  # Ref: US-3 AC-1; US-4 AC-1; FRD 6.3 FB-4
  @TC_CP_025 @Functional @High @Automation
  Scenario: Verify combined Function and date-range filter (Ref US-3 AC-1, US-4 AC-1)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Function | Department |
      | From     | 01-Sep-2026 |
      | To       | 16-Nov-2026 |
    When Select Function 'Department'
    And Set From Date = 01-Sep-2026
    And Click Search
    Then Grid shows 3 Department entries: 16-Nov 09:30, 10-Nov 16:20, 20-Sep 14:00.

  # Ref: FRD 6.3 BR-7; FRD 6.3 BR-8; FRD 6.3 FB-4
  @TC_CP_026 @Functional @Medium @Automation
  Scenario: Verify a single-day range (From Date = To Date) is accepted (Ref FRD 6.3 BR-7, FRD 6.3 BR-8)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 12-Nov-2026 |
      | To   | 12-Nov-2026 |
    When Set From Date = 12-Nov-2026
    And Set To Date = 12-Nov-2026
    And Click Search
    Then No validation error; grid shows the 1 entry logged on 12-Nov-2026 (Office deleted, 11:45).

  # Ref: FRD 6.3 FB-4; FRD 6.3 BR-4
  @TC_CP_027 @Functional @Medium @Automation
  Scenario: Verify From Date boundary is inclusive (entry at 00:00:00 included, 23:59:59 of the previous day excluded) (assumption) (Ref FRD 6.3 FB-4, FRD 6.3 BR-4)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Entries             | Post 17-Oct-2026 00:00:00 |
      | Post 16-Oct-2026 23 | 59:59 |
    When Keep From Date = 17-Oct-2026 and To Date = 16-Nov-2026
    And Click Search (or use the default view)
    And Check the entries at 17-Oct-2026 00:00:00 and 16-Oct-2026 23:59:59
    Then Entry dated 17-Oct-2026 00:00:00 is displayed.
    And Entry dated 16-Oct-2026 23:59:59 is not displayed.
    And Note: FRD does not state inclusive boundaries; confirm with BA.

  # Ref: FRD 6.3 BR-3; FRD 6.3 BR-8; FRD 6.3 F-To
  @TC_CP_028 @Functional @Medium @Automation
  Scenario: Verify To Date = today is accepted and includes entries logged today (Ref FRD 6.3 BR-3, FRD 6.3 BR-8)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | To Date  | 16-Nov-2026 |
      | Function | Department |
    When Confirm To Date = 16-Nov-2026
    And Click Search after setting Function = Department
    Then Today's date is accepted; the entry logged on 16-Nov-2026 09:30 is displayed.

  # Ref: FRD 6.3 BR-6; US-4 AC-1
  @TC_CP_029 @Functional @Medium @Automation
  Scenario: Verify user can modify both From Date and To Date (Ref FRD 6.3 BR-6, US-4 AC-1)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From | 20-Oct-2026 |
      | To   | 14-Nov-2026 |
    When Change From Date to 20-Oct-2026
    And Change To Date to 14-Nov-2026
    And Click Search
    Then Both fields accept the new values; grid shows 5 entries from 20-Oct-2026 13:40 to 14-Nov-2026 15:10.

  # Ref: US-11 AC-1; US-11 AC-2; FRD 6.3 FB-6
  @TC_CP_030 @Functional @High @Automation
  Scenario: Verify 'No records found' state when no entries match the Function and range (Ref US-11 AC-1, US-11 AC-2)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Function | Standards & Formats |
      | Range    | 17-Oct-2026 to 16-Nov-2026 |
    When Select Function 'Standards & Formats'
    And Keep the default range
    And Click Search
    Then Grid shows the 'No records found' state.
    And No error message is displayed.

  # Ref: US-11 AC-1; FRD 6.3 FB-6
  @TC_CP_031 @Functional @Medium @Automation
  Scenario: Verify 'No records found' state for a date range with no entries across all Functions (Ref US-11 AC-1, FRD 6.3 FB-6)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | From     | 01-Jan-2026 |
      | To       | 31-Jan-2026 |
      | Function | All |
    When Set From Date = 01-Jan-2026
    And Set To Date = 31-Jan-2026
    And Keep Function = All and click Search
    Then 'No records found' state is displayed and is not treated as an error.

  # Ref: FRD 6.3 C-SlNo
  @TC_CP_032 @Functional @Medium @Automation
  Scenario: Verify Sl No. is a sequential row number for the currently displayed result set (Ref FRD 6.3 C-SlNo)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Function | Department |
      | Range    | default |
    When Select Function 'Department' and click Search
    And Read the Sl No. column
    Then Sl No. shows 1 and 2 for the two displayed rows (renumbered for this result set, not carried over from the full list).

  # Ref: FRD 6.3 C-Function
  @TC_CP_033 @Functional @Medium @Automation
  Scenario: Verify Function Name column shows the Function against which the transaction was performed (Ref FRD 6.3 C-Function)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Entry | Department created 16-Nov-2026 09:30 |
    When Open the Audit Trail screen
    And Read the Function Name of the 16-Nov-2026 09:30 entry
    Then Function Name = 'Department'.

  # Ref: FRD 6.3 C-LogDT
  @TC_CP_034 @Functional @Medium @Automation
  Scenario: Verify Log Date & Time column shows the date and time the entry was recorded (Ref FRD 6.3 C-LogDT)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Entry | Post deletion blocked 14-Nov-2026 15:10:00 |
    When Open the Audit Trail screen
    And Read the Log Date & Time of the 14-Nov-2026 15:10 entry
    Then Log Date & Time = 14-Nov-2026 15:10 (matches the recorded timestamp).

  # Ref: FRD 6.3 C-Class; FRD 6.2 FB-3
  @TC_CP_035 @Functional @Medium @Automation
  Scenario: Verify Class Name column shows the backend-configured identifier (Ref FRD 6.3 C-Class, FRD 6.2 FB-3)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Entry                 | Office deleted |
      | Configured Class Name | CivitCORE.Office.OfficeMaster (placeholder) |
    When Open the Audit Trail screen
    And Read the Class Name of the 12-Nov-2026 11:45 entry
    Then Class Name equals the Class Name configured in the backend for Function 'Office'.

  # Ref: FRD 6.3 C-IP
  @TC_CP_036 @Functional @Medium @Automation
  Scenario: Verify Client IP column shows the IP address of the client system (Ref FRD 6.3 C-IP)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Entry | Department created from 192.168.1.25 |
    When Open the Audit Trail screen
    And Read the Client IP of the 16-Nov-2026 09:30 entry
    Then Client IP = 192.168.1.25.

  # Ref: FRD 6.3 C-Message; FRD 7.1 A-Update
  @TC_CP_037 @Functional @Medium @Automation
  Scenario: Verify Message column shows the system-generated transaction message (Ref FRD 6.3 C-Message, FRD 7.1 A-Update)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Entry | Department updated 10-Nov-2026 16:20 |
    When Open the Audit Trail screen
    And Read the Message of the 10-Nov-2026 16:20 entry
    Then Message = 'Department updated successfully.' (backend-configured text for Updation).

  # Ref: US-5 AC-1; FRD 6.2 BR-6
  @TC_CP_038 @Functional @High @Automation
  Scenario: Verify all fields of an Audit Log entry are displayed as read-only (Ref US-5 AC-1, FRD 6.2 BR-6)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Row | first row of the default grid |
    When Inspect a grid row
    And Click/double-click each of Sl No., Function Name, Log Date & Time, Class Name, Client IP and Message
    Then All six fields are rendered as plain read-only text; no input control, edit icon or inline editor appears.

  # Ref: FRD 6.3 FB-7; FRD 6.2 FB-5
  @TC_CP_039 @Functional @High @Automation
  Scenario: Verify a newly created audit entry is available in the listing without any manual step (Ref FRD 6.3 FB-7, FRD 6.2 FB-5)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Department | Civil Works |
    When Create Department 'Civil Works' in the Department module
    And Navigate to Audit Trail (default filters)
    And Locate the new entry
    Then New entry for Function 'Department' is displayed at the top of the list without any manual record creation.

  # Ref: FRD 6.3 BR-1; US-13 AC-2
  @TC_CP_040 @Functional @High @Automation
  Scenario: Verify the Audit Trail listing is viewable by any user holding View Audit Trail (Ref FRD 6.3 BR-1, US-13 AC-2)
    Given Viewer_User1 (View Audit Trail only, no Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User     | Viewer_User1 |
      | Function | Office |
    When Open the Audit Trail screen
    And Apply Function 'Office' and click Search
    Then Listing is displayed and the filter returns the 2 Office entries of the default range.

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.3 F-Functions; US-3 AC-3
  @TC_CP_124 @Negative @Medium @Automation
  Scenario: Verify free-text entry in Functions is not permitted (Ref FRD 6.3 F-Functions, US-3 AC-3)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Typed text | Invoice Register |
    When Click the Functions control
    And Type 'Invoice Register' and press Enter
    Then Free text is not accepted; the control keeps its previous valid value.

  # Ref: FRD 6.3 F-Functions
  @TC_CP_125 @Negative @Medium @Automation
  Scenario: Verify the Functions dropdown cannot be left blank (Ref FRD 6.3 F-Functions)
    Given Admin_User1 (View Audit Trail + Clear Audit Log) is logged in
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And Audit Trail screen is open with default filters
    And the following test data is used
      | Function | (empty) attempt |
    When Open the Functions dropdown
    And Look for a blank/none option or attempt to clear the selection
    Then No blank option is offered; Functions always holds 'All' or a configured Function (mandatory field).

  # Ref: US-3 AC-3; FRD 6.3 BR-10; FRD 6.3 F-Functions
  @TC_CP_126 @Negative @High @Automation
  Scenario: Verify an unconfigured Function value is rejected via API (Ref US-3 AC-3, FRD 6.3 BR-10)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | User     | Admin_User1 |
      | Function | Invoice Register |
    When Send get-audit-entries with function='Invoice Register', from=2026-10-17, to=2026-11-16
    And Check the response
    Then Request is rejected (validation error); no entries are returned and the value is not processed.

  # Ref: FRD 6.3 BR-10; FRD 6.3 F-Functions
  @TC_CP_127 @Negative @High @Automation
  Scenario: Verify SQL-injection payload in the Function parameter is rejected (Ref FRD 6.3 BR-10, FRD 6.3 F-Functions)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | Function | ' OR '1'='1 |
    When Send get-audit-entries with function="' OR '1'='1"
    And Check the response and audit store integrity
    Then Request is rejected as an unconfigured Function; no data is leaked and no query manipulation occurs.

  # Ref: FRD 6.3 F-From; FRD 6.3 BR-9
  @TC_CP_128 @Negative @High @Automation
  Scenario: Verify malicious date parameter is rejected via API (Ref FRD 6.3 F-From, FRD 6.3 BR-9)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | From | 2026-11-01'; DROP TABLE AuditLog;-- |
    When Send get-audit-entries with from="2026-11-01'; DROP TABLE AuditLog;--" and to=2026-11-16
    Then Request is rejected as an invalid date; audit table is intact.

  # Ref: FRD 6.3 BR-7; FRD 6.3 BR-9; US-12 AC-1
  @TC_CP_129 @Negative @High @Automation
  Scenario: Verify API rejects From Date later than To Date (Ref FRD 6.3 BR-7, FRD 6.3 BR-9)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | From | 2026-11-10 |
      | To   | 2026-11-05 |
    When Send get-audit-entries with from=2026-11-10 and to=2026-11-05
    Then Request is rejected with a validation error; no results returned (server-side enforcement of the same rule).

  # Ref: FRD 6.3 BR-8; US-12 AC-2
  @TC_CP_130 @Negative @High @Automation
  Scenario: Verify API rejects a future To Date (Ref FRD 6.3 BR-8, US-12 AC-2)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline audit data (see Summary) is loaded
    And Today (T) = 16-Nov-2026
    And the following test data is used
      | To | 2026-11-17 |
    When Send get-audit-entries with to=2026-11-17
    Then Request is rejected with a validation error.
