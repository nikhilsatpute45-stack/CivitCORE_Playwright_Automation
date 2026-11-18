@NumberConfiguration @NumberConfigurationUpdate
Feature: Number Configuration Update
  Automated scenarios for the "Number Configuration Update" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-1; FRD 6.4 BR-1; FRD 6.4 FB-1; FRD Sec 8 Toaster #2
  @TC_NC_061 @Functional @High @Automation
  Scenario: Verify Active/used configuration (PO-Cfg-1) can be edited and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-1 (Active, used) |
      | Digits | 00001                   |
    When the user clicks 'Edit' on PO-Cfg-1
    And the user observes whether fields are editable
    And the user changes Digits to '00001'
    And the user clicks Save
    Then Fields open as editable regardless of Status and usage
    And Save succeeds; toaster 'Number Configuration updated successfully.'

  # Ref: US-5 AC-1; FRD 6.4 BR-1; FRD 6.4 FB-1; FRD Sec 8 Toaster #2
  @TC_NC_062 @Functional @High @Automation
  Scenario: Verify Active/unused configuration (WO-Cfg-1) can be edited and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in on the Number Configuration screen with Process 'Work Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | WO-Cfg-1 (Active, unused) |
      | Digits | 00001                     |
    When the user clicks 'Edit' on WO-Cfg-1
    And the user observes whether fields are editable
    And the user changes Digits to '00001'
    And the user clicks Save
    Then Fields open as editable regardless of Status and usage
    And Save succeeds; toaster 'Number Configuration updated successfully.'

  # Ref: US-5 AC-1; FRD 6.4 BR-1; FRD 6.4 FB-1; FRD Sec 8 Toaster #2
  @TC_NC_063 @Functional @High @Automation
  Scenario: Verify InActive/used configuration (PO-Cfg-2) can be edited and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-2 (InActive, used) |
      | Digits | 00001                     |
    When the user clicks 'Edit' on PO-Cfg-2
    And the user observes whether fields are editable
    And the user changes Digits to '00001'
    And the user clicks Save
    Then Fields open as editable regardless of Status and usage
    And Save succeeds; toaster 'Number Configuration updated successfully.'

  # Ref: US-5 AC-1; FRD 6.4 BR-1; FRD 6.4 FB-1; FRD Sec 8 Toaster #2
  @TC_NC_064 @Functional @High @Automation
  Scenario: Verify InActive/unused configuration (PO-Cfg-3) can be edited and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 (InActive, unused) |
      | Digits | 00001                       |
    When the user clicks 'Edit' on PO-Cfg-3
    And the user observes whether fields are editable
    And the user changes Digits to '00001'
    And the user clicks Save
    Then Fields open as editable regardless of Status and usage
    And Save succeeds; toaster 'Number Configuration updated successfully.'

  # Ref: FRD 6.4 FB-5; FRD Sec 8 Toaster #2
  @TC_NC_065 @Functional @High @Automation
  Scenario: Verify the updated value is shown after saving an edit
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | 100 |
    When the user clicks 'Edit' on PO-Cfg-3
    And the user changes Start With to '100'
    And the user clicks Save
    And the user re-opens PO-Cfg-3 via Edit
    Then Toaster 'Number Configuration updated successfully.' is displayed
    And Edit shows Start With '100'

  # Ref: FRD 6.4 FB-3; FRD 6.2 FB-6; FRD 6.2 FB-8; FRD 6.2 FB-9
  @TC_NC_066 @Functional @High @Automation
  Scenario: Verify attributes can be added, reordered and removed while editing
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 |
    When the user clicks 'Edit' on PO-Cfg-3
    And the user drags 'Department' into the grid and enter Abbreviation 'DEPT'
    And the user drags 'Department' above 'Company Code'
    And the user removes 'Office'
    And the user clicks Save
    Then Same drag-and-drop, per-attribute and reorder behaviour as creation is available
    And Save succeeds; toaster 'Number Configuration updated successfully.'; saved sequence matches the grid

  # Ref: US-5 AC-2; FRD 6.4 BR-2; FRD 6.4 FB-5
  @TC_NC_067 @Functional @High @Automation
  Scenario: Verify an edit of a used configuration applies to numbers generated from that point forward
    Given PO-Cfg-1 is Active and has generated numbers (last 'HO/2026-27/0006')
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-1 |
      | Prefix | PO-      |
      | Office | HO       |
    When the user edits PO-Cfg-1 and set Prefix 'PO-' on 'Office'; Save
    And the user requests a new Purchase Order number for Office 'HO'
    Then The new number reflects the updated Prefix (e.g. 'PO-HO/2026-27/0007')
    And Update applies prospectively

  # Ref: FRD 6.4 BR-2; US-5 AC-2; FRD 6.5 BR-3
  @TC_NC_068 @Functional @High @Automation
  Scenario: Verify previously generated numbers stay unchanged after the configuration is edited
    Given PO-Cfg-1 generated 'HO/2026-27/0006' which is persisted on an existing Purchase Order
    And API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Existing number | HO/2026-27/0006 |
    When the user edits PO-Cfg-1: set Prefix 'PO-' and Digits '00001'; Save
    And the user reads the persisted number of the existing Purchase Order
    Then The existing number remains 'HO/2026-27/0006'
    And No number is regenerated or retroactively altered (also confirms immutability once persisted)

  # Ref: FRD 6.4 BR-3
  @TC_NC_069 @Functional @High @Automation
  Scenario: Verify Status cannot be changed directly on the Edit screen
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Work Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | WO-Cfg-1 |
    When the user clicks 'Edit' on WO-Cfg-1 (Active)
    And the user tries to change the Status
    Then Status is not editable on the Edit screen; activation/deactivation is done via the list actions

  # Ref: FRD 6.4 BR-3; FRD 6.4 FB-5
  @TC_NC_070 @Functional @Medium @Automation
  Scenario: Verify Status is unchanged after editing and saving an Active configuration
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Work Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | WO-Cfg-1 |
    When the user clicks 'Edit' on WO-Cfg-1
    And the user changes Digits to '00001'
    And the user clicks Save
    And the user observes the Status column
    Then WO-Cfg-1 remains 'Active' after the update
