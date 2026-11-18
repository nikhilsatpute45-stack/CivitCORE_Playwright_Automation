@DMS @CompareVersions
Feature: Compare Versions
  Automated scenarios for the "Compare Versions" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.8.5 BR-Min2
  @TC_CP_218 @Functional @Medium @Automation
  Scenario: Verify Compare Versions is disabled for a document with a single version and enabled with two or more
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 (V1 only) and DOC-0005 (V1-V3) exist
    And the following test data is used
      | Documents | DOC-0001, DOC-0005 |
    When the user checks Compare Versions on DOC-0001
    And the user checks Compare Versions on DOC-0005
    Then Disabled for DOC-0001; enabled for DOC-0005

  # Ref: US-11 AC-4; FRD 6.8.5 FB-Compare; FRD 6.8.5 F-Dropdown
  @TC_CP_219 @Functional @High @Automation
  Scenario: Verify Compare opens a side-by-side read-only comparison with version headers and category tabs
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1-V3
    And the following test data is used
      | Base         | V3 |
      | Compare With | V2 |
    When the user opens Compare Versions
    And the user selects Base 'V3 – Active' and Compare With 'V2 – Previous'
    And the user clicks Compare
    Then Both versions are shown side by side with headers 'V3 – Active' and 'V2 – Previous'
    And Tabs Content, Annotations, Metadata show difference counts; Content is selected by default

  # Ref: FRD 6.8.5 F-Compare; FRD 6.8.5 F-Dropdown
  @TC_CP_220 @Functional @Medium @Automation
  Scenario: Verify Compare is enabled only when both versions are selected and the list is latest first
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Compare Versions window for DOC-0005 is open
    And the following test data is used
      | Document | DOC-0005 |
    When the user observes Compare with no Compare With selection
    And the user opens the Base Version list
    And the user selects both
    Then Compare is disabled until both are selected
    And Versions are listed latest first as 'V3 – Active', 'V2 – Previous', 'V1 – Previous'

  # Ref: FRD 6.8.5 BR-Highlight
  @TC_CP_221 @Functional @High @Automation
  Scenario: Verify added, removed and modified content is highlighted green, red and amber with a legend
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And V2 and V3 of DOC-0005 (DOCX) differ by one added, one removed and one modified paragraph
    And the following test data is used
      | Document | DOC-0005 (DOCX) |
    When the user compares V2 and V3
    And the user reviews the Content tab
    Then Added content is green, removed is red, modified is amber
    And The legend shows Added (green), Removed (red) and Modified (amber)

  # Ref: FRD 6.8.5 BR-Metadata
  @TC_CP_222 @Functional @Medium @Automation
  Scenario: Verify the Metadata tab highlights only fields whose values differ
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And V2 and V3 differ only in Description and Tags
    And the following test data is used
      | Changed | Description, Tags |
    When the user compares V2 and V3
    And the user opens the Metadata tab
    Then Only Description and Tags are highlighted; Name, Category and Sub-category are not

  # Ref: FRD 6.8.5 Scope-Annotation
  @TC_CP_223 @Functional @Medium @Automation
  Scenario: Verify the Annotations tab identifies added, removed and modified annotations
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And V2 has a Rectangle on page 1; V3 has the Rectangle moved and a new Text annotation
    And the following test data is used
      | Document | DOC-0005 |
    When the user compares V2 and V3
    And the user opens the Annotations tab
    Then The new Text annotation is shown as added and the Rectangle's changed position as modified

  # Ref: FRD 6.8.5 Table-FileType
  @TC_CP_224 @Functional @Medium @Automation
  Scenario: Verify content comparison methods for text documents, PDF and images
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Documents with two versions exist for DOCX, TXT, PDF and JPG
    And the following test data is used
      | Files | DOCX |
      | Data  | TXT  |
      | Data  | PDF  |
      | Data  | JPG  |
    When the user compares two versions of each
    And the user repeats for each value
    Then DOCX/TXT use text comparison, PDF uses text/page comparison, JPG uses visual comparison

  # Ref: FRD 6.8.5 BR-Unsupported
  @TC_CP_225 @Functional @Medium @Automation
  Scenario: Verify the unsupported-content message is shown while annotation and metadata differences still display
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A DWG document with two versions exists
    And the following test data is used
      | File | Structural Layout.dwg (V1, V2) |
    When the user compares the two versions
    And the user opens each tab
    Then Content tab shows 'Content comparison is not supported for this file type.'
    And Annotations and Metadata tabs still show differences

  # Ref: FRD 6.8.5 F-Tabs
  @TC_CP_226 @Functional @Medium @Automation
  Scenario: Verify the empty state is shown in a tab with no differences
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Two versions have identical metadata
    And the following test data is used
      | Document | DOC-0005 |
    When the user compares them and open the Metadata tab
    Then An illustration with 'No differences found.' is displayed with a count of 0

  # Ref: FRD 6.8.5 BR-Watermark
  @TC_CP_227 @Functional @Medium @Automation
  Scenario: Verify the Previous Version pane shows the watermark in the comparison
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1-V3
    And the following test data is used
      | Base         | V3 |
      | Compare With | V2 |
    When the user compares V3 and V2
    Then The V2 pane shows 'V2 – PREVIOUS'; the V3 pane shows none

  # Ref: FRD 6.8.5 BR-ReadOnly
  @TC_CP_228 @Functional @High @Automation
  Scenario: Verify comparing does not modify versions, annotations or metadata or create a version
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 has V1-V3
    And the following test data is used
      | Base         | V3 |
      | Compare With | V1 |
    When the user compares V3 and V1
    And the user checks the version list, annotations and metadata
    Then Nothing is modified and no new version is created

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.8.5 BR-SameVersion
  @TC_CP_472 @Negative @High @Automation
  Scenario: Verify the same version cannot be selected in both fields
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Compare Versions window for DOC-0005 is open with Base 'V3'
    And the following test data is used
      | Base         | V3 |
      | Compare With | V2 |
    When the user opens Compare With and look for V3
    And the user selects Compare With 'V2' and open Base
    Then V3 is not selectable in Compare With and V2 is not selectable in Base Version

  # Ref: FRD 6.8.5 F-Dropdown
  @TC_CP_473 @Negative @Medium @Automation
  Scenario: Verify validation messages for missing selections
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Compare Versions window is open
    And the following test data is used
      | Document | DOC-0005 |
    When the user clears Base Version and try to compare
    And the user leaves Compare With empty and try to compare
    Then 'Please select the Base Version.' and 'Please select a version to compare with.' are displayed where validation is triggered

  # Ref: FRD 6.8.5 BR-Perm
  @TC_CP_474 @Negative @High @Automation
  Scenario: Verify a user without Compare Versions permission cannot compare
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. (no Compare Versions permission)
    And DOC-0005 exists
    And the following test data is used
      | User | Viewer_User1 |
    When the user looks for Compare Versions
    And the user sends a compare API request
    Then The action is not shown; API returns 403

  # Ref: FRD 6.8.5 BR-SameDoc
  @TC_CP_475 @Negative @Medium @Automation
  Scenario: Verify versions of different documents cannot be compared
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 and DOC-0001 exist
    And the following test data is used
      | Versions | DOC-0005 V3, DOC-0001 V1 |
    When the user sends a compare API request with version IDs from DOC-0005 and DOC-0001
    Then The request is rejected; only two versions of the same Document ID can be compared
