@DMS @DeleteDocument
Feature: Delete Document
  Automated scenarios for the "Delete Document" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.6.6 FB-Popup; FRD 6.6.6 F-Warning; US-9 AC-5; FRD 6.6.6 BR-Confirm
  @TC_CP_161 @Functional @High @Automation
  Scenario: Verify the Delete Document pop-up shows the warning text, document name, Cancel and Delete
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0002 'BOQ Summary' is not checked out
    And the following test data is used
      | Document | BOQ Summary |
    When the user clicks kebab > Delete Document on DOC-0002
    And the user observes the pop-up
    Then Pop-up shows 'Are you sure you want to delete this document? This action will delete the document along with all its versions.'
    And 'Deleting document: BOQ Summary' is shown
    And Cancel and Delete are displayed and Delete is enabled

  # Ref: FRD 6.6.6 FB-Cancel
  @TC_CP_162 @Functional @High @Automation
  Scenario: Verify Cancel on the Delete Document pop-up does not delete the document
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0002 exists
    And the following test data is used
      | Document | BOQ Summary |
    When the user opens the delete pop-up and click Cancel
    Then The pop-up closes and the document remains

  # Ref: FRD 6.6.6 FB-Delete; FRD Sec 8 T25; FRD 6.6.6 BR-Soft; FRD 7.1 Act-Deleted
  @TC_CP_163 @Functional @High @Automation
  Scenario: Verify confirming delete soft-deletes the document, removes it from the list and search and shows the toaster
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0002 exists and is not checked out
    And the following test data is used
      | Document | BOQ Summary |
    When the user deletes DOC-0002 and confirm
    And the user checks the Document List and search for 'BOQ'
    And the user checks the database record
    Then Toaster 'Document deleted successfully.' is displayed
    And The document is removed from the list and search
    And The record is retained as deleted (soft delete) and the deletion is logged

  # Ref: FRD 6.6.6 BR-AllVersions
  @TC_CP_164 @Functional @High @Automation
  Scenario: Verify deleting a document removes all versions, annotations and discussion; single versions cannot be deleted
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1-V3, annotations and a discussion
    And the following test data is used
      | Document | DOC-0005 |
    When the user deletes DOC-0005 and confirm
    And the user looks for a way to delete only V2 in Version History
    Then All versions, annotations and the discussion are no longer accessible
    And Version History offers no per-version delete

  # Ref: FRD 6.6.6 BR-LogsRetained
  @TC_CP_165 @Functional @Medium @Automation
  Scenario: Verify activity log and Download Log entries of a deleted document are retained
    Given DOC-0002 was deleted
    And the following test data is used
      | Document | DOC-0002 |
    When the user queries the audit store for DOC-0002 as an administrator
    Then Activity log and Download Log entries of DOC-0002 remain retained for audit

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.6.6 BR-CheckedOut
  @TC_CP_446 @Negative @High @Automation
  Scenario: Verify a checked-out document cannot be deleted
    Given DOC-0011 is checked out by Editor_User1
    And the following test data is used
      | Document | DOC-0011 |
    When the user opens the kebab menu on DOC-0011
    And the user sends a delete API request
    Then 'Delete Document' is not displayed; the API request is rejected and the document remains

  # Ref: FRD 6.6.6 BR-Perm
  @TC_CP_447 @Negative @High @Automation
  Scenario: Verify a user without Delete permission cannot delete
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 exists
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens the kebab menu
    And the user sends a delete API request
    Then 'Delete Document' is not shown; API returns 403 and the document remains

  # Ref: FRD 6.6.6 BR-NoAccess
  @TC_CP_448 @Negative @High @Automation
  Scenario: Verify a deleted document cannot be reached through direct URL, list or search
    Given DOC-0002 was soft-deleted
    And the following test data is used
      | Document | DOC-0002 |
    When the user opens the direct URL of DOC-0002
    And the user searches 'BOQ Summary' in 'Contracts'
    And the user checks the Document List
    Then The document is not accessible by direct URL (not found/denied), is not in search results and is not in the Document List
