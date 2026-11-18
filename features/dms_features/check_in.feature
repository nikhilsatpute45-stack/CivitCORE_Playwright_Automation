@DMS @CheckIn
Feature: Check-in
  Automated scenarios for the "Check-in" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.8.2 FB-Checkin; US-11 AC-2; FRD 6.8.2 BR-NewVersion; FRD Sec 8 T30; FRD 7.1 Act-CheckedIn
  @TC_CP_195 @Functional @High @Automation
  Scenario: Verify the checkout owner checks in a revised file creating the next Active version and releasing the lock
    Given DOC-0011 (V1 Active) is checked out by Editor_User1
    And Editor_User1 is logged in
    And Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Revised file | Locked_Plan_v2.pdf           |
      | Note         | Added revised column details |
    When the user clicks kebab > Check-in
    And the user observes the pop-up
    And the user uploads the revised file
    And the user enters the note
    And the user clicks Check-in
    And the user views Document List, Version History and activity log
    Then Pop-up shows 'Checking in document: Locked Plan', Upload Revised Document, Check-in Note, Cancel and Check-in
    And Version V2 is created and Active; V1 becomes Previous; Document ID unchanged
    And The lock is released
    And Toaster 'Document checked in successfully. Version V2 is now active.' is displayed (confirm {Version} format)
    And Activity log has 'Document Checked In' and 'Version Created'

  # Ref: FRD 6.8.2 BR-Metadata
  @TC_CP_196 @Functional @High @Automation
  Scenario: Verify check-in records the user, date-time, note, file type and file size against the new version
    Given DOC-0011 is checked out by Editor_User1
    And the following test data is used
      | File | Locked_Plan_v2.pdf (3 MB) |
    When the user checks in 'Locked_Plan_v2.pdf' (3 MB)
    And the user opens Version History for V2
    Then V2 shows Uploaded By Editor_User1, upload date and time, file type PDF, file size ~3 MB and the check-in note

  # Ref: FRD 6.8.2 BR-Notes
  @TC_CP_197 @Functional @High @Automation
  Scenario: Verify the Check-in Note is displayed in Version History and the Check-out Note is only in the activity log
    Given DOC-0011 was checked out with note 'Revise column widths' and checked in with note 'Columns widened'
    And the following test data is used
      | Check-out note | Revise column widths |
      | Check-in note  | Columns widened      |
    When the user opens Version History
    And the user opens the activity log
    Then Version History shows 'Columns widened' for V2 and does not show the check-out note
    And Activity log shows the check-out note with the check-out entry

  # Ref: FRD 6.8.2 FB-Admin; FRD 6.6.2 Table-CheckedOut
  @TC_CP_198 @Functional @High @Automation
  Scenario: Verify an authorized administrator can check in a document checked out by another user
    Given DOC-0011 is checked out by Editor_User1
    And DocAdmin_User1 (authorized administrator) is logged in
    And the following test data is used
      | File | Admin_Revision.pdf      |
      | Note | Admin override check-in |
    When the user opens the kebab menu on DOC-0011
    And the user checks in a revised file with a note
    Then Check-in is available to DocAdmin_User1 and the new version is created; the lock is released

  # Ref: FRD 6.8.2 FB-Cancel
  @TC_CP_199 @Functional @Medium @Automation
  Scenario: Verify Cancel on the Check-in pop-up discards the file and keeps the document checked out
    Given DOC-0011 is checked out by Editor_User1
    And the following test data is used
      | File | Cancelled_Rev.pdf |
    When the user opens Check-in, upload a file, enter a note and click Cancel
    Then The pop-up closes, the file and note are discarded and the document remains checked out

  # Ref: FRD 6.8.2 F-Upload; FRD 6.8.2 F-CheckinCTA
  @TC_CP_200 @Functional @Medium @Automation
  Scenario: Verify the selected file can be removed and replaced and Check-in is enabled only with file and note
    Given DOC-0011 is checked out by Editor_User1
    And the following test data is used
      | Files | A.pdf, B.pdf |
      | Note  | Replace test |
    When the user observes Check-in with no file/note
    And the user uploads 'A.pdf'
    And the user removes it and upload 'B.pdf'
    And the user enters a note
    Then Check-in is disabled until both file and note exist
    And 'B.pdf' is the file stored as the new version

  # Ref: FRD 6.8.2 F-Upload
  @TC_CP_201 @Functional @Medium @Automation
  Scenario: Verify the revised file can be added by drag-and-drop in the Check-in pop-up
    Given DOC-0011 is checked out by Editor_User1
    And the following test data is used
      | File | Revision_DnD.pdf |
    When the user drags 'Revision_DnD.pdf' into the Upload Revised Document area
    Then The file is accepted in the upload field

  # Ref: FRD 6.8.2 BR-Annotations
  @TC_CP_203 @Functional @High @Automation
  Scenario: Verify preview after check-in shows the new version without the previous annotations
    Given DOC-0001 (V1) has saved annotations and is checked out by Admin_User1
    And the following test data is used
      | Document | DOC-0001 |
    When the user checks in a revised file
    And the user opens the document preview
    Then The preview shows Active V2 without annotations; V1's annotations remain with V1 in Version History

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.8.2 BR-Perm; FRD 6.6.2 BR-CheckinOwner
  @TC_CP_463 @Negative @High @Automation
  Scenario: Verify a user who is neither the owner nor an authorized administrator cannot check in
    Given DOC-0011 is checked out by Editor_User1
    And Viewer_User1 has View access
    And the following test data is used
      | User | Viewer_User1 |
      | File | Hack.pdf     |
      | Note | Test         |
    When the user opens the kebab menu as Viewer_User1
    And the user sends a check-in API request with this user's token
    Then Check-in is not displayed; API returns 403 and no version is created

  # Ref: FRD 6.8.2 BR-OnlyIfCheckedOut
  @TC_CP_464 @Negative @High @Automation
  Scenario: Verify Check-in is not available for a document that is not checked out
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is not checked out
    And the following test data is used
      | Document | DOC-0001 |
    When the user opens the kebab menu
    And the user sends a check-in API request
    Then 'Check-in Document' is not displayed; the API request is rejected

  # Ref: FRD 6.8.2 F-Upload; FRD 6.8.2 BR-FailNoVersion
  @TC_CP_465 @Negative @High @Automation
  Scenario: Verify check-in without a revised file is rejected
    Given DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | Note | No file attached |
    When the user enters a note and attempt to check in without a file
    Then 'Please upload the revised document.' is displayed; no version is created and the document stays checked out

  # Ref: FRD 6.8.2 F-Upload; FRD 6.8.2 BR-FailNoVersion
  @TC_CP_466 @Negative @High @Automation
  Scenario: Verify an unsupported revised file is rejected on check-in
    Given DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | File | Revision.exe |
      | Note | Bad format   |
    When the user uploads 'Revision.exe' with a note and click Check-in
    Then 'This file format is not supported.' is displayed; no version is created; the document stays checked out

  # Ref: FRD 6.8.2 F-Note; US-11 AC-2
  @TC_CP_467 @Negative @High @Automation
  Scenario: Verify a blank Check-in Note is rejected
    Given DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | File | Revision.pdf |
      | Note | (blank)      |
    When the user uploads a valid file and leave the note blank
    Then 'Check-in Note is required.' is displayed; check-in is blocked; the document stays checked out

  # Ref: FRD 6.8.2 F-Note
  @TC_CP_468 @Negative @Medium @Automation
  Scenario: Verify a Check-in Note containing only spaces is treated as blank
    Given DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | Note | ' ' |
    When the user uploads a valid file and enter spaces only
    Then 'Check-in Note is required.' is displayed

  # Ref: FRD 6.8.2 F-Note
  @TC_CP_469 @Negative @Medium @Automation
  Scenario: Verify a Check-in Note over 250 characters is not allowed and 250 is accepted
    Given DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | Notes | 'c' repeated 251 times |
      | Data  | 250 characters         |
    When the user pastes a 251-character note
    And Then use a 250-character note and check in
    Then Entry beyond 250 is not allowed (error 'Check-in Note cannot exceed 250 characters.' if shown)
    And The 250-character note is accepted

  # Ref: FRD 6.8.2 BR-OneFile
  @TC_CP_470 @Negative @Medium @Automation
  Scenario: Verify only one file can be uploaded per check-in
    Given DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | Files | A.pdf, B.pdf |
    When the user attempts to attach two files to the Check-in pop-up via UI/API
    Then Only one file is accepted; two versions are not created from one check-in
