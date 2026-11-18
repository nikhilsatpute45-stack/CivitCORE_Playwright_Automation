@RateCard @RateCardView
Feature: Rate Card View
  Automated scenarios for the "Rate Card View" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-4 AC-1; FRD 5.4 FB-2; US-3 AC-3
  @TC_RC_070 @Functional @Medium @Automation
  Scenario: Verify View displays Rate Card Name, Associated Offices (count and list), Created By, Created On, Last Modified By and Last Modified On
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Sub Mountanious |
    When the user selects View from the kebab menu of 'Sub Mountanious'
    And the user reads all fields
    Then 'View Rate Card' pop-up shows Rate Card Name 'Sub Mountanious'
    And Associated Offices shows '4 offices' with Nabha, Patiala, Rajpura, Samana in alphabetical order
    And Created By, Created On, Last Modified By and Last Modified On are shown in read-only mode

  # Ref: FRD 5.4 FB-2
  @TC_RC_071 @Functional @Medium @Automation
  Scenario: Verify fields that were never set show '-' in View
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Highland Zone (never edited) |
    When the user adds Rate Card 'Highland Zone'
    And the user selects View from the kebab menu of the new row
    And the user reads Last Modified By and Last Modified On
    Then Last Modified By shows '-'
    And Last Modified On shows '-'

  # Ref: US-4 AC-2; FRD 5.4 FB-3
  @TC_RC_072 @Functional @High @Automation
  Scenario: Verify the 'Edit' button in the View pop-up is shown to a user with Edit permission
    Given Editor_User1 (Rate Card: View+Edit) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Editor_User1 |
    When the user selects View from the kebab menu of 'Coastal Region'
    And the user observes the buttons
    Then 'Edit' and 'Close' are displayed in the View pop-up

  # Ref: FRD 5.4 FB-3; FRD 5.5 FB-1
  @TC_RC_073 @Functional @High @Automation
  Scenario: Verify clicking 'Edit' in the View pop-up opens the Edit Rate Card pop-up for the same Rate Card
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region |
    When the user selects View from the kebab menu of 'Coastal Region'
    And the user clicks 'Edit'
    Then 'Edit Rate Card' pop-up opens with Rate Card Name 'Coastal Region' pre-filled and editable

  # Ref: US-4 AC-2; FRD 5.4 FB-4
  @TC_RC_074 @Functional @Medium @Automation
  Scenario: Verify 'Close' in the View pop-up returns to the list with the same page and search values
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Search | Bulk |
      | Page   | 2    |
    When the user types 'Bulk' in the Rate Card Name search box and go to page 2
    And the user selects View on any row
    And the user clicks 'Close'
    Then Pop-up closes; list is on page 2 with search 'Bulk' retained

  # Ref: FRD 5.4 BR-1
  @TC_RC_075 @Functional @High @Automation
  Scenario: Verify View does not change data and creates no Activity Log entry
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region |
    When the user notes the Activity Log entry count for 'Coastal Region' and its Last Modified values
    And the user opens View of 'Coastal Region' and click Close
    And the user compares data and Activity Log
    Then No field value changed (including Last Modified By/On)
    And No new Activity Log entry exists

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.4 FB-4; US-4 AC-2
  @TC_RC_173 @Negative @Medium @Automation
  Scenario: Verify the close (X) icon on the View pop-up returns to the list with the same page and search values
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Search | Bulk |
      | Page   | 2    |
    When the user types 'Bulk' in the Rate Card Name search box and go to page 2
    And the user selects View on any row
    And the user clicks the close (X) icon
    Then Pop-up closes; list is on page 2 with search 'Bulk' retained

  # Ref: FRD 5.4 BR-2
  @TC_RC_174 @Negative @Medium @Automation
  Scenario: Verify opening View on a Rate Card deleted by another user refreshes the list without a toaster
    Given Admin_User1 and Admin_User2 are logged in in two sessions
    And Baseline data (see Summary) is loaded and both are on the Rate Card List page
    And the following test data is used
      | Rate Card | Coastal Region |
    When In session 2 delete 'Coastal Region' (Yes)
    And In session 1 (without refreshing) select View on 'Coastal Region'
    Then The list is refreshed and 'Coastal Region' is no longer shown
    And No toaster message is displayed
