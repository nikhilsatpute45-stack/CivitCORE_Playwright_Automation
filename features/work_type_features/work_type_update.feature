@WorkType @WorkTypeUpdate
Feature: Work Type Update
  Automated scenarios for the "Work Type Update" module of Work Type.
  Source: CivitINFRA_WorkType_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-005_CivitINFRA Configuration_Work Type.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-4 AC-1; FRD 5.5 FB-2
  @TC_WT_062 @Functional @High @Automation
  Scenario: Verify the Edit pop-up opens pre-filled with current values and both fields are editable
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and on the Work Type List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway |
      | Data      | Roads   |
    When the user clicks the kebab on 'Taxiway' and select 'Edit'
    And the user observes the fields
    And the user modifies both fields
    Then 'Edit Work Type' pop-up opens with Work Type Name 'Taxiway' and Work Type 'Roads' pre-filled
    And Both fields are editable

  # Ref: US-4 AC-2; Sec 7 T2
  @TC_WT_063 @Functional @High @Automation
  Scenario: Verify Work Type Name can be updated
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Taxiway -> Taxiway East |
    When the user changes Work Type Name
    And the user clicks 'Save'
    Then Pop-up closes and toaster 'Work Type updated successfully.' is displayed
    And List shows 'Taxiway East'

  # Ref: US-4 AC-2; FRD 5.5 FB-4
  @TC_WT_064 @Functional @High @Automation
  Scenario: Verify Work Type value can be updated
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Roads -> Other |
    When the user changes Work Type
    And the user clicks 'Save'
    Then Toaster 'Work Type updated successfully.' is displayed
    And List shows 'Taxiway' with Work Type 'Other'

  # Ref: US-4 AC-2; FRD 5.5 FB-4
  @TC_WT_065 @Functional @High @Automation
  Scenario: Verify both Work Type Name and Work Type can be updated together
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Taxiway -> Taxiway Bay |
      | Work Type      | Roads -> Building      |
    When the user changes Work Type Name
    And the user changes Work Type
    And the user clicks 'Save'
    Then Toaster 'Work Type updated successfully.' is displayed
    And List shows 'Taxiway Bay' / Building at the same position

  # Ref: FRD 5.5 FB-4
  @TC_WT_066 @Functional @High @Automation
  Scenario: Verify Last Modified By and Last Modified On are recorded on update
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Boundary Wall'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Boundary Wall -> Perimeter Wall |
      | User           | Admin_User1                     |
    When the user changes Work Type Name and Save
    And the user opens View for the record
    Then Last Modified By shows Admin_User1 and Last Modified On shows the current date-time (no longer '-')

  # Ref: US-4 AC-3; FRD 5.5 BR-1
  @TC_WT_067 @Functional @High @Automation
  Scenario: Verify changing only the letter case of the Work Type's own name is allowed
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Taxiway -> TAXIWAY |
    When the user changes the case of the name
    And the user clicks 'Save'
    Then Update succeeds with toaster 'Work Type updated successfully.' and the list shows 'TAXIWAY'
    And No duplicate error is shown (uniqueness check excludes the record being edited)

  # Ref: US-4 AC-4; FRD 5.5 BR-2
  @TC_WT_068 @Functional @High @Automation
  Scenario: Verify a Work Type used in Works and having Sub Work Types can be edited
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Runway' (used in Work WRK-0001, has Sub Work Type 'Runway Lighting')
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Runway -> Runway Main |
    When the user changes Work Type Name
    And the user clicks 'Save'
    Then Update succeeds with toaster 'Work Type updated successfully.'

  # Ref: US-4 AC-2; FRD 5.7 FB-4; FRD 5.5 BR-3
  @TC_WT_069 @Functional @High @Automation
  Scenario: Verify the changed Work Type Name is shown in the Sub Work Type screen
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Hanger'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Hanger -> Hanger Main |
    When the user changes Work Type Name and Save
    And the user opens the Sub Work Type screen and view the Work Type 'Hanger Main' and its Sub Work Type
    Then Sub Work Type screen shows 'Hanger Main' with its Sub Work Type 'Hanger Roofing' intact

  # Ref: US-4 AC-2; FRD 5.7 FB-4; FRD 5.5 BR-3
  @TC_WT_070 @Functional @High @Automation
  Scenario: Verify the changed Work Type Name is shown in every Work that uses it
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Terminal Building'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Terminal Building -> Passenger Terminal |
    When the user changes Work Type Name and Save
    And the user opens Work WRK-0002
    Then Work WRK-0002 shows Work Type 'Passenger Terminal'; the Work still refers to the same Work Type

  # Ref: FRD 5.5 BR-3; FRD 5.7 FB-4
  @TC_WT_071 @Functional @High @Automation
  Scenario: Verify a change of Work Type value is shown in the Sub Work Type screen and in Works using the Work Type
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Runway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Other -> Roads |
    When the user changes Work Type and Save
    And the user opens the Sub Work Type screen and Work WRK-0001
    Then Sub Work Type screen and Work WRK-0001 show the new Work Type value 'Roads' for 'Runway'

  # Ref: FRD 5.2 BR-7; FRD 5.5 BR-3; FRD 5.7 BR-1
  @TC_WT_072 @Functional @High @Automation
  Scenario: Verify the Internal ID does not change when a Work Type is renamed or its value changed
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Runway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Runway/Other -> Runway Main/Building |
    When the user notes the Internal ID in the database
    And the user changes name and Work Type, then Save
    And the user re-reads the Internal ID
    Then Internal ID is identical before and after the update; Work WRK-0001 and Sub Work Type 'Runway Lighting' still reference it

  # Ref: US-4 AC-5; FRD 5.5 FB-5
  @TC_WT_073 @Functional @High @Automation
  Scenario: Verify saving without changing any field closes the pop-up with no toaster and no Activity Log entry
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Taxiway / Roads (unchanged) |
    When the user does not change any value
    And the user clicks 'Save'
    And the user checks the Activity Log and the record's Last Modified fields
    Then Pop-up closes; no toaster is displayed
    And Record is not updated and no Activity Log entry is created

  # Ref: FRD 5.5 BR-4; FRD 5.2 BR-2
  @TC_WT_074 @Functional @Medium @Automation
  Scenario: Verify leading/trailing spaces are removed on update
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | ' Taxiway Apron ' |
    When the user changes the name adding spaces
    And the user clicks 'Save'
    Then Name is saved as 'Taxiway Apron'

  # Ref: FRD 5.5 BR-4; FRD 5.2 BR-2
  @TC_WT_075 @Functional @Medium @Automation
  Scenario: Verify repeated internal spaces are reduced to one on update
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | 'Taxiway North Link' |
    When the user changes the name adding repeated internal spaces
    And the user clicks 'Save'
    Then Name is saved as 'Taxiway North Link'

  # Ref: FRD 5.5 BR-4; FRD 5.2 BR-5; FRD 5.2 BR-8
  @TC_WT_076 @Functional @Medium @Automation
  Scenario: Verify special characters are accepted on update and shown as plain text
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Taxiway <B> & "Link" 'A' |
    When the user changes the name
    And the user clicks 'Save'
    Then Name is saved exactly as entered and displayed as plain text

  # Ref: FRD 5.5 BR-4; FRD 5.2 F-Name (max 100)
  @TC_WT_077 @Functional @Medium @Automation
  Scenario: Verify Work Type Name of exactly 100 characters is accepted on update (Ref 5.5 BR-4, 5.2 F-Name (max 100))
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | 100 'C' characters |
    When the user replaces the name with a 100-character value
    And the user clicks 'Save'
    Then Update succeeds and the full 100-character name is saved

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.5 BR-4; FRD 5.5 FB-3; Sec 7 FLE-1
  @TC_WT_180 @Negative @High @Automation
  Scenario: Verify error when Work Type Name is blank on update
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | (blank) |
    When the user clears Work Type Name
    And the user clicks 'Save'
    Then Field-level error 'Work Type Name is required.' is displayed; the record is not updated

  # Ref: FRD 5.5 BR-4; FRD 5.2 F-Name
  @TC_WT_181 @Negative @High @Automation
  Scenario: Verify error when Work Type Name contains only spaces on update
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | ' ' |
    When the user replaces Work Type Name with spaces
    And the user clicks 'Save'
    Then Field-level error 'Work Type Name is required.' is displayed; the record is not updated

  # Ref: FRD 5.5 BR-4; Sec 7 FLE-3
  @TC_WT_182 @Negative @High @Automation
  Scenario: Verify error when Work Type is reset to the placeholder on update
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Select Work Type (placeholder) |
    When the user selects the placeholder 'Select Work Type'
    And the user clicks 'Save'
    Then Field-level error 'Work Type is required.' is displayed; the record is not updated

  # Ref: FRD 5.6 BR-5; Sec 7 FLE-3
  @TC_WT_183 @Negative @High @Automation
  Scenario: Verify the legacy 'None' record cannot be saved without selecting a Work Type
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for the legacy record 'Legacy Zone'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type | Select Work Type (placeholder) |
    When the user does not select a Work Type
    And the user clicks 'Save'
    Then Field-level error 'Work Type is required.' is displayed and nothing is saved

  # Ref: US-4 AC-3; FRD 5.5 BR-1; Sec 7 FLE-2
  @TC_WT_184 @Negative @High @Automation
  Scenario: Verify a name equal to another Work Type's name is rejected on update
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Taxiway -> Apron |
    When the user changes the name to another existing name
    And the user clicks 'Save'
    Then Field-level error 'A Work Type with this name already exists.' is displayed; the record is not updated

  # Ref: US-4 AC-3; FRD 5.5 BR-4
  @TC_WT_185 @Negative @High @Automation
  Scenario: Verify a name equal to another name in different case and spaces is rejected on update
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Taxiway -> ' APRON ' |
    When the user changes the name
    And the user clicks 'Save'
    Then Field-level error 'A Work Type with this name already exists.' is displayed

  # Ref: FRD 5.5 BR-4; FRD 5.2 BR-2
  @TC_WT_186 @Negative @Medium @Automation
  Scenario: Verify a name equal to another name after collapsing internal spaces is rejected on update
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Taxiway -> 'Boundary Wall' |
    When the user changes the name
    And the user clicks 'Save'
    Then Field-level error 'A Work Type with this name already exists.' is displayed

  # Ref: FRD 5.5 FB-3; FRD 5.2 FB-4
  @TC_WT_187 @Negative @Medium @Automation
  Scenario: Verify the pop-up stays open with entered values retained after an update validation failure
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Apron |
    When the user changes the name to 'Apron' (duplicate)
    And the user clicks 'Save'
    And the user observes the pop-up
    Then Pop-up stays open with 'Apron' retained and the field error shown; no toaster is displayed

  # Ref: FRD 5.5 BR-4; FRD 5.2 F-Name (max 100)
  @TC_WT_188 @Negative @Medium @Automation
  Scenario: Verify typing stops at 100 characters on update (max+1) (Ref 5.5 BR-4, 5.2 F-Name (max 100))
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | 101 'G' characters |
    When the user types a 101-character name in Work Type Name
    And the user observes the box
    Then The box contains exactly 100 characters

  # Ref: US-4 AC-6; FRD 5.5 FB-6
  @TC_WT_189 @Negative @High @Automation
  Scenario: Verify Cancel closes the Edit pop-up without saving changes
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Taxiway -> Taxiway West |
    When the user changes Work Type Name and Work Type
    And the user clicks 'Cancel'
    And the user observes the list and Activity Log
    Then Pop-up closes; the record is unchanged and no Activity Log entry is created

  # Ref: US-4 AC-6; FRD 5.5 FB-6
  @TC_WT_190 @Negative @High @Automation
  Scenario: Verify the close (X) icon closes the Edit pop-up without saving changes
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | Taxiway -> Taxiway West |
    When the user changes Work Type Name
    And the user clicks the close (X) icon
    And the user observes the list
    Then Pop-up closes; the record is unchanged

  # Ref: FRD 5.2 BR-8; FRD 5.5 BR-4; FRD 5.5 BR-1
  @TC_WT_191 @Negative @High @Automation
  Scenario: Verify the server rejects an update request for a duplicate name
    Given API client is authenticated with the token of Admin_User1 (Work Type: View/Add/Edit/Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload   | {name:'apron'} |
      | Work Type | Taxiway        |
    When the user sends an update request renaming 'Taxiway' to 'apron'
    Then Request is rejected as duplicate; 'Taxiway' remains unchanged

  # Ref: FRD 5.2 BR-6; FRD 5.5 BR-4
  @TC_WT_192 @Negative @Medium @Automation
  Scenario: Verify the server rejects an update request with a value not configured in the backend
    Given API client is authenticated with the token of Admin_User1 (Work Type: View/Add/Edit/Delete)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Payload   | {workType:'Custom'} |
      | Work Type | Taxiway             |
    When the user sends an update request with an unlisted Work Type value
    Then Request is rejected; 'Taxiway' remains unchanged

  # Ref: FRD 5.5 FB-3; Sec 7
  @TC_WT_193 @Negative @Medium @Automation
  Scenario: Verify no toaster is shown for any update validation failure
    Given Admin_User1 (Work Type: View/Add/Edit/Delete) is logged in to CivitINFRA and the 'Edit Work Type' pop-up is open for 'Taxiway'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Work Type Name | (blank), then Apron |
    When the user clears Work Type Name and click 'Save'
    And the user enters 'Apron' and click 'Save'
    Then Only field-level errors are displayed; no toaster appears
