@DMS @UserGroups
Feature: User Groups
  Automated scenarios for the "User Groups" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.9.5 UG-Create; FRD Sec 8 T37; FRD 7.1 Act-Group
  @TC_CP_257 @Functional @High @Automation
  Scenario: Verify a user group is created from Manage Access with at least one user and the toaster
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Manage Access of 'Drawings' is open
    And the following test data is used
      | Group Name  | QA Team                     |
      | Description | Quality assurance reviewers |
      | Users       | QA_User1, QA_User2          |
    When the user clicks Create User Group
    And the user enters Group Name and Description
    And the user searches and add two users
    And the user clicks Save
    Then Toaster 'User group created successfully.' is displayed
    And 'QA Team' is available for selection as an access target
    And Creation is recorded in the activity log

  # Ref: FRD 6.9.5 BR-NoAutoAccess; US-12 AC-4
  @TC_CP_258 @Functional @High @Automation
  Scenario: Verify creating a user group does not grant access until it is assigned to a folder
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Group 'QA Team' was just created with QA_User1; 'Drawings' is Private
    And the following test data is used
      | User | QA_User1 |
    When the user logs in as QA_User1 and open 'Drawings'
    Then QA_User1 cannot access 'Drawings' until the group is assigned

  # Ref: FRD 6.9.5 BR-MultiGroup; FRD 6.9.5 F-Members
  @TC_CP_259 @Functional @Medium @Automation
  Scenario: Verify a user can be in multiple groups and added users are not listed again
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Group 'QA Team' has QA_User1
    And the following test data is used
      | Groups | QA Team, Site Team |
      | User   | QA_User1           |
    When the user creates group 'Site Team' and add QA_User1
    And In the Add Users list for 'Site Team' search for the added user
    Then QA_User1 is a member of both
    And The user already added is not listed again; the Group Members list shows Name, Email ID and Remove

  # Ref: FRD 6.9.5 UG-Save
  @TC_CP_260 @Functional @Medium @Automation
  Scenario: Verify Save is enabled only when the Group Name is entered and at least one user is added
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create User Group window is open
    And the following test data is used
      | Group Name | Ops Team  |
      | User       | Ops_User1 |
    When the user observes Save empty
    And the user enters a name only
    And the user adds a user
    Then Save is disabled until both are provided

  # Ref: FRD 6.9.5 BR-ManageMembers
  @TC_CP_261 @Functional @Medium @Automation
  Scenario: Verify members can be added to or removed from an existing group
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Group 'QA Team' exists with QA_User1
    And the following test data is used
      | Group | QA Team |
    When the user adds QA_User2
    And the user removes QA_User1
    Then Membership updates; the change is recorded in the activity log

  # Ref: FRD 6.9.5 F-Name; FRD 6.9.5 F-Desc
  @TC_CP_262 @Functional @Medium @Automation
  Scenario: Verify Group Name of 100 characters and Group Description of 500 characters are accepted
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create User Group window is open
    And the following test data is used
      | Name        | 'G' repeated 100 |
      | Description | 'd' repeated 500 |
    When the user enters a 100-character name and a 500-character description
    And the user adds a user
    And the user saves
    Then The group is created with the full values

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.9.5 F-Name
  @TC_CP_486 @Negative @High @Automation
  Scenario: Verify a blank Group Name is rejected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create User Group window is open
    And the following test data is used
      | Group Name | (blank) |
    When the user leaves Group Name blank
    And the user adds a user
    And the user attempts to save
    Then 'Please enter the Group Name.' is displayed; the group is not saved

  # Ref: FRD 6.9.5 BR-UniqueName
  @TC_CP_487 @Negative @High @Automation
  Scenario: Verify a duplicate Group Name is rejected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Group 'QA Team' exists
    And the following test data is used
      | Names | QA Team |
      | Data  | qa team |
    When the user creates a group named 'QA Team'
    And the user creates a group named 'qa team' (case variant; FRD silent)
    Then 'A user group with this name already exists.' is displayed for the exact duplicate
    And Behaviour for the case variant to be confirmed with BA

  # Ref: FRD 6.9.5 F-Name
  @TC_CP_488 @Negative @Medium @Automation
  Scenario: Verify a Group Name over 100 characters is rejected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create User Group window is open
    And the following test data is used
      | Group Name | 'G' repeated 101 |
    When the user enters a 101-character name and save
    Then Input is limited to 100 characters or the save is rejected

  # Ref: FRD 6.9.5 F-Desc
  @TC_CP_489 @Negative @Medium @Automation
  Scenario: Verify a Group Description over 500 characters is rejected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create User Group window is open
    And the following test data is used
      | Description | 'd' repeated 501 |
    When the user enters a 501-character description and save
    Then Input is limited to 500 characters or the save is rejected

  # Ref: FRD 6.9.5 BR-MinUser; FRD 6.9.5 F-AddUsers
  @TC_CP_490 @Negative @High @Automation
  Scenario: Verify a group cannot be saved without any user
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create User Group window is open
    And the following test data is used
      | Group Name | Empty Group |
    When the user enters a Group Name only
    And the user attempts to save
    Then 'Please add at least one user.' is displayed; the group is not saved

  # Ref: FRD 6.9.5 BR-Authorized
  @TC_CP_491 @Negative @High @Automation
  Scenario: Verify a user without authority cannot create a user group
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User  | Viewer_User1 |
      | Group | Hack Team    |
    When the user opens Manage Access (if visible)
    And the user sends a create-group API request with this user's token
    Then The Create User Group option is not shown and the API returns 403
