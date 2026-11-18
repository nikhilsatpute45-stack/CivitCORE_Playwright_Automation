@WorkType @WorkTypeDropdownValues
Feature: Work Type Dropdown Values
  Automated scenarios for the "Work Type Dropdown Values" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.6 BR-3
  @TC_WT_078 @Functional @High @Automation
  Scenario: Verify a backend change to the dropdown values is reflected the next time the Add pop-up is opened
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Backend | Other, Building, Roads + Water |
    When the user adds the backend value 'Water' to the Work Type configuration
    And the user clicks 'Add' and open the Work Type dropdown
    Then Dropdown lists Other, Building, Roads, Water in configured order

  # Ref: FRD 5.6 BR-3
  @TC_WT_079 @Functional @High @Automation
  Scenario: Verify a backend change to the dropdown values is reflected the next time the Edit pop-up is opened
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Backend | Other, Building, Roads + Water |
    When the user adds the backend value 'Water' to the Work Type configuration
    And the user opens Edit for 'Taxiway' and open the Work Type dropdown
    Then Edit dropdown lists Other, Building, Roads, Water in configured order

  # Ref: FRD 5.6 BR-2; FRD 5.3 FB-3
  @TC_WT_080 @Functional @Medium @Automation
  Scenario: Verify the Work Type column search dropdown lists the same backend values in configured order
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Backend | Other, Building, Roads |
    When the user opens the Work Type column search dropdown
    And the user compares with the Add pop-up dropdown
    Then Column search lists All, Other, Building, Roads in the same order as the Add/Edit dropdown

  # Ref: FRD 5.6 BR-4; US-2 AC-8
  @TC_WT_081 @Functional @Medium @Automation
  Scenario: Verify no 'None' value is listed in the Edit dropdown or the column search dropdown
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Backend | Other, Building, Roads |
    When the user opens the Work Type column search dropdown
    And the user opens Edit for 'Taxiway' and open its Work Type dropdown
    Then 'None' is not listed in either dropdown

  # Ref: FRD 5.6 BR-5
  @TC_WT_083 @Functional @Medium @Automation
  Scenario: Verify a Work Type previously saved with 'None' shows a blank Work Type in the list
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the list is displayed; legacy record 'Legacy Zone' (saved with 'None' before this change) exists
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Legacy Zone |
    When the user locates 'Legacy Zone' in the list
    Then The Work Type column is blank for 'Legacy Zone'

  # Ref: FRD 5.6 BR-5
  @TC_WT_084 @Functional @Medium @Automation
  Scenario: Verify a Work Type previously saved with 'None' shows a blank Work Type on the View pop-up
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the list is displayed; legacy record 'Legacy Zone' exists
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Legacy Zone |
    When the user opens View for 'Legacy Zone'
    Then View pop-up shows Work Type blank

  # Ref: FRD 5.6 BR-5
  @TC_WT_085 @Functional @Medium @Automation
  Scenario: Verify the Edit pop-up of a legacy 'None' record opens with 'Select Work Type' in the Work Type field
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the list is displayed; legacy record 'Legacy Zone' exists
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Legacy Zone |
    When the user opens Edit for 'Legacy Zone'
    And the user observes the Work Type field
    Then Work Type field shows the placeholder 'Select Work Type'

  # Ref: FRD 5.6 BR-5
  @TC_WT_086 @Functional @Medium @Automation
  Scenario: Verify a legacy 'None' record can be saved after selecting a real Work Type value
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for the legacy record 'Legacy Zone'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Building |
    When the user selects a Work Type value
    And the user clicks 'Save'
    Then Toaster 'Work Type updated successfully.' is displayed and the list shows 'Legacy Zone' with Work Type 'Building'
