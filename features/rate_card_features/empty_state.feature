@RateCard @EmptyState
Feature: Empty State
  Automated scenarios for the "Empty State" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-2; FRD 5.3 ES-1; FRD 5.3 ES-6; FRD 5.1 FB-2
  @TC_RC_067 @Functional @High @Automation
  Scenario: Verify the empty state is displayed when no Rate Card exists
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on Admin > Configuration > Rate Card
    And Empty dataset DS-0 (no Rate Card exists) (see Summary) is loaded
    And the following test data is used
      | Rate Cards | none |
    When the user opens Admin > Configuration > Rate Card
    Then Empty state is displayed with an illustration, the heading 'No Rate Cards added yet', the message 'Click Add to create your first Rate Card.' and an 'Add' button
    And Grid, column search and pagination are not displayed

  # Ref: FRD 5.3 ES-5; US-1 AC-3; FRD 5.1 BR-2
  @TC_RC_068 @Functional @High @Automation
  Scenario: Verify the empty state hides 'Add' for a user without Add permission while still showing the illustration, heading and message
    Given Viewer_User1 (Rate Card: View only) is logged in and on Admin > Configuration > Rate Card
    And Empty dataset DS-0 (no Rate Card exists) (see Summary) is loaded
    And the following test data is used
      | User       | Viewer_User1 |
      | Rate Cards | none         |
    When the user opens Admin > Configuration > Rate Card
    Then Illustration, heading 'No Rate Cards added yet' and message 'Click Add to create your first Rate Card.' are displayed
    And 'Add' button is not displayed

  # Ref: US-9 AC-4; FRD 5.8 FB-5
  @TC_RC_069 @Functional @High @Automation
  Scenario: Verify the empty state is shown after the last remaining Rate Card is deleted
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Dataset DS-1 (one unused Rate Card 'Only Card') (see Summary) is loaded
    And the following test data is used
      | Rate Card | Only Card |
    When the user selects Delete from the kebab menu of 'Only Card'
    And the user clicks Yes
    Then Toaster 'Rate Card deleted successfully.' is displayed
    And The empty state replaces the grid
