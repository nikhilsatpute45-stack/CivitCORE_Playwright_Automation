@AuthNAuthZ @LoginUsingOtpUi
Feature: Login Using OTP UI
  Automated scenarios for the "Login Using OTP UI" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: 6.3 F-OTP
  @TC_CP_131 @UIVisual @Medium @Automation
  Scenario: Verify OTP box accepts digits only
    Given OTP Verification screen is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed | ab12!@ |
    When the user types 'ab12!@' in the OTP box
    Then Only digits '12' are accepted; letters and symbols are not accepted (6.3 F-OTP)
