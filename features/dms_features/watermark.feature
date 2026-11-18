@DMS @Watermark
Feature: Watermark
  Automated scenarios for the "Watermark" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.8.4 FB-Previous; US-11 AC-3; FRD 6.8.4 Format
  @TC_CP_211 @Functional @High @Automation
  Scenario: Verify a Previous Version preview shows the watermark 'V{Version Number} – PREVIOUS'
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1-V3
    And the following test data is used
      | Versions | V3, V2, V1 |
    When the user previews V3 (Active)
    And the user previews V2
    And the user previews V1
    Then V3 shows no watermark
    And V2 shows 'V2 – PREVIOUS'
    And V1 shows 'V1 – PREVIOUS'

  # Ref: FRD 6.8.4 BR-NoDownload; US-11 AC-3
  @TC_CP_212 @Functional @High @Automation
  Scenario: Verify downloaded files (Original and With Annotations) contain no watermark
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 V2 (Previous) has a saved annotated copy
    And the following test data is used
      | Version | V2 |
    When the user downloads V2 Original
    And the user downloads V2 With Annotations
    And the user opens both files / extract text
    Then Neither file contains the 'V2 – PREVIOUS' watermark

  # Ref: FRD 6.8.4 BR-Overlay
  @TC_CP_213 @Functional @Medium @Automation
  Scenario: Verify the watermark is a preview overlay and the stored file is unchanged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 V2 is Previous
    And Stored file checksum is noted
    And the following test data is used
      | Version | V2 |
    When the user previews V2
    And the user re-computes the stored file checksum
    Then The checksum is unchanged; the watermark exists only in the preview

  # Ref: FRD 6.8.4 BR-NewCheckin
  @TC_CP_214 @Functional @High @Automation
  Scenario: Verify the earlier Active Version shows the watermark after a new check-in
    Given DOC-0011 V1 is Active and previewed without watermark
    And DOC-0011 is checked out by Admin_User1
    And the following test data is used
      | Document | DOC-0011 |
    When the user checks in V2
    And the user previews V1 from Version History
    Then V1 now shows 'V1 – PREVIOUS'; V2 shows none

  # Ref: FRD 6.8.4 BR-Formats
  @TC_CP_215 @Functional @Medium @Automation
  Scenario: Verify the watermark appears for each previewable format when a previous version is opened
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Documents with a previous version exist for each format
    And the following test data is used
      | Files | PDF  |
      | Data  | DOCX |
      | Data  | XLSX |
      | Data  | PPTX |
      | Data  | JPG  |
      | Data  | DWG  |
      | Data  | TXT  |
      | Data  | CSV  |
    When the user previews a previous version of each file
    And the user repeats for each value
    Then The 'V{n} – PREVIOUS' watermark is shown on every page for each format

  # Ref: FRD 6.8.4 BR-Persistent
  @TC_CP_216 @Functional @Medium @Automation
  Scenario: Verify the watermark remains visible while zooming, scrolling and searching and cannot be removed
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A Previous Version of DOC-0005 is open in preview
    And the following test data is used
      | Version | V2 |
    When the user zooms in and out
    And the user scrolls through the pages
    And the user uses Find
    And the user looks for a control to hide the watermark
    Then The watermark stays visible and scales proportionally; there is no option to hide it

  # Ref: FRD 6.8.4 Appearance-Occurrence
  @TC_CP_217 @Functional @Medium @Automation
  Scenario: Verify one watermark appears on every page of a multi-page previous version
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 V2 is a 5-page PDF
    And the following test data is used
      | Version | V2 (5 pages) |
    When the user previews V2 and scroll through all pages
    Then Exactly one watermark is displayed on each of the 5 pages
