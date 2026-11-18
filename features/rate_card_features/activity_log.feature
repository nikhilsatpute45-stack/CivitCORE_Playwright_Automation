@RateCard @ActivityLog
Feature: Activity Log
  Automated scenarios for the "Activity Log" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1 AA-Created; US-11 AC-1; FRD 6 FB-1; FRD 6 FB-3; FRD 5.2 FB-5
  @TC_RC_108 @Functional @High @Automation
  Scenario: Verify a 'Rate Card Created' entry captures User, Date-Time and Rate Card Name
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Highland Zone |
      | User           | Admin_User1   |
    When the user adds Rate Card 'Highland Zone'
    And As Auditor_User1 open the Activity Log section and find the entry
    Then Entry 'Rate Card Created' shows User Admin_User1, Date-Time of the save and Rate Card Name 'Highland Zone'

  # Ref: FRD 6.1 AA-Updated; US-11 AC-2; FRD 5.5 FB-4
  @TC_RC_109 @Functional @High @Automation
  Scenario: Verify a 'Rate Card Updated' entry captures previous and new Rate Card Name
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Coastal Region -> Coastal Region East |
    When the user edits 'Coastal Region' to 'Coastal Region East' and Save
    And As Auditor_User1 open the Activity Log and find the entry
    Then Entry 'Rate Card Updated' shows User, Date-Time, previous name 'Coastal Region' and new name 'Coastal Region East'

  # Ref: FRD 6.1 AA-Deleted; US-11 AC-1; FRD 5.8 FB-5
  @TC_RC_110 @Functional @High @Automation
  Scenario: Verify a 'Rate Card Deleted' entry captures User, Date-Time and Rate Card Name
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Coastal Region |
    When the user deletes 'Coastal Region' (Yes)
    And As Auditor_User1 open the Activity Log and find the entry
    Then Entry 'Rate Card Deleted' shows User, Date-Time and Rate Card Name 'Coastal Region'

  # Ref: FRD 6.1 AA-Sequence; US-11 AC-1
  @TC_RC_111 @Functional @High @Automation
  Scenario: Verify a 'Sequence Changed' entry captures the moved Rate Card, previous position and new position
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Civit-ratecard |
      | Previous  | 3              |
      | New       | 1              |
    When the user drags 'Civit-ratecard' from position 3 to position 1
    And As Auditor_User1 open the Activity Log and find the entry
    Then Entry 'Sequence Changed' shows User, Date-Time, Rate Card Name 'Civit-ratecard', previous position 3 and new position 1

  # Ref: FRD 6.1 AA-Blocked; US-11 AC-1; FRD 5.8 FB-3
  @TC_RC_112 @Functional @High @Automation
  Scenario: Verify a 'Rate Card Deletion Blocked' entry captures the process in which the Rate Card is used
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Hill Zone     |
      | Used in   | Resource Rate |
    When the user selects Delete on 'Hill Zone' (used in Resource Rate RR-001)
    And As Auditor_User1 open the Activity Log and find the entry
    Then Entry 'Rate Card Deletion Blocked' shows User, Date-Time, Rate Card Name 'Hill Zone' and Reason 'Resource Rate'

  # Ref: FRD 6.1 AA-Blocked; FRD 5.8 FB-3
  @TC_RC_113 @Functional @Medium @Automation
  Scenario: Verify a 'Rate Card Deletion Blocked' entry lists every process in which the Rate Card is used
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Civit-ratecard |
      | Used in   | Office, Item   |
    When the user selects Delete on 'Civit-ratecard' (used in Office and Item ITM-002)
    And As Auditor_User1 open the Activity Log and find the entry
    Then Reason lists both 'Office' and 'Item'

  # Ref: FRD 6 FB-2
  @TC_RC_114 @Functional @High @Automation
  Scenario: Verify each Activity Log entry is linked to the Rate Card by Internal ID and survives a rename
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Highland Zone -> Highland Zone 2 |
    When the user creates 'Highland Zone', rename it to 'Highland Zone 2' and drag it to position 3
    And the user queries the Activity Log by the Rate Card Internal ID
    Then Entries Created, Updated and Sequence Changed are all returned for the same Internal ID

  # Ref: FRD 6 FB-3; FRD 6 FB-4
  @TC_RC_115 @Functional @Medium @Automation
  Scenario: Verify Activity Log entries capture user, date-time and activity type and are listed most recent first
    Given Auditor_User1 (Activity Log: View) is logged in and on the Activity Log section
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Highland Zone (Add then rename) |
    When the user performs an Add and then an Edit as Admin_User1
    And the user opens the Activity Log section
    And the user reads the first two entries
    Then First entry is 'Rate Card Updated', second is 'Rate Card Created' (most recent first)
    And Each entry shows user, date-time and activity type

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6 FB-4; US-11 AC-1
  @TC_RC_205 @Negative @High @Automation
  Scenario: Verify Activity Log entries cannot be edited or deleted by any user
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User  | Admin_User1                              |
      | Entry | 'Rate Card Created' for 'Coastal Region' |
    When the user sends an update request for an existing 'Rate Card Created' entry
    And the user sends a delete request for the same entry
    Then Both requests are rejected; the entry remains unchanged (read-only log)
