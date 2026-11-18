@MembersConfiguration @MemberUpdateDescriptionValidation
Feature: Member Update - Description Validation
  Automated scenarios for the "Member Update - Description Validation" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-3; FRD Sec 7 FE-1; FRD 5.4 BR-2
  @TC_MC_137 @Negative @High @Automation
  Scenario: Verify blank Description is rejected with 'Description is required.' and not saved
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Project |
      | Description | (blank) |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user clears the Description field
    And the user clicks 'Save'
    Then Field-level error 'Description is required.' is shown below Description
    And Pop-up stays open; record is not saved

  # Ref: US-3 AC-3; FRD 5.4 BR-2; FRD Sec 7 FE-1
  @TC_MC_138 @Negative @High @Automation
  Scenario: Verify a spaces-only Description is rejected as blank
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Project        |
      | Description | ' ' (6 spaces) |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user replaces Description with 6 spaces
    And the user clicks 'Save'
    Then Value is trimmed to empty; error 'Description is required.' is shown and nothing is saved

  # Ref: FRD 5.4 FB-4; FRD Sec 7 TR-1
  @TC_MC_139 @Negative @High @Automation
  Scenario: Verify a validation failure shows no toaster
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description | (blank) |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user clears the Description field
    And the user clicks 'Save'
    And the user observes the screen for 5 seconds
    Then Only the field-level error is shown; no toaster (success or error) is displayed

  # Ref: FRD 5.4 FB-4; FRD 6 FB-1
  @TC_MC_140 @Negative @High @Automation
  Scenario: Verify a blank Description keeps the pop-up open and no Activity Log entry is created
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Project |
      | Description | (blank) |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user clears the Description field
    And the user clicks 'Save'
    And the user closes the pop-up and, as Auditor_User1, check the Activity Log for 'Project'
    Then Pop-up stayed open after Save
    And No Activity Log entry and no Last Modified update exist for the failed save

  # Ref: US-3 AC-4; FRD Sec 7 FE-2; FRD 5.4 BR-4
  @TC_MC_141 @Negative @High @Automation
  Scenario: Verify an exact duplicate Description in the same enum is rejected
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum        | Proposal Nature |
      | Member      | Others          |
      | Description | Project         |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with 'Project'
    And the user clicks 'Save'
    Then Field-level error 'A member with this description already exists in this enum.' is shown
    And Pop-up stays open and nothing is saved

  # Ref: US-3 AC-4; FRD 5.4 BR-4
  @TC_MC_142 @Negative @High @Automation
  Scenario: Verify a duplicate Description in lower case is rejected (case-insensitive)
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others  |
      | Description | project |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with 'project'
    And the user clicks 'Save'
    Then Error 'A member with this description already exists in this enum.' is shown; nothing is saved

  # Ref: US-3 AC-4; FRD 5.4 BR-4
  @TC_MC_143 @Negative @High @Automation
  Scenario: Verify a duplicate Description in upper case is rejected (case-insensitive)
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others  |
      | Description | PROJECT |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with 'PROJECT'
    And the user clicks 'Save'
    Then Error 'A member with this description already exists in this enum.' is shown; nothing is saved

  # Ref: US-3 AC-4; FRD 5.4 BR-2; FRD 5.4 BR-4
  @TC_MC_144 @Negative @High @Automation
  Scenario: Verify a duplicate Description with leading and trailing spaces is rejected (trim before check)
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others      |
      | Description | ' Project ' |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with the value that has leading and trailing spaces
    And the user clicks 'Save'
    Then Value is trimmed to 'Project'; error 'A member with this description already exists in this enum.' is shown

  # Ref: FRD 5.4 BR-2; FRD 5.4 BR-4
  @TC_MC_145 @Negative @High @Automation
  Scenario: Verify a duplicate Description after reducing repeated internal spaces is rejected
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others                                                |
      | Description | 'Original Work' (6 spaces) duplicates 'Original Work' |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with the value that has repeated internal spaces
    And the user clicks 'Save'
    Then Spaces are reduced to one; error 'A member with this description already exists in this enum.' is shown

  # Ref: FRD 5.4 BR-4; FRD Sec 7 FE-2
  @TC_MC_146 @Negative @Medium @Automation
  Scenario: Verify a Description equal to an inactive member's Description in the same enum is rejected
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'Modernization' is inactive
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others                          |
      | Description | Modernization (inactive member) |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with 'Modernization'
    And the user clicks 'Save'
    Then Error 'A member with this description already exists in this enum.' is shown; uniqueness covers all members of the enum

  # Ref: FRD 5.4 FB-4
  @TC_MC_147 @Negative @Medium @Automation
  Scenario: Verify the entered value is retained after a duplicate-description error
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description typed | project |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with 'project'
    And the user clicks 'Save'
    And the user observes the Description field
    Then Pop-up stays open and the Description field still contains 'project'

  # Ref: FRD 5.4 F-Desc
  @TC_MC_148 @Negative @High @Automation
  Scenario: Verify typing stops at 100 characters in Description (max+1 boundary)
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed | 'D' x 101 |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user clicks in Description and clear it
    And the user types 101 characters one after another
    Then Field accepts only 100 characters; the 101st character is not entered

  # Ref: FRD 5.4 F-Desc
  @TC_MC_149 @Negative @High @Automation
  Scenario: Verify pasted text longer than 100 characters is cut at 100
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pasted | 'D' x 150 |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user clears Description
    And the user pastes the 150-character text into Description
    Then Description holds exactly the first 100 characters

  # Ref: FRD 5.4 BR-5; FRD 5.4 F-Desc
  @TC_MC_150 @Negative @High @Automation
  Scenario: Verify the server rejects a Description of 101 characters sent directly
    Given API client authenticated with the token of Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Admin_User1 |
      | Member      | Others      |
      | Description | 'D' x 101   |
    When the user sends an update-member request with a 101-character Description for member 'Others'
    And the user reads the member
    Then Request is rejected; stored Description of 'Others' is unchanged

  # Ref: FRD 5.4 BR-5; FRD 5.4 BR-2
  @TC_MC_151 @Negative @High @Automation
  Scenario: Verify the server rejects a blank Description sent directly
    Given API client authenticated with the token of Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others          |
      | Description | (blank and ' ') |
    When the user sends an update-member request with a blank Description for member 'Others'
    And the user reads the member
    Then Request is rejected for both values; stored Description is unchanged

  # Ref: FRD 5.4 BR-5; FRD 5.4 BR-4; FRD 5.4 FB-3
  @TC_MC_152 @Negative @High @Automation
  Scenario: Verify the server rejects a duplicate Description sent directly
    Given API client authenticated with the token of Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others      |
      | Description | ' pROJECT ' |
    When the user sends an update-member request for member 'Others' with Description ' pROJECT '
    And the user reads the member
    Then Request is rejected as a duplicate of 'Project'; stored Description is unchanged

  # Ref: FRD 5.4 FB-4; US-3 AC-3
  @TC_MC_153 @Negative @Medium @Automation
  Scenario: Verify Active is not saved when the Description in the same Save is blank
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Project   |
      | Description | blank     |
      | Active      | unchecked |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user clears Description
    And the user unchecks 'Active'
    And the user clicks 'Save'
    And the user clicks 'Cancel' and check the list
    Then Error 'Description is required.' is shown
    And After Cancel, 'Project' is still active; the save was blocked as a whole

  # Ref: US-3 AC-7; FRD 5.4 FB-7
  @TC_MC_154 @Negative @Medium @Automation
  Scenario: Verify Cancel after a validation error saves nothing
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others  |
      | Description | Project |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with 'Project'
    And the user clicks 'Save' to get the duplicate error
    And the user clicks 'Cancel'
    Then Pop-up closes and 'Others' keeps Description 'Others'; no toaster
