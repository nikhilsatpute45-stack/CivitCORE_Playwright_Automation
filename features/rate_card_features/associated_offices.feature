@RateCard @AssociatedOffices
Feature: Associated Offices
  Automated scenarios for the "Associated Offices" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-1; FRD 5.6 BR-1; FRD 5.6 BR-4
  @TC_RC_084 @Functional @Medium @Automation
  Scenario: Verify an office created in Office Creation with a Rate Card appears in that Rate Card's Associated Offices on next load
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Office    | Patiala        |
      | Rate Card | Coastal Region |
    When In Office Creation, create office 'Patiala' selecting Rate Card 'Coastal Region' and save
    And the user opens Admin > Configuration > Rate Card (reload the list)
    And the user reads the Associated Offices cell of 'Coastal Region'
    Then 'Patiala' is included in the Associated Offices of 'Coastal Region' (cell shows 'Patiala')

  # Ref: US-3 AC-2; FRD 5.6 BR-3; FRD 5.6 BR-2
  @TC_RC_085 @Functional @High @Automation
  Scenario: Verify an office whose Rate Card is changed in Office Creation moves to the new Rate Card only
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Office    | Rajpura                           |
      | Rate Card | Sub Mountanious -> Civit-ratecard |
    When In Office Creation, edit office 'Rajpura' (currently under 'Sub Mountanious') and change its Rate Card to 'Civit-ratecard'
    And the user reloads the Rate Card List
    And the user reads Associated Offices of both Rate Cards
    Then 'Rajpura' appears only under 'Civit-ratecard'
    And 'Sub Mountanious' no longer lists 'Rajpura' (shows 'Nabha, Patiala, Samana')

  # Ref: FRD 5.6 BR-2; FRD 5.6 BR-1
  @TC_RC_086 @Functional @Medium @Automation
  Scenario: Verify a Rate Card can be associated with any number of offices without limit
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Dataset DS-248 (Rate Card 'Mega Office Card' with 248 offices) (see Summary) is loaded
    And the following test data is used
      | Offices | 248 existing + 'Office-246' |
    When In Office Creation, create the 249th office selecting 'Mega Office Card'
    And the user reloads the Rate Card List and open View of 'Mega Office Card'
    Then View shows '249 offices'; no limit error occurs

  # Ref: FRD 5.6 BR-5
  @TC_RC_087 @Functional @Medium @Automation
  Scenario: Verify a renamed office is shown with its new name in Associated Offices
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Office | Patiala -> Patiala City |
    When In Office Creation, rename office 'Patiala' to 'Patiala City' and save
    And the user reloads the Rate Card List
    And the user reads Associated Offices of 'Sub Mountanious'
    Then Associated Offices of 'Sub Mountanious' shows 'Nabha, Patiala City, Rajpura +1 more'

  # Ref: US-3 AC-3; FRD 5.4 FB-2
  @TC_RC_088 @Functional @Medium @Automation
  Scenario: Verify Associated Offices lists all names alphabetically with the total count in the View pop-up
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Dataset DS-248 (Rate Card 'Mega Office Card' with 248 offices) (see Summary) is loaded
    And the following test data is used
      | Rate Card | Mega Office Card |
    When the user opens View of 'Mega Office Card'
    And the user scrolls through the Associated Offices list
    Then Header shows '248 offices'
    And All 248 names are listed in alphabetical order and no add/remove control is displayed

  # Ref: FRD 3 Overview; FRD 5.2 F-AssocOffices
  @TC_RC_089 @Functional @Medium @Automation
  Scenario: Verify Associated Offices is empty and read-only ('No offices associated yet') for a newly created Rate Card
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Highland Zone |
    When the user adds Rate Card 'Highland Zone'
    And the user opens View of 'Highland Zone'
    Then Associated Offices shows 'No offices associated yet'
    And List cell in the grid shows '-'
