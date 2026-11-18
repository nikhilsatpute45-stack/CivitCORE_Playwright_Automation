@DMS @DocumentPreview
Feature: Document Preview
  Automated scenarios for the "Document Preview" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-7 AC-3; FRD 6.5.2 FB-Preview; FRD 6.5.2 BR-Embedded; FRD 7.1 Act-Previewed
  @TC_CP_110 @Functional @High @Automation
  Scenario: Verify a document is previewed in the embedded viewer without downloading and the preview is logged
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 (PDF) exists
    And the following test data is used
      | Document | DOC-0001 (PDF) |
    When the user opens DOC-0001
    And the user observes the preview area
    And the user opens the activity log as Auditor_User1
    Then The document loads in the embedded viewer (iFrame) inside DMS; the user is not redirected outside DMS and no file is downloaded
    And Activity log has a 'Document Previewed' entry

  # Ref: FRD 6.5.2 Table-Viewer
  @TC_CP_111 @Functional @High @Automation
  Scenario: Verify PDF and Office documents (DOC, DOCX, RTF, XLS, XLSX, PPT, PPTX) preview in Apryse WebViewer
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Documents of each format exist in 'Reports'
    And the following test data is used
      | Files | a.pdf  |
      | Data  | a.docx |
      | Data  | a.rtf  |
      | Data  | a.xlsx |
      | Data  | a.pptx |
    When the user opens each document
    And the user repeats for each value
    Then Each document loads in Apryse WebViewer (Office Conversion add-on for Office formats) with its content visible

  # Ref: FRD 6.5.2 Table-Viewer
  @TC_CP_112 @Functional @Medium @Automation
  Scenario: Verify TXT and CSV use the built-in text and table previews
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0009 'Meeting Notes' (TXT) and DOC-0010 'Rate Data' (CSV) exist
    And the following test data is used
      | Files | Meeting Notes.txt, Rate Data.csv |
    When the user opens DOC-0009
    And the user opens DOC-0010
    Then TXT is shown in the built-in text preview and CSV in the built-in table preview

  # Ref: FRD 6.5.2 Table-Viewer
  @TC_CP_113 @Functional @Medium @Automation
  Scenario: Verify image files (JPG, JPEG, PNG, TIFF, BMP, GIF) preview in Apryse WebViewer
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Image documents exist in 'Reports'
    And the following test data is used
      | Files | a.jpg  |
      | Data  | a.jpeg |
      | Data  | a.png  |
      | Data  | a.tiff |
      | Data  | a.bmp  |
      | Data  | a.gif  |
    When the user opens each image document
    And the user repeats for each value
    Then Each image loads in the Apryse WebViewer preview

  # Ref: FRD 6.5.2 FB-ZIP; FRD 6.5.2 BR-ZIP
  @TC_CP_116 @Functional @High @Automation
  Scenario: Verify a ZIP file has no preview and offers Download subject to permission
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0008 'Archive Pack' (ZIP) exists
    And the following test data is used
      | Document | DOC-0008 |
    When the user opens DOC-0008 as Admin_User1
    And the user opens DOC-0008 as Viewer_User1 (no Download permission)
    Then No preview is available; the Download option is shown to Admin_User1
    And Viewer_User1 does not get a Download option

  # Ref: FRD 6.5.2 BR-DownloadIndep
  @TC_CP_117 @Functional @High @Automation
  Scenario: Verify a user with View but without Download permission can preview but cannot download
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 exists
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens DOC-0001 preview
    And the user looks for Download options
    Then Preview loads
    And No Download options are displayed

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-7 AC-3; FRD 6.5.2 BR-NoView; FRD 6.5.2 BR-NoBypass
  @TC_CP_428 @Negative @High @Automation
  Scenario: Verify a user without View access cannot preview a document
    Given NoAccess_User1 is logged in
    And DOC-0003 is in Private 'Drawings'
    And the following test data is used
      | User     | NoAccess_User1 |
      | Document | DOC-0003       |
    When the user opens the direct URL of DOC-0003 preview
    And the user requests the preview API for DOC-0003
    Then Access is denied (403/404); no preview content is returned

  # Ref: FRD 6.5.2 BR-NoPreviewMsg
  @TC_CP_429 @Negative @Medium @Automation
  Scenario: Verify the message is displayed when a file cannot be converted or displayed
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A corrupt DOCX 'Corrupt.docx' exists in 'Reports'
    And the following test data is used
      | File | Corrupt.docx |
    When the user opens the corrupt document
    Then Message 'Preview is not available for this document.' is displayed; Download remains available subject to Download permission
