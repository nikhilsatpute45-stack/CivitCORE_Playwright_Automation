@DMS @DownloadActiveVersion
Feature: Download Active Version
  Automated scenarios for the "Download Active Version" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.6.5 FB-Download; FRD Sec 8 T26; FRD 6.6.5 BR-Original
  @TC_CP_158 @Functional @High @Automation
  Scenario: Verify Download Active Version downloads the original Active file named with the Document Name and extension
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1, V2, V3 (Active V3)
    And the following test data is used
      | Document | Quarterly Report (V3 Active) |
    When the user clicks kebab > Download Active Version on DOC-0005
    And the user checks the downloaded file
    Then The V3 original is downloaded as 'Quarterly Report.pdf' without annotations
    And Toaster 'Active version downloaded successfully.' is displayed

  # Ref: FRD 6.6.5 BR-Log; FRD 6.6.5 BR-NoChange; FRD 7.2 DownloadLog
  @TC_CP_159 @Functional @High @Automation
  Scenario: Verify the download is logged with type Original and does not change the document
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 V3 Active
    And the following test data is used
      | Document | DOC-0005 |
    When the user downloads the Active Version
    And the user checks the Download Log and activity log
    And the user checks versions, metadata and check-out status
    Then Download Log has an entry with Download Type 'Original'; activity log has an entry
    And No new version and no change to metadata or check-out status

  # Ref: FRD 6.6.5 BR-CheckedOut
  @TC_CP_160 @Functional @High @Automation
  Scenario: Verify a checked-out document's Active Version download returns the last checked-in version
    Given DOC-0011 is checked out by Editor_User1 with changes in progress
    And the following test data is used
      | Document | DOC-0011 (V1 Active) |
    When the user clicks Download Active Version as Admin_User1
    Then The last checked-in Active Version (V1) is downloaded; in-progress changes are not included

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.6.5 BR-Perm
  @TC_CP_445 @Negative @High @Automation
  Scenario: Verify the action is hidden and blocked for a user without Download permission
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 exists
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens the kebab menu
    And the user sends an API request to download the Active Version
    Then 'Download Active Version' is not shown; API returns 403
