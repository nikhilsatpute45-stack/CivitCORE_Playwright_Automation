@AuthNAuthZ @PermissionHierarchy
Feature: Permission Hierarchy
  Automated scenarios for the "Permission Hierarchy" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: 6.9 FB-1
  @TC_CP_089 @Functional @Medium @Automation
  Scenario: Verify Role Permission Configuration shows tree, action checkboxes, Excluded per child, expand/collapse and Save
    Given roleadmin.user (Manage Roles) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Project Manager |
    When the user opens Role Permission Configuration and select role 'Project Manager'
    And the user expands and collapse nodes
    Then Tree Process > Sub-process > Page > Control/Action with one checkbox per available action, an Excluded checkbox per child node, expand/collapse and Save (6.9 FB-1)

  # Ref: US-9 AC-1; 6.9 FB-3; 6.9 BR-1
  @TC_CP_090 @Functional @High @Automation
  Scenario: Verify ticking View and Create on a Process is inherited by all children and no other action is granted
    Given roleadmin.user is logged in
    And Role 'Estimator' has no permissions
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Project Management |
      | Actions | View, Create       |
    When the user selects 'Estimator'
    And the user ticks View and Create on Process 'Project Management' and Save
    And the user checks Sub-processes and Pages
    Then Every Sub-process and Page has View and Create shown as inherited (greyed tick); Delete and Approve are not granted (US-9 AC-1, 6.9 FB-3, 6.9 BR-1)

  # Ref: 6.9 FB-4
  @TC_CP_091 @Functional @High @Automation
  Scenario: Verify ticking an action on a child node applies to that child only
    Given roleadmin.user is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Page   | Invoice Listing |
      | Action | Approve         |
    When the user selects 'Estimator'
    And the user ticks 'Approve' on Page 'Invoice Listing' only and Save
    Then Approve is granted only on Invoice Listing; siblings are unchanged (6.9 FB-4)

  # Ref: US-9 AC-2; 6.9 FB-5
  @TC_CP_092 @Functional @High @Automation
  Scenario: Verify Excluded child removes all permissions of the role on that node and descendants
    Given Estimator has View and Create on Process 'Project Management'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Excluded | Project Schedule |
    When the user marks Page 'Project Schedule' as Excluded and Save
    And the user logs in as a user with only this role and open Project Schedule
    Then Project Schedule has no permission for this role including inherited ones (US-9 AC-2, 6.9 FB-5)

  # Ref: 6.9 BR-2
  @TC_CP_093 @Functional @High @Automation
  Scenario: Verify Excluded node stays inaccessible whatever other roles grant
    Given rahul.sharma active role Project Manager has Project Schedule excluded; Finance Viewer grants View
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Excluded in | Project Manager |
    When the user opens Project Schedule while Project Manager is active
    Then Access is denied while Project Manager is active even if another role grants it (6.9 BR-2)

  # Ref: 6.9 BR-3
  @TC_CP_094 @Functional @High @Automation
  Scenario: Verify a page is accessible only with View and menu items appear only if a page beneath is viewable
    Given Role has Create (without View) on 'Invoice Listing' only
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Estimator (Create only on Invoice Listing) |
    When the user logs in as the user and check the menu
    And the user opens Invoice Listing by URL
    Then Page is not accessible; 'Finance' process and sub-process do not appear in the menu (6.9 BR-3)

  # Ref: US-9 AC-3; 6.9 BR-4; EX-11
  @TC_CP_095 @Functional @High @Automation
  Scenario: Verify controls without permission are hidden and the Delete API is rejected with 403 and audited
    Given User role lacks Delete on 'Project Listing'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Role | Site Engineer              |
      | API  | DELETE /projects/PRJ-HO-01 |
    When the user opens Project Listing and look for Delete
    And the user calls the Delete API directly for project PRJ-HO-01
    Then Delete control is hidden; API returns HTTP 403 'Access denied' and an 'Access Denied' entry is audited (US-9 AC-3, 6.9 BR-4, EX-11)

  # Ref: US-9 AC-4; EX-15
  @TC_CP_096 @Functional @High @Automation
  Scenario: Verify a permission change applies from the next request and removed pages show Access Denied
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Page | Project Schedule |
    When As roleadmin.user remove View on Project Schedule from Project Manager
    And As rahul.sharma open the Project Schedule page
    Then Access Denied page with 'You do not have permission to access this page.' appears from the next request (US-9 AC-4, EX-15)

  # Ref: 6.9 FB-3
  @TC_CP_098 @Functional @Medium @Automation
  Scenario: Verify unticking a parent action removes the inherited permission on children
    Given Estimator has Create on Process 'Project Management'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Action | Create |
    When the user unticks Create on the process and Save
    And the user checks the children
    Then Inherited Create is removed from every child (6.9 FB-3)

  # Ref: 6.9 FB-3
  @TC_CP_099 @Functional @Medium @Automation
  Scenario: Verify ticking an action on a parent grants it only on children that support it
    Given Estimator has no permissions
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Action | Export |
    When the user ticks 'Export' on Process 'Finance'
    And the user checks 'Invoice Listing' (no Export) and 'Financial Reports' (supports Export)
    Then Export is inherited only on Financial Reports (6.9 FB-3)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-9 AC-3; EX-11
  @TC_CP_235 @Negative @High @Automation
  Scenario: Verify a control without permission cannot be used via direct API (Delete without permission)
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | API | DELETE /schedules/SCH-01 |
    When the user calls Delete API on a record with Project Manager (Delete not granted)
    Then HTTP 403 'Access denied'; audited as 'Access Denied' (US-9 AC-3, EX-11)

  # Ref: US-9 AC-1; 6.9 BR-1
  @TC_CP_236 @Negative @High @Automation
  Scenario: Verify granting a process does not automatically grant Delete or Approve
    Given Role 'Estimator' has View, Create on Process 'Project Management'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Actions | Delete, Approve |
    When the user logs in as a user with Estimator and call Delete and Approve on Project Schedule
    Then Both are rejected with HTTP 403 (US-9 AC-1, 6.9 BR-1)

  # Ref: US-9 AC-2; 6.9 FB-5
  @TC_CP_237 @Negative @High @Automation
  Scenario: Verify an Excluded node and its descendants are not accessible
    Given Project Schedule is Excluded for Project Manager
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Node | Project Schedule |
    When the user opens the page, a child control URL and API
    Then All requests are denied (US-9 AC-2, 6.9 FB-5)

  # Ref: EX-15; US-9 AC-4
  @TC_CP_238 @Negative @High @Automation
  Scenario: Verify permission removal during a session shows Access Denied from next request
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Page | Project Schedule |
    When the user removes the page permission as roleadmin.user
    And the user clicks the page link
    Then Access Denied page with 'You do not have permission to access this page.' (EX-15)

  # Ref: EX-10; 7.1 A-Denied
  @TC_CP_239 @Negative @High @Automation
  Scenario: Verify unauthorized page access by URL shows Access Denied and is audited
    Given anita.desai is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Page | Invoice Listing |
    When the user opens Invoice Listing URL directly
    Then 'You do not have permission to access this page.' is shown; 'Access Denied' is audited (EX-10)
