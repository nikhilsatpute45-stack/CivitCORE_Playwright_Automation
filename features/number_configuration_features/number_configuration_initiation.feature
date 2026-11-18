@NumberConfiguration @NumberConfigurationInitiation
Feature: Number Configuration Initiation
  Automated scenarios for the "Number Configuration Initiation" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1 FB-1; FRD 6.1 FB-2; FRD 6.1 FB-3; FRD 6.1 BR-3; US-1 AC-1
  @TC_NC_001 @Functional @High @Automation
  Scenario: Verify the screen lands on the Process list with the first Process selected and its configurations shown (Add above the list)
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | Admin_User1                         |
      | Process list | Purchase Order, Work Order, Invoice |
    When the user logs in to CivitCORE as Admin_User1
    And the user navigates to Admin / Configuration > Number Configuration
    And the user observes the screen without clicking anything
    Then Process list is displayed with the Process names
    And 'Purchase Order' (first Process) is selected by default
    And Configurations PO-Cfg-1 to PO-Cfg-4 are displayed immediately without an explicit selection
    And An 'Add' action is displayed above the list

  # Ref: FRD 6.1 BR-2; FRD 6.1 FB-2
  @TC_NC_002 @Functional @Medium @Automation
  Scenario: Verify the Process list is product-defined and differs from product to product
    Given Admin_User1 has access to Number Configuration in CivitBUILD and CivitINFRA. Baseline data (see Summary) is loaded
    And the following test data is used
      | CivitBUILD | Purchase Order, Work Order, Invoice     |
      | CivitINFRA | Measurement Book, Running Bill (sample) |
    When the user opens Number Configuration from CivitBUILD and note the Process list
    And the user opens Number Configuration from CivitINFRA and note the Process list
    And the user compares the two lists
    Then Each product shows only its own product-defined Processes
    And CivitCORE does not add, edit or remove Processes itself

  # Ref: FRD 6.1 FB-5; FRD 6.3 FB-1
  @TC_NC_003 @Functional @High @Automation
  Scenario: Verify selecting a different Process immediately shows that Process's configurations
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Work Order |
    When the user observes the configuration list for 'Purchase Order'
    And the user selects Process 'Work Order' from the Process list
    And the user observes the configuration list
    Then List immediately refreshes to WO-Cfg-1 (Active) and WO-Cfg-2 (InActive) only
    And No Purchase Order configurations are shown

  # Ref: FRD 6.3 BR-3; FRD 6.3 C-Action; FRD 6.1 FB-6
  @TC_NC_005 @Functional @High @Automation
  Scenario: Verify Activate is shown only on InActive rows and Deactivate only on the Active row
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rows | PO-Cfg-1 (Active)   |
      | Data | PO-Cfg-3 (InActive) |
    When the user observes the Action column of PO-Cfg-1 (Active)
    And the user observes the Action column of PO-Cfg-3 (InActive)
    And the user confirms Edit and Delete are displayed on both rows
    Then PO-Cfg-1 shows Edit, Delete and Deactivate (no Activate)
    And PO-Cfg-3 shows Edit, Delete and Activate (no Deactivate)

  # Ref: FRD 6.3 BR-1; FRD 6.1 BR-1
  @TC_NC_006 @Functional @High @Automation
  Scenario: Verify a view-only user can view the configuration list and switch Process
    Given Viewer_User1 (Number Configuration: view access only) is logged in and on the Number Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Viewer_User1 |
      | Process | Work Order   |
    When the user observes the landing list
    And the user selects Process 'Work Order'
    And the user opens PO-Cfg-1 in view mode
    Then Configuration list is visible for the default Process and updates for 'Work Order'
    And Configuration details can be viewed without create/edit/activate/delete permission

  # Ref: FRD 6.1 BR-2; FRD 6.2 BR-11; FRD 6.2 F-Attribute
  @TC_NC_007 @Functional @High @Automation
  Scenario: Verify the attribute pool is product-defined per Process
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | PO pool | Company Code, Office, Financial Year, Calendar Year, Department |
      | WO pool | Office, Contractor Code, Financial Year                         |
    When the user observes the attribute pool for 'Purchase Order'
    And the user closes the form and open 'Add' for Process 'Work Order'
    And the user observes the attribute pool
    Then Each Process lists only its own product-defined attributes
    And No attribute outside the product-defined list is offered
