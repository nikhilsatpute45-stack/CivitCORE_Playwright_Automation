@DMS @SearchDiscovery
Feature: Search & Discovery
  Automated scenarios for the "Search & Discovery" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.7 FB-Default; FRD 6.7 F-SearchType
  @TC_CP_166 @Functional @High @Automation
  Scenario: Verify the Search Type dropdown defaults to 'Metadata + File Content' and lists all three options
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | Folder | Reports |
    When the user observes the Search Type dropdown
    And the user opens it
    Then 'Metadata + File Content' is selected by default
    And Options listed: Metadata, File Content, Metadata + File Content (only one selectable at a time)

  # Ref: FRD 6.7 BR-AutoSearch
  @TC_CP_167 @Functional @High @Automation
  Scenario: Verify search runs automatically as the user types and no Search button exists
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' contains 'Quarterly Report', 'Site Photo'
    And the following test data is used
      | Keyword | Quar |
    When the user types 'Quar' in the search bar
    And the user observes the results and the toolbar
    Then Results update automatically while typing; 'Quarterly Report' is listed
    And No Search CTA is displayed

  # Ref: FRD 6.7 BR-Scope; US-10 AC-1
  @TC_CP_168 @Functional @High @Automation
  Scenario: Verify search returns only documents directly within the selected folder and not from its sub-folders
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Contracts' has DOC-0001 'Site Inspection Report'; its sub-folder 'Tenders' has the document 'Tender Notice'
    And the following test data is used
      | Keywords | Tender, Inspection |
    When the user opens 'Contracts'
    And the user searches 'Tender'
    And the user searches 'Inspection'
    Then 'Tender Notice' (in a sub-folder) is not returned
    And 'Site Inspection Report' is returned

  # Ref: FRD 6.7.1 Fields-Name
  @TC_CP_169 @Functional @High @Automation
  Scenario: Verify Metadata search by Document Name is case-insensitive
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Search type 'Metadata'. 'Reports' contains 'Quarterly Report'
    And the following test data is used
      | Keyword | QUARTERLY |
    When the user types 'QUARTERLY'
    Then 'Quarterly Report' is returned

  # Ref: FRD 6.7.1 Fields-Desc
  @TC_CP_170 @Functional @High @Automation
  Scenario: Verify Metadata search by Description
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0006 has Description 'Handwritten site letter'
    And Search type 'Metadata'
    And the following test data is used
      | Keyword | handwritten |
    When the user types 'handwritten'
    Then DOC-0006 is returned

  # Ref: FRD 6.7.1 Fields-Category
  @TC_CP_171 @Functional @High @Automation
  Scenario: Verify Metadata search by Category and by Sub-category
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 has Category 'Inspection' and Sub-category 'Site Inspection'
    And Search type 'Metadata'
    And the following test data is used
      | Keywords | Inspection, Site Inspection |
    When the user types 'Inspection'
    And the user types 'Site Inspection'
    Then DOC-0001 is returned for both keywords

  # Ref: FRD 6.7.1 Fields-Tags
  @TC_CP_172 @Functional @High @Automation
  Scenario: Verify Metadata search by Tag
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 has tag 'Safety'
    And Search type 'Metadata'
    And the following test data is used
      | Keyword | safety |
    When the user types 'safety'
    Then DOC-0001 is returned

  # Ref: FRD 6.7.1 Fields-FileType
  @TC_CP_173 @Functional @Medium @Automation
  Scenario: Verify Metadata search by File Type and by Version
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' has PDF and JPG documents; DOC-0005 is V3
    And Search type 'Metadata'
    And the following test data is used
      | Keywords | jpg, V3 |
    When the user types 'jpg'
    And the user types 'V3'
    Then JPG documents are returned for 'jpg'
    And DOC-0005 is returned for 'V3'

  # Ref: FRD 6.7.1 Fields-UploadedBy; FRD 6.7.1 Fields-UploadDate; US-10 AC-1
  @TC_CP_174 @Functional @Medium @Automation
  Scenario: Verify Metadata search by Uploaded By and Upload Date (and Modified Date per US-10 AC-1)
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0007 was uploaded by Uploader_User1 on 05-Nov-2026
    And Search type 'Metadata'
    And the following test data is used
      | Keywords | Uploader_User1, 05-Nov-2026 |
    When the user types 'Uploader_User1'
    And the user types '05-Nov-2026'
    And the user types a Modified Date value
    Then DOC-0007 is returned for Uploaded By and Upload Date
    And Modified Date search follows US-10 AC-1 (not listed in 6.7.1; confirm with BA)

  # Ref: FRD 6.7.1 BR-NoContent
  @TC_CP_175 @Functional @High @Automation
  Scenario: Verify Metadata search does not match text that exists only inside the document content
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 content contains 'hydrostatic' but no metadata field contains it
    And the following test data is used
      | Keyword | hydrostatic |
    When the user selects search type 'Metadata'
    And the user types 'hydrostatic'
    Then No documents are returned ('No matching documents found')

  # Ref: US-10 AC-2; FRD 6.7.2 FB-Index
  @TC_CP_176 @Functional @High @Automation
  Scenario: Verify File Content search returns documents containing the term or phrase
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Search type 'File Content'
    And Indexed documents: DOC-0001 (PDF), a DOCX, an XLSX, a PPTX and DOC-0009 (TXT) contain 'hydrostatic test'
    And the following test data is used
      | Phrase | hydrostatic test |
    When the user types 'hydrostatic test'
    Then All documents containing the phrase are returned

  # Ref: FRD 6.7.2 FB-ContentOnly
  @TC_CP_177 @Functional @High @Automation
  Scenario: Verify File Content search does not match terms that exist only in metadata
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0007 has tag 'FoundationPhoto' that does not appear in its content
    And the following test data is used
      | Keyword | FoundationPhoto |
    When the user selects search type 'File Content'
    And the user types 'FoundationPhoto'
    Then DOC-0007 is not returned

  # Ref: FRD 6.7.2 OCR; US-10 AC-2
  @TC_CP_178 @Functional @High @Automation
  Scenario: Verify scanned and image-based documents are searchable through OCR without changing the original
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0006 'Scanned Letter' (image-based PDF) and a PNG containing text 'Retention Money' were uploaded and OCR has completed
    And Original checksums are noted
    And the following test data is used
      | Keyword | Retention Money                |
      | Files   | Scanned Letter.pdf, Notice.png |
    When the user searches 'Retention Money' with search type 'File Content'
    And the user compares original file checksums
    Then Both documents are returned via OCR text
    And Original files are unchanged

  # Ref: FRD 6.7.2 FB-Async
  @TC_CP_179 @Functional @Medium @Automation
  Scenario: Verify the user is not blocked while indexing runs after upload
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Indexing worker is delayed (stubbed)
    And the following test data is used
      | File | Large_Spec.pdf (100 pages) |
    When the user uploads a 100-page PDF
    And Immediately open the folder and continue working
    And the user searches for text of the PDF before and after indexing completes
    Then Upload completes without waiting for indexing
    And The content becomes searchable after indexing completes

  # Ref: FRD 6.7 BR-CaseTrim
  @TC_CP_181 @Functional @High @Automation
  Scenario: Verify search is case-insensitive and trims leading and trailing spaces
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' contains 'Quarterly Report'
    And the following test data is used
      | Keyword | ' qUARTERLY ' |
    When the user types ' qUARTERLY ' with leading/trailing spaces
    Then 'Quarterly Report' is returned

  # Ref: FRD 6.7 BR-ChangeType
  @TC_CP_182 @Functional @High @Automation
  Scenario: Verify changing the search type after a search refreshes the results
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' contains a document with 'hydrostatic' only in its content
    And the following test data is used
      | Keyword | hydrostatic |
    When the user searches 'hydrostatic' with 'File Content'
    And the user changes the type to 'Metadata'
    Then Results show the document under 'File Content' and become empty after switching to 'Metadata'

  # Ref: FRD 6.7 BR-Clear; FRD 6.7 F-Clear
  @TC_CP_183 @Functional @High @Automation
  Scenario: Verify Clear (X) and removing the keyword restore the full list and keep the selected search type
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A search is in progress with search type 'Metadata'
    And the following test data is used
      | Keyword     | Quarterly |
      | Search type | Metadata  |
    When the user clicks Clear (X)
    And the user types a keyword again and delete it manually
    Then The complete Document List is restored each time
    And Search type remains 'Metadata'
    And Clear (X) appears only while a keyword exists

  # Ref: FRD 6.7 FB-NoMatch; US-10 AC-1
  @TC_CP_184 @Functional @High @Automation
  Scenario: Verify 'No matching documents found' is shown for a search with no results
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' is open
    And the following test data is used
      | Keyword | zzzzqqqq |
    When the user types 'zzzzqqqq'
    Then An illustration with 'No matching documents found' is displayed; clearing the search returns the full list

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.7 BR-Perm
  @TC_CP_449 @Negative @High @Automation
  Scenario: Verify a user does not see documents they cannot access in search results
    Given NoAccess_User1 has no access to Private 'Drawings' (DOC-0003 'Structural Layout')
    And the following test data is used
      | Keyword | Structural     |
      | User    | NoAccess_User1 |
    When As NoAccess_User1 search 'Structural' across accessible folders and in a folder the user can see
    Then DOC-0003 is never returned to NoAccess_User1

  # Ref: FRD 6.7 BR-NoDeleted
  @TC_CP_450 @Negative @High @Automation
  Scenario: Verify deleted documents are not returned
    Given DOC-0002 'BOQ Summary' was soft-deleted
    And the following test data is used
      | Keyword | BOQ |
    When the user searches 'BOQ' in 'Contracts'
    Then The deleted document is not returned

  # Ref: FRD 6.7 BR-BarScope
  @TC_CP_451 @Negative @Medium @Automation
  Scenario: Verify the universal search bar is not available outside a selected folder
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The repository root is open with no folder selected
    And the following test data is used
      | View | Repository root |
    When the user looks for the search bar
    Then The universal search bar is displayed only inside a selected folder or sub-folder

  # Ref: FRD 6.7 BR-NoModify
  @TC_CP_452 @Negative @Medium @Automation
  Scenario: Verify performing a search does not modify any document, version or metadata
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0005 exists
    And the following test data is used
      | Keyword | Quarterly |
    When the user runs several searches that return DOC-0005
    And the user compares DOC-0005 version list, metadata and activity log before and after
    Then No document, version or metadata changes and no new activity entries are created for the search

  # Ref: FRD 6.7 BR-AutoSearch; Secure coding policy (input sanitization)
  @TC_CP_453 @Negative @Medium @Automation
  Scenario: Verify special characters and injection strings in the search bar are handled safely
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' is open
    And the following test data is used
      | Values | ' OR 1=1;--               |
      | Data   | <script>alert(1)</script> |
      | Data   | %%%                       |
    When the user types each value
    Then No error page or script execution occurs; the search returns 'No matching documents found' or only legitimate matches
