@DMS @DocumentUploadBulk
Feature: Document Upload - Bulk
  Automated scenarios for the "Document Upload - Bulk" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-4 AC-2; FRD 6.2.2 FB-Bulk; FRD Sec 8 T11; FRD 6.2.2 BR-Independent
  @TC_CP_057 @Functional @High @Automation
  Scenario: Verify a bulk upload creates independent documents, each with its own Document ID and Version 1
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Files | Plan_A.pdf, Plan_B.docx, Photo_C.jpg |
    When the user clicks ADD DOC and select three valid files
    And the user enters metadata for each file
    And the user saves
    And the user reviews the results
    Then Three documents are created with different Document IDs, each Version V1
    And Result per file is displayed
    And Toaster 'Documents uploaded successfully.' is displayed

  # Ref: US-4 AC-2; FRD 6.2.2 BR-PartialMsg; FRD Sec 8 T12
  @TC_CP_058 @Functional @High @Automation
  Scenario: Verify a bulk upload with an unsupported file uploads the valid files and shows the partial-success toaster
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Files | Valid_1.pdf, Valid_2.pdf, Invalid.exe |
    When the user selects two valid files and one unsupported file
    And the user completes metadata and save
    Then Valid_1 and Valid_2 are uploaded; Invalid.exe is rejected
    And Toaster 'Documents uploaded successfully. Some files could not be uploaded.' is displayed
    And Failure of one file does not fail the batch

  # Ref: FRD 6.2.2 BR-Metadata
  @TC_CP_059 @Functional @Medium @Automation
  Scenario: Verify metadata is captured separately per file and not applied across the batch
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Two valid files are selected in a bulk upload
    And the following test data is used
      | File 1 | Name 'Plan A', Category 'Inspection' |
      | File 2 | Name 'Plan B', Category 'Contract'   |
    When the user enters different Name, Description and Category for each file
    And the user saves
    And the user opens each document's details
    Then Each document retains its own metadata; no common metadata is applied to the batch

  # Ref: FRD 6.2.2 BR-Metadata
  @TC_CP_060 @Functional @Medium @Automation
  Scenario: Verify each file is saved only after its own mandatory metadata is provided
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Two valid files are selected in a bulk upload
    And the following test data is used
      | File 1 | complete              |
      | File 2 | Category not selected |
    When the user completes metadata for file 1 only
    And the user attempts to save
    Then File 2 cannot be saved until its mandatory metadata is provided; inline error 'Please select a document category.' is shown for file 2

  # Ref: FRD 6.2.2 BR-Remove; FRD 6.2.1 Msg-Removed
  @TC_CP_061 @Functional @Medium @Automation
  Scenario: Verify one file can be removed from the list without affecting the others and is not counted as failed
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Three valid files are in the bulk upload list
    And the following test data is used
      | Files | Plan_A.pdf, Plan_B.pdf, Plan_C.pdf (remove Plan_B) |
    When the user clicks Remove against the second file
    And the user saves the remaining files
    And the user reads the completion toaster
    Then 'Document removed successfully.' is displayed on removal
    And Plan_A and Plan_C are uploaded; Plan_B creates no record, version or activity event
    And Completion toaster is 'Documents uploaded successfully.' (removal is not a failure)

  # Ref: FRD 6.2.2 BR-RemoveAll
  @TC_CP_062 @Functional @Medium @Automation
  Scenario: Verify no document is saved if all files are removed
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Two valid files are in the bulk upload list
    And the following test data is used
      | Files | Plan_A.pdf, Plan_B.pdf |
    When the user removes both files
    And the user attempts to save
    Then No document is saved and no document record is created

  # Ref: FRD 6.2.2 BR-Audit; FRD 6.2.2 BR-Inherit
  @TC_CP_063 @Functional @High @Automation
  Scenario: Verify each bulk-uploaded document has its own activity event and inherits folder access
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Drawings' (Private, Role: Site Engineer) is open
    And the following test data is used
      | Files | Dwg_1.pdf, Dwg_2.pdf |
    When Bulk upload two valid files
    And the user opens the activity log of each document
    And the user logs in as NoAccess_User1 and try to access them
    Then Each document has its own 'Document Uploaded' entry
    And Both inherit the folder access; NoAccess_User1 cannot access either

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.2.2 BR-Independent; FRD 6.3.2 FB-Bulk
  @TC_CP_392 @Negative @High @Automation
  Scenario: Verify an oversized file in a bulk upload is rejected while the other files upload
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Files | Huge.pdf (501 MB), Small.pdf (1 MB) |
    When the user selects a 501 MB PDF and a 1 MB PDF
    And the user completes metadata and save
    Then Huge.pdf is rejected with 'Upload failed. This file exceeds the maximum allowed size of 500 MB.'
    And Small.pdf is uploaded; the partial toaster is displayed

  # Ref: FRD 6.2.2 BR-Perm
  @TC_CP_393 @Negative @Medium @Automation
  Scenario: Verify a user without upload permission cannot bulk upload
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Files | A.pdf, B.pdf |
    When the user sends a bulk upload API request with two files
    Then API returns 403 and no documents are created
