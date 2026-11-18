@NumberConfiguration @NumberConfigurationUi
Feature: Number Configuration UI
  Automated scenarios for the "Number Configuration UI" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.3 C-SlNo
  @TC_NC_113 @UIVisual @Low @Automation
  Scenario: Verify Sl No. is sequential from 1 for the displayed list
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | PO list | 4 rows |
      | WO list | 2 rows |
    When the user observes Sl No. for the Purchase Order list
    And the user selects 'Work Order' and observe Sl No
    Then Sl No. shows 1..4 for Purchase Order and 1..2 for Work Order

  # Ref: FRD 6.1 BR-1; FRD 6.3 BR-1; FRD 6.1 FB-6
  @TC_NC_115 @UIVisual @High @Automation
  Scenario: Verify Add, Edit, Delete and Activate/Deactivate are not displayed for a view-only user
    Given Viewer_User1 (Number Configuration: view access only) is logged in and on the Number Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user inspects the toolbar and row actions of every row
    Then 'Add', Edit, Delete, Activate and Deactivate are not displayed (or are disabled); only viewing remains

  # Ref: FRD 6.2 BR-3; FRD 6.2 F-FYFormat
  @TC_NC_119 @UIVisual @High @Automation
  Scenario: Verify the Financial Year / Budget Year Format dropdown lists only the supported patterns
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Options | YYYY, YYYY-YYYY, YY-YY, YYYY-YY |
    When the user opens the Financial Year / Budget Year Format dropdown
    And the user tries to type a custom value
    Then Exactly four options are listed
    And Free-text entry is not possible

  # Ref: FRD 6.2 BR-4; FRD 6.2 F-CYFormat
  @TC_NC_120 @UIVisual @High @Automation
  Scenario: Verify the Calendar Year Format dropdown lists only the supported patterns
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Options | YYYY, YY |
    When the user opens the Calendar Year Format dropdown
    And the user tries to type a custom value
    Then Exactly two options are listed
    And Free-text entry is not possible

  # Ref: FRD 6.2 BR-12; US-3 AC-1
  @TC_NC_121 @UIVisual @Medium @Automation
  Scenario: Verify the attribute pool shows attribute names and shrinks when an attribute is added
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | PO pool | 5 attributes |
    When the user observes the pool
    And the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user observes the pool again
    Then Pool lists 5 attribute names, then 4 after 'Office' is added

  # Ref: US-3 AC-2; FRD 6.2 F-Order; FRD 6.2 BR-13
  @TC_NC_123 @UIVisual @High @Automation
  Scenario: Verify Order is a read-only display and cannot be typed
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Order value | 1 |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user clicks the Order value and try to type '5'
    Then Order is not editable; it only reflects the row position

  # Ref: FRD 6.4 FB-2; FRD 6.4 BR-3
  @TC_NC_132 @UIVisual @Medium @Automation
  Scenario: Verify the Edit screen shows fields editable except Status
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 |
    When the user clicks 'Edit' on PO-Cfg-3
    And the user inspects each field
    Then Separator, Start With, Digits, year formats and attribute settings are editable
    And Status is displayed but not editable

  # Ref: FRD 6.2 FB-11; US-3 AC-8
  @TC_NC_135 @UIVisual @Medium @Automation
  Scenario: Verify the user returns to the grid showing the new configuration after Save
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute | Office (OFF) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clicks Save
    Then User is returned to the list for 'Purchase Order' where the new configuration is visible
