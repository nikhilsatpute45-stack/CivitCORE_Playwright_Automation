@MembersConfiguration @MemberConsumptionModules
Feature: Member Consumption - Modules
  Automated scenarios for the "Member Consumption - Modules" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-1; FRD 5.6 FB-4
  @TC_MC_099 @Functional @High @Automation
  Scenario: Verify a changed Modules Description appears at once in Role Permission Configuration
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Role Permission Configuration is available in another session
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum        | Modules                       |
      | Member      | ContractorBill                |
      | Description | Billing -> Contractor Billing |
    When the user clicks the kebab (⋮) icon of member 'ContractorBill'
    And the user selects 'Edit'
    And the user replaces Description 'Billing' with 'Contractor Billing'
    And the user clicks 'Save'
    And the user opens Role Permission Configuration and view the module list (entitlement tree)
    Then Module list of Role Permission Configuration shows 'Contractor Billing' immediately, without relogin

  # Ref: US-5 AC-2; FRD 5.6 FB-4
  @TC_MC_100 @Functional @High @Automation
  Scenario: Verify users see the changed Modules Description in their module menu from their next login
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Billing_User1 has the Billing module entitlement
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Billing_User1                 |
      | Description | Billing -> Contractor Billing |
    When the user clicks the kebab (⋮) icon of member 'ContractorBill'
    And the user selects 'Edit'
    And the user replaces Description 'Billing' with 'Contractor Billing'
    And the user clicks 'Save'
    And the user logs in as Billing_User1 (new login)
    And the user observes the module menu
    Then Module menu of Billing_User1 shows 'Contractor Billing' after the next login

  # Ref: US-5 AC-3; FRD 5.6 FB-4
  @TC_MC_101 @Functional @High @Automation
  Scenario: Verify an inactive Modules member is removed from Role Permission Configuration
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum   | Modules        |
      | Member | ContractorBill |
    When the user selects 'Modules' in the Product Enum dropdown
    And the user unchecks the Active checkbox of 'ContractorBill'
    And the user opens Role Permission Configuration and view the module list
    Then The module is no longer shown in Role Permission Configuration

  # Ref: US-5 AC-3; FRD 5.6 FB-4
  @TC_MC_102 @Functional @High @Automation
  Scenario: Verify an inactive Modules member is removed from user module menus from their next login
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Billing_User1 has the Billing module entitlement
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Billing_User1  |
      | Member | ContractorBill |
    When the user selects 'Modules'
    And the user unchecks the Active checkbox of 'ContractorBill'
    And the user logs in as Billing_User1 (new login)
    And the user observes the module menu
    Then Module menu of Billing_User1 does not show the module after the next login
