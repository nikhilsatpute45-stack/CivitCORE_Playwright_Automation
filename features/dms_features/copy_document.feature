@DMS @CopyDocument
Feature: Copy Document
  Automated scenarios for the "Copy Document" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.6.4 FB-Copy; FRD Sec 8 T24; FRD 6.6.4 F-NewName; FRD 7.1 Act-Copied
  @TC_CP_151 @Functional @High @Automation
  Scenario: Verify a document is copied with a pre-filled name, new Document ID and the toaster
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 'Site Inspection Report' is in 'Contracts'
    And the following test data is used
      | New Document Name | Site Inspection Report (Copy) |
      | Target            | Reports                       |
    When the user clicks kebab > Copy to Folder
    And the user observes 'Copying from: Site Inspection Report' and the pre-filled name
    And the user selects 'Reports'
    And the user clicks Copy
    Then A new document 'Site Inspection Report (Copy)' with a new Document ID exists in 'Reports'
    And Toaster 'Document copied successfully.' is displayed
    And Activity log has 'Document Copied'

  # Ref: FRD 6.6.4 BR-V1; FRD 6.6.4 BR-NotCarried
  @TC_CP_152 @Functional @High @Automation
  Scenario: Verify the copy is Version 1 (Active) created from the Active Version and no history is carried over
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1-V3 with annotations, discussion and activity
    And the following test data is used
      | Source | DOC-0005 (Active V3) |
    When the user copies DOC-0005 to 'Archive'
    And the user opens the copy: details, Version History, annotations, discussion and activity log
    Then The copy is V1 (Active) with the content of V3
    And Version history, annotations, discussion thread and activity log of the source are not carried over

  # Ref: FRD 6.6.4 BR-Metadata
  @TC_CP_153 @Functional @High @Automation
  Scenario: Verify the copy keeps Description, Category, Sub-category and Tags of the source
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 has Description 'Weekly report', Category 'Inspection', Sub-category 'Site Inspection', Tags 'Safety'
    And the following test data is used
      | Source | DOC-0001 |
    When the user copies DOC-0001 to 'Reports'
    And the user opens the copy's details
    Then The copy shows the same Description, Category, Sub-category and Tags

  # Ref: FRD 6.6.4 BR-TargetPerm
  @TC_CP_154 @Functional @High @Automation
  Scenario: Verify the copied document follows the permissions of the target and not of the source
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0003 is in Private 'Drawings'. 'Archive' is Public
    And the following test data is used
      | Source | DOC-0003 |
      | Target | Archive  |
    When the user copies DOC-0003 to 'Archive'
    And the user logs in as NoAccess_User1 and open 'Archive'
    Then NoAccess_User1 can see the copy
    And The source's Private permissions are not carried over

  # Ref: FRD 6.6.4 BR-CheckedOut
  @TC_CP_155 @Functional @Medium @Automation
  Scenario: Verify a checked-out document can be copied and the copy is not checked out
    Given DOC-0011 is checked out by Editor_User1
    And the following test data is used
      | Source | DOC-0011 |
    When the user copies DOC-0011 to 'Archive'
    And the user opens the copy
    Then Copy is created from the Active Version, is not checked out and the original stays checked out

  # Ref: FRD 6.6.4 F-Target; FRD 6.6.4 F-NewName
  @TC_CP_156 @Functional @Medium @Automation
  Scenario: Verify the copy can be created in the current folder and the extension is retained
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 (PDF) is in 'Contracts'
    And the following test data is used
      | Target | Contracts |
    When the user copies DOC-0001 to 'Contracts' with the pre-filled name
    And the user looks for any extension control in the form
    Then 'Site Inspection Report (Copy)' is created alongside the source with the '.pdf' extension
    And The extension is not editable

  # Ref: FRD 6.6.4 F-Copy; FRD 6.6.4 FB-Cancel
  @TC_CP_157 @Functional @Medium @Automation
  Scenario: Verify Copy is enabled only with a valid name and a target, and Cancel discards entries
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Copy form for DOC-0001 is open
    And the following test data is used
      | Target | Reports |
    When the user observes Copy with no target
    And the user selects a target
    And the user clears the name
    And the user clicks Cancel
    Then Copy is disabled until both a valid name and target exist
    And Cancel closes the form with no copy created

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.6.4 F-NewName
  @TC_CP_441 @Negative @High @Automation
  Scenario: Verify New Document Name validations on copy
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Copy form for DOC-0001 is open
    And the following test data is used
      | Names | (blank)            |
      | Data  | 101-character name |
      | Data  | Copy#1             |
    When the user enters each invalid value and click Copy
    And the user repeats for each value
    Then 'Document name is required' / 'Document name cannot exceed 100 characters' / 'Document name contains invalid characters' are displayed; no copy is created

  # Ref: FRD 6.6.4 BR-Unique
  @TC_CP_442 @Negative @High @Automation
  Scenario: Verify a duplicate New Document Name at the target is blocked case-insensitively
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' contains a document 'Quarterly Report'
    And the following test data is used
      | New Name | QUARTERLY REPORT |
      | Target   | Reports          |
    When the user copies DOC-0001 with the name 'QUARTERLY REPORT' to 'Reports'
    And the user clicks Copy
    Then Error 'A document with this name already exists in the target location' is displayed and no copy is created

  # Ref: FRD 6.6.4 F-Target
  @TC_CP_443 @Negative @Medium @Automation
  Scenario: Verify a copy cannot be made without a Target Location
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Copy form for DOC-0001 is open
    And the following test data is used
      | Target | (none) |
    When the user leaves Target empty
    And the user attempts Copy via UI and API
    Then 'Target location is required' is shown; Copy is disabled; API request is rejected

  # Ref: FRD 6.6.4 BR-Perm
  @TC_CP_444 @Negative @Medium @Automation
  Scenario: Verify a user without Copy permission cannot copy a document
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 exists
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens the kebab menu
    And the user sends a copy API request
    Then 'Copy to Folder' is not shown; API returns 403
