@DMS @FolderCreation
Feature: Folder Creation
  Automated scenarios for the "Folder Creation" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-4; FRD 6.1.1 FB-Create; FRD Sec 8 T1; FRD 6.1.1 F-Name
  @TC_CP_007 @Functional @High @Automation
  Scenario: Verify a folder is created with a valid name and the toaster is displayed
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Folder Name | Site Reports |
    When the user selects the repository 'Organization Document'
    And the user clicks New Folder
    And the user enters the folder name
    And the user clicks Create
    Then Folder 'Site Reports' is created and listed in the folder hierarchy
    And Toaster 'Folder created successfully.' is displayed

  # Ref: US-1 AC-4; FRD 6.1.1 FB-Available
  @TC_CP_008 @Functional @High @Automation
  Scenario: Verify a newly created folder is immediately available for document upload and sub-folder creation
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Site Reports' was just created
    And the following test data is used
      | Folder     | Site Reports        |
      | File       | Inspection_Plan.pdf |
      | Sub Folder | Week 1              |
    When the user opens 'Site Reports'
    And the user uploads the file 'Inspection_Plan.pdf' using ADD DOC
    And the user adds a sub-folder 'Week 1' to 'Site Reports'
    Then ADD DOC is available and the document is uploaded into 'Site Reports'
    And Sub-folder 'Week 1' is created under 'Site Reports' without any delay or refresh requirement

  # Ref: US-1 AC-4; FRD 6.1.1 FB-Inherit
  @TC_CP_009 @Functional @High @Automation
  Scenario: Verify a newly created folder inherits the applicable permissions of its parent
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Drawings' is Private with access for Role 'Site Engineer'
    And SiteEng_User1 (Role: Site Engineer) and NoAccess_User1 exist
    And the following test data is used
      | Parent      | Drawings                      |
      | Folder Name | Revisions                     |
      | Users       | SiteEng_User1, NoAccess_User1 |
    When the user creates folder 'Revisions' under 'Drawings'
    And the user opens Manage Access for 'Revisions'
    And the user logs in as SiteEng_User1 and open 'Drawings'
    And the user logs in as NoAccess_User1 and open the repository
    Then Manage Access of 'Revisions' lists Role 'Site Engineer' with Source 'Inherited'
    And SiteEng_User1 can see 'Revisions'; NoAccess_User1 cannot

  # Ref: FRD 6.1.1 FB-Cancel
  @TC_CP_010 @Functional @Medium @Automation
  Scenario: Verify Cancel on the Create Folder form closes it without creating a folder
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Folder Name | Temp Folder |
    When the user clicks New Folder
    And the user enters 'Temp Folder'
    And the user clicks Cancel
    Then The form is closed
    And Folder 'Temp Folder' is not created

  # Ref: FRD 6.1.1 F-Name
  @TC_CP_011 @Functional @High @Automation
  Scenario: Verify leading and trailing spaces in Folder Name are trimmed before persistence
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Folder Name | ' Site Photos ' |
    When the user clicks New Folder
    And the user enters the name with leading/trailing spaces
    And the user clicks Create
    And the user observes the folder name in the list
    Then Folder is created with the name 'Site Photos' (no leading/trailing spaces)

  # Ref: FRD 6.1.1 F-Name
  @TC_CP_012 @Functional @Medium @Automation
  Scenario: Verify Folder Name of exactly 1 character is accepted (lower boundary)
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Folder Name | A |
    When the user clicks New Folder
    And the user enters a 1-character name
    And the user clicks Create
    Then Folder 'A' is created (minimum length 1)

  # Ref: FRD 6.1.1 F-Name
  @TC_CP_013 @Functional @Medium @Automation
  Scenario: Verify Folder Name of exactly 100 characters is accepted (upper boundary)
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Folder Name | 'F' repeated 100 times (100 chars) |
    When the user clicks New Folder
    And the user enters a 100-character name
    And the user clicks Create
    Then Folder is created with the full 100-character name (maximum length 100)

  # Ref: FRD 6.1.1 F-Name
  @TC_CP_014 @Functional @Medium @Automation
  Scenario: Verify permitted special characters hyphen, underscore, period, parentheses, ampersand and comma are accepted in Folder Name
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Folder Name | Plans-2026_v1.0 (Final) & Notes, Rev 2 |
    When the user clicks New Folder
    And the user enters the name containing permitted characters
    And the user clicks Create
    Then Folder is created with the exact name
    And No invalid-characters error is displayed

  # Ref: FRD 6.1.1 F-Create
  @TC_CP_015 @Functional @Medium @Automation
  Scenario: Verify the Create button is enabled only after a folder name is entered
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create Folder form is open
    And the following test data is used
      | Folder Name | Q |
    When the user observes the Create button with the Folder Name empty
    And the user types 'Q'
    And the user clears the field
    Then Create is disabled while the name is empty
    And Create is enabled after a name is entered
    And Create is disabled again after clearing

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.1 F-Name; US-1 AC-3
  @TC_CP_353 @Negative @High @Automation
  Scenario: Verify a blank Folder Name is rejected with the required message
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create Folder form is open
    And the following test data is used
      | Folder Name | (blank) |
    When the user types 'X' in Folder Name and clear it
    And the user observes the field and the Create button
    Then Inline error 'Folder Name is required' is displayed
    And Create is disabled and no folder is created

  # Ref: FRD 6.1.1 F-Name
  @TC_CP_354 @Negative @High @Automation
  Scenario: Verify a Folder Name containing only spaces is rejected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create Folder form is open
    And the following test data is used
      | Folder Name | ' ' (5 spaces) |
    When the user enters spaces only
    And the user attempts to click Create
    Then Name is treated as blank after trimming; 'Folder Name is required' is displayed and no folder is created

  # Ref: FRD 6.1.1 F-Name
  @TC_CP_355 @Negative @Medium @Automation
  Scenario: Verify Folder Name of 101 characters is rejected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create Folder form is open
    And the following test data is used
      | Folder Name | 'F' repeated 101 times (101 chars) |
    When the user enters a 101-character name
    And the user clicks Create
    Then Error 'Folder Name cannot exceed 100 characters' is displayed and no folder is created

  # Ref: FRD 6.1.1 F-Name
  @TC_CP_356 @Negative @High @Automation
  Scenario: Verify each restricted character \ / : * ? " < > | is rejected in Folder Name
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create Folder form is open
    And the following test data is used
      | Folder Names | Plan\A  |
      | Data         | Plan/A  |
      | Plan         | A       |
      | Data         | Plan*A  |
      | Data         | Plan?A  |
      | Data         | Plan"A  |
      | Data         | Plan<A  |
      | Data         | Plan>A  |
      | Data         | Plan\|A |
    When the user enters a name containing the restricted character
    And the user clicks Create
    And the user repeats for each value in Test Data
    Then For every value the error 'Folder Name contains invalid characters' is displayed
    And No folder is created

  # Ref: US-1 AC-3; FRD 6.1.1 F-Name; FRD 6.1 BR-UniqueName
  @TC_CP_357 @Negative @High @Automation
  Scenario: Verify a duplicate Folder Name under the same parent is blocked
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Contracts' exists at the root level
    And the following test data is used
      | Folder Name | Contracts |
    When the user clicks New Folder at the root level
    And the user enters 'Contracts'
    And the user clicks Create
    Then Error 'A folder with this name already exists.' is displayed
    And No folder is created

  # Ref: US-1 AC-3; FRD 6.1.1 F-Name
  @TC_CP_358 @Negative @High @Automation
  Scenario: Verify duplicate Folder Name validation is case-insensitive
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Contracts' exists at the root level
    And the following test data is used
      | Folder Name | CONTRACTS |
    When the user clicks New Folder
    And the user enters 'CONTRACTS'
    And the user clicks Create
    Then 'CONTRACTS' is treated the same as 'Contracts'; error 'A folder with this name already exists.' is displayed and no folder is created

  # Ref: FRD 6.1.1 F-Name
  @TC_CP_359 @Negative @Medium @Automation
  Scenario: Verify duplicate validation is applied after trimming spaces
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Contracts' exists at the root level
    And the following test data is used
      | Folder Name | ' Contracts ' |
    When the user clicks New Folder
    And the user enters ' Contracts ' with spaces
    And the user clicks Create
    Then Name is trimmed before validation; error 'A folder with this name already exists.' is displayed

  # Ref: FRD 6.1.1 Perm
  @TC_CP_360 @Negative @High @Automation
  Scenario: Verify a user without folder-creation permission cannot create a folder
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Viewer_User1            |
      | Payload | {name:'Blocked Folder'} |
    When the user opens the repository and review the toolbar
    And the user sends a create-folder API request using the token of this user
    Then 'New Folder' is not available in the UI
    And The API request is rejected (403) and no folder is created

  # Ref: FRD 6.1.1 F-Name; Secure coding policy (input sanitization)
  @TC_CP_361 @Negative @Medium @Automation
  Scenario: Verify script/SQL injection text in Folder Name is rejected safely
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Create Folder form is open
    And the following test data is used
      | Folder Names | <script>alert(1)</script>    |
      | Data         | Docs'; DROP TABLE folders;-- |
    When the user enters the injection text
    And the user clicks Create
    Then Both values are rejected with 'Folder Name contains invalid characters'
    And No script is executed and no data is altered
