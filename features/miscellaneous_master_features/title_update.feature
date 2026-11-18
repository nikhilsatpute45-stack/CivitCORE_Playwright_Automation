@MiscellaneousMaster @TitleUpdate
Feature: Title Update
  Automated scenarios for the "Title Update" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: Section 4 AC-ED-1; FRD 5.5 FB-2; FRD 5.5 FB-1
  @TC_MM_074 @Functional @Medium @Automation
  Scenario: Verify Edit opens pre-filled with current values and all four fields editable
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Unit of Measurement (Enum ID 106, Parent Measurement Groups, Display unchecked) |
    When the user clicks the kebab on 'Unit of Measurement' and select Edit
    And the user observes the values and try to change each field
    Then 'Edit Title' pre-filled with Field Title, Parent Title 'Measurement Groups', Enum ID 106 and Display unchecked
    And Field Title, Parent Title, Enum ID and Display are editable

  # Ref: Section 4 AC-ED-2; FRD 5.5 FB-4; FRD Sec 7 Toaster #2
  @TC_MM_075 @Functional @High @Automation
  Scenario: Verify Field Title can be updated and the toaster is displayed
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | List of Operator -> List of Operators |
    When the user edits 'List of Operator'
    And the user changes Field Title
    And the user clicks Save
    Then Toaster 'Title updated successfully.' is displayed and the form closes
    And Title List shows 'List of Operators'

  # Ref: FRD 5.5 FB-4; Section 4 AC-VW-1
  @TC_MM_076 @Functional @Medium @Automation
  Scenario: Verify Last Modified By and Last Modified On are updated and Created By/On remain unchanged after an update
    Given Editor_User1 (Miscellaneous Master: View/Edit) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Editor_User1                          |
      | Field Title | List of Operator -> List of Operators |
    When the user opens View for 'List of Operator' and note Created and Last Modified values
    And As Editor_User1 edit 'List of Operator' and change the Field Title
    And the user opens View again
    Then Last Modified By is 'Editor_User1' and Last Modified On is the current date-time
    And Created By and Created On are unchanged

  # Ref: FRD 5.5 FB-4; Section 4 AC-ED-2
  @TC_MM_077 @Functional @Medium @Automation
  Scenario: Verify Parent Title can be set on an existing Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title        | Draft Field           |
      | Parent Title | none -> List of Title |
    When the user edits 'Draft Field'
    And the user selects a Parent Title
    And the user clicks Save
    Then Toaster 'Title updated successfully.' is displayed
    And Parent Title column of 'Draft Field' shows 'List of Title'

  # Ref: FRD 5.5 BR-4; Section 4 AC-PT-3
  @TC_MM_078 @Functional @Medium @Automation
  Scenario: Verify Parent Title can be removed by selecting '-- Select Parent Title --'
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title        | Unit of Measurement                             |
      | Parent Title | Measurement Groups -> -- Select Parent Title -- |
    When the user edits 'Unit of Measurement'
    And the user selects '-- Select Parent Title --' in Parent Title
    And the user clicks Save
    Then Update succeeds with toaster 'Title updated successfully.'
    And Parent Title column of 'Unit of Measurement' is blank

  # Ref: FRD 5.5 BR-4; FRD 5.5 FB-4
  @TC_MM_079 @Functional @Medium @Automation
  Scenario: Verify Parent Title can be changed to a valid non-descendant Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title        | District        |
      | Parent Title | State -> Region |
    When the user edits 'District'
    And the user changes Parent Title from 'State' to 'Region'
    And the user clicks Save
    Then Update succeeds; Parent Title column of 'District' shows 'Region'

  # Ref: FRD 5.5 BR-1
  @TC_MM_080 @Functional @High @Automation
  Scenario: Verify Enum ID can be added to a Title that has none
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | Obsolete Field |
      | Enum ID | blank -> 504   |
    When the user edits 'Obsolete Field' (Enum ID blank)
    And the user enters Enum ID
    And the user clicks Save
    Then Update succeeds; Enum ID column shows 504

  # Ref: FRD 5.5 BR-1
  @TC_MM_081 @Functional @High @Automation
  Scenario: Verify Enum ID can be changed on an existing Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Operator |
      | Enum ID | 104 -> 505       |
    When the user edits 'List of Operator'
    And the user changes Enum ID
    And the user clicks Save
    Then Update succeeds; Enum ID column shows 505

  # Ref: FRD 5.5 BR-1
  @TC_MM_082 @Functional @High @Automation
  Scenario: Verify Enum ID can be cleared on an existing Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Operator |
      | Enum ID | 104 -> blank     |
    When the user edits 'List of Operator'
    And the user clears the Enum ID box
    And the user clicks Save
    Then Update succeeds; Enum ID column of 'List of Operator' is blank

  # Ref: FRD 5.5 BR-1
  @TC_MM_083 @Functional @Medium @Automation
  Scenario: Verify the Enum ID uniqueness check excludes the Title being edited
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title       | List of Operator  |
      | Field Title | List of Operators |
      | Enum ID     | 104 (unchanged)   |
    When the user edits 'List of Operator' (Enum ID 104)
    And the user changes only Field Title, leaving Enum ID 104
    And the user clicks Save
    Then Update succeeds; 'Enum ID already exists.' is not displayed

  # Ref: Section 4 AC-ED-3; FRD 5.5 BR-2
  @TC_MM_084 @Functional @Medium @Automation
  Scenario: Verify changing only the letter case of the Title's own name is allowed
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Field Title | List of Firm Type -> list of firm type |
    When the user edits 'List of Firm Type'
    And the user changes Field Title to lower case
    And the user clicks Save
    Then Update succeeds; toaster 'Title updated successfully.'; list shows 'list of firm type'

  # Ref: Section 4 AC-ED-4; FRD 5.5 FB-5
  @TC_MM_085 @Functional @High @Automation
  Scenario: Verify saving without any change closes the form with no update and no toaster
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | List of Operator |
    When the user edits 'List of Operator'
    And the user changes nothing and click Save
    And the user observes the page
    Then The form closes; no toaster message is displayed
    And Last Modified On of the Title is unchanged

  # Ref: FRD 5.6 BR-2; FRD 5.5 FB-4
  @TC_MM_086 @Functional @High @Automation
  Scenario: Verify Display can be changed from the Edit form with the same effect as from the list
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Specialization |
      | Display | unchecked -> checked   |
    When the user edits 'List of Specialization' and check Display
    And the user clicks Save
    And the user opens Specialization Master
    Then Update succeeds; Display checked in the list
    And 'List of Specialization' is available in Specialization Master exactly as with a list change

  # Ref: FRD 5.5 BR-3; FRD 5.7 BR-1
  @TC_MM_087 @Functional @High @Automation
  Scenario: Verify renaming a Title used in transactions does not affect its transactions
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title       | Site Category -> Site Category Type |
      | Transaction | TXN-0001 uses Site Category         |
    When the user edits 'Site Category' and change Field Title
    And the user opens a transaction that uses the Title
    Then Rename succeeds
    And Transaction TXN-0001 still references the Title and shows the new name 'Site Category Type'

  # Ref: FRD 5.5 BR-3; FRD 5.7 BR-1
  @TC_MM_088 @Functional @High @Automation
  Scenario: Verify renaming a Parent Title keeps its child Titles linked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Project Type -> Project Category |
    When the user edits 'Project Type' and change Field Title
    And the user observes the Parent Title column of 'Project Subtype'
    Then 'Project Subtype' still has the parent and shows 'Project Category' as Parent Title

  # Ref: FRD 5.5 BR-3; FRD 5.7 FB-5
  @TC_MM_089 @Functional @High @Automation
  Scenario: Verify renaming a Title mapped in the Specialization Master keeps the mapping and shows the new name
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Zone Type -> Zone Category |
    When the user edits 'Zone Type' and change Field Title
    And the user opens Specialization Master
    Then The Specialization Master mapping and its values are intact and the Title is shown as 'Zone Category'

  # Ref: Section 4 AC-PT-2
  @TC_MM_090 @Functional @Medium @Automation
  Scenario: Verify the Parent Title dropdown on Edit excludes the Title and all its direct and indirect children
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Region |
    When the user edits 'Region' (child 'State', grandchild 'District')
    And the user opens the Parent Title dropdown
    Then 'Region', 'State' and 'District' are not listed; all other Titles are listed

  # Ref: Section 4 AC-PT-2
  @TC_MM_091 @Functional @Medium @Automation
  Scenario: Verify the Parent Title dropdown on Edit of a mid-level Title excludes itself and its children but lists its parent
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | State |
    When the user edits 'State'
    And the user opens the Parent Title dropdown
    Then 'State' and 'District' are not listed; 'Region' is listed

  # Ref: Section 4 AC-PT-2
  @TC_MM_092 @Functional @Medium @Automation
  Scenario: Verify the Parent Title dropdown on Edit of a leaf Title excludes only itself
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | District |
    When the user edits 'District'
    And the user opens the Parent Title dropdown
    Then 'District' is not listed; 'Region' and 'State' are listed

  # Ref: FRD 5.2 BR-9; FRD 5.7 BR-1
  @TC_MM_093 @Functional @High @Automation
  Scenario: Verify the Internal ID is unchanged after the Title name and Enum ID are changed
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title       | List of Operator  |
      | Field Title | List of Operators |
      | Enum ID     | 104 -> 505        |
    When the user queries the Internal ID of 'List of Operator'
    And the user edits it: change Field Title and Enum ID, then Save
    And the user queries the Internal ID again
    Then Internal ID is identical before and after the update

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.5 BR-5; FRD 5.5 FB-3; FRD Sec 7 Field Error #1
  @TC_MM_211 @Negative @Medium @Automation
  Scenario: Verify clearing Field Title on Edit blocks Save with 'Field Title is required.'
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title       | List of Operator |
      | Field Title | blank            |
    When the user edits 'List of Operator'
    And the user clears Field Title
    And the user clicks Save
    Then Update is not saved; inline error 'Field Title is required.' is displayed; the form stays open

  # Ref: Section 4 AC-ED-3; FRD 5.5 BR-2; FRD Sec 7 Field Error #2
  @TC_MM_212 @Negative @High @Automation
  Scenario: Verify renaming a Title to the name of another Title is blocked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title       | List of Firm Type |
      | Field Title | list of title     |
    When the user edits 'List of Firm Type'
    And the user changes Field Title to the name of another Title in different case
    And the user clicks Save
    Then Update is not saved; 'A title with this name already exists.' is displayed

  # Ref: Section 4 AC-ED-3; FRD 5.5 BR-2; FRD Sec 7 Field Error #2
  @TC_MM_213 @Negative @High @Automation
  Scenario: Verify renaming to another Title's name with surrounding spaces is blocked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title       | List of Firm Type |
      | Field Title | ' List of Title ' |
    When the user edits 'List of Firm Type'
    And the user enters another Title's name with leading and trailing spaces
    And the user clicks Save
    Then Update is not saved; 'A title with this name already exists.' is displayed

  # Ref: FRD 5.5 BR-1; FRD Sec 7 Field Error #4
  @TC_MM_214 @Negative @High @Automation
  Scenario: Verify changing the Enum ID to one used by another Title is blocked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Operator |
      | Enum ID | 104 -> 101       |
    When the user edits 'List of Operator'
    And the user changes Enum ID to 101
    And the user clicks Save
    Then Update is not saved; 'Enum ID already exists.' is displayed

  # Ref: FRD 5.5 BR-5; FRD Sec 7 Field Error #3
  @TC_MM_215 @Negative @Medium @Automation
  Scenario: Verify an invalid Enum ID on Edit is rejected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Operator |
      | Enum ID | 1.5              |
    When the user edits 'List of Operator'
    And the user enters an Enum ID with a decimal point
    And the user clicks Save
    Then Update is not saved; 'Enum ID must be a whole number greater than 0.' is displayed

  # Ref: FRD 5.5 BR-5; FRD Sec 7 Field Error #3
  @TC_MM_216 @Negative @Medium @Automation
  Scenario: Verify Enum ID 0 on Edit is rejected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Operator |
      | Enum ID | 0                |
    When the user edits 'List of Operator'
    And the user enters Enum ID 0
    And the user clicks Save
    Then Update is not saved; 'Enum ID must be a whole number greater than 0.' is displayed

  # Ref: FRD 5.5 BR-5; FRD 5.2 F-FT
  @TC_MM_217 @Negative @Medium @Automation
  Scenario: Verify Field Title cannot exceed 100 characters on Edit
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pasted text | 150 characters |
    When the user edits 'List of Operator'
    And the user pastes 150 characters into Field Title
    And the user observes the box
    Then Field Title is cut at 100 characters

  # Ref: Section 4 AC-ED-5; FRD 5.5 FB-6
  @TC_MM_218 @Negative @Medium @Automation
  Scenario: Verify Cancel on the Edit form saves no change
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title       | List of Operator  |
      | Field Title | List of Operators |
    When the user edits 'List of Operator'
    And the user changes Field Title to 'List of Operators'
    And the user clicks Cancel
    And the user checks the list and the Activity Log
    Then The form closes; Title remains 'List of Operator'; no Activity Log entry is written

  # Ref: Section 4 AC-ED-5; FRD 5.5 FB-6
  @TC_MM_219 @Negative @Medium @Automation
  Scenario: Verify the close (X) icon on the Edit form saves no change
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title       | List of Operator  |
      | Field Title | List of Operators |
    When the user edits 'List of Operator'
    And the user changes Field Title to 'List of Operators'
    And the user clicks the close (X) icon
    And the user checks the list
    Then The form closes; Title remains 'List of Operator'

  # Ref: Section 4 AC-PT-4; FRD Sec 7 Field Error #5; FRD 5.2 F-PT
  @TC_MM_220 @Negative @High @Automation
  Scenario: Verify the server rejects a Title being made its own parent
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Admin_User1 |
      | Title  | Region      |
      | Parent | Region      |
    When the user sends an update-Title request for 'Region' with Parent Title set to 'Region'
    Then Request is rejected with 'Selected Parent Title creates a circular hierarchy.'; 'Region' is unchanged

  # Ref: Section 4 AC-PT-4; FRD 5.5 BR-4; FRD Sec 7 Field Error #5
  @TC_MM_221 @Negative @High @Automation
  Scenario: Verify the server rejects a Parent Title that is a direct child (two-level circle)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Admin_User1 |
      | Title  | Region      |
      | Parent | State       |
    When the user sends an update-Title request for 'Region' with Parent Title set to 'State'
    Then Request is rejected with 'Selected Parent Title creates a circular hierarchy.'

  # Ref: Section 4 AC-PT-4; FRD 5.5 BR-4; FRD Sec 7 Field Error #5
  @TC_MM_222 @Negative @High @Automation
  Scenario: Verify the server rejects a Parent Title that is an indirect child (three-level circle)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User   | Admin_User1 |
      | Title  | Region      |
      | Parent | District    |
    When the user sends an update-Title request for 'Region' with Parent Title set to 'District'
    Then Request is rejected with 'Selected Parent Title creates a circular hierarchy.'

  # Ref: Section 4 AC-PT-4; FRD Sec 7 Field Error #5; FRD 5.2 FB-5
  @TC_MM_223 @Negative @High @Automation
  Scenario: Verify a circular Parent Title chosen from a stale dropdown is rejected on Save and shown below Parent Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Session A | Admin_User1 |
      | Session B | Admin_User2 |
    When Session A: open Edit on 'Draft Field' (dropdown lists 'Legacy Field')
    And Session B: set the Parent Title of 'Legacy Field' to 'Draft Field' and save
    And Session A: select 'Legacy Field' as Parent Title and click Save
    Then Update is not saved; 'Selected Parent Title creates a circular hierarchy.' is shown below Parent Title with no toaster; the form stays open

  # Ref: FRD 5.2 BR-9
  @TC_MM_224 @Negative @High @Automation
  Scenario: Verify the Internal ID cannot be changed through an update request
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1                                               |
      | Payload | {internalId: 'NEW-9999', fieldTitle: 'List of Operators'} |
    When the user sends an update-Title request for 'List of Operator' that includes a different Internal ID value
    And the user queries the Internal ID
    Then The Internal ID of 'List of Operator' is unchanged (it cannot be entered or edited)
