@DMS @FolderCopy
Feature: Folder Copy
  Automated scenarios for the "Folder Copy" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.5 FB-Copy; FRD Sec 8 T5; US-2 AC-3
  @TC_CP_033 @Functional @High @Automation
  Scenario: Verify a folder is copied with sub-folders and documents to another location and the original is unchanged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' contains DOC-0005 and DOC-0007
    And Folder 'Archive' is empty
    And the following test data is used
      | Folder   | Reports        |
      | New name | Reports (Copy) |
      | Target   | Archive        |
    When the user clicks kebab > Copy on 'Reports'
    And the user observes 'Copying from: Reports' and New Folder Name 'Reports (Copy)'
    And the user selects target 'Archive'
    And the user clicks Copy
    Then 'Reports (Copy)' is created under 'Archive' with all sub-folders and documents
    And Toaster 'Folder copied successfully.' is displayed
    And Original 'Reports' and its documents are unchanged

  # Ref: FRD 6.1.5 FB-DocRefs
  @TC_CP_034 @Functional @High @Automation
  Scenario: Verify copied documents get new Document IDs and start at Version 1
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' contains DOC-0005 (V1-V3)
    And the following test data is used
      | Source document | DOC-0005 (Active V3) |
    When the user copies 'Reports' to 'Archive'
    And the user opens the copied document in 'Archive > Reports (Copy)'
    Then Copied document has a new Document ID different from DOC-0005
    And Original DOC-0005 still has V1-V3

  # Ref: US-2 AC-3; FRD 6.1.5 BR-TargetPerm
  @TC_CP_035 @Functional @High @Automation
  Scenario: Verify the copied folder takes the target location's permissions, not the source's
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' is Private (Role: Site Engineer). 'Archive' is Public
    And the following test data is used
      | Source | Drawings (Private) |
      | Target | Archive (Public)   |
    When the user copies 'Drawings' to 'Archive'
    And the user opens Manage Access of the copy
    And the user logs in as NoAccess_User1 and browse 'Archive'
    Then The copy does not carry Role 'Site Engineer' from the source; it inherits from 'Archive'
    And NoAccess_User1 can see the copy

  # Ref: FRD 6.1.5 FB-CopyParent
  @TC_CP_036 @Functional @Medium @Automation
  Scenario: Verify a folder can be copied into its current parent with a modified name
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Tenders' is under 'Contracts'
    And the following test data is used
      | Folder | Tenders   |
      | Target | Contracts |
    When the user clicks kebab > Copy on 'Tenders'
    And the user keeps the pre-filled name
    And the user selects 'Contracts' as target
    And the user clicks Copy
    Then 'Tenders (Copy)' is created alongside 'Tenders' under 'Contracts'

  # Ref: FRD 6.1.5 F-NewName
  @TC_CP_037 @Functional @Medium @Automation
  Scenario: Verify the pre-filled New Folder Name can be edited
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Copy form for 'Reports' is open
    And the following test data is used
      | New name | Reports Backup |
      | Target   | Archive        |
    When the user changes the name to 'Reports Backup'
    And the user selects 'Archive'
    And the user clicks Copy
    Then Folder 'Reports Backup' is created under 'Archive'

  # Ref: FRD 6.1.5 FB-Cancel
  @TC_CP_038 @Functional @Medium @Automation
  Scenario: Verify Cancel discards the name and target and creates no copy
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Copy form for 'Reports' is open with name and target entered
    And the following test data is used
      | Name   | Reports Backup |
      | Target | Archive        |
    When the user clicks Cancel
    And the user checks the repository
    Then The form closes and no copy is created

  # Ref: FRD 6.1.5 F-Copy
  @TC_CP_039 @Functional @Medium @Automation
  Scenario: Verify Copy is enabled only with a valid New Folder Name and a Target Location
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Copy form for 'Reports' is open
    And the following test data is used
      | Target | Archive |
    When the user selects no target (name pre-filled)
    And the user selects target 'Archive'
    And the user clears the name
    Then Copy is disabled without a target
    And Copy is enabled with a valid name and target
    And Copy is disabled when the name is cleared

  # Ref: FRD 6.1.5 F-Target
  @TC_CP_040 @Functional @Medium @Automation
  Scenario: Verify the target list shows only locations with create permission, with path display and case-insensitive search
    Given Editor_User1 has create permission on 'Contracts' and 'Archive' only
    And the following test data is used
      | Search text | ARCH |
    When the user opens the Copy form for 'Reports' as Editor_User1
    And the user opens the target list
    And the user searches 'ARCH'
    Then Only '(Root level)' and folders with create permission are listed with parent paths
    And Search is case-insensitive

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.5 F-Target
  @TC_CP_378 @Negative @High @Automation
  Scenario: Verify the folder being copied and its sub-folders are not selectable as target
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'QC' with sub-folder 'QC-1' exists
    And the following test data is used
      | Folder     | QC   |
      | Sub-folder | QC-1 |
    When the user opens the Copy form for 'QC'
    And the user searches the target list for 'QC' and 'QC-1'
    Then Neither 'QC' nor 'QC-1' is selectable

  # Ref: FRD 6.1.5 F-NewName
  @TC_CP_379 @Negative @High @Automation
  Scenario: Verify blank New Folder Name is rejected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Copy form for 'Reports' is open
    And the following test data is used
      | New Folder Name | (blank) |
    When the user clears the New Folder Name field
    Then Error 'Folder Name is required' is displayed and Copy is disabled

  # Ref: FRD 6.1.5 F-NewName
  @TC_CP_380 @Negative @High @Automation
  Scenario: Verify restricted characters are rejected in New Folder Name
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Copy form for 'Reports' is open
    And the following test data is used
      | Names | Rep\1  |
      | Data  | Rep/1  |
      | Rep   | 1      |
      | Data  | Rep*1  |
      | Data  | Rep?1  |
      | Data  | Rep"1  |
      | Data  | Rep<1  |
      | Data  | Rep>1  |
      | Data  | Rep\|1 |
    When the user enters the name with a restricted character and click Copy
    And the user repeats for each value
    Then 'Folder Name contains invalid characters' is displayed for each value; no copy is created

  # Ref: FRD 6.1.5 F-NewName
  @TC_CP_381 @Negative @Medium @Automation
  Scenario: Verify New Folder Name over 100 characters is rejected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Copy form for 'Reports' is open
    And the following test data is used
      | New Folder Name | 'C' repeated 101 times |
    When the user enters a 101-character name and click Copy
    Then 'Folder Name cannot exceed 100 characters' is displayed; no copy is created

  # Ref: FRD 6.1.5 F-NewName; FRD 6.1.5 BR-UniqueName
  @TC_CP_382 @Negative @High @Automation
  Scenario: Verify a duplicate New Folder Name at the target is blocked case-insensitively
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Archive' contains a sub-folder 'Reports Backup'
    And the following test data is used
      | New name | REPORTS BACKUP |
      | Target   | Archive        |
    When the user opens the Copy form for 'Reports'
    And the user enters 'REPORTS BACKUP'
    And the user selects 'Archive'
    And the user clicks Copy
    Then Error 'A folder with this name already exists in the target location' is displayed; no copy is created

  # Ref: FRD 6.1.5 F-Target
  @TC_CP_383 @Negative @Medium @Automation
  Scenario: Verify a copy cannot be submitted without a Target Location
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Copy form for 'Reports' is open with a valid name
    And the following test data is used
      | Target | (none) |
    When the user leaves Target Location empty
    And the user attempts Copy via UI and API
    Then 'Target location is required' is shown; Copy is disabled; API request is rejected
