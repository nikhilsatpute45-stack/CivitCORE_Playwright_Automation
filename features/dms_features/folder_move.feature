@DMS @FolderMove
Feature: Folder Move
  Automated scenarios for the "Folder Move" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.4 FB-Move; FRD Sec 8 T4; US-2 AC-2
  @TC_CP_025 @Functional @High @Automation
  Scenario: Verify a folder is moved to another folder with all its descendants and the toaster is displayed
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'QC' has sub-folder 'QC-1' with documents
    And Folder 'Archive' is empty
    And the following test data is used
      | Folder | QC      |
      | Target | Archive |
    When the user clicks kebab > Move on 'QC'
    And the user observes 'Moving folder: QC'
    And the user selects target 'Archive'
    And the user clicks Move
    And the user expands 'Archive > QC'
    Then 'QC' with 'QC-1' and all documents is relocated under 'Archive'
    And Toaster 'Folder moved successfully.' is displayed

  # Ref: FRD 6.1.4 FB-Move; FRD 6.1.4 Root
  @TC_CP_026 @Functional @High @Automation
  Scenario: Verify a sub-folder can be moved to the root level by selecting (Root level)
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Sub-folder 'Contracts > Tenders' exists
    And the following test data is used
      | Folder | Tenders      |
      | Target | (Root level) |
    When the user clicks kebab > Move on 'Tenders'
    And the user selects '(Root level)'
    And the user clicks Move
    Then 'Tenders' appears at the top level of the repository and no longer under 'Contracts'

  # Ref: US-2 AC-2; FRD 6.1 BR-MoveNoVersion
  @TC_CP_027 @Functional @High @Automation
  Scenario: Verify moving a folder leaves document IDs, versions and metadata unchanged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' contains DOC-0005 (V1, V2, V3)
    And the following test data is used
      | Folder | Reports |
      | Target | Archive |
    When the user notes DOC-0005 ID and version list
    And the user moves 'Reports' into 'Archive'
    And the user opens DOC-0005 > Version History
    Then Document ID, three versions, check-in notes and metadata are unchanged; no new version is created

  # Ref: US-2 AC-2; FRD 6.1.4 FB-Recalc
  @TC_CP_028 @Functional @High @Automation
  Scenario: Verify moving a folder recalculates permission inheritance based on the destination
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Tenders' is under Public 'Contracts'. 'Drawings' is Private (Role: Site Engineer)
    And NoAccess_User1 can see 'Tenders'
    And the following test data is used
      | Folder | Tenders  |
      | Target | Drawings |
    When the user moves 'Tenders' into 'Drawings'
    And the user logs in as NoAccess_User1 and browse
    And the user logs in as SiteEng_User1 and browse
    Then Inherited access of 'Tenders' now comes from 'Drawings'
    And NoAccess_User1 can no longer see 'Tenders'; SiteEng_User1 can

  # Ref: FRD 6.1.4 F-Target
  @TC_CP_029 @Functional @Medium @Automation
  Scenario: Verify the target dropdown supports case-insensitive search and shows the parent path
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Sub-folder 'QC > QC-1' exists
    And The Move form for 'Archive' is open
    And the following test data is used
      | Search text | qc-1 |
    When the user types 'qc-1' in the Select target location field
    And the user observes the list
    Then The match is displayed with its parent path (e.g., 'QC / QC-1')
    And Search is case-insensitive

  # Ref: FRD 6.1.4 F-Target; FRD 6.1.4 F-Move
  @TC_CP_030 @Functional @Medium @Automation
  Scenario: Verify clear (X) resets the target and Move is enabled only after a target is selected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Move form for 'Archive' is open
    And the following test data is used
      | Target | Contracts |
    When the user observes Move with no target
    And the user selects 'Contracts'
    And the user clicks the clear (X) icon
    Then Move is disabled with no target
    And Move is enabled after selection
    And Clear (X) resets the selection and Move is disabled again

  # Ref: FRD 6.1.4 FB-Cancel
  @TC_CP_031 @Functional @Medium @Automation
  Scenario: Verify Cancel closes the Move form and the folder is not moved
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Move form for 'Archive' is open with target 'Contracts' selected
    And the following test data is used
      | Folder | Archive   |
      | Target | Contracts |
    When the user clicks Cancel
    And the user checks the location of 'Archive'
    Then The form closes, the selection is discarded and 'Archive' remains at the root level

  # Ref: FRD 6.1.4 F-Target
  @TC_CP_032 @Functional @Medium @Automation
  Scenario: Verify only locations where the user holds move permission are listed
    Given Editor_User1 has move permission on 'Contracts' only
    And Baseline data is loaded
    And the following test data is used
      | User | Editor_User1 |
    When the user clicks kebab > Move on a folder the user may move
    And the user opens the target dropdown
    Then Only '(Root level)' and folders/sub-folders for which the user holds move permission are listed

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.4 BR-Dest
  @TC_CP_373 @Negative @High @Automation
  Scenario: Verify the folder itself and its own sub-folders are not selectable as target
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'QC' with sub-folder 'QC-1' exists
    And the following test data is used
      | Folder     | QC   |
      | Descendant | QC-1 |
    When the user clicks kebab > Move on 'QC'
    And the user opens the target dropdown and search for 'QC' and 'QC-1'
    Then 'QC' and 'QC-1' are not selectable; the move to itself or a descendant is blocked

  # Ref: FRD 6.1.4 F-Target
  @TC_CP_374 @Negative @Medium @Automation
  Scenario: Verify the current parent location is not selectable as target
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Tenders' is under 'Contracts'
    And the following test data is used
      | Folder         | Tenders   |
      | Current parent | Contracts |
    When the user clicks kebab > Move on 'Tenders'
    And the user opens the target dropdown and search for 'Contracts'
    Then 'Contracts' (current parent) is not selectable

  # Ref: FRD 6.1.4 BR-Conflict; FRD 6.1.4 F-Target
  @TC_CP_375 @Negative @High @Automation
  Scenario: Verify a move is blocked when the destination already contains a folder with the same name
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Archive' contains a sub-folder 'Tenders'. 'Contracts > Tenders' also exists
    And the following test data is used
      | Folder | Tenders                       |
      | Target | Archive (already has Tenders) |
    When the user clicks kebab > Move on 'Contracts > Tenders'
    And the user selects 'Archive'
    And the user clicks Move
    Then Error 'A folder with this name already exists in the target location' is displayed
    And The folder is not moved

  # Ref: FRD 6.1.4 F-Target; FRD 6.1.4 BR-DestMandatory
  @TC_CP_376 @Negative @Medium @Automation
  Scenario: Verify a move cannot be submitted without a target location
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Move form for 'Archive' is open
    And the following test data is used
      | Target | (none) |
    When the user leaves the target empty
    And the user tries to click Move or submit via API without target
    Then Move is disabled; 'Target location is required' is shown where validation is triggered
    And API request without target is rejected and nothing moves

  # Ref: FRD 6.1.4 Perm
  @TC_CP_377 @Negative @Medium @Automation
  Scenario: Verify a user without move permission cannot move a folder
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Viewer_User1 |
      | Target | Contracts    |
    When the user opens the kebab menu on 'Archive'
    And the user sends a move API request with this user's token
    Then 'Move' is not shown
    And API returns 403 and the folder is not moved
