@NumberConfiguration @NumberConfigurationCreationDigits
Feature: Number Configuration Creation - Digits
  Automated scenarios for the "Number Configuration Creation - Digits" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-3; FRD 6.2 F-Digits; FRD 6.2 BR-2
  @TC_NC_162 @Negative @High @Automation
  Scenario: Verify Save is blocked when Digits is cleared
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Digits | (blank) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clears Digits
    And the user clicks Save
    Then Save is blocked with 'Please enter a valid digit pattern'

  # Ref: FRD 6.2 F-Digits
  @TC_NC_163 @Negative @High @Automation
  Scenario: Verify Digits 'abc' (alphabetic) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Digits | 'abc' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Digits 'abc'
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid digit pattern' / 'only numeric characters are allowed' is displayed
    And No configuration is created

  # Ref: FRD 6.2 F-Digits
  @TC_NC_164 @Negative @Medium @Automation
  Scenario: Verify Digits '00 1' (containing a space) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Digits | '00 1' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Digits '00 1'
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid digit pattern' / 'only numeric characters are allowed' is displayed
    And No configuration is created

  # Ref: FRD 6.2 F-Digits
  @TC_NC_165 @Negative @High @Automation
  Scenario: Verify Digits '0.001' (with a decimal point) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Digits | '0.001' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Digits '0.001'
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid digit pattern' / 'only numeric characters are allowed' is displayed
    And No configuration is created

  # Ref: FRD 6.2 F-Digits
  @TC_NC_166 @Negative @High @Automation
  Scenario: Verify Digits '-0001' (with a negative sign) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Digits | '-0001' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Digits '-0001'
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid digit pattern' / 'only numeric characters are allowed' is displayed
    And No configuration is created

  # Ref: FRD 6.2 F-Digits
  @TC_NC_167 @Negative @Medium @Automation
  Scenario: Verify Digits '00a1' (alphanumeric) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Digits | '00a1' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Digits '00a1'
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid digit pattern' / 'only numeric characters are allowed' is displayed
    And No configuration is created

  # Ref: FRD 6.2 F-Digits
  @TC_NC_168 @Negative @Medium @Automation
  Scenario: Verify Digits '@001' (with a special character) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Digits | '@001' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Digits '@001'
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid digit pattern' / 'only numeric characters are allowed' is displayed
    And No configuration is created
