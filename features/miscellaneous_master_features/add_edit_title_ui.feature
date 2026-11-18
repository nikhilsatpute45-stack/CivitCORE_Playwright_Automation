@MiscellaneousMaster @AddEditTitleUi
Feature: Add / Edit Title UI
  Automated scenarios for the "Add / Edit Title UI" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.2 FB-2; FRD 5.2 F-FT; FRD 5.2 F-PT; FRD 5.2 F-EN; FRD 5.2 F-DS; FRD 5.2 F-BT
  @TC_MM_150 @UIVisual @High @Automation
  Scenario: Verify the Add Title form shows Field Title, Parent Title, Enum ID, Display, Save and Cancel
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Form | Add Title |
    When the user clicks 'Add'
    And the user inspects all elements of the pop-up
    Then Pop-up shows Field Title (text box), Parent Title (dropdown), Enum ID (text box), Display (checkbox) and buttons Save and Cancel; no Internal ID field is shown

  # Ref: FRD 5.2 F-FT
  @TC_MM_153 @UIVisual @High @Automation
  Scenario: Verify Field Title stops accepting typing at 100 characters
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed text | 101 characters |
    When the user clicks 'Add'
    And the user types 101 characters into Field Title
    Then The box contains only the first 100 characters; the 101st character is not accepted

  # Ref: FRD 5.2 F-FT
  @TC_MM_154 @UIVisual @High @Automation
  Scenario: Verify pasted text longer than 100 characters in Field Title is cut at 100
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pasted text | 150 characters |
    When the user clicks 'Add'
    And the user pastes 150 characters into Field Title
    Then Field Title contains exactly the first 100 characters of the pasted text

  # Ref: FRD 5.2 F-EN
  @TC_MM_155 @UIVisual @High @Automation
  Scenario: Verify Enum ID stops accepting typing at 10 characters
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed text | 12345678901 |
    When the user clicks 'Add'
    And the user types 11 digits into Enum ID
    Then The box contains only '1234567890'; the 11th character is not accepted

  # Ref: FRD 5.2 F-EN
  @TC_MM_156 @UIVisual @High @Automation
  Scenario: Verify pasted text longer than 10 characters in Enum ID is cut at 10
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pasted text | 123456789012345 |
    When the user clicks 'Add'
    And the user pastes 15 digits into Enum ID
    Then Enum ID contains exactly '1234567890'

  # Ref: Section 4 AC-VW-2; FRD 5.4 FB-3
  @TC_MM_160 @UIVisual @High @Automation
  Scenario: Verify the Edit button is not displayed on View for a user without Edit permission
    Given Viewer_User1 (Miscellaneous Master: View only) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Viewer_User1 |
      | Permissions | View only    |
    When the user opens View for 'List of Operator'
    And the user inspects the buttons
    Then Only 'Close' (and the X icon) is displayed; the 'Edit' button is not shown
