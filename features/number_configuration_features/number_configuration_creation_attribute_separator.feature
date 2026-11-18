@NumberConfiguration @NumberConfigurationCreationAttributeSeparator
Feature: Number Configuration Creation - Attribute Separator
  Automated scenarios for the "Number Configuration Creation - Attribute Separator" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.2 BR-15; FRD 6.2 F-AttrSeparator
  @TC_NC_197 @Negative @High @Automation
  Scenario: Verify Save is blocked when an attribute Separator is cleared
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute Separator | (blank) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clears the Separator of 'Office'
    And the user clicks Save
    Then Save is blocked; attribute Separator is mandatory (error text not defined; see Assumptions)

  # Ref: FRD 6.2 F-AttrSeparator; FRD 6.2 BR-15
  @TC_NC_198 @Negative @High @Automation
  Scenario: Verify a two-character attribute Separator is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute Separator | -- |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '--' in the Separator of 'Office'
    And the user clicks Save
    Then Save is blocked with error 'Only a single character is allowed'

  # Ref: FRD 6.2 F-AttrSeparator
  @TC_NC_199 @Negative @High @Automation
  Scenario: Verify attribute Separator 'A' (letter) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute Separator | 'A' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters 'A' in the Separator of 'Office'
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'

  # Ref: FRD 6.2 F-AttrSeparator
  @TC_NC_200 @Negative @High @Automation
  Scenario: Verify attribute Separator '7' (digit) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute Separator | '7' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '7' in the Separator of 'Office'
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'

  # Ref: FRD 6.2 F-AttrSeparator
  @TC_NC_201 @Negative @High @Automation
  Scenario: Verify attribute Separator ' ' (space) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute Separator | ' ' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters ' ' in the Separator of 'Office'
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'

  # Ref: FRD 6.2 F-AttrSeparator
  @TC_NC_202 @Negative @Medium @Automation
  Scenario: Verify attribute Separator '#' ('#') is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute Separator | '#' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '#' in the Separator of 'Office'
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'

  # Ref: FRD 6.2 F-AttrSeparator
  @TC_NC_203 @Negative @Medium @Automation
  Scenario: Verify attribute Separator '@' ('@') is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute Separator | '@' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '@' in the Separator of 'Office'
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'
