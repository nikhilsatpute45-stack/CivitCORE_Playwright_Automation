@MembersConfiguration @BackendManagedMembers
Feature: Backend-Managed Members
  Automated scenarios for the "Backend-Managed Members" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.7 BR-3
  @TC_MC_103 @Functional @Medium @Automation
  Scenario: Verify a member added in the backend appears the next time the Product Enum is loaded with the backend Description and Active status
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And A new member 'Tendering2' (Description 'Tender Stage 2', Active = No) is added to 'Modules' in the backend
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum               | Modules        |
      | New backend member | Tendering2     |
      | Description        | Tender Stage 2 |
      | Active             | No             |
    When the user selects 'Tender Type' in the Product Enum dropdown
    And the user selects 'Modules' again
    And the user locates 'Tendering2'
    Then 'Tendering2' is listed with Description 'Tender Stage 2' and Active unchecked, in its backend position

  # Ref: FRD 5.7 BR-1; FRD 5.2 FB-2
  @TC_MC_104 @Functional @Medium @Automation
  Scenario: Verify member order and Member Name are taken from the backend configuration
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And The backend order of 'Consultancy' and 'Others' is swapped in the backend configuration
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Backend order after change | Project, RepairAndMaintenance, Modernization, Others, Consultancy, OriginalWork |
    When the user selects 'Tender Type' in the Product Enum dropdown
    And the user selects 'Proposal Nature' again
    And the user observes the row order and Member Name column
    Then List shows the new backend order; Member Names are unchanged and cannot be reordered or renamed on the screen
