@DMS @DocumentUploadSingle
Feature: Document Upload - Single
  Automated scenarios for the "Document Upload - Single" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-4 AC-1; FRD 6.2.1 FB-Upload; FRD Sec 8 T10; FRD 6.2.1 BR-ID
  @TC_CP_050 @Functional @High @Automation
  Scenario: Verify a single valid file is uploaded with a unique Document ID, Version 1 (Active) and the success toaster
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File          | Site_Inspection_Report.pdf (2 MB) |
      | Document Name | Site_Inspection_Report            |
      | Category      | Inspection                        |
      | Sub-category  | Site Inspection                   |
    When the user clicks ADD DOC
    And the user selects the file from the local device
    And the user completes the mandatory metadata
    And the user saves
    And the user observes the Document List
    Then A document is created with a unique Document ID and Version V1 marked Active
    And The document is displayed in the folder
    And Toaster 'Document uploaded successfully.' is displayed

  # Ref: US-4 AC-1; FRD 7.1 Act-Lifecycle
  @TC_CP_051 @Functional @High @Automation
  Scenario: Verify the upload is recorded in the activity log
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A document 'Site_Inspection_Report.pdf' was just uploaded into 'Reports'
    And the following test data is used
      | Document | Site_Inspection_Report |
    When As Admin_User1 open the document's View Activity Log
    Then An entry with Action 'Document Uploaded', the uploading user, system date and time, Version V1 is present

  # Ref: FRD 6.2.1 BR-InheritAccess
  @TC_CP_052 @Functional @High @Automation
  Scenario: Verify an uploaded document inherits the access permissions of the target folder
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Drawings' is Private (Role: Site Engineer); Uploader_User1 has upload permission there
    And the following test data is used
      | File  | Rev_A.pdf                     |
      | Users | SiteEng_User1, NoAccess_User1 |
    When the user uploads 'Rev_A.pdf' into 'Drawings'
    And the user logs in as SiteEng_User1 and open 'Drawings'
    And the user logs in as NoAccess_User1 and try to open the document URL
    Then SiteEng_User1 can see the document
    And NoAccess_User1 cannot access it

  # Ref: FRD 6.4.1 FB-Default; US-6 AC-1
  @TC_CP_053 @Functional @High @Automation
  Scenario: Verify Document Name defaults to the file name without extension and the extension is retained
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | Monthly_Progress.xlsx |
    When the user clicks ADD DOC and select the file
    And the user observes the Document Name field
    And the user saves and open document details
    Then Document Name is pre-populated as 'Monthly_Progress' (no extension)
    And The extension '.xlsx' is retained by the system and is not editable

  # Ref: FRD 6.2.1 FB-Remove; FRD 6.2.1 Msg-Removed
  @TC_CP_054 @Functional @Medium @Automation
  Scenario: Verify the uploaded file can be removed before saving and another file selected
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A file is selected in the upload form with metadata entered
    And the following test data is used
      | File 1 | Draft.pdf |
      | File 2 | Final.pdf |
    When the user clicks Remove against the file
    And the user selects a different file
    Then Toaster 'Document removed successfully.' is displayed
    And The file and entered metadata are discarded and no document record is created
    And The second file can be selected

  # Ref: FRD 6.2.1 BR-Cancel
  @TC_CP_055 @Functional @Medium @Automation
  Scenario: Verify cancelling the upload before saving creates no document record
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A file is selected with metadata entered but not saved
    And the following test data is used
      | File | Cancelled.pdf |
    When the user cancels the upload
    And the user checks the Document List
    Then No document record or Document ID is created and nothing is added to the folder

  # Ref: FRD 6.2.1 BR-RemoveAfterSave
  @TC_CP_056 @Functional @Medium @Automation
  Scenario: Verify the Remove option is not available once the document is saved
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Document 'Saved_Doc' was uploaded and saved
    And the following test data is used
      | Document | Saved_Doc |
    When the user opens the Document List and document details
    And the user looks for a Remove option
    Then No Remove option exists; deletion is possible only through Delete Document (6.6.6)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.2.1 BR-Perm
  @TC_CP_388 @Negative @High @Automation
  Scenario: Verify the ADD DOC CTA is not available to a user without upload permission
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | User | Viewer_User1 |
      | File | Blocked.pdf  |
    When the user looks for ADD DOC
    And the user sends an upload API request with this user's token
    Then ADD DOC is not displayed
    And API returns 403 and no document is created

  # Ref: FRD 6.2.1 BR-FailMsg; FRD Sec 8 T13
  @TC_CP_389 @Negative @High @Automation
  Scenario: Verify the failure message is displayed when the upload fails
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And Storage service is stubbed to return an error
    And the following test data is used
      | File | Storage_Fail.pdf |
    When the user uploads a valid file while the storage error is simulated
    Then Toaster 'Document upload failed. Please try again.' is displayed
    And No document record, Version or Document ID is created

  # Ref: FRD 6.2.1 BR-Mandatory
  @TC_CP_390 @Negative @High @Automation
  Scenario: Verify the document cannot be saved without the mandatory metadata
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected
    And the following test data is used
      | File     | Missing_Meta.pdf |
      | Name     | (blank)          |
      | Category | (not selected)   |
    When the user clears Document Name and do not select Category
    And the user attempts to save
    Then The document is not saved; inline errors 'Document name is required.' and 'Please select a document category.' are displayed

  # Ref: FRD 6.2.1 BR-OneFile
  @TC_CP_391 @Negative @Medium @Automation
  Scenario: Verify a single file upload operation accepts only one file
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Files | A.pdf, B.pdf |
    When the user sends an upload API request that carries two files in a single-upload call
    Then Only one file is processed or the request is rejected; two documents are not created from one single-upload operation
