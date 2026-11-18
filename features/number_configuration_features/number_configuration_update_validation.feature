@NumberConfiguration @NumberConfigurationUpdateValidation
Feature: Number Configuration Update - Validation
  Automated scenarios for the "Number Configuration Update - Validation" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4 FB-4; FRD 6.2 F-Separator
  @TC_NC_204 @Negative @High @Automation
  Scenario: Verify the same validations apply on Edit: Separator cleared
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 |
    When the user clicks 'Edit' on PO-Cfg-3
    And the user clears the common Separator
    And the user clicks Save
    Then Save is blocked with 'Separator is required'; the stored configuration is unchanged

  # Ref: FRD 6.4 FB-4; FRD 6.2 BR-14; FRD Sec 8 Toaster #8
  @TC_NC_205 @Negative @High @Automation
  Scenario: Verify Edit blocks a duplicate Abbreviation
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviations | CC, CC |
    When the user clicks 'Edit' on PO-Cfg-3
    And the user changes Abbreviation of 'Office' to the same value as 'Company Code' (CC)
    And the user clicks Save
    Then Save is blocked with 'Abbreviation is required and must be unique across all attributes selected in this configuration.'

  # Ref: FRD 6.4 FB-4; FRD 6.2 BR-10; FRD Sec 8 Toaster #9
  @TC_NC_206 @Negative @High @Automation
  Scenario: Verify Edit blocks removal of every attribute
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attributes | none |
    When the user clicks 'Edit' on PO-Cfg-3
    And the user removes all attributes from the grid
    And the user clicks Save
    Then Save is blocked with 'At least one attribute is required to save this configuration.'

  # Ref: FRD 6.4 FB-4; FRD 6.2 F-StartWith
  @TC_NC_207 @Negative @High @Automation
  Scenario: Verify Edit rejects an invalid Start With
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | 0 |
    When the user clicks 'Edit' on PO-Cfg-3
    And the user enters Start With '0'
    And the user clicks Save
    Then Save is blocked; stored Start With remains unchanged
