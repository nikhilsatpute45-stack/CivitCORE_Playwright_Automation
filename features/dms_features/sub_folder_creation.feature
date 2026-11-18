@DMS @SubFolderCreation
Feature: Sub-folder Creation
  Automated scenarios for the "Sub-folder Creation" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.2 FB-Create; FRD Sec 8 T2; FRD 6.1.2 BR-Inherit
  @TC_CP_016 @Functional @High @Automation
  Scenario: Verify a sub-folder is created via the kebab menu with the toaster and parent permissions inherited
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Drawings' is Private (Role: Site Engineer)
    And the following test data is used
      | Sub Folder Name | Level 1 |
    When the user clicks kebab menu against 'Drawings' > Add Sub Folder
    And the user enters the name
    And the user clicks Create
    And the user opens Manage Access of the new sub-folder
    Then Sub-folder 'Level 1' is created under 'Drawings'
    And Toaster 'Sub-folder created successfully.' is displayed
    And Parent permissions are inherited (Role 'Site Engineer', Source 'Inherited')

  # Ref: FRD 6.1.2 BR-StandardFolder
  @TC_CP_017 @Functional @Medium @Automation
  Scenario: Verify a sub-folder can contain documents and further sub-folders
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Sub-folder 'Contracts > Tenders' exists
    And the following test data is used
      | File              | Tender_Notice.pdf |
      | Nested sub-folder | Phase 1           |
    When the user opens 'Tenders'
    And the user uploads 'Tender_Notice.pdf'
    And the user adds a sub-folder 'Phase 1' under 'Tenders'
    Then Document is uploaded into the sub-folder
    And Nested sub-folder 'Phase 1' is created (a sub-folder behaves as a standard folder object)

  # Ref: FRD 6.1.2 FB-Cancel
  @TC_CP_018 @Functional @Medium @Automation
  Scenario: Verify Cancel on the Add Sub Folder form creates no sub-folder
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Sub Folder Name | Temp Sub |
    When the user clicks kebab > Add Sub Folder on 'Contracts'
    And the user enters 'Temp Sub'
    And the user clicks Cancel
    Then The form is closed and no sub-folder 'Temp Sub' is created

  # Ref: FRD 6.1.2 F-Name; FRD 6.1.2 F-Create
  @TC_CP_019 @Functional @Medium @Automation
  Scenario: Verify Sub Folder Name boundaries (1 and 100 characters) and Create button enablement
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Add Sub Folder form is open under 'Archive'
    And the following test data is used
      | Names | B                      |
      | Data  | 'S' repeated 100 times |
    When the user observes Create with empty name
    And the user enters 1-character name and create
    And the user creates another sub-folder with a 100-character name
    Then Create is disabled until a name is entered
    And Both sub-folders are created successfully

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.2 F-Name
  @TC_CP_362 @Negative @High @Automation
  Scenario: Verify blank Sub Folder Name is rejected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Add Sub Folder form is open
    And the following test data is used
      | Sub Folder Name | (blank) |
    When the user types 'X' then clear the field
    Then Inline error 'Sub Folder Name is required' is displayed
    And Create is disabled

  # Ref: FRD 6.1.2 F-Name
  @TC_CP_363 @Negative @High @Automation
  Scenario: Verify restricted characters are rejected in Sub Folder Name
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Add Sub Folder form is open
    And the following test data is used
      | Names | Sub\A  |
      | Data  | Sub/A  |
      | Sub   | A      |
      | Data  | Sub*A  |
      | Data  | Sub?A  |
      | Data  | Sub"A  |
      | Data  | Sub<A  |
      | Data  | Sub>A  |
      | Data  | Sub\|A |
    When the user enters a name with the restricted character and click Create
    And the user repeats for each value
    Then 'Sub Folder Name contains invalid characters' is displayed for every value and no sub-folder is created

  # Ref: FRD 6.1.2 F-Name
  @TC_CP_364 @Negative @Medium @Automation
  Scenario: Verify Sub Folder Name of 101 characters is rejected
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The Add Sub Folder form is open
    And the following test data is used
      | Sub Folder Name | 'S' repeated 101 times |
    When the user enters a 101-character name and click Create
    Then 'Sub Folder Name cannot exceed 100 characters' is displayed and no sub-folder is created

  # Ref: US-1 AC-3; FRD 6.1.2 F-Name
  @TC_CP_365 @Negative @High @Automation
  Scenario: Verify duplicate sub-folder name under the same parent is blocked case-insensitively
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Sub-folder 'Tenders' exists under 'Contracts'
    And the following test data is used
      | Parent          | Contracts |
      | Sub Folder Name | tenders   |
    When the user adds Sub Folder under 'Contracts'
    And the user enters 'tenders'
    And the user clicks Create
    Then Error 'A Sub folder with this name already exists.' is displayed and no sub-folder is created

  # Ref: FRD 6.1.2 Perm
  @TC_CP_366 @Negative @Medium @Automation
  Scenario: Verify a user without create permission cannot see Add Sub Folder
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens the kebab menu against 'Contracts'
    Then 'Add Sub Folder' is not displayed in the kebab menu
