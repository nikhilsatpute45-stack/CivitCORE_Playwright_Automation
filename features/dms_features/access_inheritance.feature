@DMS @AccessInheritance
Feature: Access Inheritance
  Automated scenarios for the "Access Inheritance" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.9 Inherit-FolderDown; US-3 AC-3
  @TC_CP_251 @Functional @High @Automation
  Scenario: Verify access managed at folder level flows down to sub-folders and documents
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' is Private with Role 'Site Engineer'; 'Drawings > Level 1' contains a document
    And the following test data is used
      | User | SiteEng_User1 |
    When the user logs in as SiteEng_User1
    And the user opens 'Level 1' and its document
    Then SiteEng_User1 accesses 'Level 1' and its document through the inherited Role access

  # Ref: FRD 6.9 Inherit-SubOnly; US-12 AC-3
  @TC_CP_252 @Functional @High @Automation
  Scenario: Verify access assigned only at sub-folder level does not flow up to the parent folder
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' is Private (Role: Site Engineer). 'Level 1' is given direct access for Editor_User1 only
    And the following test data is used
      | User | Editor_User1 |
    When the user logs in as Editor_User1
    And the user tries to open 'Drawings' and documents directly under it
    And the user opens 'Level 1'
    Then Editor_User1 can access 'Level 1' and below but not the parent 'Drawings' content

  # Ref: FRD 6.9 Inherit-Both; US-12 AC-3
  @TC_CP_253 @Functional @High @Automation
  Scenario: Verify a sub-folder receives the parent's access plus its own access
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' has Role 'Site Engineer'. 'Level 1' has direct User 'Editor_User1'
    And the following test data is used
      | Users | SiteEng_User1, Editor_User1 |
    When the user logs in as SiteEng_User1 and open 'Level 1'
    And the user logs in as Editor_User1 and open 'Level 1'
    Then Both users access 'Level 1' (inherited + direct = union; own access does not replace parent's)

  # Ref: FRD 6.9.1 BR-SubPrivate
  @TC_CP_254 @Functional @High @Automation
  Scenario: Verify making a sub-folder Private does not remove access received from a Public parent
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Contracts' is Public. 'Tenders' under it is made Private with Role 'Site Engineer'
    And the following test data is used
      | Folder | Contracts > Tenders |
    When the user logs in as NoAccess_User1
    And the user opens 'Contracts > Tenders'
    Then Access flowing from the Public parent is not removed; to restrict access the parent must be made Private. Record the observed behaviour for NoAccess_User1

  # Ref: FRD 6.1.7 BR-InheritedReadOnly; US-3 AC-4
  @TC_CP_255 @Functional @High @Automation
  Scenario: Verify inherited access has no Remove option at the child level
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Level 1' inherits Role 'Site Engineer' and has direct User 'Editor_User1'
    And the following test data is used
      | Folder | Drawings > Level 1 |
    When the user opens Manage Access on 'Level 1'
    Then Inherited rows (Source 'Inherited') have no Remove Access control; direct rows do. Inherited access can be changed only at the parent

  # Ref: FRD 6.9 BR-DocFollowsFolder; US-12 AC-1
  @TC_CP_256 @Functional @High @Automation
  Scenario: Verify a newly uploaded document follows the folder's access with no per-document configuration
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' is Private (Role: Site Engineer)
    And the following test data is used
      | File | Plan_X.pdf |
    When the user uploads 'Plan_X.pdf'
    And the user checks document actions
    And the user logs in as SiteEng_User1
    Then No access configuration is requested for the document
    And SiteEng_User1 can access it; there is no Manage Access at document level

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.9 BR-NoDocAccess; US-12 AC-1
  @TC_CP_481 @Negative @High @Automation
  Scenario: Verify access cannot be assigned to an individual document through the API
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0003 exists in 'Drawings'
    And the following test data is used
      | Document | DOC-0003          |
      | Assign   | User Editor_User1 |
    When the user sends an access-assignment request targeting DOC-0003 directly
    Then The request is rejected; document-level access management does not exist

  # Ref: FRD 6.9 BR-NoAccessNav; US-12 AC-6
  @TC_CP_482 @Negative @High @Automation
  Scenario: Verify a user without folder access cannot reach documents through folder navigation or the Document List
    Given NoAccess_User1 has no access to 'Drawings'
    And the following test data is used
      | User   | NoAccess_User1 |
      | Folder | Drawings       |
    When the user browses the repository as NoAccess_User1
    And the user requests the Document List API for 'Drawings'
    Then The folder is not visible and the Document List API returns 403/empty

  # Ref: FRD 6.9 BR-NoAccessSearch
  @TC_CP_483 @Negative @High @Automation
  Scenario: Verify search never returns documents from a folder the user cannot access
    Given NoAccess_User1 has no access to 'Drawings'
    And the following test data is used
      | Keyword | Structural |
    When the user searches 'Structural' in folders the user can open
    Then DOC-0003 is not returned

  # Ref: FRD 6.9 BR-NoAccessDirect; US-12 AC-6
  @TC_CP_484 @Negative @High @Automation
  Scenario: Verify direct document URLs and API calls are denied without folder access
    Given NoAccess_User1 has no access to 'Drawings'
    And the following test data is used
      | User     | NoAccess_User1 |
      | Document | DOC-0003       |
    When the user opens the direct URL of DOC-0003
    And the user calls the document metadata and download APIs for DOC-0003
    Then Every request is denied (403/404); no data is returned (IDOR protection)

  # Ref: FRD 6.9 BR-Authorized
  @TC_CP_485 @Negative @High @Automation
  Scenario: Verify a user without Manage Access authority cannot change folder access through the API
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Viewer_User1           |
      | Payload | {role:'Site Engineer'} |
    When the user sends an access-assignment request for 'Archive' with this user's token
    Then API returns 403 and no access is assigned
