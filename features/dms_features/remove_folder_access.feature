@DMS @RemoveFolderAccess
Feature: Remove Folder Access
  Automated scenarios for the "Remove Folder Access" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.9.6 FB-Remove; US-12 AC-5; FRD 6.9.6 F-Confirm; FRD Sec 8 T36; FRD 7.1 Act-AccessRemoved
  @TC_CP_263 @Functional @High @Automation
  Scenario: Verify directly assigned access is removed after confirming 'Are you sure you want to remove this access?'
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' has direct Role 'Site Engineer' and Role 'Project Manager'
    And the following test data is used
      | Folder | Drawings           |
      | Access | Role Site Engineer |
    When the user opens Manage Access
    And the user clicks Remove Access against 'Site Engineer'
    And the user observes the confirmation
    And the user clicks Yes
    And the user checks the activity log
    Then Confirmation 'Are you sure you want to remove this access?' with Yes/No is shown
    And On Yes the access is removed and toaster 'Folder access removed successfully.' is displayed
    And 'Access Removed' is recorded

  # Ref: FRD 6.9.6 F-No
  @TC_CP_264 @Functional @High @Automation
  Scenario: Verify clicking No leaves the access unchanged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' has direct Role 'Site Engineer' and Role 'Project Manager'
    And the following test data is used
      | Access | Role Site Engineer |
    When the user clicks Remove Access on 'Site Engineer'
    And the user clicks No
    Then The confirmation closes and the access remains

  # Ref: FRD 6.9.6 BR-Effective
  @TC_CP_265 @Functional @High @Automation
  Scenario: Verify users who lose access no longer see the folder in the list, search results or pinned list
    Given SiteEng_User1 has access to 'Drawings' only via Role and has pinned it
    And the following test data is used
      | Folder | Drawings      |
      | User   | SiteEng_User1 |
    When the user removes Role 'Site Engineer' from 'Drawings'
    And As SiteEng_User1 check the folder list, search and pinned list
    Then 'Drawings' is not visible in the folder list, search results or pinned list

  # Ref: FRD 6.9.6 BR-OtherRule
  @TC_CP_266 @Functional @High @Automation
  Scenario: Verify a user retains access if they hold it through another applicable rule
    Given SiteEng_User1 has Role 'Site Engineer' and is also directly assigned as a User on 'Drawings'
    And the following test data is used
      | User | SiteEng_User1 |
    When the user removes Role 'Site Engineer'
    And the user logs in as SiteEng_User1
    Then SiteEng_User1 still has access through the direct User assignment

  # Ref: FRD 6.9.6 BR-SubUnaffected
  @TC_CP_267 @Functional @High @Automation
  Scenario: Verify removing direct sub-folder access does not affect the parent or inherited access
    Given 'Drawings' has Role 'Site Engineer'; 'Level 1' has direct User 'Editor_User1'
    And the following test data is used
      | Folder | Level 1 |
    When the user removes 'Editor_User1' from 'Level 1'
    And the user checks access of SiteEng_User1 on 'Drawings' and 'Level 1'
    Then Only Editor_User1's direct access is removed; the inherited Role access and the parent's access remain

  # Ref: FRD 6.9.6 Table-FolderLevel; FRD 6.9.6 BR-SubKept
  @TC_CP_268 @Functional @High @Automation
  Scenario: Verify removing access at folder level also removes it from children except where assigned directly to a sub-folder
    Given 'Drawings' and its sub-folder 'Level 1' both have Role 'Site Engineer' assigned directly
    And the following test data is used
      | Access | Role Site Engineer |
    When the user removes Role 'Site Engineer' from 'Drawings'
    And the user checks access to 'Drawings' and 'Level 1'
    Then Access is removed from 'Drawings' and from other child folders but remains on 'Level 1' where assigned directly

  # Ref: FRD 6.9.6 BR-GroupKept
  @TC_CP_269 @Functional @Medium @Automation
  Scenario: Verify removing a user group's access does not delete the group or change its members
    Given 'Drawings' has group 'QA Team' (QA_User1, QA_User2)
    And the following test data is used
      | Group | QA Team |
    When the user removes 'QA Team' from 'Drawings'
    And the user opens the group
    Then The group and its members remain intact

  # Ref: FRD 6.9.6 BR-NoContentChange
  @TC_CP_270 @Functional @Medium @Automation
  Scenario: Verify removing access does not delete, move or change the folder, sub-folders or documents
    Given 'Drawings' contains documents and sub-folders
    And the following test data is used
      | Folder | Drawings |
    When the user removes an access scope
    And the user checks the content
    Then The folder, sub-folders and documents remain unchanged

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.9.6 BR-LastScope; FRD 6.9.6 Err-LastScope
  @TC_CP_492 @Negative @High @Automation
  Scenario: Verify removing the last access assignment of a Private folder is blocked
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Archive' is Private with a single Role assignment
    And the following test data is used
      | Folder | Archive |
    When the user clicks Remove Access on the only assignment
    And the user clicks Yes
    Then The removal is not allowed; message 'At least one access scope is required for a Private folder.' is displayed and the access stays

  # Ref: FRD 6.9.6 BR-InheritedNoRemove
  @TC_CP_493 @Negative @High @Automation
  Scenario: Verify inherited access cannot be removed at the sub-folder through UI or API
    Given 'Level 1' inherits Role 'Site Engineer' from 'Drawings'
    And the following test data is used
      | Folder | Level 1                        |
      | Access | Role Site Engineer (Inherited) |
    When the user looks for Remove Access on the inherited row
    And the user sends a remove request for the inherited assignment on 'Level 1'
    Then No Remove option is shown; the API request is rejected

  # Ref: FRD 6.9.6 BR-Authorized
  @TC_CP_494 @Negative @Medium @Automation
  Scenario: Verify a user without Manage Access authority cannot remove access
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user sends a remove-access API request for 'Drawings'
    Then API returns 403 and the access remains
