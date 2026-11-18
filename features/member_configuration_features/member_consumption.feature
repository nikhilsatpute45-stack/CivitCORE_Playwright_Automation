@MembersConfiguration @MemberConsumption
Feature: Member Consumption
  Automated scenarios for the "Member Consumption" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.6 FB-1; US-4 AC-3
  @TC_MC_088 @Functional @High @Automation
  Scenario: Verify a using field offers only active members with their Description in backend order
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'Modernization' is inactive
    And Create Work screen is available
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field            | Proposal Nature                                  |
      | Expected options | Project, AMC, Consultancy, Others, Original Work |
    When the user opens the Create Work screen
    And the user opens the Proposal Nature dropdown
    Then Dropdown offers exactly the 5 active members, labelled with their Description, in backend order
    And 'Modernization' is not offered

  # Ref: US-3 AC-2; FRD 5.6 FB-3
  @TC_MC_089 @Functional @High @Automation
  Scenario: Verify a changed Description is shown in the using dropdown the next time the screen is opened
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | RepairAndMaintenance               |
      | Description | AMC -> Annual Maintenance Contract |
    When the user clicks the kebab (⋮) icon of member 'RepairAndMaintenance'
    And the user selects 'Edit'
    And the user replaces Description with 'Annual Maintenance Contract'
    And the user clicks 'Save'
    And the user opens the Create Work screen
    And the user opens the Proposal Nature dropdown
    Then Dropdown shows 'Annual Maintenance Contract' instead of 'AMC'

  # Ref: US-4 AC-3; FRD 5.6 FB-1
  @TC_MC_090 @Functional @High @Automation
  Scenario: Verify a member made inactive is no longer offered on using screens
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Others |
    When the user unchecks the Active checkbox of 'Others'
    And the user opens the Create Work screen
    And the user opens the Proposal Nature dropdown
    Then 'Others' is not offered in the Proposal Nature dropdown

  # Ref: US-4 AC-3; FRD 5.6 FB-2
  @TC_MC_091 @Functional @High @Automation
  Scenario: Verify a saved record keeps an inactive member and shows its Description
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Work WRK-0001 is saved with Proposal Nature = RepairAndMaintenance (Description 'AMC')
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | WRK-0001             |
      | Member | RepairAndMaintenance |
    When the user unchecks the Active checkbox of 'RepairAndMaintenance'
    And the user opens the Work List and view WRK-0001
    Then WRK-0001 still shows Proposal Nature 'AMC'

  # Ref: US-4 AC-4; FRD 5.6 FB-3
  @TC_MC_092 @Functional @High @Automation
  Scenario: Verify a member made active again is offered again the next time the using screen is opened
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'Modernization' is inactive
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Modernization |
    When the user checks the Active checkbox of 'Modernization'
    And the user opens the Create Work screen
    And the user opens the Proposal Nature dropdown
    Then 'Modernization' is offered in the Proposal Nature dropdown in its backend position (3rd)

  # Ref: FRD 5.6 FB-2
  @TC_MC_093 @Functional @High @Automation
  Scenario: Verify saved records show the current Description in lists and details
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Work WRK-0001 is saved with Proposal Nature = RepairAndMaintenance
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record      | WRK-0001                           |
      | Description | AMC -> Annual Maintenance Contract |
    When the user clicks the kebab (⋮) icon of member 'RepairAndMaintenance'
    And the user selects 'Edit'
    And the user replaces Description with 'Annual Maintenance Contract'
    And the user clicks 'Save'
    And the user opens the Work List
    And the user opens WRK-0001 details
    Then Work List and WRK-0001 details show 'Annual Maintenance Contract'

  # Ref: FRD 5.6 BR-1
  @TC_MC_094 @Functional @High @Automation
  Scenario: Verify the application stores a member by Member Name, not Description
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Work WRK-0001 is saved with Proposal Nature = RepairAndMaintenance
    And Database read access is available
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record                | WRK-0001             |
      | Stored value expected | RepairAndMaintenance |
    When the user clicks the kebab (⋮) icon of member 'RepairAndMaintenance'
    And the user selects 'Edit'
    And the user replaces Description with 'Annual Maintenance Contract'
    And the user clicks 'Save'
    And the user reads the stored Proposal Nature value of WRK-0001 from the database
    Then Stored value is still 'RepairAndMaintenance'; the record resolves to the new Description through Member Name

  # Ref: FRD 5.6 BR-2
  @TC_MC_095 @Functional @High @Automation
  Scenario: Verify records saved with a member are unchanged when it is made inactive
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Work WRK-0001 is saved with Proposal Nature = RepairAndMaintenance
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | WRK-0001 |
    When the user unchecks the Active checkbox of 'RepairAndMaintenance'
    And the user reads WRK-0001 from the database
    Then WRK-0001 still stores 'RepairAndMaintenance'; no record was modified

  # Ref: FRD 5.6 BR-2
  @TC_MC_096 @Functional @High @Automation
  Scenario: Verify editing a saved record shows its inactive member as the current value
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And WRK-0001 has Proposal Nature = RepairAndMaintenance, which is inactive
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record          | WRK-0001                   |
      | Inactive member | RepairAndMaintenance (AMC) |
    When the user opens WRK-0001 in Edit mode on the Work screen
    And the user observes the Proposal Nature field
    Then Proposal Nature shows 'AMC' as the current value although the member is inactive

  # Ref: FRD 5.6 EX-1; FRD 5.6 FB-1
  @TC_MC_097 @Functional @Medium @Automation
  Scenario: Verify the Tender Type Description and Active status are used on Create Tender
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Create Tender screen is available
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum | Tender Type                          |
      | Data | SingleTender -> Single Source Tender |
      | Data | LimitedTender -> inactive            |
    When the user edits 'SingleTender' and change Description to 'Single Source Tender'
    And the user unchecks Active of 'LimitedTender'
    And the user opens the Create Tender screen and open the Tender Type field
    Then Tender Type offers 'Open Tender' and 'Single Source Tender' only

  # Ref: FRD 5.6 EX-1; FRD 5.6 FB-1
  @TC_MC_098 @Functional @Medium @Automation
  Scenario: Verify Proposal Classification and LeadQryType values are used by their fields
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Create Proposal and Lead Management Rates screens are available
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Proposal Classification | PSU inactive        |
      | LeadQryType             | Commercial inactive |
    When the user unchecks Active of 'PSU' in 'Proposal Classification'
    And the user unchecks Active of 'Commercial' in 'LeadQryType'
    And the user opens Proposal Classification on Create Proposal
    And the user opens Lead type on Lead Management Rates
    Then Proposal Classification offers 'Government' and 'Private'
    And Lead type offers 'Residential' only

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.6 BR-2
  @TC_MC_178 @Negative @High @Automation
  Scenario: Verify an inactive member cannot be newly selected in other records
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'Modernization' is inactive
    And WRK-0002 has Proposal Nature = Project
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record          | WRK-0002      |
      | Inactive member | Modernization |
    When the user opens WRK-0002 in Edit mode
    And the user opens the Proposal Nature dropdown
    Then 'Modernization' is not offered for selection in WRK-0002

  # Ref: US-4 AC-5; FRD 5.5 BR-4
  @TC_MC_179 @Negative @High @Automation
  Scenario: Verify a Product Enum with all members inactive offers no option on the using field
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And All 3 members of 'Proposal Classification' are inactive
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum | Proposal Classification (Government, Private, PSU inactive) |
    When the user opens the Create Proposal screen
    And the user opens the Proposal Classification dropdown
    Then Dropdown offers no option until a member is made active again
