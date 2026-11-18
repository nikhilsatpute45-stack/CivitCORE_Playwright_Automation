@DMS @DocumentList
Feature: Document List
  Automated scenarios for the "Document List" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-9 AC-1; FRD 6.6.1 Columns; FRD 6.6.1 BR-Sort
  @TC_CP_133 @Functional @High @Automation
  Scenario: Verify the Document List shows only accessible documents sorted with the most recently uploaded first
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' contains documents uploaded at different times
    And the following test data is used
      | Folder   | Reports    |
      | New file | Newest.pdf |
    When the user opens 'Reports'
    And the user observes the order
    And the user uploads a new file 'Newest.pdf'
    Then Documents are listed most recent first; 'Newest.pdf' appears at the top
    And Only documents the user can access are listed

  # Ref: FRD 6.6.1 Columns; FRD 6.6.1 FB-Display
  @TC_CP_134 @Functional @Medium @Automation
  Scenario: Verify the Sr. No. is sequential and Latest Version shows the Active version
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 (V3 Active) is in 'Reports'
    And the following test data is used
      | Document | DOC-0005 |
    When the user observes the Sr. No. and Latest Version columns
    Then Sr. No. is 1, 2, 3... for the current list
    And Latest Version shows 'V3' for DOC-0005

  # Ref: US-9 AC-1; FRD 6.6.1 BR-Link
  @TC_CP_135 @Functional @High @Automation
  Scenario: Verify clicking the Document ID or Document Name opens Document Details
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' contains DOC-0005
    And the following test data is used
      | Document | DOC-0005 |
    When the user clicks the Document ID
    And the user goes back and click the Document Name
    Then Both open the Document Details screen of DOC-0005

  # Ref: FRD 6.6.1 BR-ID
  @TC_CP_136 @Functional @High @Automation
  Scenario: Verify Document IDs are unique, system-generated and not generated for failed or cancelled uploads
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' is open
    And the following test data is used
      | Files | Cancelled.pdf, Bad.exe, Good.pdf |
    When the user notes the last Document ID
    And the user cancels an upload and upload an unsupported file
    And the user uploads a valid file
    Then No ID is consumed by the cancelled or rejected upload
    And The new document gets a unique ID that cannot be edited by the user

  # Ref: FRD 6.6.1 BR-IDStable; FRD 6.8 BR-SameID
  @TC_CP_137 @Functional @High @Automation
  Scenario: Verify the Document ID is unchanged after Check-in
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | Document | DOC-0011 |
    When the user notes the Document ID
    And the user checks in 'Locked_Plan_v2.pdf' with a note
    And the user checks the ID in the list
    Then Document ID remains DOC-0011; Latest Version becomes V2

  # Ref: US-9 AC-3; FRD 6.6.1 EmptyState
  @TC_CP_138 @Functional @High @Automation
  Scenario: Verify an empty folder shows 'No documents available' with an Upload Document CTA for users with upload permission
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Empty Folder' has no documents
    And the following test data is used
      | Folder | Empty Folder   |
      | User   | Uploader_User1 |
    When the user opens 'Empty Folder'
    Then An illustration and 'No documents available' are displayed
    And An Upload Document CTA is displayed

  # Ref: US-9 AC-4; FRD 6.6.1 BR-LockIcon
  @TC_CP_139 @Functional @High @Automation
  Scenario: Verify a checked-out document shows the Checked Out indicator with the lock holder
    Given DOC-0011 is checked out by Editor_User1
    And Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Document | DOC-0011     |
      | Holder   | Editor_User1 |
    When the user opens the folder containing DOC-0011
    Then A lock icon with 'Checked Out' and the holder name 'Editor_User1' is displayed

  # Ref: FRD 6.6.1 FB-Display; US-9 AC-1
  @TC_CP_140 @Functional @High @Automation
  Scenario: Verify the Document List shows only the documents of the selected folder and respects access
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Contracts' has documents and sub-folders
    And the following test data is used
      | Folders | Contracts, Drawings |
    When the user opens 'Contracts'
    And the user logs in as NoAccess_User1 and open a Private folder
    Then Only documents stored directly in the selected folder are listed
    And NoAccess_User1 sees no documents of the Private folder

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-9 AC-3; FRD 6.6.1 EmptyState
  @TC_CP_436 @Negative @Medium @Automation
  Scenario: Verify the empty state has no Upload Document CTA for users without upload permission
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Empty Folder' has no documents
    And the following test data is used
      | Folder | Empty Folder |
      | User   | Viewer_User1 |
    When the user opens 'Empty Folder'
    Then The illustration and 'No documents available' are displayed without the Upload Document CTA

  # Ref: US-9 AC-4; FRD 6.6.1 BR-LockIcon
  @TC_CP_437 @Negative @Medium @Automation
  Scenario: Verify the lock holder's name is not shown to a user without permission to see it
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. (no permission to view lock holder)
    And DOC-0011 is checked out
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens the folder containing DOC-0011
    Then The Checked Out indicator is displayed but the holder's name is not shown
