@DMS @DocumentMetadataDescription
Feature: Document Metadata - Description
  Automated scenarios for the "Document Metadata - Description" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4.2 BR-Optional
  @TC_CP_083 @Functional @High @Automation
  Scenario: Verify the document can be saved without a description
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Description | (blank) |
    When the user leaves Description empty
    And the user saves
    Then The document is saved successfully without a description

  # Ref: FRD 6.4.2 F-Desc
  @TC_CP_084 @Functional @Medium @Automation
  Scenario: Verify a description of exactly 250 characters is accepted
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Description | 'x' repeated 250 times |
    When the user enters a 250-character description
    And the user saves
    Then The description is saved in full

  # Ref: FRD 6.4.2 F-Desc
  @TC_CP_085 @Functional @Medium @Automation
  Scenario: Verify a description containing only spaces is treated as blank
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Description | ' ' |
    When the user enters spaces only
    And the user saves
    And the user opens document details
    Then The document is saved and the description is shown as blank

  # Ref: FRD 6.4.2 F-Desc
  @TC_CP_086 @Functional @Medium @Automation
  Scenario: Verify every permitted special character is accepted in Description
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Description | Site-visit_1.0, A&B (ok): yes; 50/50? Done! @QC #12 100%'s |
    When the user enters the text and save
    Then The description is saved exactly as entered

  # Ref: FRD 6.4.2 BR-LineBreaks
  @TC_CP_087 @Functional @Medium @Automation
  Scenario: Verify line breaks in Description are stored and displayed
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Description | 'Line one' + Enter + 'Line two' |
    When the user enters a description with two lines
    And the user saves
    And the user opens document details
    Then Both lines are displayed on separate lines in Document Details

  # Ref: FRD 6.4.2 F-Desc
  @TC_CP_088 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces in Description are removed on save
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Description | ' Final drawing ' |
    When the user enters the description with surrounding spaces and save
    Then Stored description is 'Final drawing'

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4.2 F-Desc; US-6 AC-2
  @TC_CP_413 @Negative @High @Automation
  Scenario: Verify restricted characters in Description are rejected
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Descriptions | Cost $100   |
      | Data         | Total = 5   |
      | Data         | A*B         |
      | Data         | <b>bold</b> |
      | Data         | Path\file   |
      | Data         | A\|B        |
      | Data         | [list]      |
      | Data         | {x}         |
    When the user enters the text and attempt to save
    And the user repeats for each value
    Then 'Description contains invalid characters.' is displayed inline for each value; the document cannot be saved

  # Ref: FRD 6.4.2 F-Desc; US-6 AC-2
  @TC_CP_414 @Negative @Medium @Automation
  Scenario: Verify entry beyond 250 characters is not allowed in Description
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected in the upload form
    And the following test data is used
      | Description | 'x' repeated 251 times |
    When the user pastes a 251-character description
    Then Input is limited to 250 characters; if an error is shown, it reads 'Description cannot exceed 250 characters.' and the document cannot be saved with more than 250 characters
