@DMS @FolderRename
Feature: Folder Rename
  Automated scenarios for the "Folder Rename" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.3 FB-Rename; FRD Sec 8 T3; FRD 6.1.3 F-Name
  @TC_CP_020 @Functional @High @Automation
  Scenario: Verify a folder is renamed with the current name pre-filled and the toaster displayed
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Sub-folder 'Work Orders' exists under 'Contracts'
    And the following test data is used
      | Current | Work Orders      |
      | New     | Work Orders 2026 |
    When the user clicks kebab > Rename on 'Work Orders'
    And the user observes the pre-filled name
    And the user changes it to the new name
    And the user clicks Save
    Then The field is pre-filled with 'Work Orders'
    And Folder is renamed to 'Work Orders 2026'
    And Toaster 'Folder renamed successfully.' is displayed

  # Ref: US-2 AC-1; FRD 6.1.3 BR-NoVersion
  @TC_CP_021 @Functional @High @Automation
  Scenario: Verify renaming a folder leaves documents, metadata and versions unchanged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' contains DOC-0005 (V1, V2, V3)
    And the following test data is used
      | Folder   | Reports > Reports 2026 |
      | Document | DOC-0005               |
    When the user notes DOC-0005 ID, metadata and version list
    And the user renames 'Reports' to 'Reports 2026'
    And the user opens DOC-0005 and its Version History
    Then All documents remain in the folder
    And No document version is created, deleted or altered; metadata and version history are unchanged

  # Ref: FRD 6.1.3 FB-Cancel
  @TC_CP_022 @Functional @Medium @Automation
  Scenario: Verify Cancel on the Rename form leaves the name unchanged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Folder | Archive   |
      | Typed  | Archive X |
    When the user clicks kebab > Rename on 'Archive'
    And the user changes the name to 'Archive X'
    And the user clicks Cancel
    Then The form closes and the folder name remains 'Archive'

  # Ref: FRD 6.1.3 F-Save
  @TC_CP_023 @Functional @Medium @Automation
  Scenario: Verify Save is enabled only when the name is non-empty and differs from the current name
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Rename form for 'Archive' is open
    And the following test data is used
      | Current | Archive   |
      | New     | Archive 2 |
    When the user observes Save with the pre-filled name
    And the user clears the field
    And the user enters 'Archive 2'
    Then Save is disabled when the name equals the current name
    And Save is disabled when empty
    And Save is enabled for 'Archive 2'

  # Ref: FRD 6.1.3 F-Name
  @TC_CP_024 @Functional @Low @Automation
  Scenario: Verify a case-only change of the folder's own name is accepted (self is excluded from duplicate check)
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Archive' exists. (FRD is silent on self-match; assumption: own name is excluded.)
    And the following test data is used
      | Current | Archive |
      | New     | ARCHIVE |
    When the user renames 'Archive' to 'ARCHIVE'
    And the user clicks Save
    Then Folder is renamed to 'ARCHIVE' with 'Folder renamed successfully.' and no duplicate error is shown for itself

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.3 F-Name
  @TC_CP_367 @Negative @High @Automation
  Scenario: Verify blank name is rejected on rename
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Rename form for 'Archive' is open
    And the following test data is used
      | Name | (blank) |
    When the user clears the Name field
    Then Error 'Folder / Sub Folder Name is required' is displayed and Save is disabled

  # Ref: FRD 6.1.3 F-Name
  @TC_CP_368 @Negative @High @Automation
  Scenario: Verify restricted characters are rejected on rename
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Rename form for 'Archive' is open
    And the following test data is used
      | Names | Arc\1  |
      | Data  | Arc/1  |
      | Arc   | 1      |
      | Data  | Arc*1  |
      | Data  | Arc?1  |
      | Data  | Arc"1  |
      | Data  | Arc<1  |
      | Data  | Arc>1  |
      | Data  | Arc\|1 |
    When the user enters the name with a restricted character and Save
    And the user repeats for each value
    Then 'Folder / Sub Folder Name contains invalid characters' is displayed for each value; name is unchanged

  # Ref: FRD 6.1.3 F-Name
  @TC_CP_369 @Negative @Medium @Automation
  Scenario: Verify name over 100 characters is rejected on rename
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Rename form for 'Archive' is open
    And the following test data is used
      | Name | 'R' repeated 101 times |
    When the user enters a 101-character name and Save
    Then 'Folder / Sub Folder Name cannot exceed 100 characters' is displayed; name is unchanged

  # Ref: FRD 6.1.3 F-Name; US-1 AC-3
  @TC_CP_370 @Negative @High @Automation
  Scenario: Verify renaming to a sibling's name is blocked case-insensitively
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folders 'Archive' and 'Empty Folder' exist at the root level
    And the following test data is used
      | Folder   | Empty Folder |
      | New name | ARCHIVE      |
    When the user renames 'Empty Folder' to 'ARCHIVE'
    And the user clicks Save
    Then Error 'A folder or sub folder with this name already exists.' is displayed and the name is unchanged

  # Ref: FRD 6.1.3 F-Name; US-1 AC-3
  @TC_CP_371 @Negative @High @Automation
  Scenario: Verify renaming a sub-folder to a sibling sub-folder's name is blocked
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Tenders' and 'Work Orders' exist under 'Contracts'
    And the following test data is used
      | Sub-folder | Work Orders |
      | New name   | Tenders     |
    When the user renames 'Work Orders' to 'Tenders'
    And the user clicks Save
    Then Error 'A folder or sub folder with this name already exists.' is displayed

  # Ref: FRD 6.1.3 Perm
  @TC_CP_372 @Negative @Medium @Automation
  Scenario: Verify a user without rename permission cannot rename a folder
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Viewer_User1       |
      | Payload | {name:'Archive Z'} |
    When the user opens the kebab menu on 'Archive'
    And the user sends a rename API request with this user's token
    Then 'Rename' is not shown
    And API returns 403 and the name is unchanged
