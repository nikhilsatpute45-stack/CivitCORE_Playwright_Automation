@DMS @DocumentActions
Feature: Document Actions
  Automated scenarios for the "Document Actions" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-9 AC-2; FRD 6.6.2 Table-NotCheckedOut
  @TC_CP_141 @Functional @High @Automation
  Scenario: Verify the kebab menu of a non-checked-out document shows all authorized actions for an administrator
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is not checked out
    And the following test data is used
      | Document | DOC-0001 |
    When the user opens the kebab menu on DOC-0001
    Then Menu shows: Edit Document, Check-out Document, Collaborate / Chat, Share via Email, Move to Folder, Copy to Folder, Download Active Version, View Version History, View Activity Log, Delete Document

  # Ref: FRD 6.6.2 Table-CheckedOut
  @TC_CP_142 @Functional @High @Automation
  Scenario: Verify the kebab menu for the checkout owner on a checked-out document
    Given DOC-0011 is checked out by Editor_User1
    And Editor_User1 is logged in
    And the following test data is used
      | Owner | Editor_User1 |
    When the user opens the kebab menu on DOC-0011
    Then Check-in, Collaborate, Copy to Folder, Download Active Version, View Version History and View Activity Log are shown
    And Check-out, Share via Email, Move to Folder and Delete Document are not shown

  # Ref: FRD 6.6.2 Table-CheckedOut; FRD 6.6.2 BR-CheckedOutOthers
  @TC_CP_143 @Functional @High @Automation
  Scenario: Verify the kebab menu for other users on a checked-out document
    Given DOC-0011 is checked out by Editor_User1
    And Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. (not the owner)
    And the following test data is used
      | User | Admin_User1 (non-owner) |
    When the user opens the kebab menu on DOC-0011 as Admin_User1 acting as non-administrator for this action
    Then Check-in is not shown (unless authorized administrator)
    And Check-out, Share via Email, Move to Folder and Delete Document are not shown
    And Collaborate, Copy, Download, Version History, Activity Log are shown

  # Ref: FRD 6.6.2 BR-Revert
  @TC_CP_144 @Functional @Medium @Automation
  Scenario: Verify the kebab menu reverts to the not-checked-out actions after Check-in
    Given DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | Document | DOC-0011 |
    When the user checks in the document
    And the user opens the kebab menu
    Then Check-out, Share via Email, Move to Folder and Delete Document are available again; Check-in is not shown

  # Ref: FRD 6.6.2 BR-Auth
  @TC_CP_145 @Functional @High @Automation
  Scenario: Verify a view-only user sees only the actions they are authorized for
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 exists
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens the kebab menu on DOC-0001
    Then Edit, Check-out, Share, Move, Copy, Download and Delete are not displayed

  # Ref: US-9 AC-5
  @TC_CP_146 @Functional @Medium @Automation
  Scenario: Verify Manage Access is not available as a document-specific action
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 exists
    And the following test data is used
      | Document | DOC-0001 |
    When the user opens the kebab menu on DOC-0001
    Then No 'Manage Access' action exists at document level (access is managed at folder level only)
