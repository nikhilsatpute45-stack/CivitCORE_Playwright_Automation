@DMS @DocumentMetadataCategory
Feature: Document Metadata - Category
  Automated scenarios for the "Document Metadata - Category" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4.3 FB-Category; US-6 AC-3
  @TC_CP_089 @Functional @High @Automation
  Scenario: Verify the Sub-category list shows only active sub-categories mapped to the selected Category
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Master: Category 'Inspection' has sub-categories 'Site Inspection' and 'Safety Audit'; Category 'Contract' has 'Tender'
    And the following test data is used
      | Category | Inspection |
    When the user selects Category 'Inspection'
    And the user opens the Sub-category dropdown
    Then Only 'Site Inspection' and 'Safety Audit' are listed ('Tender' is not)

  # Ref: FRD 6.4.3 BR-Disabled
  @TC_CP_090 @Functional @Medium @Automation
  Scenario: Verify the Sub-category dropdown is disabled until a Category is selected
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The metadata form is open with no Category selected
    And the following test data is used
      | Category | (none) |
    When the user observes the Sub-category dropdown
    Then Sub-category is disabled

  # Ref: FRD 6.4.3 BR-ClearSub
  @TC_CP_091 @Functional @High @Automation
  Scenario: Verify changing the Category clears the selected Sub-category
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Category 'Inspection' and Sub-category 'Site Inspection' are selected
    And the following test data is used
      | Category | Inspection > Contract |
    When the user changes Category to 'Contract'
    And the user observes Sub-category
    Then The previously selected Sub-category is cleared and only 'Contract' sub-categories are listed

  # Ref: FRD 6.4.3 BR-SingleSelect
  @TC_CP_092 @Functional @Medium @Automation
  Scenario: Verify only one Category and one Sub-category can be assigned
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The metadata form is open
    And the following test data is used
      | Categories | Inspection, Contract |
    When the user selects 'Inspection'
    And the user tries to select 'Contract' as well
    Then Selecting another value replaces the first; only one Category and one Sub-category are stored

  # Ref: FRD 6.4.3 BR-NoSubMapped
  @TC_CP_093 @Functional @Medium @Automation
  Scenario: Verify Sub-category is not mandatory when the selected Category has no sub-categories
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Category 'General' has no mapped sub-categories
    And the following test data is used
      | Category | General |
    When the user selects Category 'General'
    And the user saves without a Sub-category
    Then The document is saved; no Sub-category error is shown

  # Ref: FRD 6.4.3 BR-NoCreate
  @TC_CP_094 @Functional @Medium @Automation
  Scenario: Verify categories and sub-categories cannot be created or edited from the upload/metadata screen
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The metadata form is open
    And the following test data is used
      | Typed text | My New Category |
    When the user types 'My New Category' in the Category field
    And the user looks for add/edit options
    Then Free-text entry is not allowed and no add/edit option exists; only master values can be selected

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4.3 F-Category
  @TC_CP_415 @Negative @High @Automation
  Scenario: Verify Category is mandatory
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A valid file is selected
    And the following test data is used
      | Category | (none) |
    When the user leaves Category unselected
    And the user saves
    Then 'Please select a document category.' is displayed and the document is not saved

  # Ref: FRD 6.4.3 F-Sub
  @TC_CP_416 @Negative @High @Automation
  Scenario: Verify Sub-category is mandatory when sub-categories are mapped to the Category
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Category 'Inspection' has mapped sub-categories
    And the following test data is used
      | Category     | Inspection |
      | Sub-category | (none)     |
    When the user selects 'Inspection' and leave Sub-category empty
    And the user saves
    Then 'Please select a sub-category.' is displayed and the document is not saved

  # Ref: US-6 AC-3; FRD 6.4.3 BR-Inactive
  @TC_CP_417 @Negative @High @Automation
  Scenario: Verify inactive categories and sub-categories are not available for new selection
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Category 'Legacy' and sub-category 'Safety Audit' are marked inactive in the master
    And the following test data is used
      | Inactive | Legacy, Safety Audit |
    When the user opens the Category dropdown
    And the user selects 'Inspection' and open Sub-category
    Then 'Legacy' and 'Safety Audit' are not listed. (Note: 6.4.3 BR-1 says all categories shall be available; US-6 AC-3 governs.)

  # Ref: FRD 6.4.3 F-Category
  @TC_CP_418 @Negative @Medium @Automation
  Scenario: Verify free-text entry is not allowed in Category and Sub-category
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The metadata form is open
    And the following test data is used
      | Category | NotInMaster |
    When the user sends an upload request via API with a category value that does not exist in the master
    Then The request is rejected and the document is not saved with an invalid category
