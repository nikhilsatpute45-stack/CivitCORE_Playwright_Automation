@AuthNAuthZ @OrganizationOfficeMapping
Feature: Organization & Office Mapping
  Automated scenarios for the "Organization & Office Mapping" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-6 AC-1; 6.7 FB-1; 6.7 FB-2
  @TC_CP_055 @Functional @High @Automation
  Scenario: Verify administrator can map a user to organizations and offices of that organization and save
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | kiran.patil     |
      | Org    | Alpha Infra Ltd |
      | Office | Pune Office     |
    When the user opens User Organization & Office Mapping
    And the user selects user 'kiran.patil'
    And the user adds 'Alpha Infra Ltd' and tick 'Pune Office'
    And the user clicks Save and reopen the user
    Then Mapping is saved and listed with the org and office (US-6 AC-1, 6.7 FB-1, 6.7 FB-2)

  # Ref: 6.7 BR-1
  @TC_CP_056 @Functional @Medium @Automation
  Scenario: Verify a user can be mapped to many organizations and many offices
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | anita.desai |
    When the user maps user 'anita.desai' to Alpha (Head Office, Pune Office) and Beta Constructions (Mumbai Office)
    And the user saves
    Then Both organizations with all selected offices are saved (6.7 BR-1)

  # Ref: 6.7 FB-3
  @TC_CP_057 @Functional @Medium @Automation
  Scenario: Verify mapping screen lists the user's organizations with offices and read-only roles
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | rahul.sharma |
    When the user selects rahul.sharma on the mapping screen
    And the user inspects the grid and try to edit the roles column
    Then Alpha (Head Office, Pune Office; Project Manager, Finance Viewer) and Beta (Mumbai Office; Finance Viewer) are listed; the roles column is read-only (6.7 FB-3)

  # Ref: 6.7 FB-2
  @TC_CP_058 @Functional @High @Automation
  Scenario: Verify removing an organization after confirmation removes its offices and roles
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | rahul.sharma       |
      | Org removed | Beta Constructions |
    When the user selects rahul.sharma and remove 'Beta Constructions'
    And the user reads the confirmation and click Continue
    And the user saves and reopen
    Then Confirmation 'Removing this organization will also remove the user's offices and roles in it. Continue?' is shown
    And After Continue the org, Mumbai Office and Finance Viewer assignment are removed (6.7 FB-2)

  # Ref: US-6 AC-2; 6.7 BR-2
  @TC_CP_059 @Functional @High @Automation
  Scenario: Verify a user mapped to Office X only cannot list or open records of other offices
    Given pune.user is mapped only to Pune Office of Alpha Infra Ltd
    And Project 'PRJ-HO-01' belongs to Head Office
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Records | PRJ-PU-01 (Pune)        |
      | Data    | PRJ-HO-01 (Head Office) |
    When the user logs in as pune.user to Alpha Infra Ltd
    And the user opens Project Listing
    And the user opens the Head Office record by direct URL
    Then Only Pune records are listed; the Head Office record is denied with 'You do not have permission to access this record.' (US-6 AC-2, 6.7 BR-2)

  # Ref: 6.7 BR-5
  @TC_CP_060 @Functional @Medium @Automation
  Scenario: Verify organization and office pick-lists contain only active masters
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Inactive org    | Delta Legacy Pvt Ltd |
      | Inactive office | Nagpur Office        |
    When the user opens the mapping screen for kiran.patil
    And the user expands the organization and office pick-lists
    Then Inactive organization and office are not selectable (6.7 BR-5)

  # Ref: 6.7 BR-4
  @TC_CP_061 @Functional @Medium @Automation
  Scenario: Verify mapping changes apply to the affected user from the next request
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded. admin.user is logged in in another browser
    And the following test data is used
      | Office | Pune Office |
    When As admin.user remove the Pune Office mapping of rahul.sharma
    And As rahul.sharma open Pune data on the next request
    Then The change applies on the next request without relogin (6.7 BR-4)

  # Ref: US-6 AC-3; EX-14
  @TC_CP_062 @Functional @High @Automation
  Scenario: Verify session ends when the active organization mapping is removed during the session
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Org | Alpha Infra Ltd |
    When As admin.user remove the 'Alpha Infra Ltd' mapping of rahul.sharma
    And As rahul.sharma click any menu
    Then Session ends and Login shows 'Your access to this organization has been removed. Please log in again.' (US-6 AC-3, EX-14)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: 6.7 BR-1
  @TC_CP_215 @Negative @High @Automation
  Scenario: Verify an office cannot be selected under a different organization
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Office | Pune Office under Gamma Water Board |
    When the user selects kiran.patil, add 'Gamma Water Board'
    And the user tries to select 'Pune Office' (Alpha Infra Ltd)
    Then The office is not offered/accepted under another organization (6.7 BR-1)

  # Ref: 6.7 FB-2
  @TC_CP_216 @Negative @High @Automation
  Scenario: Verify Cancel in the organization removal confirmation keeps mapping unchanged
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Org | Beta Constructions |
    When the user removes 'Beta Constructions' from rahul.sharma
    And the user clicks Cancel in the confirmation
    Then No change is made to organization, offices or roles (6.7 FB-2)

  # Ref: 6.7 BR-3; EX-06
  @TC_CP_217 @Negative @High @Automation
  Scenario: Verify an operation requiring an office is denied when no office is mapped
    Given nooffice.user is mapped to Alpha Infra Ltd with no office
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | nooffice.user |
    When the user logs in as nooffice.user and perform an office-specific operation (create a project)
    Then 'No office is assigned to you for this operation. Please contact your administrator.' is shown; 'Access Denied' is audited (6.7 BR-3, EX-06)

  # Ref: 6.7 BR-4; EX-11
  @TC_CP_218 @Negative @High @Automation
  Scenario: Verify users without Manage User Access cannot change mappings (UI and API)
    Given roleadmin.user (Manage Roles only) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | roleadmin.user |
    When the user opens the mapping screen URL
    And the user sends a mapping save API request
    Then UI is denied and API returns 403; no change is saved (6.7 BR-4, EX-11)
