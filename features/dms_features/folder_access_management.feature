@DMS @FolderAccessManagement
Feature: Folder Access Management
  Automated scenarios for the "Folder Access Management" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-1; FRD 6.1.7 FB-Open; FRD 6.9.6 F-Assignments
  @TC_CP_229 @Functional @High @Automation
  Scenario: Verify Manage Access shows the access mode and separates inherited from directly assigned access
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' is Private with Role 'Site Engineer'
    And Sub-folder 'Drawings > Level 1' has direct access for User 'Editor_User1'
    And the following test data is used
      | Folder | Drawings > Level 1 |
    When the user clicks kebab > Manage Access on 'Level 1'
    And the user reviews the Access Assignments list
    Then Role 'Site Engineer' is listed with Source 'Inherited'; User 'Editor_User1' with Source 'Direct'
    And Access Type, Name and Source are shown for each

  # Ref: FRD 6.1.7 BR-Menu
  @TC_CP_230 @Functional @High @Automation
  Scenario: Verify Manage Access appears in the kebab menu only for authorized users
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. and Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. exist
    And the following test data is used
      | Users | Admin_User1, Viewer_User1 |
    When the user opens the kebab menu on 'Contracts' as each user
    Then Manage Access is shown to Admin_User1 and not to Viewer_User1

  # Ref: FRD 6.9 BR-DefaultPublic; FRD 6.9.1 BR-Default; US-12 AC-1
  @TC_CP_231 @Functional @High @Automation
  Scenario: Verify a newly created folder is Public by default
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Folder | Public Check |
    When the user creates folder 'Public Check'
    And the user opens Manage Access
    Then Access Mode is 'Public' (accessible to all users of the organization)

  # Ref: US-12 AC-2; FRD 6.9.1 FB-Private; FRD 6.9.1 Msg-Private; FRD 7.1 Act-ModeChanged
  @TC_CP_232 @Functional @High @Automation
  Scenario: Verify a Public folder is changed to Private with at least one access scope and the change flows down and is logged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Archive' is Public and contains a document and a sub-folder
    And the following test data is used
      | Folder | Archive       |
      | Role   | Site Engineer |
    When the user opens Manage Access on 'Archive'
    And the user selects Private
    And the user assigns Role 'Site Engineer'
    And the user clicks Save
    And the user logs in as NoAccess_User1 and browse
    And the user checks the activity log of the document
    Then Toaster 'Folder access changed to Private successfully.' is displayed
    And The mode applies to the sub-folder and document; NoAccess_User1 loses access
    And Activity log has 'Access Mode Changed'

  # Ref: FRD 6.9.1 FB-Public
  @TC_CP_233 @Functional @High @Automation
  Scenario: Verify changing Private back to Public asks for confirmation and shows the toaster
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Archive' is Private
    And the following test data is used
      | Folder | Archive |
    When the user opens Manage Access
    And the user selects Public
    And the user clicks Save
    And the user confirms
    Then A confirmation is displayed
    And On confirm the mode becomes Public and toaster 'Folder access changed to Public successfully.' is displayed

  # Ref: FRD 6.9.1 FB-Public
  @TC_CP_234 @Functional @Medium @Automation
  Scenario: Verify declining the Public confirmation keeps the folder Private
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Archive' is Private
    And the following test data is used
      | Folder | Archive |
    When the user selects Public and Save
    And the user declines the confirmation
    Then The access mode remains Private and nothing is changed

  # Ref: FRD 6.9.1 F-Scope
  @TC_CP_235 @Functional @Medium @Automation
  Scenario: Verify the access scope options appear only when Private is selected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Manage Access of 'Archive' is open
    And the following test data is used
      | Folder | Archive |
    When the user observes the form in Public mode
    And the user selects Private
    Then Scope options Organization, Department, Role, User and User Group are displayed only after selecting Private

  # Ref: FRD 6.9.1 F-Cancel
  @TC_CP_236 @Functional @Medium @Automation
  Scenario: Verify Cancel closes Manage Access without saving
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Manage Access of 'Archive' is open with Private and a Role selected
    And the following test data is used
      | Folder | Archive |
    When the user clicks Cancel
    And the user re-opens Manage Access
    Then No change was saved; the mode is as before

  # Ref: FRD 6.9.2 FB-Org; FRD 6.9.2 F-Org; FRD Sec 8 T35; US-3 AC-2
  @TC_CP_237 @Functional @High @Automation
  Scenario: Verify organization access is granted and users mapped to the organization receive access
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' is Private
    And Organization 'SoftTech Engineers Ltd' has user 'Org_User1'
    And the following test data is used
      | Organization | SoftTech Engineers Ltd |
    When the user opens Manage Access on 'Drawings'
    And the user selects Organization
    And the user selects 'SoftTech Engineers Ltd'
    And the user clicks Save
    And the user logs in as Org_User1
    Then Toaster 'Folder access granted successfully.' is displayed
    And Org_User1 can access 'Drawings' and its documents
    And The selection is displayed in the access configuration

  # Ref: FRD 6.9.2 BR-OrgLater; US-12 AC-4
  @TC_CP_238 @Functional @High @Automation
  Scenario: Verify access is recalculated when a user is added to or removed from the organization
    Given 'Drawings' has Organization access
    And Org_User2 is not in the organization
    And the following test data is used
      | User | Org_User2 |
    When the user adds Org_User2 to the organization
    And the user checks Org_User2's access
    And the user removes Org_User2 from the organization
    And the user checks again
    Then Org_User2 gains access after being added and loses it after being removed (unless covered by another rule)

  # Ref: FRD 6.9.2 BR-NoRepeat; FRD 6.9.2 FB-Search
  @TC_CP_239 @Functional @Medium @Automation
  Scenario: Verify an organization already assigned is not listed again and multiple organizations can be selected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' already has Organization 'SoftTech Engineers Ltd'
    And the following test data is used
      | Existing | SoftTech Engineers Ltd |
    When the user opens Manage Access > Organization
    And the user searches and select two other organizations
    Then The assigned organization is not listed
    And Two other organizations can be selected

  # Ref: FRD 6.9.3 FB-Dept; FRD 6.9.3 F-Dept
  @TC_CP_240 @Functional @High @Automation
  Scenario: Verify department access is granted and limited to departments of the applicable organization
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' is Private
    And Departments 'Engineering' and 'Finance' exist in the organization
    And the following test data is used
      | Department | Engineering |
    When the user opens Manage Access > Department
    And the user reviews the list
    And the user selects 'Engineering'
    And the user saves
    Then Only departments of the applicable organization are listed
    And Toaster 'Folder access granted successfully.' is displayed
    And Engineering users receive access

  # Ref: FRD 6.9.3 BR-DeptLater
  @TC_CP_241 @Functional @Medium @Automation
  Scenario: Verify access is recalculated when a user joins or leaves a department
    Given 'Drawings' has Department 'Engineering' access
    And Finance_User1 is in 'Finance'
    And the following test data is used
      | User | Finance_User1 |
    When the user moves Finance_User1 to 'Engineering'
    And the user checks access
    And the user moves back
    And the user checks again
    Then Access is gained on joining and lost on leaving 'Engineering'

  # Ref: FRD 6.9.4 FB-Role; FRD 6.9.4 F-Role
  @TC_CP_242 @Functional @High @Automation
  Scenario: Verify role-based access is granted to users holding the role
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' is Private
    And SiteEng_User1 has Role 'Site Engineer'
    And the following test data is used
      | Role | Site Engineer |
    When the user opens Manage Access > Role
    And the user selects 'Site Engineer'
    And the user saves
    And the user logs in as SiteEng_User1
    Then Toaster 'Folder access granted successfully.' is displayed
    And SiteEng_User1 can access the folder

  # Ref: FRD 6.9.4 BR-RoleRecalc
  @TC_CP_243 @Functional @High @Automation
  Scenario: Verify effective access is recalculated when a user's role assignment changes
    Given 'Drawings' has Role 'Site Engineer' access
    And PM_User1 has Role 'Project Manager'
    And the following test data is used
      | User | PM_User1 |
    When the user assigns 'Site Engineer' to PM_User1
    And the user checks access
    And the user removes the role
    And the user checks again
    Then Access is gained after assigning and lost after removing the role (unless another rule applies)

  # Ref: FRD 6.9.5 FB-UserGroup; FRD 6.9.5 F-User
  @TC_CP_244 @Functional @High @Automation
  Scenario: Verify access is granted to individual users and user groups
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' is Private
    And User group 'QA Team' has member QA_User1
    And the following test data is used
      | Selection | Editor_User1, QA Team |
    When the user opens Manage Access > User / User Group
    And the user selects 'Editor_User1' and 'QA Team'
    And the user saves
    And the user logs in as Editor_User1 and QA_User1
    Then Toaster 'Folder access granted successfully.' is displayed
    And Editor_User1 and QA_User1 can access the folder
    And Only active users are listed

  # Ref: FRD 6.9.5 BR-GroupMembers
  @TC_CP_245 @Functional @High @Automation
  Scenario: Verify adding or removing a group member updates access
    Given 'Drawings' has access for group 'QA Team'
    And the following test data is used
      | Group | QA Team  |
      | User  | QA_User2 |
    When the user adds 'QA_User2' to the group
    And the user checks access
    And the user removes QA_User2
    And the user checks again
    Then Access is gained after adding and lost after removing (unless another rule applies)

  # Ref: FRD 6.9.5 BR-NoRepeat
  @TC_CP_246 @Functional @Medium @Automation
  Scenario: Verify a user or group already assigned is not listed again
    Given 'Drawings' has User 'Editor_User1' and group 'QA Team'
    And the following test data is used
      | Assigned | Editor_User1, QA Team |
    When the user opens Manage Access > User / User Group and search for both
    Then Neither appears in the list again

  # Ref: FRD 6.9.2 F-Cancel
  @TC_CP_247 @Functional @Medium @Automation
  Scenario: Verify Cancel in the access selection window discards the selection
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Manage Access > Role is open with 'Site Engineer' selected
    And the following test data is used
      | Role | Site Engineer |
    When the user clicks Cancel
    And the user re-opens Manage Access
    Then The window closes; no access is saved

  # Ref: FRD 6.1.7 BR-Immediate
  @TC_CP_248 @Functional @High @Automation
  Scenario: Verify access changes take effect immediately on save
    Given SiteEng_User1 is logged in on a second session without access to 'Archive' (Private)
    And the following test data is used
      | Folder | Archive |
    When As Admin_User1 grant Role 'Site Engineer' on 'Archive'
    And the user refreshes as SiteEng_User1
    Then SiteEng_User1 sees the folder immediately after the refresh with no delay

  # Ref: FRD 6.1.7 BR-AuditAccess; FRD 7.1 Act-AccessGranted
  @TC_CP_249 @Functional @High @Automation
  Scenario: Verify granting folder access is recorded in the activity log
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Archive' contains DOC-0007 (moved there)
    And the following test data is used
      | Folder | Archive |
    When the user grants Role 'Site Engineer' on 'Archive'
    And the user opens the activity log of DOC-0007
    Then An 'Access Granted' entry with user, time and details is recorded

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.9.1 BR-OneScope; FRD 6.9.1 F-Scope
  @TC_CP_476 @Negative @High @Automation
  Scenario: Verify a folder cannot be saved as Private without an access scope
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Archive' is Public
    And the following test data is used
      | Folder | Archive |
    When the user opens Manage Access
    And the user selects Private
    And the user clicks Save without assigning any scope
    Then Error 'Please assign at least one access scope.' is displayed and the mode stays Public

  # Ref: FRD 6.9.2 F-Org
  @TC_CP_477 @Negative @High @Automation
  Scenario: Verify Save is disabled and the error is shown when no organization is selected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Manage Access > Organization is open
    And the following test data is used
      | Organization | (none) |
    When the user observes Save with no selection
    And the user attempts to save
    Then Save is disabled; 'Please select at least one organization.' is displayed where validation is triggered

  # Ref: FRD 6.9.3 F-Dept
  @TC_CP_478 @Negative @High @Automation
  Scenario: Verify the error is shown when no department is selected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Manage Access > Department is open
    And the following test data is used
      | Department | (none) |
    When the user attempts to save with no selection
    Then Save is disabled; 'Please select at least one department.' is displayed where validation is triggered

  # Ref: FRD 6.9.4 F-Role
  @TC_CP_479 @Negative @High @Automation
  Scenario: Verify the error is shown when no role is selected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Manage Access > Role is open
    And the following test data is used
      | Role | (none) |
    When the user attempts to save with no selection
    Then Save is disabled; 'Please select at least one role.' is displayed where validation is triggered

  # Ref: FRD 6.9.5 F-User
  @TC_CP_480 @Negative @High @Automation
  Scenario: Verify the error is shown when no user or group is selected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Manage Access > User / User Group is open
    And the following test data is used
      | Selection | (none) |
    When the user attempts to save with no selection
    Then Save is disabled; 'Please select at least one user or user group.' is displayed where validation is triggered
