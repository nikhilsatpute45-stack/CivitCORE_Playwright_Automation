@RateCard @DependentProcesses
Feature: Dependent Processes
  Automated scenarios for the "Dependent Processes" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.7 FB-1; US-10 AC-1
  @TC_RC_090 @Functional @High @Automation
  Scenario: Verify the Rate Card selection in Office Creation lists every Rate Card in the display sequence of the Rate Card List
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Office Creation screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Cards | 8 baseline Rate Cards |
    When the user opens the Rate Card selection in Office Creation
    And the user compares the options with the Rate Card List
    Then All 8 Rate Cards are offered showing the Rate Card Name, in the same order as the Rate Card List (Coastal Region, Desert Zone, Civit-ratecard, Sub Mountanious, Hill Zone, Item Rate Card, Lead Rate Card, Single Office Card)

  # Ref: FRD 5.7 FB-1; US-10 AC-1
  @TC_RC_091 @Functional @High @Automation
  Scenario: Verify the Rate Card selection in Resource Rate definition lists every Rate Card in the display sequence of the Rate Card List
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Resource Rate definition screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Cards | 8 baseline Rate Cards |
    When the user opens the Rate Card selection in Resource Rate definition
    And the user compares the options with the Rate Card List
    Then All 8 Rate Cards are offered showing the Rate Card Name, in the same order as the Rate Card List (Coastal Region, Desert Zone, Civit-ratecard, Sub Mountanious, Hill Zone, Item Rate Card, Lead Rate Card, Single Office Card)

  # Ref: FRD 5.7 FB-1; US-10 AC-1
  @TC_RC_092 @Functional @High @Automation
  Scenario: Verify the Rate Card selection in Item definition lists every Rate Card in the display sequence of the Rate Card List
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Item definition screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Cards | 8 baseline Rate Cards |
    When the user opens the Rate Card selection in Item definition
    And the user compares the options with the Rate Card List
    Then All 8 Rate Cards are offered showing the Rate Card Name, in the same order as the Rate Card List (Coastal Region, Desert Zone, Civit-ratecard, Sub Mountanious, Hill Zone, Item Rate Card, Lead Rate Card, Single Office Card)

  # Ref: FRD 5.7 FB-1; US-10 AC-1
  @TC_RC_093 @Functional @High @Automation
  Scenario: Verify the Rate Card selection in Reports - CSR lists every Rate Card in the display sequence of the Rate Card List
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Reports - CSR screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Cards | 8 baseline Rate Cards |
    When the user opens the Rate Card selection in Reports - CSR
    And the user compares the options with the Rate Card List
    Then All 8 Rate Cards are offered showing the Rate Card Name, in the same order as the Rate Card List (Coastal Region, Desert Zone, Civit-ratecard, Sub Mountanious, Hill Zone, Item Rate Card, Lead Rate Card, Single Office Card)

  # Ref: FRD 5.7 FB-1; US-10 AC-1
  @TC_RC_094 @Functional @High @Automation
  Scenario: Verify the Rate Card selection in Reports - Rate Analysis lists every Rate Card in the display sequence of the Rate Card List
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Reports - Rate Analysis screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Cards | 8 baseline Rate Cards |
    When the user opens the Rate Card selection in Reports - Rate Analysis
    And the user compares the options with the Rate Card List
    Then All 8 Rate Cards are offered showing the Rate Card Name, in the same order as the Rate Card List (Coastal Region, Desert Zone, Civit-ratecard, Sub Mountanious, Hill Zone, Item Rate Card, Lead Rate Card, Single Office Card)

  # Ref: FRD 5.7 FB-1; US-10 AC-1
  @TC_RC_095 @Functional @High @Automation
  Scenario: Verify the Rate Card selection in Lead Rate Management lists every Rate Card in the display sequence of the Rate Card List
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Lead Rate Management screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Cards | 8 baseline Rate Cards |
    When the user opens the Rate Card selection in Lead Rate Management
    And the user compares the options with the Rate Card List
    Then All 8 Rate Cards are offered showing the Rate Card Name, in the same order as the Rate Card List (Coastal Region, Desert Zone, Civit-ratecard, Sub Mountanious, Hill Zone, Item Rate Card, Lead Rate Card, Single Office Card)

  # Ref: FRD 5.7 FB-2; US-10 AC-2
  @TC_RC_096 @Functional @High @Automation
  Scenario: Verify a newly added Rate Card is selectable in a dependent process without further configuration
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Highland Zone |
    When the user adds Rate Card 'Highland Zone'
    And the user opens the Rate Card selection of Office Creation (or refresh it if already open)
    Then 'Highland Zone' is offered as the first option

  # Ref: FRD 5.7 FB-3; US-10 AC-2; FRD 5.5 BR-2
  @TC_RC_097 @Functional @High @Automation
  Scenario: Verify a renamed Rate Card shows its new name in every dependent process and existing record
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Item Rate Card -> Item Rate Card 2026 |
    When the user renames 'Item Rate Card' to 'Item Rate Card 2026'
    And the user opens Item ITM-001 and the Item Rate Card selection
    And the user opens Resource Rate and Lead Rate selections
    Then Item ITM-001 shows 'Item Rate Card 2026' and all selections show the new name

  # Ref: FRD 5.7 FB-4; US-9 AC-2
  @TC_RC_098 @Functional @High @Automation
  Scenario: Verify a deleted Rate Card is no longer offered in any dependent process
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region |
    When the user deletes the unused Rate Card 'Coastal Region' (Yes)
    And the user opens the Rate Card selection of each dependent process
    Then 'Coastal Region' is not offered in Office Creation, Resource Rate, Item, Reports or Lead Rate Management

  # Ref: FRD 5.7 BR-1
  @TC_RC_099 @Functional @High @Automation
  Scenario: Verify dependent processes reference a Rate Card by Internal ID and not by name
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Item      | ITM-001        |
      | Rate Card | Item Rate Card |
    When the user reads the stored Rate Card reference of Item ITM-001 from the database
    And the user compares with the Internal ID and the name of 'Item Rate Card'
    Then The reference stored is the Rate Card Internal ID, not the Rate Card Name

  # Ref: FRD 5.7 BR-2
  @TC_RC_100 @Functional @High @Automation
  Scenario: Verify selecting a Rate Card only as a Reports filter does not count as use, so it can be deleted
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Desert Zone (CSR report filter only) |
    When In Reports (CSR), select 'Desert Zone' as a filter and run the report
    And the user returns to the Rate Card List and select Delete on 'Desert Zone'
    Then Deletion is not blocked and the confirmation dialog is displayed
