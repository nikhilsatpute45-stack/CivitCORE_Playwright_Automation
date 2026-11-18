@DMS @DocumentMetadataTags
Feature: Document Metadata - Tags
  Automated scenarios for the "Document Metadata - Tags" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4.4 FB-Suggest; FRD 6.4.4 BR-Suggest
  @TC_CP_095 @Functional @High @Automation
  Scenario: Verify typing in the Tags field shows matching existing tags (case-insensitive, contains match)
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Existing tags: Safety, SafetyAudit, Quality, Urgent
    And the following test data is used
      | Typed | saf |
    When the user types 'saf' in the Tags field
    And the user observes suggestions
    Then 'Safety' and 'SafetyAudit' are suggested; 'Quality' and 'Urgent' are not

  # Ref: FRD 6.4.4 FB-Select
  @TC_CP_096 @Functional @High @Automation
  Scenario: Verify selecting a suggested tag adds it to the document
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Existing tag 'Safety' exists
    And the following test data is used
      | Tag | Safety |
    When the user types 'saf'
    And the user clicks 'Safety'
    And the user saves
    Then Tag 'Safety' is added to the document and saved

  # Ref: FRD 6.4.4 FB-Create; FRD 6.4.4 BR-AnyUser
  @TC_CP_097 @Functional @High @Automation
  Scenario: Verify typing a new tag and pressing Enter creates it and makes it available for other documents
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Tag 'NewTag1' does not exist
    And the following test data is used
      | Tag | NewTag1 |
    When the user types 'NewTag1' in Tags and press Enter
    And the user saves
    And the user opens another document's metadata and type 'New'
    Then Tag is created and added to the document
    And 'NewTag1' appears in suggestions on other documents
    And No separate tag-creation permission was needed

  # Ref: FRD 6.4.4 BR-NoDuplicate
  @TC_CP_098 @Functional @High @Automation
  Scenario: Verify pressing Enter on text matching an existing tag adds the existing tag without creating a duplicate
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Existing tag 'Safety'
    And the following test data is used
      | Typed | SAFETY |
    When the user types 'SAFETY' and press Enter
    And the user checks the tag master/suggestions
    Then The existing 'Safety' tag is added; no duplicate tag is created

  # Ref: FRD 6.4.4 BR-NoReAdd
  @TC_CP_099 @Functional @Medium @Automation
  Scenario: Verify a tag already added is not suggested and cannot be added again
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Tag 'Safety' is already added to the document
    And the following test data is used
      | Tag | Safety |
    When the user types 'Safety' again
    And the user presses Enter
    Then 'Safety' is not shown in suggestions
    And Pressing Enter does not add a second copy

  # Ref: FRD 6.4.4 BR-Multi
  @TC_CP_100 @Functional @Medium @Automation
  Scenario: Verify multiple tags can be added to a document
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The metadata form is open
    And the following test data is used
      | Tags | Safety, Urgent, Phase1 |
    When the user adds three tags
    And the user saves
    And the user opens document details
    Then All three tags are stored and displayed

  # Ref: FRD 6.4.4 BR-Remove; FRD 6.4.4 FB-Remove
  @TC_CP_101 @Functional @High @Automation
  Scenario: Verify removing a tag from a document does not delete the tag from the system
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Document has tag 'Urgent'
    And the following test data is used
      | Tag | Urgent |
    When the user clicks the remove (x) on 'Urgent'
    And the user saves
    And the user opens another document and type 'Urg'
    Then 'Urgent' is removed from the document
    And 'Urgent' is still suggested for other documents

  # Ref: FRD 6.4.4 F-TagName
  @TC_CP_102 @Functional @Medium @Automation
  Scenario: Verify a tag of exactly 15 characters with allowed special characters is accepted
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The metadata form is open
    And the following test data is used
      | Tags | Abcdefghij12345 |
      | Data | Q&A-1#_2        |
    When the user types the tag and press Enter
    Then Both tags are created (maximum 15 characters; letters, numbers and special characters allowed)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.4.4 F-TagName; FRD 6.4.4 Err-Length
  @TC_CP_419 @Negative @High @Automation
  Scenario: Verify a tag longer than 15 characters is not allowed
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The metadata form is open
    And the following test data is used
      | Tag | Abcdefghij123456 (16 chars) |
    When the user types a 16-character tag
    And the user presses Enter
    Then Entry beyond 15 characters is not allowed; error 'Tag cannot exceed 15 characters.' is displayed and no tag is created

  # Ref: FRD 6.4.4 F-TagName; FRD 6.4.4 Err-Space
  @TC_CP_420 @Negative @High @Automation
  Scenario: Verify a tag containing spaces is rejected
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The metadata form is open
    And the following test data is used
      | Tag | Site Visit |
    When the user types a tag with a space
    And the user presses Enter
    Then Error 'Spaces are not allowed in a tag.' is displayed and no tag is created

  # Ref: FRD 6.4.4 FB-Create
  @TC_CP_421 @Negative @Medium @Automation
  Scenario: Verify pressing Enter on an empty Tags field creates no tag
    Given Uploader_User1 (View + Upload permission) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And The metadata form is open
    And the following test data is used
      | Tag | (blank) |
    When the user clicks the Tags field
    And the user presses Enter with no text
    Then No tag is created or added
