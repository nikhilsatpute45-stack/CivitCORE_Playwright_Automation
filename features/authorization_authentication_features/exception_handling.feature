@AuthNAuthZ @ExceptionHandling
Feature: Exception Handling
  Automated scenarios for the "Exception Handling" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: EX-15; 6.9 BR-5
  @TC_CP_243 @Negative @High @Automation
  Scenario: Verify active-role permission change during session applies from next request
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Action removed | Edit |
    When the user removes an action from Project Manager; use that action in the next request
    Then The action is denied (EX-15, 6.9 BR-5)

  # Ref: EX-14
  @TC_CP_244 @Negative @High @Automation
  Scenario: Verify account deactivation during session shows the inactive message on next request
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | rahul.sharma |
    When the user deactivates rahul.sharma; send a request
    Then 'Your account is inactive. Please contact your administrator.' (EX-14)
