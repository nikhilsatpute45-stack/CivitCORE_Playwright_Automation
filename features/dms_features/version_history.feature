@DMS @VersionHistory
Feature: Version History
  Automated scenarios for the "Version History" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.8.3 FB-Open; US-11 AC-3; FRD 6.8.3 F-Fields
  @TC_CP_204 @Functional @High @Automation
  Scenario: Verify Version History lists all versions latest first with the Active version and all details
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1 (note '-'), V2 ('Updated Q2 figures'), V3 ('Added summary table')
    And the following test data is used
      | Document | DOC-0005 |
    When the user clicks kebab > View Version History on DOC-0005
    And the user reviews the list
    Then V3, V2, V1 are listed in that order; V3 is marked Active
    And Each row shows Version Number, Version Status, Check-in Note, File Type, File Size, Uploaded By, Upload Date, Upload Time with Preview and Download
    And V1 note displays '-'

  # Ref: FRD 6.8.3 BR-ReadOnly
  @TC_CP_205 @Functional @Medium @Automation
  Scenario: Verify version details cannot be edited from Version History
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Version History of DOC-0005 is open
    And the following test data is used
      | Document | DOC-0005 |
    When the user tries to edit the note or status
    And the user sends an update request via API
    Then No edit control exists and API updates are rejected

  # Ref: FRD 6.8.3 BR-CheckedOutView
  @TC_CP_206 @Functional @High @Automation
  Scenario: Verify Version History remains available while checked out and shows only existing versions
    Given DOC-0011 (V1) is checked out by Editor_User1
    And the following test data is used
      | Document | DOC-0011 |
    When the user opens Version History as Admin_User1
    Then Version History opens showing V1 only; the next version appears only after a successful check-in

  # Ref: FRD 6.8.3 FB-Preview; FRD 6.8.3 BR-AnnotatedCopy
  @TC_CP_207 @Functional @High @Automation
  Scenario: Verify a version opens in view-only preview showing its annotated copy where saved
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005: V2 has a saved annotated copy; V1 has none
    And the following test data is used
      | Versions | V2, V1 |
    When the user clicks Preview on V2
    And the user clicks Preview on V1
    Then V2 preview shows its annotations; V1 preview shows the original file
    And Both are view-only with no Annotate option

  # Ref: FRD 6.8.3 FB-Download; FRD 6.8.3 BR-DownloadSpecific; FRD 6.8.3 Msg-VersionDL; FRD 7.1 Act-VersionDownloaded
  @TC_CP_208 @Functional @High @Automation
  Scenario: Verify Download of a specific version downloads that version (not the Active) with the toaster
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 V3 is Active
    And the following test data is used
      | Version | V1       |
      | Option  | Original |
    When the user clicks Download > Original on V1
    And the user compares content with V1 and V3
    Then V1's original file is downloaded
    And Toaster 'Version downloaded successfully.' is displayed
    And 'Version Downloaded' is recorded in the activity log and a Download Log entry for V1

  # Ref: FRD 6.8.3 F-Download; FRD Sec 8 T28
  @TC_CP_209 @Functional @High @Automation
  Scenario: Verify the With Annotations option is displayed only where an annotated copy exists and downloads a PDF
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005: V2 has a saved annotated copy; V1 has none
    And the following test data is used
      | Versions | V2, V1 |
    When the user opens the Download dropdown on V2
    And the user chooses With Annotations
    And the user opens the dropdown on V1
    Then V2 offers Original and With Annotations; the With Annotations file is a PDF and toaster 'Document with annotations downloaded successfully.' is displayed
    And V1 offers only Original

  # Ref: FRD 6.8.3 BR-DownloadLog; US-14 AC-3
  @TC_CP_210 @Functional @High @Automation
  Scenario: Verify downloads of different versions create separate Download Log entries
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1-V3
    And the following test data is used
      | Versions | V1, V3 |
    When the user downloads V1 and V3
    And the user opens the Download Log
    Then Two separate entries with the respective version, user, date, time and download type

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.8.3 BR-Perm
  @TC_CP_471 @Negative @High @Automation
  Scenario: Verify Preview and Download actions are shown according to the user's permissions
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. (View only) DOC-0005 exists
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens Version History as Viewer_User1
    Then Preview is displayed; Download is not displayed
