@NumberConfiguration @NumberConfigurationCreationSeparator
Feature: Number Configuration Creation - Separator
  Automated scenarios for the "Number Configuration Creation - Separator" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-3; FRD 6.2 F-Separator; FRD 6.2 BR-2
  @TC_NC_142 @Negative @High @Automation
  Scenario: Verify Save is blocked when the common Separator is cleared
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | (blank) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clears the common Separator
    And the user clicks Save
    Then Save is blocked
    And Error 'Separator is required' is displayed; no configuration is created

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_143 @Negative @High @Automation
  Scenario: Verify a two-character common Separator is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | // |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '//' in the common Separator
    And the user clicks Save
    Then Save is blocked with error 'only a single character is allowed'

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_144 @Negative @High @Automation
  Scenario: Verify common Separator 'A' (letter) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | 'A' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters 'A' in the common Separator
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'
    And No configuration is created

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_145 @Negative @High @Automation
  Scenario: Verify common Separator '5' (digit) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | '5' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '5' in the common Separator
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'
    And No configuration is created

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_146 @Negative @High @Automation
  Scenario: Verify common Separator ' ' (space) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | ' ' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters ' ' in the common Separator
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'
    And No configuration is created

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_147 @Negative @Medium @Automation
  Scenario: Verify common Separator '@' ('@') is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | '@' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '@' in the common Separator
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'
    And No configuration is created

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_148 @Negative @Medium @Automation
  Scenario: Verify common Separator '#' ('#') is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | '#' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '#' in the common Separator
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'
    And No configuration is created

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_149 @Negative @Medium @Automation
  Scenario: Verify common Separator '$' ('$') is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | '$' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '$' in the common Separator
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'
    And No configuration is created

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_150 @Negative @Medium @Automation
  Scenario: Verify common Separator '%' ('%') is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | '%' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '%' in the common Separator
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'
    And No configuration is created

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_151 @Negative @Medium @Automation
  Scenario: Verify common Separator '&' ('&') is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | '&' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '&' in the common Separator
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'
    And No configuration is created

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_152 @Negative @Medium @Automation
  Scenario: Verify common Separator '*' ('*') is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | '*' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters '*' in the common Separator
    And the user clicks Save
    Then Save is blocked with error 'only “/”, “-”, “_”, “.”, or “:” are permitted'
    And No configuration is created
