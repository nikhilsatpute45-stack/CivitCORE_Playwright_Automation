@DMS @DocumentUploadDragAndDrop
Feature: Document Upload - Drag and Drop
  Automated scenarios for the "Document Upload - Drag and Drop" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-4 AC-3; FRD 6.2.3 FB-DnD
  @TC_CP_064 @Functional @High @Automation
  Scenario: Verify dropping a valid file into the upload area processes it as a standard upload
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | Dropped.pdf |
    When the user drags 'Dropped.pdf' into the upload area and release
    And the user completes metadata
    And the user saves
    Then File is validated and uploaded as Version V1 with a unique Document ID
    And Upload progress and result are displayed

  # Ref: FRD 6.2.3 BR-Multi
  @TC_CP_065 @Functional @Medium @Automation
  Scenario: Verify multiple files can be dropped simultaneously
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Files | D1.pdf, D2.docx, D3.png |
    When the user selects three files and drop them together
    Then All three files are listed for metadata entry and each becomes an independent document

  # Ref: FRD 6.2.3 BR-Remove
  @TC_CP_066 @Functional @Medium @Automation
  Scenario: Verify a dropped file can be removed before saving
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Two dropped files are in the upload list
    And the following test data is used
      | Files | D1.pdf, D2.pdf |
    When the user clicks Remove against one file
    And the user saves
    Then The removed file creates no document; the other uploads normally

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.2.3 BR-Outside
  @TC_CP_394 @Negative @High @Automation
  Scenario: Verify dropping files outside a valid upload area does not start an upload
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | Outside.pdf |
    When the user drags a file and drop it outside the upload area
    Then No upload starts and no document is created

  # Ref: FRD 6.2.3 BR-Perm; FRD 6.2.3 BR-SameRules
  @TC_CP_395 @Negative @High @Automation
  Scenario: Verify drag-and-drop is unavailable for a user without upload permission
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | User | Viewer_User1 |
    When the user drags a file onto the folder view
    Then No drop zone is shown and nothing is uploaded

  # Ref: FRD 6.2.3 BR-SameRules; FRD 6.3.1 FB-Reject
  @TC_CP_396 @Negative @High @Automation
  Scenario: Verify format and size rules are applied to dropped files
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Files | Setup.exe, Big.pdf (501 MB) |
    When the user drops 'Setup.exe' and a 501 MB 'Big.pdf'
    Then 'This file format is not supported.' is displayed for Setup.exe
    And 'Upload failed. This file exceeds the maximum allowed size of 500 MB.' is displayed for Big.pdf
    And No documents are created
