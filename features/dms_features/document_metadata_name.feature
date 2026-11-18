@DMS @DocumentMetadataName
Feature: Document Metadata - Name
  Automated scenarios for the "Document Metadata - Name" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4.1 F-Name; FRD 6.4.1 BR-Case
  @TC_CP_080 @Functional @High @Automation
  Scenario: Verify Document Name accepts 1 and 100 characters and is stored in the case entered
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Names | A                      |
      | Data  | 'Aa' repeated 50 times |
    When the user enters a 1-character name and save
    And the user uploads another file with a 100-character mixed-case name and save
    Then Both documents are saved and displayed exactly as entered (case preserved)

  # Ref: FRD 6.4.1 F-Name
  @TC_CP_081 @Functional @Medium @Automation
  Scenario: Verify permitted special characters are accepted in Document Name
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Name | Site-Plan_v1.2, Rev (A) & B |
    When the user enters the name and save
    Then The document is saved with the name as entered

  # Ref: FRD 6.4.1 F-Name
  @TC_CP_082 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces in Document Name are removed before saving
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Name | ' Safety Plan ' |
    When the user enters the name with surrounding spaces and save
    Then The document is saved as 'Safety Plan'

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4.1 F-Name
  @TC_CP_407 @Negative @High @Automation
  Scenario: Verify a blank Document Name is rejected
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Name | (blank) |
    When the user clears the Document Name field
    And the user attempts to save
    Then 'Document name is required.' is displayed inline and the document cannot be saved

  # Ref: FRD 6.4.1 F-Name
  @TC_CP_408 @Negative @Medium @Automation
  Scenario: Verify a Document Name containing only spaces is rejected
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Name | ' ' |
    When the user enters only spaces
    And the user attempts to save
    Then 'Document name is required.' is displayed; the document cannot be saved

  # Ref: FRD 6.4.1 F-Name
  @TC_CP_409 @Negative @Medium @Automation
  Scenario: Verify entry beyond 100 characters is not allowed in Document Name
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Name | 'D' repeated 101 times |
    When the user types or paste 101 characters into Document Name
    Then Input is limited to 100 characters (entry beyond 100 is not allowed)

  # Ref: FRD 6.4.1 F-Name
  @TC_CP_410 @Negative @High @Automation
  Scenario: Verify an uploaded file name longer than 100 characters is populated as extracted and the error is shown
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | 105-character name + '.pdf' |
    When the user uploads a file whose name (without extension) is 105 characters
    Then The name is populated as extracted
    And 'Document name cannot exceed 100 characters.' is displayed; the document cannot be saved until corrected

  # Ref: FRD 6.4.1 F-Name
  @TC_CP_411 @Negative @High @Automation
  Scenario: Verify restricted characters in Document Name are rejected
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Names | Plan/A  |
      | Data  | Plan\A  |
      | Plan  | A       |
      | Data  | Plan*A  |
      | Data  | Plan?A  |
      | Data  | Plan"A  |
      | Data  | Plan<A  |
      | Data  | Plan>A  |
      | Data  | Plan\|A |
      | Data  | Plan#A  |
      | Data  | Plan@A  |
      | Data  | Plan%A  |
    When the user enters the name and attempt to save
    And the user repeats for each value
    Then 'Document name contains invalid characters.' is displayed for each value; the document cannot be saved

  # Ref: FRD 6.4.1 F-Name
  @TC_CP_412 @Negative @Medium @Automation
  Scenario: Verify a file name containing restricted characters is populated and flagged
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is open
    And the following test data is used
      | File | Report#1@Final.pdf |
    When the user uploads 'Report#1@Final.pdf'
    Then Name is populated as extracted with the error 'Document name contains invalid characters.'; save is blocked until corrected
