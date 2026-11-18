@AuthNAuthZ @RoleSwitching
Feature: Role Switching
  Automated scenarios for the "Role Switching" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-8 AC-1; 6.8 SW-2
  @TC_CP_081 @Functional @High @Automation
  Scenario: Verify Switch Role lists all assigned active roles in assignment order with active role marked
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Roles | Project Manager (active), Finance Viewer |
    When the user clicks Switch Role in the header
    Then List shows Project Manager (marked active) then Finance Viewer (US-8 AC-1, 6.8 SW-2)

  # Ref: US-8 AC-2; 6.8 SW-3; 6.9 BR-5
  @TC_CP_082 @Functional @High @Automation
  Scenario: Verify switching to Finance Viewer reloads menus with that role's permissions and opens module home
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And Rahul is on the Project Schedule page
    And the following test data is used
      | Switch to | Finance Viewer |
    When the user selects 'Finance Viewer' in Switch Role
    And the user inspects the header, menu and landing page
    Then Finance Viewer is active in header; menus and controls are reloaded with Finance Viewer permissions only; module home page opens (US-8 AC-2, 6.8 SW-3, 6.9 BR-5)

  # Ref: 6.8 BR-2
  @TC_CP_083 @Functional @High @Automation
  Scenario: Verify Finance Viewer permissions after switching (Rahul table)
    Given rahul.sharma switched to Finance Viewer
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Finance Viewer | Allowed, Denied, Allowed, Denied |
    When the user checks 'View project', 'Edit schedule', 'View financial reports', 'Approve invoice'
    Then Results match the Finance Viewer column of the Active Role example (6.8 BR-2)

  # Ref: US-8 AC-4; 6.8 SW-4
  @TC_CP_084 @Functional @High @Automation
  Scenario: Verify the same active role remains after moving to another module through SSO
    Given rahul.sharma switched to Finance Viewer
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Module | CivitINFRA |
    When the user opens CivitINFRA from the module menu
    And the user checks the active role in the header
    Then Finance Viewer remains active in CivitINFRA (US-8 AC-4, 6.8 SW-4)

  # Ref: US-8 AC-5
  @TC_CP_085 @Functional @Medium @Automation
  Scenario: Verify Switch Role is not shown for a user with only one role
    Given anita.desai (single role Site Engineer) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | anita.desai |
    When the user inspects the header
    Then No Switch Role control is displayed (US-8 AC-5)

  # Ref: US-8 AC-6; 6.8 SW-6
  @TC_CP_086 @Functional @High @Automation
  Scenario: Verify login after logout starts with the first assigned role regardless of last used role
    Given rahul.sharma switched to Finance Viewer
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | First role | Project Manager |
    When the user logs out and login again to Alpha Infra Ltd
    Then Project Manager is active (US-8 AC-6, 6.8 SW-6)

  # Ref: 6.8 SW-5; 6.8 BR-3
  @TC_CP_087 @Functional @Medium @Automation
  Scenario: Verify role switching does not change the active organization and inactive roles are not listed
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And Store Keeper (inactive) is assigned to rahul.sharma
    And the following test data is used
      | Inactive role | Store Keeper |
    When the user switches role and check the header and Switch Role list
    Then Active organization is unchanged; inactive roles are not listed (6.8 SW-5, 6.8 BR-3)

  # Ref: 6.8 SW-3
  @TC_CP_088 @Functional @Medium @Automation
  Scenario: Verify unsaved changes on the open page are not saved when switching role
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And Edit form is open with unsaved changes
    And the following test data is used
      | Typed | 'Draft' |
    When the user types a change in an open form
    And the user switches role
    Then Role switches; unsaved changes are not saved (6.8 SW-3)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-8 AC-3; EX-10
  @TC_CP_232 @Negative @High @Automation
  Scenario: Verify page of another role is denied after switching, by menu and by URL
    Given rahul.sharma switched to Finance Viewer
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Page | Project Schedule (Project Manager only) |
    When the user looks for 'Project Schedule' edit page in the menu
    And the user opens its URL directly
    Then Menu entry is absent and the URL shows 'You do not have permission to access this page.' (US-8 AC-3, EX-10)

  # Ref: EX-17; 7.1 A-Switch
  @TC_CP_233 @Negative @High @Automation
  Scenario: Verify switching to a role not assigned to the user is rejected and audited
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role requested | Quality Auditor |
    When the user sends a switch-role API request for 'Quality Auditor' (not assigned to Rahul)
    Then HTTP 403 'You do not have permission to use this role.'; the active role is unchanged; 'Role Switch Denied' is audited (EX-17, 7.1)

  # Ref: EX-17
  @TC_CP_234 @Negative @Medium @Automation
  Scenario: Verify the Switch Role control cannot be forced for a single-role user
    Given anita.desai is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Finance Viewer |
    When the user sends a switch-role API request for 'Finance Viewer'
    Then Request is rejected with 403 (EX-17)
