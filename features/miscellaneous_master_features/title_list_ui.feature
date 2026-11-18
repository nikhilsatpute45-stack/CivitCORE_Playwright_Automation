@MiscellaneousMaster @TitleListUi
Feature: Title List UI
  Automated scenarios for the "Title List UI" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: Section 4 AC-SC-1; FRD 5.3 C-SL; FRD 5.3 C-EN; FRD 5.3 C-TI; FRD 5.3 C-PA; FRD 5.3 C-DI; FRD 5.3 C-AC
  @TC_MM_142 @UIVisual @High @Automation
  Scenario: Verify Title List column headers are Sl. No., Enum ID, Title, Parent Title, Display and Actions in this order
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Columns | Sl. No.      |
      | Data    | Enum ID      |
      | Data    | Title        |
      | Data    | Parent Title |
      | Data    | Display      |
      | Data    | Actions      |
    When the user opens Miscellaneous Master
    And the user observes the grid headers
    Then Exactly these six columns are present in this order with the correct labels and no extra columns

  # Ref: FRD 5.3 FB-3
  @TC_MM_143 @UIVisual @Medium @Automation
  Scenario: Verify search boxes exist below the Enum ID, Title, Parent Title and Display headers only
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Columns | Sl. No., Enum ID, Title, Parent Title, Display, Actions |
    When the user observes the area directly below each column header
    And the user looks above the grid for any separate search box
    Then Enum ID, Title and Parent Title have a text search box directly below the header; Display has a dropdown
    And Sl. No. and Actions have no search box and there is no separate search box above the grid

  # Ref: FRD 5.3 FB-3; FRD 5.3 C-DI
  @TC_MM_144 @UIVisual @Medium @Automation
  Scenario: Verify the Display search dropdown has the options All, Checked and Unchecked with All as default
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Dropdown options | All       |
      | Data             | Checked   |
      | Data             | Unchecked |
    When the user opens Miscellaneous Master
    And the user opens the Display search dropdown
    Then Options are All, Checked, Unchecked and 'All' is selected by default; the control is a dropdown, not free text

  # Ref: FRD 5.1 FB-3; FRD 5.3 C-AC
  @TC_MM_145 @UIVisual @Medium @Automation
  Scenario: Verify a kebab icon is present in the Actions column of every row
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Data | Baseline Titles 1-18 |
    When the user observes the Actions column across all rows of page 1
    Then Every row has a kebab icon in the Actions column
