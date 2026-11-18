@DMS @CheckOut
Feature: Check-out
  Automated scenarios for the "Check-out" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.8.1 FB-Checkout; US-11 AC-1; FRD Sec 8 T29; FRD 7.1 Act-CheckedOut
  @TC_CP_188 @Functional @High @Automation
  Scenario: Verify a document is checked out with a mandatory note, locked, and logged
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is not checked out
    And the following test data is used
      | Note | Updating inspection figures |
    When the user clicks kebab > Check-out Document
    And the user observes the pop-up
    And the user enters the note
    And the user clicks Check-out
    And the user opens the activity log
    Then Pop-up shows 'Checking out document: Site Inspection Report', the Check-out Note field, Cancel and Check-out
    And The document is locked; user, date-time and note are recorded
    And Toaster 'Document checked out successfully.' is displayed
    And Activity log has 'Document Checked Out' with user, time and note

  # Ref: FRD 6.8.1 FB-Indicator
  @TC_CP_189 @Functional @High @Automation
  Scenario: Verify the lock indicator with the user name is displayed after check-out
    Given DOC-0001 was just checked out by Editor_User1
    And the following test data is used
      | Document | DOC-0001     |
      | Holder   | Editor_User1 |
    When the user views the Document List
    Then A lock icon with 'Checked Out' and 'Editor_User1' is displayed for DOC-0001

  # Ref: FRD 6.8.1 FB-Source
  @TC_CP_190 @Functional @Medium @Automation
  Scenario: Verify Check-out can also be initiated from the Document Details screen
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is not checked out
    And the following test data is used
      | Note | Revision from details |
    When the user opens Document Details
    And the user clicks Check-out
    And the user enters a note and confirm
    Then The document is checked out exactly as through the kebab menu

  # Ref: FRD 6.8.1 FB-Cancel
  @TC_CP_191 @Functional @Medium @Automation
  Scenario: Verify Cancel on the Check-out pop-up does not check out the document
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Check-out pop-up is open with a note entered
    And the following test data is used
      | Note | Draft note |
    When the user clicks Cancel
    Then The pop-up closes, the note is discarded and the document is not checked out

  # Ref: FRD 6.8.1 F-Note; FRD 6.8.1 F-Checkout
  @TC_CP_192 @Functional @Medium @Automation
  Scenario: Verify Check-out is enabled only after a note is entered and notes of 1 and 250 characters are accepted
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Check-out pop-up is open
    And the following test data is used
      | Notes | R                  |
      | Data  | 250-character note |
    When the user observes Check-out with an empty note
    And the user enters a 1-character note and check out (use another document for the 250-character note)
    Then Check-out is disabled until a note is entered
    And Both notes are accepted and recorded

  # Ref: FRD 6.8.1 F-Note
  @TC_CP_193 @Functional @Medium @Automation
  Scenario: Verify the Check-out Note keeps line breaks and trims leading/trailing spaces
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Check-out pop-up is open
    And the following test data is used
      | Note | ' Line one' + Enter + 'Line two ' |
    When the user enters a two-line note with surrounding spaces
    And the user confirms
    And the user views the activity log
    Then The note is stored trimmed with its line break and shown in the activity log

  # Ref: FRD 6.8.1 FB-OthersView; FRD 6.8.1 State-AfterCheckout; FRD 6.8.1 BR-NoVersion
  @TC_CP_194 @Functional @High @Automation
  Scenario: Verify other users can view, preview, download, see history, compare and collaborate on a checked-out document
    Given DOC-0011 is checked out by Editor_User1
    And Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Document | DOC-0011 |
    When As Admin_User1 open DOC-0011: preview, download, Version History, Compare Versions (where available) and Collaborate
    And the user checks versions
    Then All listed actions are available
    And No new version was created by check-out

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.8.1 F-Note; US-11 AC-1
  @TC_CP_456 @Negative @High @Automation
  Scenario: Verify a blank Check-out Note is rejected
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Check-out pop-up is open
    And the following test data is used
      | Note | (blank) |
    When the user types and clear the note
    And the user tries to check out (and via API without note)
    Then 'Check-out Note is required.' is displayed; the document is not checked out

  # Ref: FRD 6.8.1 F-Note
  @TC_CP_457 @Negative @Medium @Automation
  Scenario: Verify a Check-out Note containing only spaces is treated as blank
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Check-out pop-up is open
    And the following test data is used
      | Note | ' ' |
    When the user enters spaces only and try to check out
    Then 'Check-out Note is required.' is displayed

  # Ref: FRD 6.8.1 F-Note
  @TC_CP_458 @Negative @Medium @Automation
  Scenario: Verify entry beyond 250 characters is not allowed in the Check-out Note
    Given Editor_User1 (View, Download, Upload, Edit Metadata, Check-out/Check-in) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Check-out pop-up is open
    And the following test data is used
      | Note | 'n' repeated 251 times |
    When the user pastes a 251-character note
    Then Input is limited to 250 characters; if an error is shown it reads 'Check-out Note cannot exceed 250 characters.' and the document is not checked out with more than 250 characters

  # Ref: FRD 6.8.1 BR-OneUser
  @TC_CP_459 @Negative @High @Automation
  Scenario: Verify a document already checked out cannot be checked out again
    Given DOC-0011 is checked out by Editor_User1
    And Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Document | DOC-0011 |
    When the user opens the kebab menu on DOC-0011 as Admin_User1
    And the user sends a check-out API request
    Then 'Check-out Document' is not displayed; the API request is rejected

  # Ref: FRD 6.8.1 BR-OneUser
  @TC_CP_460 @Negative @High @Automation
  Scenario: Verify only one user wins when two users check out the same document simultaneously
    Given DOC-0001 is not checked out
    And Admin_User1 and Editor_User1 submit check-out at the same time
    And the following test data is used
      | Users | Admin_User1, Editor_User1 |
    When the user submits two parallel check-out requests with different notes
    Then Exactly one check-out succeeds; the other is rejected; a single lock owner is recorded

  # Ref: FRD 6.8.1 BR-Perm
  @TC_CP_461 @Negative @High @Automation
  Scenario: Verify a user without Check-out permission cannot check out
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 exists
    And the following test data is used
      | User | Viewer_User1 |
      | Note | Test         |
    When the user opens the kebab menu
    And the user sends a check-out API request
    Then 'Check-out Document' is not displayed; API returns 403

  # Ref: FRD 6.8.1 BR-LockOthers
  @TC_CP_462 @Negative @High @Automation
  Scenario: Verify other users cannot edit metadata, annotate, share, move or delete a checked-out document
    Given DOC-0011 is checked out by Editor_User1
    And Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Document | DOC-0011 |
    When As Admin_User1 attempt each of: edit metadata, annotate, share via email, move, delete
    Then None of these actions is available or each is rejected (API 403/409)
