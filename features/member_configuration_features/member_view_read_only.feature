@MembersConfiguration @MemberViewReadOnly
Feature: Member View - Read-only
  Automated scenarios for the "Member View - Read-only" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-3; FRD 5.3 BR-1
  @TC_MC_158 @Negative @High @Automation
  Scenario: Verify no field can be edited in the View Member pop-up
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'View'
    And the user tries to type into Description
    And the user tries to click the Active checkbox
    Then Description cannot be edited and the Active checkbox cannot be toggled; nothing is saved or logged

  # Ref: US-2 AC-2; FRD 5.3 FB-3
  @TC_MC_159 @Negative @High @Automation
  Scenario: Verify the Edit button is not shown in View Member for a user without Edit permission
    Given Viewer_User1 (Members Configuration: View only) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1 |
      | Member | Project      |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'View'
    And the user observes the pop-up buttons
    Then No 'Edit' button is shown; only 'Close' and the close (X) icon are available
