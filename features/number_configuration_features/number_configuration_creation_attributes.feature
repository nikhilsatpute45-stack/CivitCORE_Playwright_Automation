@NumberConfiguration @NumberConfigurationCreationAttributes
Feature: Number Configuration Creation - Attributes
  Automated scenarios for the "Number Configuration Creation - Attributes" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-4; FRD 6.2 BR-10; FRD Sec 8 Toaster #9
  @TC_NC_175 @Negative @High @Automation
  Scenario: Verify Save is blocked when no attribute is added
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attributes | none |
    When the user leaves the attribute grid empty
    And the user clicks Save
    Then Save is blocked
    And Message 'At least one attribute is required to save this configuration.' is displayed
    And No configuration is created

  # Ref: FRD 6.2 BR-10; FRD Sec 8 Toaster #9
  @TC_NC_176 @Negative @High @Automation
  Scenario: Verify Save is blocked after the only attribute is removed
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attributes | none after removal |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user removes 'Office' from the grid
    And the user clicks Save
    Then Message 'At least one attribute is required to save this configuration.' is displayed and nothing is saved

  # Ref: US-1 AC-5; FRD 6.2 F-Abbreviation; FRD Sec 8 Toaster #8
  @TC_NC_177 @Negative @High @Automation
  Scenario: Verify Save is blocked when an Abbreviation is missing
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | (blank) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user leaves Abbreviation blank
    And the user clicks Save
    Then Save is blocked
    And Message 'Abbreviation is required and must be unique across all attributes selected in this configuration.' / 'Abbreviation is required' is displayed

  # Ref: FRD 6.2 F-Abbreviation
  @TC_NC_178 @Negative @Medium @Automation
  Scenario: Verify a whitespace-only Abbreviation is treated as missing
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | ' ' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation ' ' for attribute 'Office'
    And the user clicks Save
    Then After trimming it is blank; Save is blocked with 'Abbreviation is required'

  # Ref: US-1 AC-5; FRD 6.2 BR-14; FRD Sec 8 Toaster #8
  @TC_NC_179 @Negative @High @Automation
  Scenario: Verify a duplicate Abbreviation within the same configuration is blocked
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviations | PO, PO |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'PO' for attribute 'Office'
    And the user drags attribute 'Financial Year' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'PO' for attribute 'Financial Year'
    And the user clicks Save
    Then Save is blocked
    And Message 'Abbreviation is required and must be unique across all attributes selected in this configuration.' is displayed

  # Ref: FRD 6.2 F-Abbreviation; FRD 6.2 BR-14
  @TC_NC_180 @Negative @High @Automation
  Scenario: Verify Abbreviation uniqueness is case-insensitive
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviations | PO, po |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'PO' for attribute 'Office'
    And the user drags attribute 'Financial Year' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'po' for attribute 'Financial Year'
    And the user clicks Save
    Then 'PO' and 'po' are duplicates; Save is blocked with 'Abbreviation is required and must be unique across all attributes selected in this configuration.'

  # Ref: FRD 6.2 F-Abbreviation
  @TC_NC_181 @Negative @Medium @Automation
  Scenario: Verify duplicate detection ignores leading/trailing spaces in Abbreviation
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviations | OFF, ' OFF ' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user drags attribute 'Financial Year' from the attribute pool into the attribute grid
    And the user enters Abbreviation ' OFF ' for attribute 'Financial Year'
    And the user clicks Save
    Then Values are trimmed and treated as duplicates; Save is blocked with 'Abbreviation is required and must be unique across all attributes selected in this configuration.'

  # Ref: FRD 6.2 F-Abbreviation
  @TC_NC_182 @Negative @High @Automation
  Scenario: Verify Abbreviation 'A B' (containing a space) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | A B |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'A B' for attribute 'Office'
    And the user clicks Save
    Then Save is blocked with error 'Only alphanumeric characters are allowed'

  # Ref: FRD 6.2 F-Abbreviation
  @TC_NC_183 @Negative @Medium @Automation
  Scenario: Verify Abbreviation 'OF-F' (containing a hyphen) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | OF-F |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OF-F' for attribute 'Office'
    And the user clicks Save
    Then Save is blocked with error 'Only alphanumeric characters are allowed'

  # Ref: FRD 6.2 F-Abbreviation
  @TC_NC_184 @Negative @Medium @Automation
  Scenario: Verify Abbreviation 'OFF#' (containing a special character) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | OFF# |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF#' for attribute 'Office'
    And the user clicks Save
    Then Save is blocked with error 'Only alphanumeric characters are allowed'

  # Ref: FRD 6.2 F-Abbreviation
  @TC_NC_185 @Negative @Medium @Automation
  Scenario: Verify Abbreviation 'ÖFF' (containing a non-ASCII letter) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | ÖFF |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'ÖFF' for attribute 'Office'
    And the user clicks Save
    Then Save is blocked with error 'Only alphanumeric characters are allowed'

  # Ref: FRD 6.2 F-Abbreviation
  @TC_NC_186 @Negative @High @Automation
  Scenario: Verify an 11-character Abbreviation (max+1) is rejected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | ABCDE123456 (11 chars) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'ABCDE123456' for attribute 'Office'
    And the user clicks Save
    Then Save is blocked; the value is not accepted beyond 10 characters (error text not defined; see Assumptions)

  # Ref: FRD 6.2 BR-12; US-3 AC-1
  @TC_NC_187 @Negative @High @Automation
  Scenario: Verify the same attribute cannot be added twice via API
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute | Office x2 |
    When the user sends a create request listing attribute 'Office' twice with Abbreviations 'OFF' and 'OF2'
    Then Request is rejected; an attribute can be added only once (no longer selectable once added)

  # Ref: FRD 6.2 BR-11
  @TC_NC_188 @Negative @High @Automation
  Scenario: Verify an attribute outside the product-defined pool is rejected via API
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute | Cost Centre |
    When the user sends a create request for 'Purchase Order' with attribute 'Cost Centre' (not in the pool)
    Then Request is rejected; nothing is created

  # Ref: FRD 6.2 BR-11; FRD 6.2 F-Attribute
  @TC_NC_189 @Negative @High @Automation
  Scenario: Verify an attribute from another Process's pool is rejected via API
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute | Contractor Code |
    When the user sends a create request for 'Purchase Order' with attribute 'Contractor Code' (Work Order only)
    Then Request is rejected; the pool is specific to the selected Process

  # Ref: FRD 6.1 BR-2; FRD 6.2 F-Process
  @TC_NC_190 @Negative @High @Automation
  Scenario: Verify a configuration for an unknown Process is rejected via API
    Given API client authenticated with the token of Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Gate Pass |
    When the user sends a create request for Process 'Gate Pass' (not product-defined)
    Then Request is rejected; Processes are defined only at product level
