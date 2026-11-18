@MiscellaneousMaster @TitleConsumption
Feature: Title Consumption
  Automated scenarios for the "Title Consumption" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.7 FB-1
  @TC_MM_101 @Functional @High @Automation
  Scenario: Verify the Specialization Master lists exactly the Titles whose Display is checked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Data | Baseline Titles |
    When the user opens Specialization Master and note the available fields
    And the user compares with the Title List filtered by Display 'Checked'
    Then Specialization Master lists exactly List of Title, List of Firm Type, List of Operator, Zone Type and Material Group; no unchecked Title is listed

  # Ref: FRD 5.7 FB-3; Section 4 AC-AD-4
  @TC_MM_102 @Functional @High @Automation
  Scenario: Verify a Title without an Enum ID is not shown on any form page
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Measurement Groups (Enum ID blank) |
    When the user opens the Vendor Registration and Contractor Registration forms
    And the user looks for the Title 'Measurement Groups' (no Enum ID)
    Then 'Measurement Groups' is not shown on any form page

  # Ref: FRD 5.7 FB-3
  @TC_MM_103 @Functional @High @Automation
  Scenario: Verify a Title with an Enum ID matching the backend field is shown on that form
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Firm Type   |
      | Enum ID | 102                 |
      | Form    | Vendor Registration |
    When the user opens the Vendor Registration form
    And the user checks the Firm Type field
    Then 'List of Firm Type' is shown on the Firm Type field of the Vendor Registration form

  # Ref: FRD 5.7 FB-4; FRD 5.5 BR-1
  @TC_MM_104 @Functional @High @Automation
  Scenario: Verify changing the Enum ID moves the Title to the form linked to the new Enum ID from the next time the form is opened
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | Obsolete Field |
      | Enum ID | 401 -> 402     |
    When the user edits 'Obsolete Field' and enter Enum ID 401; save; open Vendor Registration form
    And the user edits 'Obsolete Field' and change Enum ID to 402; save
    And the user re-opens the Vendor Registration and Contractor Registration forms
    Then After step 1 the Title is shown on Vendor Registration
    And After step 3 it is shown on Contractor Registration and no longer on Vendor Registration

  # Ref: FRD 5.7 FB-4
  @TC_MM_105 @Functional @High @Automation
  Scenario: Verify clearing the Enum ID removes the Title from every form page from the next time the form is opened
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Firm Type |
      | Enum ID | 102 -> blank      |
    When the user edits 'List of Firm Type' and clear Enum ID; save
    And the user re-opens the Vendor Registration form
    Then 'List of Firm Type' is not shown on any form page

  # Ref: FRD 5.7 FB-5
  @TC_MM_106 @Functional @High @Automation
  Scenario: Verify a renamed Title is shown with the new name on form pages and in the Specialization Master
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | List of Firm Type -> List of Firm Types |
    When the user edits 'List of Firm Type' and change Field Title to 'List of Firm Types'
    And the user opens the Vendor Registration form and the Specialization Master
    Then The new name is shown on the Vendor Registration form and in Specialization Master

  # Ref: FRD 5.7 FB-6; FRD 5.7 BR-1
  @TC_MM_107 @Functional @Medium @Automation
  Scenario: Verify consuming screens can read the Parent-Child relationship of a Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title  | Unit of Measurement |
      | Parent | Measurement Groups  |
    When the user requests the Title details for 'Unit of Measurement' from the consuming-screen read interface
    And the user checks the parent reference
    Then The relationship is returned referencing the parent's Internal ID so the child can be presented in the context of 'Measurement Groups'

  # Ref: FRD 5.7 BR-1
  @TC_MM_108 @Functional @High @Automation
  Scenario: Verify changing the Enum ID of a Title used in transactions keeps the transaction reference intact
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | Site Category |
      | Enum ID | 107 -> 507    |
    When the user edits 'Site Category' and change Enum ID from 107 to 507
    And the user opens transaction TXN-0001
    Then TXN-0001 still references 'Site Category' (references use the Internal ID, not the Enum ID)
