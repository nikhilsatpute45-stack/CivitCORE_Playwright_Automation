@NumberConfiguration @NumberConfigurationDeletion
Feature: Number Configuration Deletion
  Automated scenarios for the "Number Configuration Deletion" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.6 DT-3; FRD 6.6 BR-3; US-7 AC-3; FRD 6.6 FB-1; FRD 6.6 FB-6; FRD 6.3 FB-5
  @TC_NC_098 @Functional @High @Automation
  Scenario: Verify a delete confirmation dialog is shown for an InActive, unused configuration
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-4 |
    When the user clicks 'Delete' on PO-Cfg-4 (InActive, unused)
    Then A delete confirmation dialog with Confirm and Cancel is displayed
    And Nothing is deleted yet

  # Ref: FRD 6.6 DT-4; FRD 6.6 FB-7; US-7 AC-3; FRD Sec 8 Toaster #5
  @TC_NC_099 @Functional @High @Automation
  Scenario: Verify confirming the dialog deletes the InActive, unused configuration
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-4 |
    When the user clicks 'Delete' on PO-Cfg-4
    And the user clicks Confirm
    Then Configuration is deleted
    And Toaster 'Number Configuration deleted successfully.' is displayed
    And PO-Cfg-4 no longer appears in the list

  # Ref: FRD 6.6 FB-1
  @TC_NC_100 @Functional @Medium @Automation
  Scenario: Verify deleting one configuration does not affect the others
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Deleted | PO-Cfg-4 |
    When the user deletes PO-Cfg-4 and confirm
    And the user observes PO-Cfg-1, PO-Cfg-2 and PO-Cfg-3
    Then Only the selected configuration is deleted; the others remain with unchanged Status and settings

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-7 AC-1; FRD 6.6 DT-1; FRD 6.6 BR-1; FRD 6.6 FB-3; FRD Sec 8 Toaster #6
  @TC_NC_212 @Negative @High @Automation
  Scenario: Verify deleting an Active, used configuration is blocked with no confirmation dialog
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-1 |
    When the user clicks 'Delete' on PO-Cfg-1 (Active, used)
    Then Deletion is blocked
    And Message 'This Number Configuration is Active and cannot be deleted.' is displayed
    And No delete confirmation dialog is shown; PO-Cfg-1 still exists

  # Ref: FRD 6.6 BR-1; FRD 6.6 DT-1; FRD Sec 8 Toaster #6
  @TC_NC_213 @Negative @High @Automation
  Scenario: Verify deleting an Active, unused configuration is blocked regardless of usage
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Work Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | WO-Cfg-1 |
    When the user clicks 'Delete' on WO-Cfg-1 (Active, unused)
    Then Deletion is blocked with 'This Number Configuration is Active and cannot be deleted.'
    And No confirmation dialog is shown; WO-Cfg-1 still exists

  # Ref: US-7 AC-2; FRD 6.6 DT-2; FRD 6.6 BR-2; FRD 6.6 FB-5; FRD Sec 8 Toaster #7
  @TC_NC_214 @Negative @High @Automation
  Scenario: Verify deleting an InActive, used configuration is blocked with no confirmation dialog
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-2 |
    When the user clicks 'Delete' on PO-Cfg-2 (InActive, used)
    Then Deletion is blocked
    And Message 'This Number Configuration has already been used and cannot be deleted.' is displayed
    And No delete confirmation dialog is shown; PO-Cfg-2 still exists

  # Ref: FRD 6.6 BR-4; FRD 6.6 FB-2
  @TC_NC_215 @Negative @High @Automation
  Scenario: Verify the Active check takes precedence over the usage check
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-1 |
    When the user clicks 'Delete' on PO-Cfg-1 (Active and used)
    Then The Active message 'This Number Configuration is Active and cannot be deleted.' is shown (not the already-used message)

  # Ref: US-7 AC-4; FRD 6.6 DT-5; FRD 6.6 FB-8
  @TC_NC_216 @Negative @High @Automation
  Scenario: Verify cancelling the delete dialog keeps the configuration unchanged
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-4 |
    When the user clicks 'Delete' on PO-Cfg-4
    And the user clicks Cancel
    Then Configuration is not deleted and remains unchanged
    And No deletion log entry is recorded

  # Ref: FRD 6.6 BR-4; FRD 6.6 FB-2
  @TC_NC_217 @Negative @High @Automation
  Scenario: Verify a stale list is re-checked: a row shown InActive that was activated elsewhere cannot be deleted
    Given Admin_User1 has the Purchase Order list open showing PO-Cfg-3 as InActive
    And In another session PO-Cfg-3 is then activated
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 (now Active) |
    When In the first session (not refreshed) click 'Delete' on PO-Cfg-3
    Then System re-checks Status at delete time: deletion is blocked with 'This Number Configuration is Active and cannot be deleted.'; no dialog

  # Ref: FRD 6.6 BR-4; FRD 6.6 FB-4
  @TC_NC_218 @Negative @High @Automation
  Scenario: Verify a stale list is re-checked: a row shown unused that has since generated a number cannot be deleted
    Given Admin_User1 has the Purchase Order list open showing PO-Cfg-4 as InActive and unused
    And Afterwards PO-Cfg-4 generates a number
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-4 (now used) |
    When In the first session (not refreshed) click 'Delete' on PO-Cfg-4
    Then System re-checks usage at delete time: deletion is blocked with 'This Number Configuration has already been used and cannot be deleted.'; no dialog

  # Ref: FRD 6.6 BR-1
  @TC_NC_219 @Negative @High @Automation
  Scenario: Verify an Active configuration cannot be deleted via API
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-1 |
    When the user sends a delete request for PO-Cfg-1 (Active)
    Then Request is rejected; PO-Cfg-1 still exists

  # Ref: FRD 6.6 BR-2
  @TC_NC_220 @Negative @High @Automation
  Scenario: Verify a used InActive configuration cannot be deleted via API
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-2 |
    When the user sends a delete request for PO-Cfg-2 (InActive, used)
    Then Request is rejected; PO-Cfg-2 still exists

  # Ref: FRD 6.6 FB-1
  @TC_NC_221 @Negative @Medium @Automation
  Scenario: Verify deleting a non-existent configuration is rejected (API)
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-999 |
    When the user sends a delete request for 'PO-Cfg-999'
    Then Request is rejected; no data is changed
