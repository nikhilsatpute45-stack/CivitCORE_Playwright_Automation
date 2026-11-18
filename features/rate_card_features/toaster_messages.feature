@RateCard @ToasterMessages
Feature: Toaster Messages
  Automated scenarios for the "Toaster Messages" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD Sec 7 TR-2
  @TC_RC_117 @Functional @Medium @Automation
  Scenario: Verify a success toaster closes automatically after 5 seconds
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Toaster | Rate Card added successfully. |
    When the user adds Rate Card 'Highland Zone'
    And the user starts a timer when the toaster appears and observe it without interacting
    Then Toaster disappears automatically after 5 seconds

  # Ref: FRD Sec 7 TR-2; FRD Sec 7 Toaster #4
  @TC_RC_118 @Functional @Medium @Automation
  Scenario: Verify an error toaster closes automatically after 5 seconds
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Toaster | This Rate Card is used in one or more transactions and cannot be deleted. |
    When the user selects Delete on 'Hill Zone' (used)
    And the user starts a timer when the toaster appears and observe it without interacting
    Then Error toaster disappears automatically after 5 seconds

  # Ref: FRD Sec 7 TR-1
  @TC_RC_119 @Functional @Medium @Automation
  Scenario: Verify no toaster is displayed for events not listed in the toaster table
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Actions | kebab, View, Cancel, search |
    When the user opens and close a kebab menu
    And the user opens View on 'Coastal Region' and click Close
    And the user opens Add and click Cancel
    And the user applies and clear a column search
    Then No toaster is displayed for any of these events
