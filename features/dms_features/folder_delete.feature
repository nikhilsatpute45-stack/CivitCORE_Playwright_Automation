@DMS @FolderDelete
Feature: Folder Delete
  Automated scenarios for the "Folder Delete" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.8 FB-DeleteEmpty; FRD 6.1.8 BR-EmptyDirect; FRD Sec 8 T8; US-2 AC-5
  @TC_CP_044 @Functional @High @Automation
  Scenario: Verify an empty folder is deleted directly without an impact summary
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Empty Folder' has no documents, sub-folders or linked content
    And the following test data is used
      | Folder | Empty Folder |
    When the user clicks kebab > Delete on 'Empty Folder'
    Then Folder is deleted directly with no impact summary
    And Toaster 'Folder deleted successfully.' is displayed

  # Ref: FRD 6.1.8 FB-ConfirmPopup; US-2 AC-5; FRD 6.1.8 BR-Confirm
  @TC_CP_045 @Functional @High @Automation
  Scenario: Verify deleting a non-empty folder shows the impact and confirmation pop-up with folder name, Cancel and Delete
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' contains documents
    And the following test data is used
      | Folder | Reports |
    When the user clicks kebab > Delete on 'Reports'
    And the user observes the impact and the pop-up
    Then The impact of the deletion is displayed
    And Pop-up shows a warning message, the folder name 'Reports', and Cancel and Delete CTAs

  # Ref: FRD 6.1.8 FB-DeleteConfirm
  @TC_CP_046 @Functional @High @Automation
  Scenario: Verify the non-empty folder is deleted per the configured policy only after Delete is confirmed
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Contracts' contains sub-folders and documents
    And the following test data is used
      | Folder | Contracts |
    When the user clicks kebab > Delete on 'Contracts'
    And the user clicks Delete in the pop-up
    Then The folder is deleted per the configured deletion policy
    And Toaster 'Folder deleted successfully.' is displayed

  # Ref: FRD 6.1.8 FB-Cancel
  @TC_CP_047 @Functional @High @Automation
  Scenario: Verify Cancel on the Delete Folder pop-up keeps the folder
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' contains documents
    And the following test data is used
      | Folder | Reports |
    When the user clicks kebab > Delete on 'Reports'
    And the user clicks Cancel
    Then The pop-up closes and the folder and its contents are not deleted

  # Ref: FRD 6.1.8 BR-Confirm
  @TC_CP_048 @Functional @High @Automation
  Scenario: Verify a folder containing only sub-folders is treated as non-empty and requires confirmation
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'QC' contains only sub-folder 'QC-1' (no documents)
    And the following test data is used
      | Folder | QC |
    When the user clicks kebab > Delete on 'QC'
    Then Impact and confirmation pop-up are displayed (not deleted directly)

  # Ref: FRD 6.1.8 FB-Linked
  @TC_CP_049 @Functional @Medium @Automation
  Scenario: Verify a folder with linked/associated content is deleted only after the impact is confirmed
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A folder 'Linked Docs' holds a document associated with a business entity (e.g., Tender TND-001)
    And the following test data is used
      | Folder      | Linked Docs |
      | Association | TND-001     |
    When the user clicks kebab > Delete on 'Linked Docs'
    Then The impact including the linked content is displayed and deletion needs confirmation

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.8 BR-NoSilentDelete
  @TC_CP_386 @Negative @High @Automation
  Scenario: Verify a non-empty folder cannot be deleted through API without the confirmation step
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' contains documents
    And the following test data is used
      | Folder       | Reports      |
      | Confirmation | not supplied |
    When the user sends a delete request for 'Reports' without the confirmation flag
    And the user checks the folder
    Then Request is rejected (or requires confirmation) and the folder is not deleted. (Assumption: confirmation is enforced server-side.)

  # Ref: FRD 6.1.8 Perm
  @TC_CP_387 @Negative @Medium @Automation
  Scenario: Verify a user without delete permission cannot delete a folder
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens the kebab menu on 'Empty Folder'
    And the user sends a delete API request with this user's token
    Then 'Delete' is not shown
    And API returns 403 and the folder remains
