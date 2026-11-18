@Specialization @SpecializationUi
Feature: Specialization UI
  Automated scenarios for the "Specialization UI" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-5; FRD 5.3 DS-5; FRD 5.3 C-Drag
  @TC_SP_147 @UIVisual @High @Automation
  Scenario: Verify drag handles are disabled while a column search is active
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Code search | m |
    When the user types 'm' in the Code search box
    And the user tries to drag the first visible row
    Then Drag handles are disabled and rows cannot be moved

  # Ref: US-3 AC-5; FRD 5.3 DS-5
  @TC_SP_148 @UIVisual @High @Automation
  Scenario: Verify drag handles are disabled for a user without Edit permission
    Given Adder_User1 (Specialization: View/Add) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Adder_User1 (View+Add) |
    When the user observes the drag handles
    And the user tries to drag row 'Dr.'
    Then Drag handles are disabled and the row cannot be moved

  # Ref: FRD 5.2 F-MiscType; FRD 5.2 BR-1
  @TC_SP_152 @UIVisual @Medium @Automation
  Scenario: Verify Misc Type in the Add pop-up is read-only text and cannot be edited
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Misc Type | List of Title |
    When the user clicks 'Add'
    And the user clicks on the Misc Type value and try to type or change it
    Then Misc Type is plain text that cannot be edited or changed

  # Ref: US-1 AC-5; FRD 5.1 BR-2
  @TC_SP_162 @UIVisual @Medium @Automation
  Scenario: Verify the empty-state 'Add' button is shown to a user with Add permission
    Given Adder_User1 (Specialization: View/Add) is logged in and on the Specialization screen with Misc Type 'List of Firm Type' selected
    And Baseline data (see Summary) is loaded. 'List of Firm Type' has no Specialization Entries
    And the following test data is used
      | User | Adder_User1 |
    When the user selects 'List of Firm Type'
    And the user observes the empty state
    Then 'Add' button is displayed on the empty state

  # Ref: US-1 AC-7; FRD 5.1 FB-3
  @TC_SP_163 @UIVisual @High @Automation
  Scenario: Verify the kebab menu shows only View for a View-only user
    Given Viewer_User1 (Specialization: View only) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user clicks the kebab icon on 'Mr.'
    And the user reads the menu
    Then Menu shows only View

  # Ref: US-1 AC-4; FRD 5.1 BR-2
  @TC_SP_164 @UIVisual @High @Automation
  Scenario: Verify the 'Add' button is not shown to a user without Add permission
    Given Editor_User1 (Specialization: View/Edit) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Editor_User1 (View+Edit) |
    When the user observes the area above the list
    Then 'Add' button is not displayed

  # Ref: US-1 AC-5; FRD 5.1 BR-2
  @TC_SP_165 @UIVisual @High @Automation
  Scenario: Verify the 'Add' button is not shown on the empty state to a user without Add permission
    Given Viewer_User1 (Specialization: View only) is logged in and on the Specialization screen with Misc Type 'List of Firm Type' selected
    And Baseline data (see Summary) is loaded. 'List of Firm Type' has no Specialization Entries
    And the following test data is used
      | User | Viewer_User1 |
    When the user selects 'List of Firm Type'
    And the user observes the empty state
    Then Empty state heading and message are shown but no 'Add' button

  # Ref: US-1 AC-7; FRD 5.1 BR-2
  @TC_SP_166 @UIVisual @High @Automation
  Scenario: Verify the kebab menu shows View and Edit but not Delete to a user without Delete permission
    Given Editor_User1 (Specialization: View/Edit) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Editor_User1 (View+Edit) |
    When the user clicks the kebab icon on 'Mr.'
    And the user reads the menu
    Then Menu shows View and Edit only

  # Ref: US-1 AC-7; FRD 5.1 BR-2
  @TC_SP_167 @UIVisual @High @Automation
  Scenario: Verify the kebab menu shows View and Delete but not Edit to a user without Edit permission
    Given Deleter_User1 (Specialization: View/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Deleter_User1 (View+Delete) |
    When the user clicks the kebab icon on 'Mr.'
    And the user reads the menu
    Then Menu shows View and Delete only

  # Ref: US-4 AC-2; FRD 5.1 BR-2
  @TC_SP_168 @UIVisual @High @Automation
  Scenario: Verify the Edit button on the View pop-up is hidden for a user without Edit permission
    Given Viewer_User1 (Specialization: View only) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens View for 'Mr.'
    And the user observes the buttons
    Then Only 'Close' (and the X icon) is displayed; no 'Edit' button

  # Ref: US-1 AC-4; FRD 5.1 BR-2
  @TC_SP_169 @UIVisual @Medium @Automation
  Scenario: Verify the 'Add' button is shown to a user with Add permission on the list
    Given Adder_User1 (Specialization: View/Add) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Adder_User1 (View+Add) |
    When the user observes the area above the list
    Then 'Add' button is displayed above the list
