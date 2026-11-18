@NumberConfiguration @NumberConfigurationView
Feature: Number Configuration View
  Automated scenarios for the "Number Configuration View" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.3 BR-2; US-4 AC-3; FRD 6.3 C-Status
  @TC_NC_059 @Functional @High @Automation
  Scenario: Verify the list shows both Active and InActive configurations with their current Status
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Data | PO-Cfg-1 Active; PO-Cfg-2, 3, 4 InActive |
    When the user observes the Status column for the Purchase Order list
    Then All four configurations are listed
    And Each shows its current Status (Active / InActive)

  # Ref: FRD 6.3 FB-2; FRD 6.4 FB-2; FRD 6.3 FB-5
  @TC_NC_060 @Functional @High @Automation
  Scenario: Verify Edit opens the full configuration details
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-1 |
    When the user clicks 'Edit' on PO-Cfg-1
    Then Separator, Status, Start With, Digits, year formats and the full attribute sequence with each attribute's settings are displayed
