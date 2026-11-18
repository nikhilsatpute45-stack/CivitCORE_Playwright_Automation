@NumberConfiguration @NumberConfigurationCreationStartWith
Feature: Number Configuration Creation - Start With
  Automated scenarios for the "Number Configuration Creation - Start With" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-3; FRD 6.2 F-StartWith; FRD 6.2 BR-2
  @TC_NC_153 @Negative @High @Automation
  Scenario: Verify Save is blocked when Start With is cleared
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | (blank) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clears Start With
    And the user clicks Save
    Then Save is blocked with 'Please enter a valid whole number' (mandatory field; exact message for blank is assumed)

  # Ref: FRD 6.2 F-StartWith; FRD 6.2 BR-8
  @TC_NC_154 @Negative @High @Automation
  Scenario: Verify Start With '0' (below the minimum 1 (min-1)) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | '0' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Start With '0'
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid whole number' is displayed (message mapping per Assumptions)
    And No configuration is created

  # Ref: FRD 6.2 F-StartWith; FRD 6.2 BR-8
  @TC_NC_155 @Negative @High @Automation
  Scenario: Verify Start With '-1' (negative) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | '-1' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Start With '-1'
    And the user clicks Save
    Then Save is blocked; error 'Negative values and decimal values are not allowed' is displayed (message mapping per Assumptions)
    And No configuration is created

  # Ref: FRD 6.2 F-StartWith; FRD 6.2 BR-8
  @TC_NC_156 @Negative @High @Automation
  Scenario: Verify Start With '1.5' (decimal) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | '1.5' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Start With '1.5'
    And the user clicks Save
    Then Save is blocked; error 'Negative values and decimal values are not allowed' is displayed (message mapping per Assumptions)
    And No configuration is created

  # Ref: FRD 6.2 F-StartWith; FRD 6.2 BR-8
  @TC_NC_157 @Negative @Medium @Automation
  Scenario: Verify Start With 'abc' (alphabetic) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | 'abc' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Start With 'abc'
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid whole number' is displayed (message mapping per Assumptions)
    And No configuration is created

  # Ref: FRD 6.2 F-StartWith; FRD 6.2 BR-8
  @TC_NC_158 @Negative @Medium @Automation
  Scenario: Verify Start With '1a' (alphanumeric) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | '1a' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Start With '1a'
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid whole number' is displayed (message mapping per Assumptions)
    And No configuration is created

  # Ref: FRD 6.2 F-StartWith; FRD 6.2 BR-8
  @TC_NC_159 @Negative @Medium @Automation
  Scenario: Verify Start With ' ' (whitespace-only) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | ' ' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Start With ' '
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid whole number' is displayed (message mapping per Assumptions)
    And No configuration is created

  # Ref: FRD 6.2 F-StartWith; FRD 6.2 BR-8
  @TC_NC_160 @Negative @Medium @Automation
  Scenario: Verify Start With '01' (with a leading zero) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | '01' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Start With '01'
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid whole number' is displayed (message mapping per Assumptions)
    And No configuration is created

  # Ref: FRD 6.2 F-StartWith; FRD 6.2 BR-8
  @TC_NC_161 @Negative @Medium @Automation
  Scenario: Verify Start With '@#' (special characters) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | '@#' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Start With '@#'
    And the user clicks Save
    Then Save is blocked; error 'Please enter a valid whole number' is displayed (message mapping per Assumptions)
    And No configuration is created
