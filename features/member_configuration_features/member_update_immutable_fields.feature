@MembersConfiguration @MemberUpdateImmutableFields
Feature: Member Update - Immutable Fields
  Automated scenarios for the "Member Update - Immutable Fields" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.4 BR-1; FRD 5.4 F-MemberName
  @TC_MC_155 @Negative @High @Automation
  Scenario: Verify Member Name cannot be edited in the Edit pop-up
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member Name | Project |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user clicks into the Member Name field and try to type 'Project2'
    Then Member Name is read-only; typing has no effect and the value stays 'Project'

  # Ref: FRD 5.4 F-ProductEnum
  @TC_MC_156 @Negative @High @Automation
  Scenario: Verify Product Enum cannot be changed in the Edit pop-up
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product Enum | Proposal Nature |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user clicks into the Product Enum field and try to change it to 'Tender Type'
    Then Product Enum is read-only and stays 'Proposal Nature'

  # Ref: FRD 5.4 BR-1
  @TC_MC_157 @Negative @High @Automation
  Scenario: Verify the server does not change Member Name when it is sent in an update request
    Given API client authenticated with the token of Admin_User1
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member             | Project        |
      | Payload memberName | ProjectRenamed |
    When the user sends an update-member request for 'Project' with Member Name 'ProjectRenamed' and Description 'Capital Project'
    And the user reads the member
    Then Member Name remains 'Project' (changed name rejected or ignored); no member named 'ProjectRenamed' exists
