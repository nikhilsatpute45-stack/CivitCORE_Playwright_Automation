@DMS @ShareViaEmail
Feature: Share via Email
  Automated scenarios for the "Share via Email" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.10.1 FB-Share; US-13 AC-1; FRD Sec 8 T38; FRD 7.1 Act-Shared
  @TC_CP_271 @Functional @High @Automation
  Scenario: Verify a document is shared by email with a secure link, a prefilled subject and the activity logged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is not checked out
    And User 'Editor_User1' exists
    And the following test data is used
      | Recipients | Editor_User1, ext.vendor@example.com |
      | Message    | Please review                        |
    When the user clicks kebab > Share via Email
    And the user observes the window
    And the user adds recipients
    And the user clicks Send
    And the user checks the received email and the activity log
    Then The window shows document name and version, a secure link in the body and the subject prefilled with the document name
    And Toaster 'Document shared successfully.' is displayed
    And The email contains the link to the Active Version and no attachment
    And Activity log records sender, recipients, document, version, date-time

  # Ref: FRD 6.10.1 FB-Subject; FRD 6.10.1 Recipients
  @TC_CP_272 @Functional @Medium @Automation
  Scenario: Verify the subject can be modified, the message is optional and multiple recipients can be added
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Share via Email window is open
    And the following test data is used
      | Subject    | DOC-0001 for review                          |
      | Recipients | Editor_User1, Auditor_User1, a.b@example.com |
    When the user changes the subject
    And the user sends with no message and three recipients
    Then The email is sent to all valid recipients with the modified subject and no message

  # Ref: FRD 6.10.1 BR-ExternalReadOnly; FRD 6.10.1 BR-NoGrant
  @TC_CP_273 @Functional @High @Automation
  Scenario: Verify an external recipient can only view the shared document in read-only preview and gets no other access
    Given The share email to ext.vendor@example.com was received
    And the following test data is used
      | Link | secure link for DOC-0001 |
    When the user opens the secure link
    And the user tries to navigate to the folder or another document ID via URL
    Then The document opens in read-only preview
    And No other document or folder is accessible; no folder access is granted

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.10.1 BR-NoAccessRecipient
  @TC_CP_495 @Negative @High @Automation
  Scenario: Verify a CivitCORE user without access does not receive the email and the message is shown
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And NoAccess_User1 (display name 'NoAccess User1') has no access to DOC-0003
    And DOC-0003 is in 'Drawings'
    And the following test data is used
      | Recipients | NoAccess User1, SiteEng_User1 |
    When the user shares DOC-0003 to 'NoAccess User1' and 'SiteEng_User1' (has access)
    Then Message 'NoAccess User1 does not have access to this document.' is displayed
    And The email is not sent to NoAccess User1; valid recipients still receive it

  # Ref: FRD 6.10.1 BR-OneRecipient; FRD 6.10.1 BR-EmailFormat
  @TC_CP_496 @Negative @High @Automation
  Scenario: Verify sending is blocked with no recipient or an invalid email ID
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Share via Email window is open
    And the following test data is used
      | Recipients | (none)          |
      | Invalid    | vendor@@example |
    When the user clicks Send with no recipients
    And the user enters an invalid email and click Send
    Then The email is not sent in either case and a validation message is shown (text not specified in FRD)

  # Ref: FRD 6.8.1 BR-LockOthers; FRD 6.6.2 Table-CheckedOut
  @TC_CP_497 @Negative @High @Automation
  Scenario: Verify Share via Email is not available while the document is checked out
    Given DOC-0011 is checked out by Editor_User1
    And the following test data is used
      | Document | DOC-0011 |
    When the user opens the kebab menu
    And the user sends a share API request
    Then 'Share via Email' is not displayed; the API request is rejected

  # Ref: FRD 6.10.1 BR-OnlyAccess
  @TC_CP_498 @Negative @High @Automation
  Scenario: Verify a user without document access cannot share it
    Given NoAccess_User1 has no access to DOC-0003
    And the following test data is used
      | User      | NoAccess_User1         |
      | Recipient | ext.vendor@example.com |
    When the user sends a share API request for DOC-0003
    Then API returns 403; no email is sent

  # Ref: FRD 6.10.1 BR-LinkScope
  @TC_CP_499 @Negative @Medium @Automation
  Scenario: Verify altering the secure link to another document ID is denied
    Given An external secure link for DOC-0001 exists
    And the following test data is used
      | Link | tampered |
    When the user replaces the document identifier in the link with DOC-0003
    Then Access is denied; no content of DOC-0003 is returned
