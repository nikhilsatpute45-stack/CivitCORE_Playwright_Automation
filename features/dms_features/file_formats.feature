@DMS @FileFormats
Feature: File Formats
  Automated scenarios for the "File Formats" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.3.1 FB-Accept; FRD 6.3.1 Table-Documents
  @TC_CP_067 @Functional @High @Automation
  Scenario: Verify Document formats PDF, DOC, DOCX, TXT and RTF are accepted
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open and default formats are configured
    And the following test data is used
      | Files | a.pdf  |
      | Data  | a.doc  |
      | Data  | a.docx |
      | Data  | a.txt  |
      | Data  | a.rtf  |
    When the user uploads each file
    And the user repeats for each value
    Then Each file passes format validation and is uploaded

  # Ref: FRD 6.3.1 Table-Spreadsheets
  @TC_CP_068 @Functional @High @Automation
  Scenario: Verify Spreadsheet formats XLS, XLSX and CSV are accepted
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Files | a.xls  |
      | Data  | a.xlsx |
      | Data  | a.csv  |
    When the user uploads each file
    And the user repeats for each value
    Then Each file is uploaded successfully

  # Ref: FRD 6.3.1 Table-Presentations
  @TC_CP_069 @Functional @High @Automation
  Scenario: Verify Presentation formats PPT and PPTX are accepted
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Files | a.ppt  |
      | Data  | a.pptx |
    When the user uploads each file
    And the user repeats for each value
    Then Each file is uploaded successfully

  # Ref: FRD 6.3.1 Table-CAD
  @TC_CP_070 @Functional @High @Automation
  Scenario: Verify CAD formats DWG, DXF and DGN are accepted
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Drawings' is open
    And the following test data is used
      | Files | a.dwg |
      | Data  | a.dxf |
      | Data  | a.dgn |
    When the user uploads each file
    And the user repeats for each value
    Then Each file is uploaded successfully

  # Ref: FRD 6.3.1 Table-BIM
  @TC_CP_071 @Functional @High @Automation
  Scenario: Verify BIM formats IFC and RVT are accepted
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Drawings' is open
    And the following test data is used
      | Files | Block_A.ifc |
      | Data  | Block_A.rvt |
    When the user uploads each file
    And the user repeats for each value
    Then Each file is uploaded successfully

  # Ref: FRD 6.3.1 Table-Images
  @TC_CP_072 @Functional @High @Automation
  Scenario: Verify Image formats JPG, JPEG, PNG, TIFF, BMP and GIF are accepted
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Files | a.jpg  |
      | Data  | a.jpeg |
      | Data  | a.png  |
      | Data  | a.tiff |
      | Data  | a.bmp  |
      | Data  | a.gif  |
    When the user uploads each file
    And the user repeats for each value
    Then Each file is uploaded successfully

  # Ref: FRD 6.3.1 Table-Archives; FRD 6.3.1 BR-ZipSingle
  @TC_CP_073 @Functional @High @Automation
  Scenario: Verify a ZIP file is accepted and stored as a single document without extraction
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | Archive_Pack.zip (3 files inside) |
    When the user uploads 'Archive_Pack.zip' containing 3 files
    And the user checks the Document List
    Then One document 'Archive_Pack' is created; the contents are not extracted into separate documents

  # Ref: FRD 6.3.1 BR-CaseInsensitive
  @TC_CP_074 @Functional @Medium @Automation
  Scenario: Verify extension validation is case-insensitive
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Files | UPPER.PDF, lower.pdf |
    When the user uploads 'UPPER.PDF' and 'lower.pdf'
    Then Both files are accepted as the same PDF format

  # Ref: FRD 6.3.1 BR-Config; US-5 AC-4; FRD 6.3.1 BR-ConfigPersist
  @TC_CP_075 @Functional @High @Automation
  Scenario: Verify removing a format in Document Configuration rejects new uploads of that format while existing documents stay accessible
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Admin_User1 can open Document Configuration
    And Document 'Old_Image.bmp' already exists
    And the following test data is used
      | Format removed | BMP                          |
      | Files          | New_Image.bmp, Old_Image.bmp |
    When the user removes 'BMP' from accepted formats and save
    And the user uploads 'New_Image.bmp'
    And the user opens 'Old_Image.bmp'
    Then New_Image.bmp is rejected with 'This file format is not supported.'
    And Old_Image.bmp remains accessible

  # Ref: FRD 6.3.1 BR-Config; FRD 6.3.1 BR-Check-in
  @TC_CP_076 @Functional @Medium @Automation
  Scenario: Verify format configuration changes also apply to Check-in
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'BMP' was removed from accepted formats
    And DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | File | Revision.bmp |
    When the user starts Check-in and upload 'Revision.bmp'
    Then 'This file format is not supported.' is displayed and no version is created

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.3.1 FB-Reject; US-5 AC-1
  @TC_CP_398 @Negative @High @Automation
  Scenario: Verify an unsupported file format is rejected before any record is created
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Files | setup.exe |
      | Data  | video.mp4 |
      | Data  | page.html |
      | Data  | macro.bat |
    When the user uploads each unsupported file
    And the user repeats for each value
    And the user checks the folder
    Then Message 'This file format is not supported.' is displayed for each
    And No document record, version or folder entry is created

  # Ref: FRD 6.3.1 BR-NoExt
  @TC_CP_399 @Negative @High @Automation
  Scenario: Verify a file without an extension is rejected
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | README |
    When the user uploads a file named 'README' with no extension
    Then The file is rejected with 'This file format is not supported.' and no record is created

  # Ref: FRD 6.3.1 BR-Mismatch; US-5 AC-2
  @TC_CP_400 @Negative @High @Automation
  Scenario: Verify a file whose content does not match its extension is rejected
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | Invoice.pdf (actual content: EXE) |
    When the user renames an executable 'malware.exe' to 'Invoice.pdf'
    And the user uploads it
    Then The file is treated as unsupported and rejected; no document record is created

  # Ref: FRD 6.3.1 BR-Order
  @TC_CP_401 @Negative @Medium @Automation
  Scenario: Verify format validation happens before size validation
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | Large.exe (600 MB) |
    When the user uploads a 600 MB file with an unsupported extension
    Then 'This file format is not supported.' is displayed (not the size message)
