@DMS @CollaborationDiscussion
Feature: Collaboration - Discussion
  Automated scenarios for the "Collaboration - Discussion" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.10.2 FB-Collaborate; US-13 AC-2
  @TC_CP_274 @Functional @High @Automation
  Scenario: Verify Collaborate opens the Active Version with a Version dropdown listing all versions
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1-V3
    And the following test data is used
      | Document | DOC-0005 |
    When the user clicks kebab > Collaborate on DOC-0005
    Then The window shows the Active Version V3 preview and its discussion
    And The Version dropdown lists V1-V3 with V3 selected by default

  # Ref: FRD 6.10.2 FB-VersionSwitch; FRD 6.8.4 BR-Previous
  @TC_CP_275 @Functional @High @Automation
  Scenario: Verify selecting another version updates the preview, header and discussion history with the watermark
    Given DOC-0005 V2 has a comment 'Check Q2 totals'
    And the following test data is used
      | Version | V2 |
    When the user chooses V2 in the Version dropdown
    Then Preview, discussion header and history switch to V2 (comment visible)
    And The preview shows the 'V2 – PREVIOUS' watermark

  # Ref: FRD 6.10.2 FB-Post; FRD 6.10.2 Msg-Comment; US-13 AC-3; FRD 7.1 Act-CommentAdded
  @TC_CP_276 @Functional @High @Automation
  Scenario: Verify a comment is posted against the selected version with user and time, and logged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Collaborate window for DOC-0005 is open on V3
    And the following test data is used
      | Comment | Please confirm the revised totals. |
    When the user enters a comment
    And the user clicks Post
    And the user checks the activity log
    Then Toaster 'Comment posted successfully.' is displayed
    And The comment is stored against Document ID and V3 with user name and date-time
    And Activity log has 'Comment Added'

  # Ref: FRD 6.10.2 FB-Mention; US-13 AC-3; FRD 7.1 Act-Mentioned
  @TC_CP_277 @Functional @High @Automation
  Scenario: Verify @mention lists only users with access, notifies the mentioned user and logs the mention
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Editor_User1 has access to DOC-0005; NoAccess_User1 does not
    And the following test data is used
      | Mention | @Editor_User1 |
    When the user types '@' and search 'User1' in the comment box
    And the user selects Editor_User1
    And the user posts
    And the user checks Editor_User1's notification and the activity log
    Then Only users with access are listed (NoAccess_User1 is absent)
    And Editor_User1 is notified
    And 'User Mentioned' is recorded; the mention does not grant access

  # Ref: FRD 6.10.2 FB-Reply
  @TC_CP_278 @Functional @High @Automation
  Scenario: Verify a reply is associated with the same version and the history is chronological
    Given DOC-0005 V3 has a comment by Admin_User1
    And the following test data is used
      | Reply | Totals confirmed. |
    When the user replies as Editor_User1
    And the user switches the version dropdown to V2 and back
    Then The reply appears under the comment in V3 with user and time; history is chronological
    And The reply is not shown in V2

  # Ref: FRD 6.10.2 BR-NewVersion; US-13 AC-4
  @TC_CP_279 @Functional @High @Automation
  Scenario: Verify after check-in the new version starts with an empty discussion and the previous version keeps its comments
    Given DOC-0011 V1 has 2 comments
    And DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | Document | DOC-0011 |
    When the user checks in V2
    And the user opens Collaborate
    And the user switches to V1
    Then V2 shows 'No comments yet.'
    And V1 still shows its 2 comments (not copied to V2)

  # Ref: FRD 6.10.2 BR-CheckedOut; FRD 6.6.2 Table-CheckedOut
  @TC_CP_280 @Functional @Medium @Automation
  Scenario: Verify Collaborate remains available on a checked-out document for all users
    Given DOC-0011 is checked out by Editor_User1
    And Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Comment | Awaiting your check-in |
    When the user opens Collaborate on DOC-0011 as Admin_User1 and post a comment
    Then Collaboration works normally during check-out

  # Ref: FRD 6.10.2 F-Comment; FRD 6.10.2 F-Post
  @TC_CP_281 @Functional @Medium @Automation
  Scenario: Verify a comment of exactly 1000 characters is accepted and Post is enabled only when text is entered
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Collaborate window is open
    And the following test data is used
      | Comment | 'c' repeated 1000 |
    When the user observes Post with an empty comment
    And the user enters a 1000-character comment
    And the user posts
    Then Post is disabled until text is entered
    And The comment is posted in full

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.10.2 F-Comment
  @TC_CP_500 @Negative @High @Automation
  Scenario: Verify a blank comment cannot be posted
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Collaborate window is open
    And the following test data is used
      | Comment | (blank) |
    When the user leaves the comment empty
    And the user attempts to post
    Then 'Please enter a comment.' is displayed where validation is triggered; nothing is posted

  # Ref: FRD 6.10.2 F-Comment
  @TC_CP_501 @Negative @Medium @Automation
  Scenario: Verify a comment over 1000 characters is not allowed
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Collaborate window is open
    And the following test data is used
      | Comment | 'c' repeated 1001 |
    When the user pastes a 1001-character comment
    Then Input is limited to 1000 characters

  # Ref: FRD 6.10.2 BR-NoEdit
  @TC_CP_502 @Negative @High @Automation
  Scenario: Verify posted comments and replies cannot be edited or deleted
    Given DOC-0005 V3 has a comment posted by Admin_User1
    And the following test data is used
      | Comment | Please confirm the revised totals. |
    When the user looks for edit/delete controls on the comment
    And the user sends an edit and a delete API request
    Then No edit/delete controls exist and the API requests are rejected

  # Ref: FRD 6.10.2 BR-AccessOnly; FRD 6.10.2 BR-LostAccess
  @TC_CP_503 @Negative @High @Automation
  Scenario: Verify a user without access, or who loses folder access, cannot view or post in the discussion
    Given NoAccess_User1 has no access to DOC-0003
    And Editor_User1 had access to DOC-0005 and was then removed from the folder
    And the following test data is used
      | Users | NoAccess_User1, Editor_User1 |
    When the user opens the discussion of DOC-0003 as NoAccess_User1
    And the user opens and post to DOC-0005's discussion as Editor_User1
    Then Both are denied (403); they can neither view nor post comments

  # Ref: FRD 6.10.2 BR-MentionNoAccess
  @TC_CP_504 @Negative @Medium @Automation
  Scenario: Verify a user without access cannot be mentioned and mentioning does not grant access
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And NoAccess_User1 has no access to DOC-0005
    And the following test data is used
      | Mention | @NoAccess_User1 |
    When the user sends a post-comment API request that mentions NoAccess_User1
    Then The mention is rejected or ignored and NoAccess_User1 gains no access or notification
