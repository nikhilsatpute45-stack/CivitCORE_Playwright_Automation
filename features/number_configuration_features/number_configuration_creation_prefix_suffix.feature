@NumberConfiguration @NumberConfigurationCreationPrefixSuffix
Feature: Number Configuration Creation - Prefix / Suffix
  Automated scenarios for the "Number Configuration Creation - Prefix / Suffix" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.2 F-Prefix
  @TC_NC_191 @Negative @High @Automation
  Scenario: Verify an HTML tag in Prefix is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Prefix | <b>X</b> |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Prefix '<b>X</b>'
    And the user clicks Save
    Then Save is blocked with error 'Prefix contains an unsupported character'

  # Ref: FRD 6.2 F-Prefix
  @TC_NC_192 @Negative @High @Automation
  Scenario: Verify a script in Prefix is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Prefix | <script>alert(1)</script> |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Prefix '<script>alert(1)</script>'
    And the user clicks Save
    Then Save is blocked with error 'Prefix contains an unsupported character'; no content is stored

  # Ref: FRD 6.2 F-Prefix
  @TC_NC_193 @Negative @Medium @Automation
  Scenario: Verify an 11-character Prefix (max+1) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Prefix | ABCDEFGHIJK (11 chars) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Prefix 'ABCDEFGHIJK'
    And the user clicks Save
    Then Save is blocked; the Prefix is not accepted beyond 10 characters (error text not defined; Suffix limit is a 'Recommendation')

  # Ref: FRD 6.2 F-Suffix
  @TC_NC_194 @Negative @High @Automation
  Scenario: Verify an HTML tag in Suffix is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Suffix | <b>X</b> |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Suffix '<b>X</b>'
    And the user clicks Save
    Then Save is blocked with error 'Suffix contains an unsupported character'

  # Ref: FRD 6.2 F-Suffix
  @TC_NC_195 @Negative @High @Automation
  Scenario: Verify a script in Suffix is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Suffix | <script>alert(1)</script> |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Suffix '<script>alert(1)</script>'
    And the user clicks Save
    Then Save is blocked with error 'Suffix contains an unsupported character'; no content is stored

  # Ref: FRD 6.2 F-Suffix
  @TC_NC_196 @Negative @Medium @Automation
  Scenario: Verify an 11-character Suffix (max+1) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Suffix | ABCDEFGHIJK (11 chars) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Suffix 'ABCDEFGHIJK'
    And the user clicks Save
    Then Save is blocked; the Suffix is not accepted beyond 10 characters (error text not defined; Suffix limit is a 'Recommendation')
