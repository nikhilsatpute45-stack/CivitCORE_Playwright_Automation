@RateCard @RateCardUpdate
Feature: Rate Card Update
  Automated scenarios for the "Rate Card Update" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-1; FRD 5.5 FB-2; FRD 5.2 F-AssocOffices
  @TC_RC_076 @Functional @Medium @Automation
  Scenario: Verify Edit opens the pop-up with Rate Card Name pre-filled and editable and Associated Offices read-only
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Sub Mountanious |
    When the user selects Edit from the kebab menu of 'Sub Mountanious'
    Then 'Edit Rate Card' pop-up opens
    And Rate Card Name shows 'Sub Mountanious' and is editable
    And Associated Offices lists Nabha, Patiala, Rajpura, Samana and is read-only

  # Ref: US-5 AC-2; FRD 5.5 FB-4; FRD Sec 7 Toaster #2
  @TC_RC_077 @Functional @Medium @Automation
  Scenario: Verify a Rate Card is renamed successfully with a valid unique name
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Coastal Region -> Coastal Region East |
    When the user selects Edit from the kebab menu of 'Coastal Region'
    And the user changes Rate Card Name
    And the user clicks Save
    Then Pop-up closes
    And Toaster 'Rate Card updated successfully.' is displayed
    And List shows 'Coastal Region East' at the same position (Sl. No. 1)

  # Ref: FRD 5.5 FB-4
  @TC_RC_078 @Functional @High @Automation
  Scenario: Verify Last Modified By and Last Modified On are recorded on update
    Given Editor_User1 (Rate Card: View+Edit) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Editor_User1 |
    When the user edits 'Coastal Region' to 'Coastal Region East' and Save
    And the user logs in as Admin_User1 and open View of 'Coastal Region East'
    Then Last Modified By shows Editor_User1
    And Last Modified On shows the date-time of the update

  # Ref: US-5 AC-3; FRD 5.5 BR-1
  @TC_RC_079 @Functional @High @Automation
  Scenario: Verify changing only the letter case of its own name is allowed
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Sub Mountanious -> SUB MOUNTANIOUS |
    When the user selects Edit from the kebab menu of 'Sub Mountanious'
    And the user changes the name to upper case
    And the user clicks Save
    Then Rate Card is updated to 'SUB MOUNTANIOUS' and toaster 'Rate Card updated successfully.' is displayed (own name excluded from uniqueness check)

  # Ref: US-5 AC-4; FRD 5.5 BR-2
  @TC_RC_080 @Functional @High @Automation
  Scenario: Verify a Rate Card used in transactions can be renamed
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Hill Zone -> Hill Zone North |
    When the user selects Edit from the kebab menu of 'Hill Zone' (used in Resource Rate RR-001)
    And the user changes the name
    And the user clicks Save
    Then Rate Card is renamed and toaster 'Rate Card updated successfully.' is displayed
    And Resource Rate RR-001 still references the same Rate Card

  # Ref: FRD 5.5 BR-3; FRD 5.2 BR-2
  @TC_RC_081 @Functional @Medium @Automation
  Scenario: Verify leading/trailing spaces and repeated internal spaces are normalised on Edit
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | ' Coastal Region East ' |
    When the user selects Edit from the kebab menu of 'Coastal Region'
    And the user enters the name with extra spaces
    And the user clicks Save
    Then Rate Card is saved as 'Coastal Region East'

  # Ref: FRD 5.5 BR-3; FRD 5.2 BR-4
  @TC_RC_082 @Functional @Medium @Automation
  Scenario: Verify a name with special characters is accepted on Edit
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Plains (Zone-A) & <Hills> |
    When the user selects Edit from the kebab menu of 'Coastal Region'
    And the user enters the name with special characters
    And the user clicks Save
    Then Rate Card is saved exactly as entered and displayed as plain text

  # Ref: US-5 AC-5; FRD 5.5 FB-5; FRD Sec 7 TR-1
  @TC_RC_083 @Functional @High @Automation
  Scenario: Verify Save with no change closes the pop-up with no update, no toaster and no Activity Log entry
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region (unchanged) |
    When the user selects Edit from the kebab menu of 'Coastal Region'
    And the user does not change anything and click Save
    And the user checks Last Modified values and the Activity Log
    Then Pop-up closes
    And No toaster is displayed
    And Last Modified By/On are unchanged and no Activity Log entry is created

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.5 FB-3; FRD 5.5 BR-3; FRD Sec 7 FieldError #1
  @TC_RC_166 @Negative @High @Automation
  Scenario: Verify a blank Rate Card Name is rejected on Edit
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | (blank) |
    When the user selects Edit on 'Coastal Region'
    And the user clears Rate Card Name
    And the user clicks Save
    Then Field-level error 'Rate Card Name is required.' is displayed; pop-up stays open and the Rate Card is unchanged

  # Ref: US-5 AC-3; FRD Sec 7 FieldError #2; FRD Sec 7 TR-3
  @TC_RC_167 @Negative @High @Automation
  Scenario: Verify renaming to another Rate Card's name is rejected on Edit
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Coastal Region -> Civit-ratecard |
    When the user selects Edit on 'Coastal Region'
    And the user changes the name to an existing one
    And the user clicks Save
    Then Field-level error 'A Rate Card with this name already exists.' is displayed; pop-up stays open
    And No toaster is displayed and the Rate Card is unchanged

  # Ref: US-5 AC-3; FRD 5.5 BR-3
  @TC_RC_168 @Negative @High @Automation
  Scenario: Verify renaming to another Rate Card's name with different case and extra spaces is rejected on Edit
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | ' civit-RATECARD ' |
    When the user selects Edit on 'Coastal Region'
    And the user enters ' civit-RATECARD '
    And the user clicks Save
    Then Field-level error 'A Rate Card with this name already exists.' is displayed

  # Ref: FRD 5.5 BR-3; FRD 5.2 F-Name
  @TC_RC_169 @Negative @Medium @Automation
  Scenario: Verify the 100-character limit applies on Edit
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed text | 'F' repeated 101 times |
    When the user selects Edit on 'Coastal Region'
    And the user clears the name and type 101 characters
    Then Typing stops at 100 characters

  # Ref: US-5 AC-6; FRD 5.5 FB-6
  @TC_RC_170 @Negative @Medium @Automation
  Scenario: Verify Cancel on the Edit pop-up saves no change
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Coastal Region -> Coastal Region East (cancelled) |
    When the user selects Edit on 'Coastal Region'
    And the user changes the name to 'Coastal Region East'
    And the user clicks 'Cancel'
    Then Pop-up closes; 'Coastal Region' keeps its name; no toaster and no Activity Log entry

  # Ref: US-5 AC-6; FRD 5.5 FB-6
  @TC_RC_171 @Negative @Medium @Automation
  Scenario: Verify the close (X) icon on the Edit pop-up saves no change
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Coastal Region -> Coastal Region East (closed) |
    When the user selects Edit on 'Coastal Region'
    And the user changes the name to 'Coastal Region East'
    And the user clicks the close (X) icon
    Then Pop-up closes; 'Coastal Region' keeps its name; no toaster and no Activity Log entry

  # Ref: FRD 5.2 BR-6; FRD 5.6 BR-1; US-3 AC-3
  @TC_RC_172 @Negative @High @Automation
  Scenario: Verify Associated Offices sent in an update request is ignored
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1                                    |
      | Payload | {name:'Sub Mountanious', associatedOffices:[]} |
    When the user sends an update request for 'Sub Mountanious' with a changed Associated Offices list
    And the user views the Rate Card
    Then Associated Offices of 'Sub Mountanious' remain Nabha, Patiala, Rajpura, Samana
