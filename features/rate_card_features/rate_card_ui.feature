@RateCard @RateCardUi
Feature: Rate Card UI
  Automated scenarios for the "Rate Card UI" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.3 FB-4; FRD 5.3 C-Name; FRD 5.3 C-AssocOffices
  @TC_RC_121 @UIVisual @Medium @Automation
  Scenario: Verify a search box is shown only under Rate Card Name and Associated Offices headers
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Columns | Drag handle, Sl. No., Rate Card Name, Associated Offices, Actions |
    When the user observes the area directly below each column header
    Then Text search boxes are present directly below 'Rate Card Name' and 'Associated Offices'
    And No search box is present for Drag handle, Sl. No. or Actions

  # Ref: FRD 5.1 FB-3; FRD 5.3 C-Actions
  @TC_RC_122 @UIVisual @Medium @Automation
  Scenario: Verify every row shows a kebab (⋮) icon in the Actions column with the menu order View, Edit, Delete
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rows | 8 baseline Rate Cards |
    When the user observes the Actions column of all rows
    And the user opens the kebab menu of one row
    Then A kebab (⋮) icon is displayed on every row
    And Menu options appear in the order View, Edit, Delete

  # Ref: FRD 5.3 SEQ-1; FRD 5.3 C-Drag
  @TC_RC_123 @UIVisual @Medium @Automation
  Scenario: Verify a drag handle is displayed at the start of every row for a user with Edit permission
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1 |
    When the user observes the first cell of each row
    Then A drag handle is displayed at the start of each row and is enabled

  # Ref: FRD 5.3 FB-2
  @TC_RC_124 @UIVisual @Medium @Automation
  Scenario: Verify the pagination controls (First, Previous, page numbers, Next, Last and 'current page / total pages') are displayed
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Records | 120 |
      | Pages   | 3   |
    When the user observes the pagination area below the grid
    Then First, Previous, page numbers 1-3, Next, Last and the indicator '1 / 3' are displayed

  # Ref: FRD 5.3 FB-2
  @TC_RC_125 @UIVisual @Medium @Automation
  Scenario: Verify First and Previous are disabled on page 1 and Next and Last are disabled on the last page
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Records | 120 |
      | Pages   | 3   |
    When On page 1 observe the control states
    And the user clicks Last
    And the user observes the control states on page 3
    Then On page 1 First and Previous are disabled and Next/Last are enabled
    And On page 3 Next and Last are disabled and First/Previous are enabled

  # Ref: US-2 AC-1; FRD 5.2 FB-2; FRD 5.2 F-Name; FRD 5.2 F-Cancel
  @TC_RC_126 @UIVisual @High @Automation
  Scenario: Verify the Add Rate Card pop-up shows Rate Card Name, Associated Offices, Save, Cancel and the close (X) icon
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pop-up | Add Rate Card |
    When the user clicks 'Add'
    And the user inspects the pop-up
    Then Title 'Add Rate Card' is displayed
    And Fields 'Rate Card Name' (empty text box) and 'Associated Offices' are displayed
    And Buttons 'Save' and 'Cancel' and a close (X) icon are displayed; no other input is present

  # Ref: FRD 5.2 FB-2
  @TC_RC_127 @UIVisual @Low @Automation
  Scenario: Verify the cursor is placed in Rate Card Name when the Add Rate Card pop-up opens
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pop-up | Add Rate Card |
    When the user clicks 'Add'
    And the user checks which element has focus
    Then The cursor (focus) is in the Rate Card Name text box

  # Ref: US-2 AC-1; FRD 5.2 F-AssocOffices; FRD 5.2 BR-6
  @TC_RC_128 @UIVisual @High @Automation
  Scenario: Verify the Associated Offices field on Add shows 'No offices associated yet' and is read-only
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field | Associated Offices |
    When the user clicks 'Add'
    And the user tries to click and type in Associated Offices
    Then Associated Offices shows 'No offices associated yet'
    And The field cannot be edited and no control to add/remove an office exists

  # Ref: FRD 5.2 F-Save; FRD 5.2 FB-3
  @TC_RC_129 @UIVisual @Medium @Automation
  Scenario: Verify the Save button is enabled when the Add pop-up opens
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pop-up | Add Rate Card |
    When the user clicks 'Add'
    And the user observes the Save button state without entering any value
    Then Save is enabled (always enabled; validations run on click)

  # Ref: US-3 AC-3; FRD 5.6 BR-1; FRD 5.2 F-AssocOffices
  @TC_RC_131 @UIVisual @High @Automation
  Scenario: Verify the Associated Offices field is read-only in the Edit Rate Card pop-up with no add/remove control
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Sub Mountanious |
    When the user selects Edit from the kebab menu of 'Sub Mountanious'
    And the user tries to modify the Associated Offices list
    Then Associated Offices is displayed read-only with the office names
    And No control to add or remove an office is displayed

  # Ref: FRD 5.4 FB-2; US-4 AC-1
  @TC_RC_132 @UIVisual @Medium @Automation
  Scenario: Verify all fields in the View Rate Card pop-up are read-only and the buttons are Edit (permission based) and Close
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Sub Mountanious |
    When the user selects View from the kebab menu of 'Sub Mountanious'
    And the user tries to type in each field
    And the user observes the buttons and the close (X) icon
    Then Title 'View Rate Card' is shown
    And All fields are read-only
    And 'Edit' and 'Close' buttons and the close (X) icon are displayed

  # Ref: FRD 5.2 BR-7
  @TC_RC_139 @UIVisual @Medium @Automation
  Scenario: Verify the Internal ID is not displayed on any screen
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1 |
    When the user inspects the Rate Card List columns
    And the user opens Add, View and Edit pop-ups and inspect every field
    Then No Internal ID is displayed in the list, Add, View or Edit pop-ups

  # Ref: FRD 5.8 BR-3
  @TC_RC_140 @UIVisual @Medium @Automation
  Scenario: Verify no multi-select or bulk-delete control exists on the Rate Card List
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1 |
    When the user inspects the grid and toolbar for checkboxes or a bulk Delete action
    Then No selection checkbox or bulk delete action is available; Delete is available only per row through the kebab menu
