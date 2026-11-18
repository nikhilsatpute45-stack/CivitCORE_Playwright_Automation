@WorkSubType @WorkSubTypeListViewColumnSearch
Feature: Work Sub Type List View / Column Search
  Automated scenarios for the "Work Sub Type List View / Column Search" module of Work Sub Type.
  Source: CivitINFRA_WorkSubType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-006_CivitINFRA Configuration_Work Sub Type.pdf (PRD Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-2; FRD 5.3 FB-1
  @TC_WST_014 @Functional @High @Automation
  Scenario: Verify Work Type rows are ordered newest first, as in the Work Type screen
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Expected order | Bridge, Water Supply, Road, Building |
    When the user observes the order of Work Type rows
    And the user opens the Work Type screen (CIC-F-005) and compare the order
    Then Work Type rows are shown newest first (Bridge, Water Supply, Road, Building) and match the Work Type screen order

  # Ref: FRD 5.3 FB-1
  @TC_WST_015 @Functional @Medium @Automation
  Scenario: Verify every Work Type is shown, including a Work Type without any Work Sub Types
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Bridge (no Work Sub Types) |
    When the user locates Work Type row 'Bridge'
    Then 'Bridge' row is displayed although it has no Work Sub Types

  # Ref: US-1 AC-2; FRD 5.3 FB-2
  @TC_WST_016 @Functional @High @Automation
  Scenario: Verify Work Sub Types under a parent are ordered by creation date-time, newest first
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Building | IB, OB, RB |
      | Road     | SH, NH     |
    When the user expands Work Type 'Building'
    And the user observes the order of Level 1 rows
    And the user expands 'Road' and observe the Level 1 rows
    Then Under 'Building' the Level 1 order is IB, OB, RB
    And Under 'Road' the Level 1 order is SH, NH (newest first)

  # Ref: US-1 AC-1; FRD 5.3 FB-2
  @TC_WST_017 @Functional @High @Automation
  Scenario: Verify children of a Work Sub Type are shown beneath it down to Level 4, newest first
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Hierarchy | NH > NH-SEC > NH-SEC-A > NH-SEC-A1; NH > NH-BYP |
    When the user observes the rows beneath 'NH - National Highway'
    Then Beneath NH: NH-SEC (newer) then NH-BYP (older)
    And NH-SEC-A appears under NH-SEC and NH-SEC-A1 (Level 4) under NH-SEC-A

  # Ref: US-1 AC-3; FRD 5.3 BR-3
  @TC_WST_018 @Functional @High @Automation
  Scenario: Verify Sl. No. is hierarchical under each Work Type (1, 1.1, 1.1.1, 1.1.1.1)
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Road | SH=1, NH=2, NH-SEC=2.1, NH-SEC-A=2.1.1, NH-SEC-A1=2.1.1.1, NH-BYP=2.2 |
    When the user observes Sl. No. of all Work Sub Types under 'Road'
    Then Sl. No. values are exactly 1, 2, 2.1, 2.1.1, 2.1.1.1, 2.2 as listed

  # Ref: FRD 5.3 BR-4
  @TC_WST_019 @Functional @Medium @Automation
  Scenario: Verify the Sl. No. example: newer child of Sl. No. 2 is 2.1 and the older is 2.2
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Newer child | NH-SEC |
      | Older child | NH-BYP |
    When the user observes the two children of 'NH - National Highway' (Sl. No. 2) under 'Road'
    Then 'NH-SEC' (newer) is numbered 2.1 and 'NH-BYP' (older) is numbered 2.2

  # Ref: FRD 5.3 BR-3
  @TC_WST_020 @Functional @Medium @Automation
  Scenario: Verify Sl. No. restarts from 1 under each Work Type
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Building | IB |
      | Road     | SH |
    When the user observes Sl. No. of the first Level 1 row under 'Building' and under 'Road'
    Then The first Level 1 row under each Work Type is numbered 1 ('IB' under Building, 'SH' under Road)

  # Ref: US-1 AC-4; FRD 5.3 FB-3
  @TC_WST_021 @Functional @High @Automation
  Scenario: Verify all Work Type rows and Work Sub Type rows that have children are expanded when the screen opens
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rows | Road, NH, NH-SEC, NH-SEC-A, Building, RB |
    When the user opens the Work Sub Type screen afresh
    And the user observes the expand/collapse icons and visible rows
    Then Every Work Type row and every Work Sub Type row with children shows the collapse (−) icon and is expanded; all rows to Level 4 are visible

  # Ref: US-1 AC-4; FRD 5.3 FB-3
  @TC_WST_022 @Functional @High @Automation
  Scenario: Verify clicking the collapse (−) icon hides all rows below the row
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | NH - National Highway |
    When the user clicks the collapse (−) icon on 'NH - National Highway'
    Then NH-SEC, NH-SEC-A, NH-SEC-A1 and NH-BYP are hidden
    And The icon on the NH row changes to expand (+)

  # Ref: US-1 AC-4; FRD 5.3 FB-3
  @TC_WST_023 @Functional @High @Automation
  Scenario: Verify clicking expand (+) shows only direct children and keeps each child's own expanded/collapsed state
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rows | NH, NH-SEC |
    When the user clicks collapse (−) on 'NH-SEC - NH Sections'
    And the user clicks collapse (−) on 'NH - National Highway'
    And the user clicks expand (+) on 'NH - National Highway'
    Then NH-SEC and NH-BYP are shown (direct children)
    And NH-SEC stays collapsed, so NH-SEC-A and NH-SEC-A1 remain hidden

  # Ref: US-1 AC-5; FRD 5.3 FB-3; FRD 5.3 FB-4
  @TC_WST_024 @Functional @Medium @Automation
  Scenario: Verify a Work Type with no Work Sub Types shows 'No Work Sub Types added.' beneath it when expanded
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Bridge |
    When the user observes Work Type row 'Bridge' (expanded)
    Then The 'Bridge' row shows the expand/collapse icon and, beneath it, the text "No Work Sub Types added."

  # Ref: FRD 5.3 FB-4; FRD 5.3 C-WST
  @TC_WST_025 @Functional @Medium @Automation
  Scenario: Verify a Work Sub Type without children shows no expand/collapse icon and no message
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rows | SH, NH-BYP |
    When the user observes rows 'SH - State Highway' and 'NH-BYP - NH Bypass'
    Then Neither row shows an expand/collapse icon; no 'No Work Sub Types added.' message is displayed beneath them

  # Ref: FRD 5.3 FB-3; US-4 AC-2; FRD 5.4 FB-4
  @TC_WST_026 @Functional @Medium @Automation
  Scenario: Verify the expanded/collapsed state is kept after View and Close
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Collapsed     | Building |
      | Record viewed | SH       |
    When the user collapses 'Building'
    And the user clicks kebab of 'SH - State Highway' and select View
    And the user clicks Close
    Then The list returns with 'Building' still collapsed

  # Ref: FRD 5.3 FB-3
  @TC_WST_027 @Functional @Medium @Automation
  Scenario: Verify the expanded/collapsed state is kept after Edit and Cancel
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Collapsed | Building |
      | Record    | SH       |
    When the user collapses 'Building'
    And the user opens Edit for 'SH - State Highway'
    And the user clicks Cancel
    Then The pop-up closes and 'Building' remains collapsed

  # Ref: FRD 5.3 FB-3
  @TC_WST_028 @Functional @Medium @Automation
  Scenario: Verify the expanded/collapsed state is reset to all expanded when the screen is reopened
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Collapsed before leaving | Road, Building |
    When the user collapses 'Road' and 'Building'
    And the user navigates to another screen
    And the user reopens Admin > Configuration > Work Category > Work Sub Type
    Then All Work Type rows and all rows with children are expanded

  # Ref: FRD 5.3 BR-2
  @TC_WST_029 @Functional @Medium @Automation
  Scenario: Verify default Work Types are available in the system so the empty state is not shown under normal conditions
    Given A freshly installed CivitINFRA environment with default master data only
    And Admin_User1 is logged in
    And the following test data is used
      | Environment | default master data (no manual Work Type created) |
    When the user opens the Work Sub Type screen
    Then Default Work Types are listed as rows on the screen
    And The empty state is not displayed

  # Ref: US-1 AC-6; FRD 5.1 FB-3; FRD 5.3 E-When; FRD 5.3 E-Head; FRD 5.3 E-Msg; FRD 5.3 E-Btn; FRD 5.3 E-List
  @TC_WST_030 @Functional @High @Automation
  Scenario: Verify the empty state is displayed when no Work Type exists
    Given Admin_User1 is logged in
    And Environment has no Work Type records in the Work Type master (CIC-F-005)
    And the following test data is used
      | Work Types | none |
    When the user opens Admin > Configuration > Work Category > Work Sub Type
    Then Illustration is displayed centered
    And Heading "No Work Types available" is displayed
    And Message "Add Work Types first in Work Category → Work Type to add Work Sub Types." is displayed
    And 'Add' button, list, column headers and column search are not displayed

  # Ref: FRD 5.3 E-When; FRD 5.1 FB-2
  @TC_WST_031 @Functional @Medium @Automation
  Scenario: Verify the empty state is not shown when Work Types exist without any Work Sub Type
    Given Admin_User1 is logged in
    And Only Work Type 'Bridge' exists and it has no Work Sub Types
    And the following test data is used
      | Work Types | Bridge only |
    When the user opens the Work Sub Type screen
    Then The list is shown with the 'Bridge' row and "No Work Sub Types added."
    And The empty state (illustration, heading, message) is not displayed
    And 'Add' button is displayed

  # Ref: FRD 5.3 BR-5
  @TC_WST_032 @Functional @Medium @Automation
  Scenario: Verify a renamed Work Type is shown with the new name the next time the list is loaded
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rename | Building -> Buildings |
    When the user opens the Work Type screen and rename 'Building' to 'Buildings'
    And the user reloads the Work Sub Type screen
    Then The Work Type row now shows 'Buildings'; its Work Sub Types are unchanged

  # Ref: FRD 5.3 FB-7
  @TC_WST_033 @Functional @High @Automation
  Scenario: Verify the list is filtered as the user types in the Code column search
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search (Code) | N, then NH |
    When the user clicks the Code column search box
    And the user types 'N'
    And the user types 'H' so the text is 'NH'
    Then The list is filtered after each keystroke without any button click

  # Ref: FRD 5.3 FB-7; FRD 5.3 FB-6
  @TC_WST_034 @Functional @High @Automation
  Scenario: Verify Code column search matches partial text
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search (Code) | SEC |
    When the user types 'SEC' in the Code column search box
    Then NH-SEC, NH-SEC-A and NH-SEC-A1 are shown (with their ancestors); other Work Sub Types are hidden

  # Ref: FRD 5.3 FB-7
  @TC_WST_035 @Functional @High @Automation
  Scenario: Verify Name column search ignores letter case and matches partial text
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search (Name) | high |
    When the user types 'high' in the Work Sub Type Name column search box
    Then 'NH - National Highway' and 'SH - State Highway' are shown

  # Ref: FRD 5.3 FB-6
  @TC_WST_036 @Functional @Medium @Automation
  Scenario: Verify column search covers Work Sub Types at all levels
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search (Name) | Sub Section |
    When the user types 'Sub Section' in the Work Sub Type Name column search box
    Then Level 4 row 'NH-SEC-A1 - Sub Section A1' is found and displayed

  # Ref: FRD 5.3 FB-7
  @TC_WST_037 @Functional @High @Automation
  Scenario: Verify that when both column searches have values only rows matching both are shown
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code | NH     |
      | Name | bypass |
    When the user types 'NH' in the Code column search
    And the user types 'bypass' in the Name column search
    Then Only 'NH-BYP - NH Bypass' (plus its ancestors) is shown as a match; NH-SEC rows are not shown

  # Ref: FRD 5.3 FB-8
  @TC_WST_038 @Functional @High @Automation
  Scenario: Verify a matching Work Sub Type is displayed together with its Work Type and all ancestors, all expanded
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code search | A1 |
    When the user collapses 'Road'
    And the user types 'A1' in the Code column search
    Then Work Type 'Road' and ancestors NH, NH-SEC, NH-SEC-A are shown expanded with matching row 'NH-SEC-A1'; the earlier collapsed state is not kept

  # Ref: FRD 5.3 FB-8
  @TC_WST_039 @Functional @Medium @Automation
  Scenario: Verify rows keep their Sl. No. from the full list while a search is active
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code search | BYP |
    When the user types 'BYP' in the Code column search
    Then 'NH-BYP' is still numbered 2.2 and ancestor 'NH' is still numbered 2

  # Ref: FRD 5.3 FB-8; FRD 5.3 E-When
  @TC_WST_040 @Functional @Medium @Automation
  Scenario: Verify "No records found." is shown when no Work Sub Type matches the search
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code search | ZZZ |
    When the user types 'ZZZ' in the Code column search box
    Then The list shows "No records found."
    And The empty state ("No Work Types available") is not displayed

  # Ref: FRD 5.3 FB-9
  @TC_WST_041 @Functional @Medium @Automation
  Scenario: Verify clearing the search boxes restores the full list with every row expanded
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code search | NH, then cleared |
    When the user collapses 'Road'
    And the user types 'NH' in the Code column search
    And the user clears the search box
    Then The full list is restored with every row expanded; the collapsed state from before the search is not kept

  # Ref: FRD 5.3 FB-10
  @TC_WST_042 @Functional @Medium @Automation
  Scenario: Verify search values and expanded/collapsed state are kept after an Edit
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search    | NH             |
      | Collapsed | Building       |
      | New Name  | NH Bypass Road |
    When the user collapses 'Building'
    And the user types 'NH' in the Code column search
    And the user edits 'NH-BYP' and change Name to 'NH Bypass Road'
    And the user clicks Save
    Then After the list refreshes the Code search still contains 'NH' and 'Building' remains collapsed

  # Ref: FRD 5.3 FB-10
  @TC_WST_043 @Functional @Medium @Automation
  Scenario: Verify search values and expanded/collapsed state are kept after a Delete
    Given Admin_User1 (Work Sub Type: View/Add/Edit/Delete) is logged in and on the Work Sub Type screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search    | SH       |
      | Collapsed | Building |
      | Record    | SH       |
    When the user collapses 'Building'
    And the user types 'SH' in the Code column search
    And the user deletes 'SH - State Highway' and click Yes
    Then After the list refreshes the Code search still contains 'SH' and 'Building' remains collapsed
