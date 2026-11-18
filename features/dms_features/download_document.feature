@DMS @DownloadDocument
Feature: Download Document
  Automated scenarios for the "Download Document" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.5.4 FB-DownloadOriginal; FRD 6.5.4 BR-Original; US-8 AC-3
  @TC_CP_129 @Functional @High @Automation
  Scenario: Verify Download Original returns the stored file without annotations
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 has saved annotations
    And Original checksum is noted
    And the following test data is used
      | Document | DOC-0001 |
    When the user clicks Download > Download Original
    And the user compares the downloaded file checksum and content
    Then The downloaded file is identical to the stored original with no annotations

  # Ref: FRD 6.5.4 FB-DownloadAnnotated; FRD 6.5.4 BR-Latest; FRD Sec 8 T28
  @TC_CP_130 @Functional @High @Automation
  Scenario: Verify Download with Annotations returns the latest saved annotated copy as PDF
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 has a saved annotated copy
    And the following test data is used
      | Document | DOC-0001 |
    When the user clicks Download > Download with Annotations
    And the user opens the downloaded file
    Then A PDF containing all saved annotations is downloaded
    And Toaster 'Document with annotations downloaded successfully.' is displayed

  # Ref: FRD 6.5.4 BR-NoUnsaved
  @TC_CP_131 @Functional @High @Automation
  Scenario: Verify annotations added but not saved are not included in the downloaded annotated copy
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 has one saved annotation and one unsaved new annotation in the open preview
    And the following test data is used
      | Saved   | Rectangle p.1 |
      | Unsaved | Arrow p.2     |
    When the user downloads with Annotations
    Then The downloaded file contains only the saved annotation

  # Ref: US-8 AC-4; FRD 6.5.4 BR-NoVersion; FRD 7.1 Act-Downloaded; FRD 7.2 DownloadLog
  @TC_CP_132 @Functional @High @Automation
  Scenario: Verify a download creates a Download Log entry and an activity log entry and no new version
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 (V1) exists
    And the following test data is used
      | Document | DOC-0001 |
    When the user downloads Original, then Download with Annotations
    And the user checks the Download Log and activity log
    And the user checks Latest Version
    Then Two Download Log entries (user, date, time, version, type Original / With Annotations) are created
    And Activity log has 'Document Downloaded' entries
    And Latest Version is unchanged

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.5.4 BR-OptionRule
  @TC_CP_434 @Negative @High @Automation
  Scenario: Verify Download with Annotations is not displayed when no annotations are saved
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0002 has no saved annotations
    And the following test data is used
      | Document | DOC-0002 |
    When the user opens DOC-0002 and click Download
    Then Only 'Download Original' is displayed

  # Ref: FRD 6.5.4 BR-Perm
  @TC_CP_435 @Negative @High @Automation
  Scenario: Verify a user without Download permission cannot download
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 exists
    And the following test data is used
      | User | Viewer_User1 |
    When the user looks for Download
    And the user sends a download API request
    Then Download is not displayed; API returns 403 and no file is returned
