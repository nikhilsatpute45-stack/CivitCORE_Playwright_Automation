@AuthNAuthZ @RoleManagement
Feature: Role Management
  Automated scenarios for the "Role Management" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: 6.8 FB-1
  @TC_CP_063 @Functional @Medium @Automation
  Scenario: Verify Role Master lists Sl. No., Role Name, Description, Status, kebab actions, Add, column search and 50 records per page
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded. 60 roles exist
    And the following test data is used
      | Roles  | 60 seeded |
      | Search | Project   |
    When the user opens Role Master
    And the user counts the records on page 1 and use the column search for 'Project'
    And the user opens the kebab menu of a row
    Then Columns Sl. No., Role Name, Description, Status are displayed; page 1 has 50 records; search returns 'Project Manager'; kebab lists View, Edit, Activate/Deactivate; Add is available (6.8 FB-1)

  # Ref: US-7 AC-1; 6.8 FB-2
  @TC_CP_064 @Functional @High @Automation
  Scenario: Verify a unique Role Name creates the role as Active
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role Name   | Estimator               |
      | Description | Prepares cost estimates |
    When the user clicks Add
    And the user enters Role Name 'Estimator' and Description 'Prepares cost estimates'
    And the user clicks Save
    Then Role is created with Status 'Active' by default (US-7 AC-1, 6.8 FB-2)

  # Ref: 6.8 FB-2
  @TC_CP_065 @Functional @Medium @Automation
  Scenario: Verify Role Name of exactly 100 characters and Description of exactly 250 characters are accepted
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role Name   | 'R' x 100 |
      | Description | 'd' x 250 |
    When the user adds a Role with a 100-character Role Name and a 250-character Description
    And the user saves
    Then Role is saved with both values intact (6.8 FB-2 boundaries)

  # Ref: 6.8 FB-2
  @TC_CP_066 @Functional @Medium @Automation
  Scenario: Verify Description is optional
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role Name   | Planner |
      | Description | (blank) |
    When the user adds Role 'Planner' leaving Description empty
    And the user saves
    Then Role is saved without Description (6.8 FB-2)

  # Ref: 6.8 FB-2
  @TC_CP_067 @Functional @Medium @Automation
  Scenario: Verify editing a Role's name and description and keeping its own name unchanged on save
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Quality Auditor -> Quality Lead |
    When the user edits 'Quality Auditor': change Description to 'Audits quality'
    And the user saves
    And the user edits again, change Role Name to 'Quality Lead' and save
    Then Both edits are saved; saving with the unchanged own name is not flagged as duplicate (6.8 FB-2)

  # Ref: 6.8 FB-3
  @TC_CP_068 @Functional @High @Automation
  Scenario: Verify deactivating a role after confirmation sets it Inactive and keeps the role record
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Site Engineer |
    When the user opens kebab of 'Site Engineer' and click Deactivate
    And the user reads the confirmation and click Continue
    And the user checks the Role Master for the role and any delete option
    Then Confirmation 'Deactivating this role will remove its permissions from all users who have it. Continue?' is displayed
    And Role shows Inactive and remains listed; no delete option exists (6.8 FB-3)

  # Ref: 6.8 FB-1; 6.8 BR-3
  @TC_CP_069 @Functional @Medium @Automation
  Scenario: Verify an inactive role can be activated again
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Store Keeper |
    When the user opens kebab of inactive role 'Store Keeper' and click Activate
    Then Role becomes Active and can be assigned again (6.8 FB-1, 6.8 BR-3)

  # Ref: 6.8 FB-4; 6.8 BR-3
  @TC_CP_070 @Functional @High @Automation
  Scenario: Verify User-Role Assignment lists only mapped organizations and active roles, then saves
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User  | anita.desai                    |
      | Org   | Alpha Infra Ltd                |
      | Roles | Site Engineer, Quality Auditor |
    When the user opens User-Role Assignment and select 'anita.desai'
    And the user opens the organization list
    And the user ticks 'Site Engineer' and 'Quality Auditor' for Alpha Infra Ltd and Save
    Then Only mapped orgs appear; inactive roles ('Store Keeper') are not offered; roles are saved (6.8 FB-4, 6.8 BR-3)

  # Ref: 6.8 FB-5; 6.8 BR-7
  @TC_CP_071 @Functional @High @Automation
  Scenario: Verify assigned roles are shown in assignment order with Assigned On and the first marked 'Default at login'
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Roles | Finance Viewer (day 1), then Quality Auditor + Site Engineer (day 2) |
    When the user assigns 'Finance Viewer' to anita.desai, then later assign 'Site Engineer' and 'Quality Auditor' together
    And the user views the assignment screen
    Then Order: Finance Viewer, Quality Auditor, Site Engineer (roles saved together are ordered by Role Name) with Assigned On date-time; Finance Viewer is marked 'Default at login' (6.8 FB-5, 6.8 BR-7)

  # Ref: 6.8 FB-5
  @TC_CP_072 @Functional @High @Automation
  Scenario: Verify a user with no role can log in but sees no module and the no-role message
    Given kiran.patil has no role in Gamma Water Board
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | kiran.patil       |
      | Org  | Gamma Water Board |
    When the user logs in as kiran.patil to 'Gamma Water Board'
    Then Login succeeds but no module is shown and 'You do not have any role in this organization. Please contact your administrator.' is displayed (6.8 FB-5)

  # Ref: 6.8 BR-1; US-7 AC-3
  @TC_CP_073 @Functional @High @Automation
  Scenario: Verify a role assigned in Organization A has no effect in Organization B
    Given rahul.sharma has Project Manager in Alpha only
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | rahul.sharma       |
      | Org  | Beta Constructions |
    When the user logs in to 'Beta Constructions' and inspect permissions and Switch Role
    Then Only 'Finance Viewer' permissions apply; Project Manager has no effect in Beta (6.8 BR-1, US-7 AC-3)

  # Ref: 6.8 BR-2; US-7 AC-2
  @TC_CP_074 @Functional @High @Automation
  Scenario: Verify only the active role's permissions apply (Rahul as Project Manager)
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Project Manager | View project=Allowed, Edit schedule=Allowed, View financial reports=Denied, Approve invoice=Denied |
    When the user checks 'View project', 'Edit schedule', 'View financial reports' and 'Approve invoice'
    Then Results exactly match the Project Manager column; Finance Viewer permissions are not combined (6.8 BR-2, US-7 AC-2)

  # Ref: US-7 AC-4; EX-16; 6.8 BR-6
  @TC_CP_075 @Functional @High @Automation
  Scenario: Verify an active-role removal during session ends session in all modules with role message
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role removed | Project Manager |
    When As admin.user remove 'Project Manager' from rahul.sharma
    And As rahul.sharma send any request
    Then Session ends in all modules; Login shows 'Your role has been changed by the administrator. Please log in again.' (US-7 AC-4, EX-16, 6.8 BR-6)

  # Ref: US-7 AC-4; 6.8 BR-6
  @TC_CP_076 @Functional @High @Automation
  Scenario: Verify after re-login the first remaining role is active, or the no-role message appears if none remain
    Given Project Manager removed from rahul.sharma earlier (Finance Viewer remains)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | rahul.sharma |
    When the user logs in as rahul.sharma to Alpha Infra Ltd
    And the user removes Finance Viewer too and login again
    Then First login: 'Finance Viewer' is active
    And Second login: no-role message is shown (US-7 AC-4, 6.8 BR-6)

  # Ref: US-7 AC-5; 6.8 BR-6
  @TC_CP_077 @Functional @High @Automation
  Scenario: Verify removing a non-active role keeps the session and removes it from Switch Role from next request
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role removed | Finance Viewer (non-active) |
    When As admin.user remove 'Finance Viewer' from rahul.sharma
    And As rahul.sharma perform an action and open Switch Role
    Then Session continues; Finance Viewer no longer listed (US-7 AC-5, 6.8 BR-6)

  # Ref: 6.8 BR-4; EX-16
  @TC_CP_078 @Functional @High @Automation
  Scenario: Verify deactivated role is removed from permissions of its users from the next request
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Project Manager |
    When As admin.user deactivate 'Project Manager'
    And As rahul.sharma perform an action
    Then Role changes apply on the next request; active-role deactivation ends the session (EX-16, 6.8 BR-4)

  # Ref: 6.8 BR-5
  @TC_CP_079 @Functional @High @Automation
  Scenario: Verify Role Master and Permission Configuration are available only with Manage Roles permission
    Given roleadmin.user (Manage Roles only) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | roleadmin.user |
    When the user opens Role Master and Role Permission Configuration
    And the user opens User-Role Assignment
    Then Role Master and Permission Configuration open; User-Role Assignment is not available (6.8 BR-5)

  # Ref: 6.8 BR-5; 6.7 BR-4
  @TC_CP_080 @Functional @High @Automation
  Scenario: Verify User-Role Assignment is available only with Manage User Access permission
    Given accessadmin.user (Manage User Access only) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | accessadmin.user |
    When the user opens User-Role Assignment and User Organization & Office Mapping
    And the user opens Role Master
    Then Assignment and Mapping open; Role Master is not available (6.8 BR-5, 6.7 BR-4)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-7 AC-1; 6.8 FB-2
  @TC_CP_219 @Negative @High @Automation
  Scenario: Verify duplicate Role Name shows 'A role with this name already exists.' (case-insensitive)
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role Name | project manager (existing: Project Manager) |
    When the user adds Role 'project manager' (lower case)
    And the user saves
    Then 'A role with this name already exists.' is shown and the role is not created (US-7 AC-1, 6.8 FB-2)

  # Ref: 6.8 FB-2
  @TC_CP_220 @Negative @High @Automation
  Scenario: Verify duplicate Role Name with different casing 'PROJECT MANAGER' is rejected
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role Name | PROJECT MANAGER |
    When the user adds Role 'PROJECT MANAGER'
    And the user saves
    Then 'A role with this name already exists.' is shown (6.8 FB-2)

  # Ref: 6.8 FB-2
  @TC_CP_221 @Negative @High @Automation
  Scenario: Verify editing a Role Name to another existing name is rejected
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role Name | finance viewer |
    When the user edits 'Site Engineer' and change the name to 'finance viewer'
    And the user saves
    Then 'A role with this name already exists.' is shown and the old name is retained (6.8 FB-2)

  # Ref: 6.8 FB-2
  @TC_CP_222 @Negative @High @Automation
  Scenario: Verify empty Role Name is not saved
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role Name | (blank) |
    When the user clicks Add, leave Role Name empty
    And the user saves
    Then Save is blocked with a mandatory validation (error text not defined in FRD - see Summary note)

  # Ref: 6.8 FB-2
  @TC_CP_223 @Negative @Medium @Automation
  Scenario: Verify Role Name of 101 characters is rejected
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role Name | 'R' x 101 |
    When the user enters a 101-character Role Name and Save
    Then Value is blocked or truncated at 100 characters and no role with 101 characters exists (6.8 FB-2)

  # Ref: 6.8 FB-2
  @TC_CP_224 @Negative @Medium @Automation
  Scenario: Verify Description of 251 characters is rejected
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Description | 'd' x 251 |
    When the user enters Role Name 'Planner2' and a 251-character Description; Save
    Then Value is blocked or truncated at 250 characters (6.8 FB-2)

  # Ref: 6.8 BR-3
  @TC_CP_225 @Negative @High @Automation
  Scenario: Verify an inactive role cannot be assigned to a user
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Store Keeper (Inactive) |
    When the user opens User-Role Assignment for anita.desai, org Alpha Infra Ltd
    And the user looks for inactive role 'Store Keeper'; also post an assignment API request with it
    Then The inactive role is not listed and the API rejects it (6.8 BR-3)

  # Ref: 6.8 BR-3; US-7 AC-5
  @TC_CP_226 @Negative @High @Automation
  Scenario: Verify an inactive role cannot be active and is not listed in Switch Role
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Finance Viewer |
    When the user deactivates Finance Viewer from admin.user
    And the user reloads and open Switch Role
    Then Finance Viewer is not listed (6.8 BR-3, US-7 AC-5)

  # Ref: 6.8 BR-5; EX-10; EX-11
  @TC_CP_227 @Negative @High @Automation
  Scenario: Verify Role Master and Permission Configuration are denied to users without Manage Roles
    Given accessadmin.user (Manage User Access only) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | accessadmin.user |
    When the user opens Role Master URL and send a role create API request
    Then UI shows Access Denied page and the API returns 403 (6.8 BR-5, EX-10, EX-11)

  # Ref: 6.8 FB-3
  @TC_CP_228 @Negative @Medium @Automation
  Scenario: Verify roles cannot be deleted
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Quality Auditor |
    When the user looks for a Delete option in the kebab menu
    And the user sends a DELETE API for 'Quality Auditor'
    Then No delete option exists and the API is rejected; the role stays for history (6.8 FB-3)

  # Ref: 6.8 FB-3
  @TC_CP_229 @Negative @High @Automation
  Scenario: Verify Cancel on the role deactivation confirmation keeps the role Active
    Given admin.user (Manage Roles + Manage User Access) is logged in to Alpha Infra Ltd
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Finance Viewer |
    When the user deactivates 'Finance Viewer' and click Cancel on the confirmation
    Then Role remains Active and users keep their permissions (6.8 FB-3)

  # Ref: 6.8 FB-5; EX-10
  @TC_CP_230 @Negative @High @Automation
  Scenario: Verify user without a role gets no module and no permissions in that organization
    Given kiran.patil has no role
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | kiran.patil |
    When the user logs in to Gamma Water Board and open a module URL directly
    Then No module is shown; direct URL access is denied (6.8 FB-5, EX-10)

  # Ref: 6.8 BR-2; EX-11
  @TC_CP_231 @Negative @High @Automation
  Scenario: Verify permissions of another role are not combined with the active role
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | API | GET /financial-reports |
    When With Project Manager active, call the financial reports API (allowed only for Finance Viewer)
    Then HTTP 403 'Access denied'; permissions are not combined (6.8 BR-2, EX-11)
