@MembersConfiguration @ActivityAuditLog
Feature: Activity / Audit Log
  Automated scenarios for the "Activity / Audit Log" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-7 AC-1; FRD 6 FB-1; FRD 6 FB-3; FRD 6.1 A-Desc
  @TC_MC_105 @Functional @High @Automation
  Scenario: Verify a Description change creates an Activity Log entry with all required information
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | RepairAndMaintenance               |
      | Data   | AMC -> Annual Maintenance Contract |
      | User   | Admin_User1                        |
    When the user clicks the kebab (⋮) icon of member 'RepairAndMaintenance'
    And the user selects 'Edit'
    And the user replaces Description 'AMC' with 'Annual Maintenance Contract'
    And the user clicks 'Save'
    And the user logs in as Auditor_User1 and open the Activity Log section
    Then Entry 'Description Changed' exists with User 'Admin_User1', Date-Time, Product Enum 'Proposal Nature', Member Name 'RepairAndMaintenance', previous Description 'AMC' and new Description 'Annual Maintenance Contract'

  # Ref: US-7 AC-1; FRD 6.1 A-Active; FRD 5.5 FB-2
  @TC_MC_106 @Functional @High @Automation
  Scenario: Verify an Active change from the list creates an Activity Log entry with source 'List'
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project   |
      | Active | Yes -> No |
    When the user unchecks the Active checkbox of 'Project'
    And the user logs in as Auditor_User1 and open the Activity Log section
    Then Entry 'Active Status Changed' exists with User, Date-Time, Product Enum 'Proposal Nature', Member Name 'Project', previous status 'Active', new status 'Inactive' and source 'List'

  # Ref: FRD 6.1 A-Active; US-7 AC-1
  @TC_MC_107 @Functional @High @Automation
  Scenario: Verify an Active change from the Edit pop-up creates an Activity Log entry with source 'Edit pop-up'
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project   |
      | Active | Yes -> No |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user unchecks 'Active'
    And the user clicks 'Save'
    And the user logs in as Auditor_User1 and open the Activity Log section
    Then Entry 'Active Status Changed' exists with previous 'Active', new 'Inactive' and source 'Edit pop-up'

  # Ref: US-7 AC-2; FRD 5.4 FB-5
  @TC_MC_108 @Functional @High @Automation
  Scenario: Verify an Edit changing both Description and Active captures both fields with previous and new values
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others                  |
      | Description | Others -> Miscellaneous |
      | Active      | Yes -> No               |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description 'Others' with 'Miscellaneous'
    And the user unchecks 'Active'
    And the user clicks 'Save'
    And the user logs in as Auditor_User1 and open the Activity Log section
    Then The entry captures both fields: Description 'Others' -> 'Miscellaneous' and Active 'Yes' -> 'No'

  # Ref: FRD 6 FB-2
  @TC_MC_109 @Functional @High @Automation
  Scenario: Verify each Activity Log entry is linked to the Product Enum and Member Name concerned
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum   | Tender Type |
      | Member | OpenTender  |
    When the user selects 'Tender Type'
    And the user edits 'OpenTender' and change Description to 'Open Competitive Tender'
    And the user clicks 'Save'
    And the user logs in as Auditor_User1 and filter the Activity Log by Product Enum 'Tender Type' and Member Name 'OpenTender'
    Then The new entry is returned for Product Enum 'Tender Type' and Member Name 'OpenTender' and is not linked to any other member

  # Ref: FRD 6 FB-4
  @TC_MC_110 @Functional @Medium @Automation
  Scenario: Verify Activity Log entries are shown most recent first
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member  | Project                                     |
      | Changes | Project -> Capital Project -> Capital Works |
    When the user edits 'Project' and change Description to 'Capital Project'; Save
    And the user edits 'Project' and change Description to 'Capital Works'; Save
    And the user logs in as Auditor_User1 and open the Activity Log for member 'Project'
    Then Entry 'Capital Project' -> 'Capital Works' is listed above entry 'Project' -> 'Capital Project'

  # Ref: FRD 6 FB-4
  @TC_MC_111 @Functional @Medium @Automation
  Scenario: Verify the Members Configuration screen does not display Activity Log entries
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Member 'Project' has at least one Activity Log entry
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project |
    When the user observes the Members Configuration list and the View and Edit pop-ups of 'Project'
    Then No Activity Log information is shown on the screen or the pop-ups; entries are viewable only in the separate Activity Log section

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6 FB-4
  @TC_MC_180 @Negative @High @Automation
  Scenario: Verify Activity Log entries cannot be edited by any user
    Given API client authenticated with the token of Auditor_User1
    And Entry for member 'Project' exists
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User  | Auditor_User1  |
      | Entry | Project change |
    When the user sends an update request for an Activity Log entry of 'Project'
    And the user reads the entry
    Then Request is rejected; entry values are unchanged

  # Ref: FRD 6 FB-4
  @TC_MC_181 @Negative @High @Automation
  Scenario: Verify Activity Log entries cannot be deleted by any user
    Given API client authenticated with the token of Admin_User1
    And Entry for member 'Project' exists
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User  | Admin_User1    |
      | Entry | Project change |
    When the user sends a delete request for an Activity Log entry of 'Project'
    And the user reads the Activity Log
    Then Request is rejected; the entry is still present
