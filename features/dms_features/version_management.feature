@DMS @VersionManagement
Feature: Version Management
  Automated scenarios for the "Version Management" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.8 BR-V1; FRD 6.8 BR-Sequential; FRD 6.8 BR-OneActive
  @TC_CP_186 @Functional @High @Automation
  Scenario: Verify the first upload is V1 (Active) and later check-ins create sequential versions with only one Active
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 (V1) exists
    And the following test data is used
      | Document      | DOC-0001           |
      | Revised files | Rev2.pdf, Rev3.pdf |
    When the user checks out and check in twice with different files
    And the user opens Version History
    Then Versions V1, V2, V3 exist sequentially
    And Only V3 is Active; V1 and V2 are Previous
    And Version numbers cannot be edited

  # Ref: FRD 6.8 BR-NoNewVersion
  @TC_CP_187 @Functional @High @Automation
  Scenario: Verify metadata edit and saving annotations do not create a new version
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 (V1)
    And the following test data is used
      | Document | DOC-0001 |
    When the user edits metadata and save
    And the user saves an annotation
    And the user checks the version list
    Then The document still has only V1

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.8 BR-NoRestore; FRD 6.8.3 BR-NoRestore
  @TC_CP_455 @Negative @High @Automation
  Scenario: Verify there is no option to restore a previous version as Active
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1-V3
    And the following test data is used
      | Document | DOC-0005 |
      | Version  | V2       |
    When the user opens Version History
    And the user looks for a restore/make-active control on V2
    Then No restore option exists; the latest checked-in version remains Active
