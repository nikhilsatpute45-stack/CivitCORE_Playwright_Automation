@DMS @DocumentAnnotation
Feature: Document Annotation
  Automated scenarios for the "Document Annotation" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-8 AC-1; FRD 6.5.3 FB-Annotate; FRD 6.5.3 Table-Applicable
  @TC_CP_119 @Functional @High @Automation
  Scenario: Verify the Annotate option is shown for applicable formats
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Documents of each applicable format exist
    And the following test data is used
      | Files | a.pdf  |
      | Data  | a.docx |
      | Data  | a.xlsx |
      | Data  | a.pptx |
      | Data  | a.dwg  |
      | Data  | a.jpg  |
    When the user opens each document in preview
    And the user repeats for each value
    Then The Annotate option is displayed for each file

  # Ref: FRD 6.5.3 FB-Log
  @TC_CP_121 @Functional @High @Automation
  Scenario: Verify multiple annotations are listed in the annotation log with type and page number
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is open in Annotate mode
    And the following test data is used
      | Annotations | Rectangle p.1, Text p.2 |
    When the user adds a Rectangle on page 1 and a Text on page 2
    Then Two entries appear in the annotation log showing type and page number

  # Ref: FRD 6.5.3 FB-Erase
  @TC_CP_122 @Functional @High @Automation
  Scenario: Verify erasing an annotation in the preview removes it from the annotation log
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 has two annotations (one saved, one new)
    And the following test data is used
      | Annotation | Rectangle p.1 (saved) |
    When the user erases the saved annotation in the preview
    Then The annotation is removed from the preview and from the annotation log

  # Ref: FRD 6.5.3 BR-LogSync
  @TC_CP_123 @Functional @High @Automation
  Scenario: Verify removing an annotation from the annotation log removes it from the preview
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 has one annotation
    And the following test data is used
      | Annotation | Text p.2 |
    When the user removes the entry from the annotation log
    Then The annotation disappears from the document preview

  # Ref: US-8 AC-2; FRD 6.5.3 FB-Save; FRD 7.1 Act-Annotated
  @TC_CP_124 @Functional @High @Automation
  Scenario: Verify saving creates a separate annotated PDF, leaves the original unchanged and is logged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 original checksum is noted
    And the following test data is used
      | Document | DOC-0001 |
    When the user adds annotations
    And the user clicks Save
    And the user re-computes the checksum of the original file
    And the user opens the activity log
    Then A separate annotated PDF is saved; the original file checksum is unchanged
    And The activity log has 'Document Annotated'

  # Ref: FRD 6.5.3 BR-SaveOnly
  @TC_CP_125 @Functional @High @Automation
  Scenario: Verify unsaved annotations are discarded when the preview is closed
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 is in Annotate mode with a new annotation not saved
    And the following test data is used
      | Annotation | Arrow p.1 (unsaved) |
    When the user closes the preview without saving
    And the user re-opens the document
    Then The unsaved annotation is not present after reopening

  # Ref: FRD 6.5.3 FB-ShowSaved
  @TC_CP_126 @Functional @High @Automation
  Scenario: Verify previously saved annotations are displayed when the document is reopened
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 has saved annotations
    And the following test data is used
      | Document | DOC-0001 |
    When the user opens DOC-0001 in preview
    Then Preview displays the saved annotations and the annotation log lists them with type and page

  # Ref: FRD 6.5.3 BR-SingleCopy; FRD 7.1 Act-AnnotationModified
  @TC_CP_127 @Functional @Medium @Automation
  Scenario: Verify changes to saved annotations update the same annotated copy and are logged
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 has one saved annotation
    And the following test data is used
      | Add    | Circle p.1    |
      | Remove | Rectangle p.1 |
    When the user adds a new annotation and remove the saved one
    And the user clicks Save
    And the user checks the annotated copy and activity log
    Then Only one annotated copy exists for the Active Version containing the latest annotations
    And Activity log records 'Annotation Modified' and 'Annotation Removed'

  # Ref: FRD 6.5.3 BR-VersionSpecific
  @TC_CP_128 @Functional @High @Automation
  Scenario: Verify a new version after check-in shows no annotations while the previous version keeps its annotated copy
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 (V1) has saved annotations and is checked out by Admin_User1
    And the following test data is used
      | Document     | DOC-0001          |
      | Revised file | Inspection_v2.pdf |
    When the user checks in a revised file
    And the user opens DOC-0001 preview
    And the user opens Version History and preview V1
    Then V2 preview shows no annotations
    And V1 keeps its annotated copy in Version History

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.5.3 BR-NotApplicable
  @TC_CP_430 @Negative @High @Automation
  Scenario: Verify the Annotate option is not displayed for TXT, CSV, IFC, RVT and ZIP
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Documents of each non-applicable format exist
    And the following test data is used
      | Files | a.txt |
      | Data  | a.csv |
      | Data  | a.ifc |
      | Data  | a.rvt |
      | Data  | a.zip |
    When the user opens each document
    And the user repeats for each value
    Then The Annotate option is not displayed for any of these files

  # Ref: FRD 6.5.3 BR-ActiveOnly
  @TC_CP_431 @Negative @High @Automation
  Scenario: Verify annotations cannot be added or removed on a previous version
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1-V3 with V2 annotated
    And the following test data is used
      | Document | DOC-0005 |
      | Version  | V2       |
    When the user opens Version History > Preview V2
    Then Preview is view-only; the Annotate option is not available; saved annotations cannot be added, edited or removed

  # Ref: FRD 6.8.1 BR-LockAnnotation; FRD 6.8.1 State-AfterCheckout
  @TC_CP_432 @Negative @High @Automation
  Scenario: Verify another user cannot annotate a checked-out document
    Given DOC-0011 is checked out by Editor_User1
    And Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Document | DOC-0011 |
    When As Admin_User1 open DOC-0011 preview
    Then The Annotate option is not available to the non-owner while the document is checked out

  # Ref: FRD 6.5.3 BR-Perm
  @TC_CP_433 @Negative @Medium @Automation
  Scenario: Verify a user without annotate rights cannot annotate (assumption: Viewer_User1 is not authorized)
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 (PDF) exists
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens DOC-0001 preview
    And the user sends a save-annotation API request
    Then Annotate is not offered; API request is rejected and no annotated copy is created
