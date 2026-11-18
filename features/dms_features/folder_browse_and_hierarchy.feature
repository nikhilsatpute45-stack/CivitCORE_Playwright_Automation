@DMS @FolderBrowseHierarchy
Feature: Folder Browse & Hierarchy
  Automated scenarios for the "Folder Browse & Hierarchy" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-1; FRD 6.1 FB-Browse
  @TC_CP_001 @Functional @High @Automation
  Scenario: Verify the Organization Document repository displays the folder hierarchy available to the user
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User       | Admin_User1                                                                           |
      | Repository | Organization Document                                                                 |
      | Folders    | Contracts (Tenders, Work Orders), Drawings, QC (QC-1), Reports, Archive, Empty Folder |
    When the user opens the 'Organization Document' repository
    Then The folder hierarchy (Repository > Folder > Sub-folder) available to the user is displayed
    And Folders 'Contracts', 'Drawings', 'QC', 'Reports', 'Archive' and 'Empty Folder' are listed

  # Ref: US-1 AC-1; FRD 6.1 FB-Expand
  @TC_CP_002 @Functional @Medium @Automation
  Scenario: Verify folders and sub-folders can be expanded and collapsed
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Folder      | Contracts            |
      | Sub-folders | Tenders, Work Orders |
    When the user expands folder 'Contracts'
    And the user observes the child items
    And the user collapses 'Contracts'
    Then On expand, sub-folders 'Tenders' and 'Work Orders' are shown under 'Contracts'
    And On collapse, the sub-folders are hidden

  # Ref: US-1 AC-2; FRD 6.1 FB-Docs
  @TC_CP_003 @Functional @High @Automation
  Scenario: Verify opening a folder or sub-folder displays only the documents stored in it
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' contains DOC-0005 and sub-folder 'Contracts > Tenders' contains no documents
    And the following test data is used
      | Folder     | Reports             |
      | Sub-folder | Contracts > Tenders |
    When the user clicks folder 'Reports'
    And the user observes the Document List
    And the user clicks sub-folder 'Contracts > Tenders'
    Then The Document List of 'Reports' shows its documents (e.g., 'Quarterly Report')
    And The Document List of 'Tenders' shows only the documents stored in 'Tenders' (empty state if none)

  # Ref: US-1 AC-3; FRD 6.1 BR-SameNameDiffParent
  @TC_CP_004 @Functional @High @Automation
  Scenario: Verify the same folder name is allowed under different parent folders
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Sub-folder 'Tenders' exists under 'Contracts'
    And Folder 'Archive' has no sub-folder named 'Tenders'
    And the following test data is used
      | Parent          | Archive |
      | Sub Folder Name | Tenders |
    When the user selects folder 'Archive'
    And the user clicks kebab menu > Add Sub Folder
    And the user enters 'Tenders'
    And the user clicks Create
    Then Sub-folder 'Tenders' is created under 'Archive' without a duplicate error because folder names are unique only within the same parent

  # Ref: FRD 6.1 BR-MixedContent
  @TC_CP_005 @Functional @Medium @Automation
  Scenario: Verify a folder can contain both documents and sub-folders
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Contracts' contains DOC-0001, DOC-0002 and sub-folders 'Tenders', 'Work Orders'
    And the following test data is used
      | Folder | Contracts |
    When the user opens folder 'Contracts'
    And the user observes the hierarchy and Document List
    Then Sub-folders are shown in the hierarchy and the documents DOC-0001 and DOC-0002 are shown in the Document List of the same folder

  # Ref: US-1 AC-1; FRD 6.1.7 BR-HideNoAccess
  @TC_CP_006 @Functional @High @Automation
  Scenario: Verify a user without access does not see a Private folder in the folder list
    Given NoAccess_User1 (no access to 'Drawings') is logged in
    And Folder 'Drawings' is Private (Role: Site Engineer)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User           | NoAccess_User1 |
      | Private folder | Drawings       |
    When the user opens the 'Organization Document' repository
    And the user reviews the folder list
    Then Folder 'Drawings' is not displayed in the folder list
    And Only folders the user is authorized for are displayed
