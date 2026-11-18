@NumberConfiguration @ActivationDeactivation
Feature: Activation / Deactivation
  Automated scenarios for the "Activation / Deactivation" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-4 AC-1; FRD 6.3 BR-4
  @TC_NC_071 @Functional @High @Automation
  Scenario: Verify Activate on an InActive configuration shows a warning when another is Active
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 (InActive) |
      | Active | PO-Cfg-1            |
    When the user clicks 'Activate' on PO-Cfg-3
    And the user observes the dialog
    Then A warning states that an Active configuration already exists and asks the user to confirm
    And No Status change occurs until the user responds

  # Ref: US-4 AC-2; FRD 6.3 BR-4; FRD Sec 8 Toaster #3
  @TC_NC_072 @Functional @High @Automation
  Scenario: Verify confirming the warning activates the selected configuration and deactivates the previous one
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 |
    When the user clicks 'Activate' on PO-Cfg-3
    And the user clicks confirm on the warning
    Then PO-Cfg-3 becomes Active and PO-Cfg-1 becomes InActive
    And Toaster 'Number Configuration activated successfully.' is displayed

  # Ref: US-4 AC-2; FRD 6.3 BR-4
  @TC_NC_073 @Functional @High @Automation
  Scenario: Verify exactly one Active configuration exists for the Process after activation
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Purchase Order |
    When the user activates PO-Cfg-3 and confirm
    And the user queries all Purchase Order configurations and count those with Status 'Active'
    Then Exactly one configuration (PO-Cfg-3) is Active
    And All others are InActive

  # Ref: US-4 AC-2; FRD 6.3 BR-4
  @TC_NC_074 @Functional @Medium @Automation
  Scenario: Verify activating in one Process does not change the Active configuration of another Process
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Processes | Purchase Order, Work Order |
    When the user activates PO-Cfg-3 and confirm
    And the user selects Process 'Work Order'
    And the user observes Status values
    Then WO-Cfg-1 remains the Active Work Order configuration (single Active applies per Process)

  # Ref: US-4 AC-1; FRD 6.3 FB-3; FRD Sec 8 Toaster #3
  @TC_NC_075 @Functional @Medium @Automation
  Scenario: Verify Activate on a Process with no Active configuration activates directly
    Given Admin_User1 is logged in
    And PO-Cfg-1 has been deactivated so no Purchase Order configuration is Active
    And Process 'Purchase Order' is selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 |
    When the user clicks 'Activate' on PO-Cfg-3
    Then No 'Active configuration already exists' warning applies (none exists; see Assumptions)
    And PO-Cfg-3 becomes Active; toaster 'Number Configuration activated successfully.'

  # Ref: FRD 6.3 FB-4; FRD Sec 8 Toaster #4
  @TC_NC_076 @Functional @High @Automation
  Scenario: Verify Deactivate sets the Active configuration to InActive
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Work Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | WO-Cfg-1 (Active) |
    When the user clicks 'Deactivate' on WO-Cfg-1
    Then WO-Cfg-1 Status becomes 'InActive'
    And Toaster 'Number Configuration deactivated successfully.' is displayed
    And Activate is now offered on WO-Cfg-1

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-4 AC-2; FRD 6.3 BR-4
  @TC_NC_208 @Negative @High @Automation
  Scenario: Verify cancelling the Activate warning leaves both configurations unchanged
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 |
      | Active | PO-Cfg-1 |
    When the user clicks 'Activate' on PO-Cfg-3
    And the user clicks Cancel on the warning
    And the user observes Status values
    Then PO-Cfg-1 remains Active and PO-Cfg-3 remains InActive
    And No activation toaster and no activation log entry

  # Ref: FRD 6.3 BR-3
  @TC_NC_209 @Negative @Medium @Automation
  Scenario: Verify Activate is rejected for an already Active configuration (API)
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-1 |
    When the user sends an activate request for PO-Cfg-1 (Active)
    Then Request is rejected; Activate applies only to an InActive configuration

  # Ref: FRD 6.3 BR-3
  @TC_NC_210 @Negative @Medium @Automation
  Scenario: Verify Deactivate is rejected for an InActive configuration (API)
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 |
    When the user sends a deactivate request for PO-Cfg-3 (InActive)
    Then Request is rejected; Deactivate applies only to the currently Active configuration

  # Ref: FRD 6.3 FB-3
  @TC_NC_211 @Negative @Medium @Automation
  Scenario: Verify Activate is rejected for a non-existent configuration (API)
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-999 |
    When the user sends an activate request for configuration id 'PO-Cfg-999'
    Then Request is rejected; no Status changes
