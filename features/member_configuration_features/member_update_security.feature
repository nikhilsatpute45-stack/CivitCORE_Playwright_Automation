@MembersConfiguration @MemberUpdateSecurity
Feature: Member Update - Security
  Automated scenarios for the "Member Update - Security" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.4 BR-5; FRD 5.4 BR-3
  @TC_MC_160 @Negative @High @Automation
  Scenario: Verify script text in Description is shown as plain text and never executed
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description | <script>alert('x')</script> |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with the script text
    And the user clicks 'Save'
    And the user observes the list
    And the user opens 'View' for 'Others'
    Then Text is saved and displayed as plain text in the list and View pop-up
    And No alert or script executes

  # Ref: FRD 5.4 BR-5
  @TC_MC_161 @Negative @High @Automation
  Scenario: Verify special characters < > & " ' in Description are shown as plain text
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description | A<B>&"C" 'D' |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with the special-character value
    And the user clicks 'Save'
    And the user observes the list
    Then List shows exactly A<B>&"C" 'D' as text; markup is HTML-encoded on display

  # Ref: FRD 5.4 BR-5; FRD 5.6 FB-1
  @TC_MC_162 @Negative @High @Automation
  Scenario: Verify script text in Description is not executed in a consuming dropdown
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description | <img src=x onerror=alert(1)> |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with '<img src=x onerror=alert(1)>'
    And the user clicks 'Save'
    And the user opens the Create Work screen
    And the user opens the Proposal Nature dropdown
    Then Dropdown shows the text as plain text; no alert or script executes

  # Ref: FRD 5.4 BR-5; FRD 5.4 BR-3
  @TC_MC_163 @Negative @High @Automation
  Scenario: Verify SQL injection text in Description is stored as literal text
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description | '; DROP TABLE Members; -- |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with the SQL text
    And the user clicks 'Save'
    And the user reloads the screen
    Then Value is saved as plain text through parameterized queries; no SQL runs and all members are still listed
