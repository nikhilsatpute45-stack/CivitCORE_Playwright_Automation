@WorkType @WorkTypeConsumption
Feature: Work Type Consumption
  Automated scenarios for the "Work Type Consumption" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.7 FB-1; FRD 5.7 FB-3
  @TC_WT_087 @Functional @High @Automation
  Scenario: Verify a newly created Work Type is available in the Sub Work Type screen
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | Building       |
    When the user creates the Work Type
    And the user opens the Sub Work Type screen and open the Work Type selection
    Then 'Cargo Terminal' is offered for selection in the Sub Work Type screen without further configuration

  # Ref: FRD 5.7 FB-2; FRD 5.7 FB-3
  @TC_WT_088 @Functional @High @Automation
  Scenario: Verify a newly created Work Type is available on the Create Work form
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Add Work Type' pop-up is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Cargo Terminal |
      | Work Type      | Building       |
    When the user creates the Work Type
    And the user opens the Create Work form and open the Work Type selection
    Then 'Cargo Terminal' is offered for selection on the Create Work form

  # Ref: FRD 5.7 FB-1
  @TC_WT_089 @Functional @Medium @Automation
  Scenario: Verify the Sub Work Type screen lists Work Types in the same order as the Work Type List (newest first)
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Baseline | 9 Work Types |
    When the user notes the list order of Work Types
    And the user opens the Sub Work Type screen and view the Work Type selection
    Then Sub Work Type screen lists Boundary Wall, Apron, Taxiway, Parking Bay, Fuel Farm, Control Tower, Hanger, Terminal Building, Runway in that order

  # Ref: FRD 5.7 FB-2
  @TC_WT_090 @Functional @Medium @Automation
  Scenario: Verify the Create Work form lists Work Types in the same order as the Work Type List (newest first)
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Baseline | 9 Work Types |
    When the user opens the Create Work form and view the Work Type selection
    Then Create Work form lists the Work Types in the same newest-first order as the list

  # Ref: US-6 AC-2; FRD 5.7 FB-5
  @TC_WT_091 @Functional @High @Automation
  Scenario: Verify a deleted Work Type is no longer offered in the Sub Work Type screen
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user deletes 'Taxiway' (confirm Yes)
    And the user opens the Sub Work Type screen and open the Work Type selection
    Then 'Taxiway' is not offered in the Sub Work Type screen

  # Ref: US-6 AC-2; FRD 5.7 FB-5
  @TC_WT_092 @Functional @High @Automation
  Scenario: Verify a deleted Work Type is no longer offered on the Create Work form
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
    When the user deletes 'Taxiway' (confirm Yes)
    And the user opens the Create Work form and open the Work Type selection
    Then 'Taxiway' is not offered on the Create Work form

  # Ref: FRD 5.7 BR-1
  @TC_WT_093 @Functional @High @Automation
  Scenario: Verify Works refer to a Work Type by Internal ID and not by name (rename does not detach the Work)
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rename | Control Tower -> ATC Tower; new: Control Tower / Roads |
    When the user renames 'Control Tower' to 'ATC Tower' and Save
    And the user creates a new Work Type named 'Control Tower'
    And the user opens Work WRK-0003
    Then WRK-0003 still shows 'ATC Tower' (Building), not the new 'Control Tower'
