@DMS @ActivityLog
Feature: Activity Log
  Automated scenarios for the "Activity Log" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-14 AC-1; FRD 7.1 FB-Entry
  @TC_CP_282 @Functional @High @Automation
  Scenario: Verify each activity log entry has Document ID, user, system date-time, action, version and details
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has activity from upload to check-in
    And the following test data is used
      | Document | DOC-0005 |
    When the user opens View Activity Log on DOC-0005
    And the user reviews the columns and entries
    Then Columns Date & Time, User Name, Version Number, Action and Details are displayed
    And Every entry is associated with Document ID DOC-0005 and the system timestamp

  # Ref: US-14 AC-2; FRD 7.1 FB-Order
  @TC_CP_283 @Functional @High @Automation
  Scenario: Verify activities are displayed in reverse chronological order as read-only data
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has several activities
    And the following test data is used
      | Document | DOC-0005 |
    When the user opens View Activity Log
    And the user checks the order
    And the user tries to edit an entry
    Then The most recent activity is first
    And Entries cannot be edited

  # Ref: FRD 7.1 Act-Lifecycle; FRD 7.1 Act-Metadata
  @TC_CP_284 @Functional @High @Automation
  Scenario: Verify Document Uploaded, Document Moved, Document Copied and Metadata Edited events are logged with correct details
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A new document is uploaded, moved, copied and its metadata edited
    And the following test data is used
      | Document | Audit_Test_1.pdf |
    When the user performs each action
    And the user opens the activity log of the source document
    Then Entries 'Document Uploaded', 'Document Moved', 'Document Copied' and 'Metadata Edited' exist with user, system time and details

  # Ref: FRD 7.1 Act-Access
  @TC_CP_285 @Functional @High @Automation
  Scenario: Verify Access Mode Changed, Access Granted, Access Modified and Access Removed events are logged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A folder's access is changed, granted, modified and removed
    And the following test data is used
      | Folder | Archive |
    When the user performs each access change
    And the user opens the activity log of a document in that folder
    Then Entries 'Access Mode Changed', 'Access Granted', 'Access Modified' and 'Access Removed' are recorded

  # Ref: FRD 7.1 Act-Version
  @TC_CP_286 @Functional @High @Automation
  Scenario: Verify Document Checked Out, Document Checked In, Version Created and Version Downloaded events are logged with version
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A document is checked out, checked in and a version is downloaded
    And the following test data is used
      | Document | Audit_Test_2.pdf |
    When the user performs each action
    And the user opens the activity log
    Then Entries 'Document Checked Out' (with note), 'Document Checked In' (with note), 'Version Created' and 'Version Downloaded' exist with Version Number

  # Ref: FRD 7.1 Act-Usage
  @TC_CP_287 @Functional @High @Automation
  Scenario: Verify Document Previewed, Document Downloaded, Document Annotated, Annotation Modified and Annotation Removed events are logged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A document is previewed, downloaded, annotated, modified and annotations removed
    And the following test data is used
      | Document | Audit_Test_3.pdf |
    When the user performs each action
    And the user opens the activity log
    Then One entry is present for each usage action with user and time

  # Ref: FRD 7.1 Act-Collab; FRD 7.1 Act-Sharing
  @TC_CP_288 @Functional @High @Automation
  Scenario: Verify Comment Added, User Mentioned and Document Shared via Email events are logged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A comment with a mention is posted and the document is shared
    And the following test data is used
      | Document | Audit_Test_4.pdf |
    When the user performs each action
    And the user opens the activity log
    Then 'Comment Added', 'User Mentioned' and 'Document Shared via Email' entries exist

  # Ref: FRD 7.1 FB-OpenPerm
  @TC_CP_289 @Functional @High @Automation
  Scenario: Verify the View Activity Log action is available only to users with permission
    Given Auditor_User1 (View + View Activity Log) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. and Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. exist
    And the following test data is used
      | Users | Auditor_User1, Viewer_User1 |
    When the user opens the kebab menu as each user
    Then View Activity Log is shown to Auditor_User1 and not to Viewer_User1

  # Ref: FRD 7.1 FB-AllVersions
  @TC_CP_290 @Functional @Medium @Automation
  Scenario: Verify the activity log shows the activity of all versions from one place
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1-V3
    And the following test data is used
      | Document | DOC-0005 |
    When the user opens View Activity Log
    Then Activity for V1, V2 and V3 is present in a single log with the Version Number

  # Ref: FRD 7.1 FB-CheckedOut; FRD 6.6.2 Table-CheckedOut
  @TC_CP_291 @Functional @Medium @Automation
  Scenario: Verify View Activity Log remains available on a checked-out document
    Given DOC-0011 is checked out by Editor_User1
    And Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Document | DOC-0011 |
    When the user opens View Activity Log as Admin_User1
    Then The activity log opens

  # Ref: US-14 AC-3; FRD 7.2 DownloadLog
  @TC_CP_292 @Functional @High @Automation
  Scenario: Verify the Download Log distinguishes Original from With Annotations downloads
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 V3 has a saved annotated copy
    And the following test data is used
      | Document | DOC-0005 |
      | Version  | V3       |
    When the user downloads V3 Original and V3 With Annotations
    And the user opens the Download Log
    Then Two entries each with user, date, time, version and download type ('Original' and 'With Annotations')

  # Ref: FRD 6.6.6 BR-LogsRetained; FRD 7.1 FB-Retained
  @TC_CP_293 @Functional @Medium @Automation
  Scenario: Verify activity records remain associated with the document throughout its version lifecycle
    Given DOC-0005 has had metadata edits and 3 versions
    And the following test data is used
      | Document | DOC-0005 |
    When the user checks in a new version V4
    And the user opens the activity log
    Then All earlier entries remain and new entries are added for V4

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 7.1 FB-ReadOnly; US-14 AC-1
  @TC_CP_505 @Negative @High @Automation
  Scenario: Verify activity log entries cannot be edited or deleted by standard users through the API
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has activity entries
    And the following test data is used
      | Entry | latest entry of DOC-0005 |
    When the user sends update and delete requests for an activity entry
    Then Requests are rejected; the log is unchanged

  # Ref: FRD 7.1 FB-Timestamp
  @TC_CP_506 @Negative @High @Automation
  Scenario: Verify the activity timestamp is generated by the server and not by the client
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Client machine clock is set 2 hours ahead
    And the following test data is used
      | Client time offset | +2h |
    When the user edits metadata on DOC-0001
    And the user checks the log timestamp
    Then The entry carries the server system date and time
