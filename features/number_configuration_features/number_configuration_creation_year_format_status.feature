@NumberConfiguration @NumberConfigurationCreationYearFormatStatus
Feature: Number Configuration Creation - Year Format / Status
  Automated scenarios for the "Number Configuration Creation - Year Format / Status" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-3; FRD 6.2 F-FYFormat; FRD 6.2 BR-2
  @TC_NC_169 @Negative @High @Automation
  Scenario: Verify Save is blocked when Financial Year / Budget Year Format is cleared
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | FY Format | (blank) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clears the Financial Year / Budget Year Format selection
    And the user clicks Save
    Then Save is blocked with the corresponding mandatory-field message (text not defined; see Assumptions)

  # Ref: US-1 AC-3; FRD 6.2 F-CYFormat; FRD 6.2 BR-2
  @TC_NC_170 @Negative @High @Automation
  Scenario: Verify Save is blocked when Calendar Year Format is cleared
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | CY Format | (blank) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clears the Calendar Year Format selection
    And the user clicks Save
    Then Save is blocked with the corresponding mandatory-field message (text not defined; see Assumptions)

  # Ref: FRD 6.2 BR-3; FRD 6.2 F-FYFormat
  @TC_NC_171 @Negative @High @Automation
  Scenario: Verify a free-text Financial Year / Budget Year Format is rejected via API
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | FY Format | YYYY/MM |
    When the user sends a create request with financialYearFormat 'YYYY/MM'
    Then Request is rejected; value is not in {YYYY, YYYY-YYYY, YY-YY, YYYY-YY}; nothing created

  # Ref: FRD 6.2 BR-4; FRD 6.2 F-CYFormat
  @TC_NC_172 @Negative @High @Automation
  Scenario: Verify a Calendar Year Format outside the supported list is rejected via API
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | CY Format | YYYY-YY |
    When the user sends a create request with calendarYearFormat 'YYYY-YY' (valid for FY only)
    Then Request is rejected; value is not in {YYYY, YY}; nothing created

  # Ref: FRD 6.2 BR-9; US-2 AC-2
  @TC_NC_173 @Negative @High @Automation
  Scenario: Verify Status cannot be set Active on Add when configurations already exist (API)
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Status | Active |
    When the user sends a create request for 'Purchase Order' with status 'Active'
    And the user counts Active Purchase Order configurations
    Then Request does not create a second Active configuration (rejected or stored as InActive); exactly one Active exists

  # Ref: FRD 6.4 BR-3
  @TC_NC_174 @Negative @High @Automation
  Scenario: Verify Status cannot be changed through an edit request (API)
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 |
      | Status | Active   |
    When the user sends an update request for PO-Cfg-3 with status 'Active'
    And the user reads PO-Cfg-3 and PO-Cfg-1
    Then Status of PO-Cfg-3 is unchanged (InActive) and PO-Cfg-1 stays Active; Status changes only via Activate/Deactivate
