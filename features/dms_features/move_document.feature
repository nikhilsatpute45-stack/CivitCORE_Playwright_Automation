@DMS @MoveDocument
Feature: Move Document
  Automated scenarios for the "Move Document" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.6.3 FB-Move; FRD Sec 8 T23; FRD 6.6.3 F-Label; FRD 7.1 Act-Moved
  @TC_CP_147 @Functional @High @Automation
  Scenario: Verify a document is moved to another folder with the toaster and activity log entry
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is in 'Contracts'
    And the following test data is used
      | Document | Site Inspection Report |
      | Target   | Reports                |
    When the user clicks kebab > Move to Folder on DOC-0001
    And the user observes 'Moving document: Site Inspection Report'
    And the user selects 'Reports'
    And the user clicks Move
    Then Document is now in 'Reports'
    And Toaster 'Document moved successfully.' is displayed
    And Activity log has 'Document Moved'

  # Ref: FRD 6.6.3 BR-NoVersion
  @TC_CP_148 @Functional @High @Automation
  Scenario: Verify moving keeps the Document ID, version history and metadata unchanged and creates no version
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 (V1-V3) is in 'Reports'
    And the following test data is used
      | Document | DOC-0005 |
      | Target   | Archive  |
    When the user moves DOC-0005 to 'Archive'
    And the user opens its details and Version History
    Then Document ID, three versions, notes and metadata are unchanged; no new version is created

  # Ref: FRD 6.6.3 FB-Recalc; FRD 6.9 BR-MoveCopy
  @TC_CP_149 @Functional @High @Automation
  Scenario: Verify a moved document follows the access of the destination folder
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is in Public 'Contracts'. 'Drawings' is Private (Site Engineer)
    And the following test data is used
      | Document | DOC-0001 |
      | Target   | Drawings |
    When the user moves DOC-0001 to 'Drawings'
    And the user logs in as NoAccess_User1 and search for it
    And the user logs in as SiteEng_User1
    Then NoAccess_User1 cannot access the document
    And SiteEng_User1 can access it

  # Ref: FRD 6.6.3 F-Target; FRD 6.6.3 F-Move; FRD 6.6.3 FB-Cancel
  @TC_CP_150 @Functional @Medium @Automation
  Scenario: Verify the target dropdown search, Move enablement and Cancel for a document move
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Move form for DOC-0001 is open
    And the following test data is used
      | Search text | qc-1 |
    When the user observes Move with no target
    And the user searches 'qc-1' (case-insensitive)
    And the user selects it and Cancel
    Then Move is disabled until a target is selected
    And Parent path 'QC / QC-1' is displayed
    And After Cancel the document stays in its folder

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.6.3 BR-NotCurrent
  @TC_CP_438 @Negative @High @Automation
  Scenario: Verify the current folder cannot be chosen as the target
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is in 'Contracts'
    And the following test data is used
      | Target | Contracts (current) |
    When the user opens Move to Folder
    And the user looks for 'Contracts' in the list or submit it via API
    Then The current folder is not selectable and an API request to move into the same folder is rejected

  # Ref: FRD 6.6.3 BR-CheckedOut
  @TC_CP_439 @Negative @High @Automation
  Scenario: Verify a checked-out document cannot be moved
    Given DOC-0011 is checked out by Editor_User1
    And the following test data is used
      | Document | DOC-0011 |
    When the user opens the kebab menu on DOC-0011
    And the user sends a move API request
    Then 'Move to Folder' is not displayed; the API request is rejected

  # Ref: FRD 6.6.3 F-Target; FRD 6.6.3 BR-Perm
  @TC_CP_440 @Negative @Medium @Automation
  Scenario: Verify the move requires a target and only permitted target folders are listed
    Given Editor_User1 has move permission on 'Reports' only
    And the following test data is used
      | User | Editor_User1 |
    When the user opens Move to Folder as Editor_User1
    And the user observes the list
    And the user submits a move API request with no target
    Then Only permitted folders are listed
    And 'Target location is required' is shown / request without target is rejected
