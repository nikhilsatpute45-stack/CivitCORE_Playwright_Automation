@NumberConfiguration @NumberGenerationConsumption
Feature: Number Generation (Consumption)
  Automated scenarios for the "Number Generation (Consumption)" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-6 AC-1; FRD 6.5 FB-1; FRD 6.5 FB-3; FRD 6.5 FB-5
  @TC_NC_077 @Functional @High @Automation
  Scenario: Verify a number is generated from the Active configuration attributes in Order
    Given PO-Cfg-1 is Active (Separator '/', Start With 1, Digits 0001, FY format 'YYYY-YY'; attributes: 1 Office, 2 Financial Year; running sequence at 6)
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process        | Purchase Order |
      | Office         | HO             |
      | Financial Year | 2026           |
    When the user requests a Purchase Order number supplying Office 'HO' and Financial Year 2026
    And the user reads the returned number
    Then Attributes are resolved in configured Order (Office then Financial Year) and the running sequence is added
    And Returned number is e.g. 'HO/2026-27/0007' (sequence placement per Assumptions)

  # Ref: FRD 6.5 FB-3; US-6 AC-1; FRD 6.2 BR-13
  @TC_NC_078 @Functional @High @Automation
  Scenario: Verify the generated number follows the reordered attribute sequence
    Given Purchase Order configuration PO-Cfg-3 is Active with attributes reordered to 1 Financial Year, 2 Office (Separator '/')
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Office         | HO   |
      | Financial Year | 2026 |
    When the user requests a Purchase Order number supplying Office 'HO' and Financial Year 2026
    Then Segments follow the new Order: Financial Year segment before Office segment

  # Ref: FRD 6.5 FB-4; US-6 AC-1
  @TC_NC_079 @Functional @High @Automation
  Scenario: Verify Prefix and Suffix surround the resolved value of an attribute
    Given Active Purchase Order configuration has Office with Prefix 'P-' and Suffix '-X'
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Office | HO |
      | Prefix | P- |
      | Suffix | -X |
    When the user requests a Purchase Order number supplying Office 'HO'
    Then The Office segment is 'P-HO-X' (Prefix + resolved value + Suffix)

  # Ref: FRD 6.5 FB-4; FRD 6.2 BR-16; FRD 6.2 F-Display
  @TC_NC_080 @Functional @High @Automation
  Scenario: Verify an attribute with Display unchecked is excluded from the generated number
    Given Active Purchase Order configuration has Office (Display unchecked) and Financial Year (Display checked)
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Office         | HO (Display off) |
      | Financial Year | 2026             |
    When the user requests a Purchase Order number supplying Office 'HO' and Financial Year 2026
    Then The Office segment is not included; the Financial Year segment is

  # Ref: FRD 6.5 FB-4; US-3 AC-4; FRD 6.2 BR-15
  @TC_NC_081 @Functional @High @Automation
  Scenario: Verify an overridden attribute Separator is used instead of the common Separator
    Given Active Purchase Order configuration: common Separator '/', Financial Year Separator overridden to '-'
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Common                   | / |
      | Financial Year Separator | - |
    When the user requests a Purchase Order number supplying Office 'HO' and Financial Year 2026
    Then The overridden '-' is used for that attribute's join in place of '/' (join position per Assumptions)

  # Ref: FRD 6.5 BR-2
  @TC_NC_082 @Functional @High @Automation
  Scenario: Verify the running sequence increments on each successful generation
    Given PO-Cfg-1 is Active (Separator '/', Start With 1, Digits 0001, FY format 'YYYY-YY'; attributes: 1 Office, 2 Financial Year; running sequence at 6)
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Sequence before | 6 |
    When the user requests a Purchase Order number (Office 'HO', FY 2026)
    And the user requests a second Purchase Order number with the same values
    Then First number ends with 0007 and the second with 0008

  # Ref: FRD 6.2 F-Digits; FRD 6.5 FB-3
  @TC_NC_083 @Functional @High @Automation
  Scenario: Verify the sequence is zero-padded to the Digits width
    Given Active configuration has Digits '00001' (width 5), Start With 1 and no sequence generated yet
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Digits | 00001 |
    When the user requests a number
    Then The sequence segment is '00001'

  # Ref: FRD 6.2 F-StartWith; US-3 AC-6
  @TC_NC_084 @Functional @High @Automation
  Scenario: Verify the first sequence value equals Start With
    Given Active configuration has Start With 100, Digits 0001 and no sequence generated yet
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | 100 |
    When the user requests a number
    Then The sequence segment is '0100'

  # Ref: FRD 6.2 F-FYFormat; FRD 6.2 BR-6; FRD 6.2 BR-3
  @TC_NC_085 @Functional @Medium @Automation
  Scenario: Verify Financial Year / Budget Year format 'YYYY' is applied to the Financial Year segment
    Given Active configuration includes 'Financial Year' with Financial Year / Budget Year Format 'YYYY'
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Format         | YYYY |
      | Financial Year | 2026 |
    When the user requests a number supplying Financial Year 2026
    Then The Financial Year segment is rendered as '2026'

  # Ref: FRD 6.2 F-FYFormat; FRD 6.2 BR-6; FRD 6.2 BR-3
  @TC_NC_086 @Functional @Medium @Automation
  Scenario: Verify Financial Year / Budget Year format 'YYYY-YYYY' is applied to the Financial Year segment
    Given Active configuration includes 'Financial Year' with Financial Year / Budget Year Format 'YYYY-YYYY'
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Format         | YYYY-YYYY |
      | Financial Year | 2026      |
    When the user requests a number supplying Financial Year 2026
    Then The Financial Year segment is rendered as '2026-2027'

  # Ref: FRD 6.2 F-FYFormat; FRD 6.2 BR-6; FRD 6.2 BR-3
  @TC_NC_087 @Functional @Medium @Automation
  Scenario: Verify Financial Year / Budget Year format 'YY-YY' is applied to the Financial Year segment
    Given Active configuration includes 'Financial Year' with Financial Year / Budget Year Format 'YY-YY'
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Format         | YY-YY |
      | Financial Year | 2026  |
    When the user requests a number supplying Financial Year 2026
    Then The Financial Year segment is rendered as '26-27'

  # Ref: FRD 6.2 F-FYFormat; FRD 6.2 BR-6; FRD 6.2 BR-3
  @TC_NC_088 @Functional @Medium @Automation
  Scenario: Verify Financial Year / Budget Year format 'YYYY-YY' is applied to the Financial Year segment
    Given Active configuration includes 'Financial Year' with Financial Year / Budget Year Format 'YYYY-YY'
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Format         | YYYY-YY |
      | Financial Year | 2026    |
    When the user requests a number supplying Financial Year 2026
    Then The Financial Year segment is rendered as '2026-27'

  # Ref: FRD 6.2 F-CYFormat; FRD 6.2 BR-6; FRD 6.2 BR-4
  @TC_NC_089 @Functional @Medium @Automation
  Scenario: Verify Calendar Year format 'YYYY' is applied to the Calendar Year segment
    Given Active configuration includes 'Calendar Year' with Calendar Year Format 'YYYY'
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Format        | YYYY |
      | Calendar Year | 2026 |
    When the user requests a number supplying Calendar Year 2026
    Then The Calendar Year segment is rendered as '2026'

  # Ref: FRD 6.2 F-CYFormat; FRD 6.2 BR-6; FRD 6.2 BR-4
  @TC_NC_090 @Functional @Medium @Automation
  Scenario: Verify Calendar Year format 'YY' is applied to the Calendar Year segment
    Given Active configuration includes 'Calendar Year' with Calendar Year Format 'YY'
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Format        | YY   |
      | Calendar Year | 2026 |
    When the user requests a number supplying Calendar Year 2026
    Then The Calendar Year segment is rendered as '26'

  # Ref: US-3 AC-6; FRD 6.5 BR-2; FRD 6.2 BR-17
  @TC_NC_091 @Functional @High @Automation
  Scenario: Verify the sequence restarts at Start With when a Start New Number attribute value changes
    Given PO-Cfg-1 is Active (Separator '/', Start With 1, Digits 0001, FY format 'YYYY-YY'; attributes: 1 Office, 2 Financial Year; running sequence at 6)
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Data | Financial Year (Start New Number checked): 2026 then 2027 |
    When the user requests a number with Financial Year 2026 (sequence 0007)
    And the user requests a number with Financial Year 2027
    Then Second number's sequence resets to the Start With value ('0001')

  # Ref: FRD 6.2 BR-17; FRD 6.5 BR-2
  @TC_NC_092 @Functional @High @Automation
  Scenario: Verify the sequence continues when an attribute with Start New Number unchecked changes value
    Given PO-Cfg-1 is Active (Separator '/', Start With 1, Digits 0001, FY format 'YYYY-YY'; attributes: 1 Office, 2 Financial Year; running sequence at 6)
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Office | HO then BR |
    When the user requests a number with Office 'HO'
    And the user requests a number with Office 'BR' (Office has Start New Number unchecked)
    Then Second number's sequence continues (no reset to Start With)

  # Ref: US-6 AC-3; FRD 6.5 FB-6; FRD 6.6 DT-2
  @TC_NC_093 @Functional @High @Automation
  Scenario: Verify the configuration is marked as used at the transaction level after successful generation
    Given PO-Cfg-3 is Active and unused
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-3 |
    When the user requests a Purchase Order number
    And the user deactivates PO-Cfg-3 (Admin_User1)
    And the user attempts Delete on PO-Cfg-3
    Then Configuration is flagged 'used' after generation
    And Delete is blocked with 'This Number Configuration has already been used and cannot be deleted.'

  # Ref: FRD 6.5 BR-1; FRD 6.5 FB-2
  @TC_NC_094 @Functional @High @Automation
  Scenario: Verify only the Active configuration is used when several exist for the Process
    Given PO-Cfg-1 is Active (Separator '/', Start With 1, Digits 0001, FY format 'YYYY-YY'; attributes: 1 Office, 2 Financial Year; running sequence at 6)
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Active   | PO-Cfg-1       |
      | InActive | PO-Cfg-2, 3, 4 |
    When the user requests a Purchase Order number
    And the user checks which configuration generated it
    Then Number is generated using PO-Cfg-1 only; InActive configurations are ignored

  # Ref: FRD 6.5 BR-1; US-4 AC-2
  @TC_NC_095 @Functional @High @Automation
  Scenario: Verify new numbers follow the newly Active configuration while earlier numbers stay unchanged
    Given PO-Cfg-1 is Active (Separator '/', Start With 1, Digits 0001, FY format 'YYYY-YY'; attributes: 1 Office, 2 Financial Year; running sequence at 6)
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New Active | PO-Cfg-3 |
    When the user activates PO-Cfg-3 and confirm
    And the user requests a Purchase Order number
    And the user reads the number generated earlier under PO-Cfg-1
    Then New number follows PO-Cfg-3
    And Previously generated numbers remain unchanged

  # Ref: FRD 6.5 FB-2
  @TC_NC_096 @Functional @Medium @Automation
  Scenario: Verify the Active configuration is resolved for the requesting Organization
    Given ORG-A and ORG-B each have a different Active Purchase Order configuration (see Summary)
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Organizations | ORG-A, ORG-B |
    When the user requests a Purchase Order number in the context of ORG-A
    And the user requests a Purchase Order number in the context of ORG-B
    Then Each request uses the Active configuration of its own Organization (assumes configurations are Organization-scoped; see Assumptions)

  # Ref: FRD 6.5 BR-4; FRD 6.5 FB-3
  @TC_NC_097 @Functional @Medium @Automation
  Scenario: Verify product-supplied attribute values are used as supplied and not validated by CivitCORE
    Given PO-Cfg-1 is Active (Separator '/', Start With 1, Digits 0001, FY format 'YYYY-YY'; attributes: 1 Office, 2 Financial Year; running sequence at 6)
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Office | ZZ9 |
    When the user requests a number supplying Office 'ZZ9' (a value not in any Office master)
    Then Number is generated using 'ZZ9' as supplied; CivitCORE raises no validation error for product-level values

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-6 AC-2; FRD 6.5 BR-1
  @TC_NC_222 @Negative @High @Automation
  Scenario: Verify no number is generated when the Process has no Active configuration
    Given Purchase Order has no Active configuration (PO-Cfg-1 deactivated)
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Purchase Order |
    When the user requests a Purchase Order number
    Then No number is generated; the response indicates that no Active configuration exists (text not defined)

  # Ref: FRD 6.5 BR-1; US-6 AC-2
  @TC_NC_223 @Negative @High @Automation
  Scenario: Verify a Process whose configurations are all InActive does not generate a number
    Given Work Order has only InActive configurations (WO-Cfg-1 deactivated)
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Work Order |
    When the user requests a Work Order number
    Then No number is generated; no InActive configuration is used as a fallback

  # Ref: FRD 6.5 FB-6; US-6 AC-3
  @TC_NC_224 @Negative @Medium @Automation
  Scenario: Verify a failed generation does not mark any configuration as used
    Given WO-Cfg-1 deactivated; WO-Cfg-2 InActive and unused
    And API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | WO-Cfg-2 |
    When the user requests a Work Order number (fails)
    And the user deletes WO-Cfg-2 as Admin_User1 and confirm
    Then WO-Cfg-2 is not marked used; delete succeeds with toaster 'Number Configuration deleted successfully.'

  # Ref: FRD 6.5 FB-2; FRD 6.1 BR-2
  @TC_NC_225 @Negative @Medium @Automation
  Scenario: Verify a generation request for an unknown Process is rejected
    Given API client authenticated as the CivitBUILD consuming-product service (number generation request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Gate Pass |
    When the user requests a number for Process 'Gate Pass'
    Then Request is rejected; no number is generated
