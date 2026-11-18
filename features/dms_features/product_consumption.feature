@DMS @ProductConsumption
Feature: Product Consumption
  Automated scenarios for the "Product Consumption" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-15 AC-1; FRD 6.1 FB-ProductAgnostic
  @TC_CP_294 @Functional @High @Automation
  Scenario: Verify a Civit product can configure its own repository structure, categories and access rules on the common DMS
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And CivitBUILD and CivitINFRA are enabled for the tenant
    And the following test data is used
      | Repositories | CivitBUILD Tendering, CivitINFRA Billing |
    When the user configures a repository 'CivitBUILD Tendering' with category 'Bid Documents' for CivitBUILD
    And the user configures a repository 'CivitINFRA Billing' with category 'Invoices' for CivitINFRA
    Then Each product has its own repository, categories and access rules on the common DMS without affecting the other

  # Ref: US-15 AC-2; FRD 6.1 BR-StoreOnce
  @TC_CP_295 @Functional @High @Automation
  Scenario: Verify a document is stored once while associable with multiple business entities
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And DOC-0001 exists
    And Business entities TND-001 and WO-001 exist
    And the following test data is used
      | Document | DOC-0001        |
      | Entities | TND-001, WO-001 |
    When the user associates DOC-0001 with TND-001 and WO-001
    And the user checks storage records
    Then A single stored file/record exists and is linked to both entities

  # Ref: US-15 AC-3; FRD 6.4 FB-Config
  @TC_CP_296 @Functional @Medium @Automation
  Scenario: Verify product-specific metadata is configured without changing core DMS behaviour
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And A product-specific metadata field 'Tender No' is configured at CivitCORE level
    And the following test data is used
      | Field | Tender No (CivitBUILD only) |
    When the user uploads a document from CivitBUILD
    And the user uploads from CivitINFRA
    Then 'Tender No' appears only in the CivitBUILD flow; core fields work the same in both
