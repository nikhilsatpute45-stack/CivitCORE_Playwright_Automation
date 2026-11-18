@DMS @FileSize
Feature: File Size
  Automated scenarios for the "File Size" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.3.2 BR-Max500
  @TC_CP_079 @Functional @High @Automation
  Scenario: Verify a file of exactly 500 MB is accepted (upper boundary)
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | Boundary_500MB.pdf (524,288,000 bytes) |
    When the user uploads a 500 MB PDF
    And the user completes metadata and save
    Then The file passes size validation and is uploaded as V1

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.3.2 FB-Reject; US-5 AC-3
  @TC_CP_402 @Negative @High @Automation
  Scenario: Verify a file larger than 500 MB is rejected with the size message
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | Over_500MB.pdf (524,288,001 bytes) |
    When the user uploads a file of 500 MB + 1 byte
    Then Message 'Upload failed. This file exceeds the maximum allowed size of 500 MB.' is displayed
    And No document record, version or folder entry is created; partial data is discarded

  # Ref: FRD 6.3.2 BR-Empty
  @TC_CP_403 @Negative @High @Automation
  Scenario: Verify a 0 KB file is rejected
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | Empty.pdf (0 KB) |
    When the user uploads an empty PDF
    Then Message 'Upload failed. The selected file is empty.' is displayed and no record is created

  # Ref: FRD 6.3.2 BR-ServerSide
  @TC_CP_404 @Negative @High @Automation
  Scenario: Verify the size limit is enforced server-side when the client check is bypassed
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And API client authenticated as Uploader_User1
    And the following test data is used
      | File | Bypass.pdf (501 MB) |
    When the user sends an upload request for a 501 MB file directly to the API, bypassing the UI check
    Then The back end rejects the file; no document record is created

  # Ref: FRD 6.3.2 BR-Fixed
  @TC_CP_405 @Negative @Medium @Automation
  Scenario: Verify the maximum file size is not configurable in Document Configuration
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Document Configuration is open
    And the following test data is used
      | Attempted limit | 1000 MB |
    When the user looks for a maximum file size setting
    And the user sends a config update that changes the size limit via API
    Then No file-size setting is available in the UI
    And The API change is rejected; the limit remains 500 MB

  # Ref: FRD 6.3.2 BR-Order; FRD 6.3.2 BR-Check-in
  @TC_CP_406 @Negative @Medium @Automation
  Scenario: Verify the 500 MB limit also applies to Check-in uploads
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | File | Revision_501MB.pdf |
      | Note | Large revision     |
    When the user starts Check-in and upload a 501 MB PDF with a note
    Then 'Upload failed. This file exceeds the maximum allowed size of 500 MB.' is displayed; no version is created; the document stays checked out
