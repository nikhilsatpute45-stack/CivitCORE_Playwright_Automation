@DMS @DocumentDetailsEditMetadata
Feature: Document Details & Edit Metadata
  Automated scenarios for the "Document Details & Edit Metadata" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-7 AC-1; FRD 6.5.1 FB-View; FRD 6.5.1 BR-ViewDefault
  @TC_CP_104 @Functional @High @Automation
  Scenario: Verify opening a document from the list shows its metadata in read-only view mode
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Contracts' contains DOC-0001 'Site Inspection Report'
    And the following test data is used
      | Document | DOC-0001     |
      | User     | Viewer_User1 |
    When the user clicks the Document Name 'Site Inspection Report' in the Document List
    And the user observes the Document Details
    Then Document Details opens with all metadata in read-only view mode
    And The Edit option is not displayed to this user

  # Ref: FRD 6.5.1 FB-Edit; FRD 6.5.1 BR-Editable
  @TC_CP_105 @Functional @High @Automation
  Scenario: Verify Edit enables only Name, Description, Category, Sub-category and Tags while system fields stay read-only
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is open in Document Details
    And the following test data is used
      | Editable  | Document Name, Description, Category, Sub-category, Tags    |
      | Read-only | Document Type, File Size, Uploaded By, Uploaded Date & Time |
    When the user clicks Edit
    And the user tries to modify each field
    Then Only the five editable fields can be modified
    And Document Type, File Size, Uploaded By and Uploaded Date & Time remain read-only

  # Ref: US-7 AC-2; FRD 6.5.1 FB-Save; FRD Sec 8 T17; FRD 7.1 Act-MetadataEdited
  @TC_CP_106 @Functional @High @Automation
  Scenario: Verify saving edited metadata updates the document, logs the change and does not create a new version
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 (Latest Version V1) is open
    And the following test data is used
      | Description | Updated after site visit |
    When the user clicks Edit
    And the user changes Description to 'Updated after site visit'
    And the user clicks Save
    And the user opens the activity log and check Latest Version
    Then Toaster 'Document details updated successfully.' is displayed and the metadata returns to view mode
    And Activity log has a 'Metadata Edited' entry
    And Latest Version is still V1 (no new version)

  # Ref: FRD 6.5.1 BR-Cancel
  @TC_CP_107 @Functional @Medium @Automation
  Scenario: Verify Cancel discards unsaved metadata changes
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is open in edit mode
    And the following test data is used
      | Name | Changed Name (unsaved) |
    When the user changes Document Name to 'Changed Name'
    And the user clicks Cancel
    Then Changes are discarded and the original name is shown in view mode

  # Ref: FRD 6.5.1 BR-CategoryRefresh
  @TC_CP_108 @Functional @Medium @Automation
  Scenario: Verify changing the Category in edit mode refreshes the Sub-category values
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is open in edit mode (Category 'Inspection')
    And the following test data is used
      | Category | Inspection > Contract |
    When the user changes Category to 'Contract'
    And the user opens Sub-category
    Then Sub-category list refreshes to 'Contract' sub-categories and the previous value is cleared

  # Ref: FRD 6.5.1 BR-NoExtEdit
  @TC_CP_109 @Functional @Medium @Automation
  Scenario: Verify the file extension cannot be changed when editing the Document Name
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 (PDF) is open in edit mode
    And the following test data is used
      | Name | Inspection Final |
    When the user renames the Document Name to 'Inspection Final'
    And the user saves
    Then Name is saved and the stored file extension remains '.pdf'

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.5.1 BR-Perm
  @TC_CP_423 @Negative @High @Automation
  Scenario: Verify a user without Edit Metadata permission cannot edit metadata
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is open
    And the following test data is used
      | User    | Viewer_User1           |
      | Payload | {description:'Hacked'} |
    When the user looks for Edit
    And the user sends an update-metadata API request with this user's token
    Then Edit is not displayed
    And API returns 403 and the metadata is unchanged

  # Ref: FRD 6.4.1 BR-EditRules; FRD 6.5.1 BR-Validate
  @TC_CP_424 @Negative @High @Automation
  Scenario: Verify Document Name validations apply when editing metadata
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is open in edit mode
    And the following test data is used
      | Names | (blank)            |
      | Data  | 101-character name |
      | Data  | Plan#A             |
    When the user enters each invalid name and click Save
    And the user repeats for each value
    Then 'Document name is required.' / 'Document name cannot exceed 100 characters.' / 'Document name contains invalid characters.' are displayed respectively; the changes are not saved

  # Ref: FRD 6.4.2 BR-EditRules; FRD 6.4.3 BR-EditRules; FRD 6.4.4 BR-EditRules
  @TC_CP_425 @Negative @Medium @Automation
  Scenario: Verify Description, Category/Sub-category and Tag validations apply when editing metadata
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is open in edit mode
    And the following test data is used
      | Description  | Cost $100  |
      | Sub-category | (cleared)  |
      | Tag          | Site Visit |
    When the user enters 'Cost $100' in Description and Save
    And the user clears Sub-category for a Category with mapped sub-categories and Save
    And the user adds the tag 'Site Visit'
    Then 'Description contains invalid characters.' / 'Please select a sub-category.' / 'Spaces are not allowed in a tag.' are displayed; nothing is saved

  # Ref: FRD 6.5.1 BR-SystemFields
  @TC_CP_426 @Negative @High @Automation
  Scenario: Verify system-generated metadata cannot be changed through the API
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And API client authenticated as Editor_User1
    And the following test data is used
      | Payload | {uploadedBy:'Admin_User1', fileSize:1} |
    When the user sends an update request containing uploadedBy and fileSize
    Then System-generated fields are ignored or rejected; stored values are unchanged

  # Ref: FRD 6.8.1 State-AfterCheckout; FRD 6.6.2 Table-CheckedOut
  @TC_CP_427 @Negative @Medium @Automation
  Scenario: Verify Edit Metadata is not available to another user while a document is checked out
    Given DOC-0011 is checked out by Editor_User1
    And Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Document | DOC-0011 (checked out by Editor_User1) |
    When As Admin_User1 open DOC-0011
    And the user looks for Edit
    Then Edit Metadata is not available (per 6.8.1 state table). FRD 6.6.2 says 'Based on configured policy'; confirm policy default with BA
