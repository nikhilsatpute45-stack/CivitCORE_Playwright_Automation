@DMS @DmsUiDocumentList
Feature: DMS UI - Document List
  Automated scenarios for the "DMS UI - Document List" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.6.1 EmptyState
  @TC_CP_315 @UIVisual @Low @Automation
  Scenario: Verify the Upload Document CTA is absent in the empty state for a user without upload permission
    Given Viewer_User1 (View permission only) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Empty Folder' has no documents
    And the following test data is used
      | User | Viewer_User1 |
    When the user opens 'Empty Folder'
    And the user inspects the DOM/UI for the CTA
    Then The Upload Document CTA is not present
