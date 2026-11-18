@RateCard @RateCardCreation
Feature: Rate Card Creation
  Automated scenarios for the "Rate Card Creation" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 5.2 FB-5; US-2 AC-2; FRD Sec 7 Toaster #1
  @TC_RC_012 @Functional @High @Automation
  Scenario: Verify a Rate Card is created with a unique Rate Card Name and appears as Sl. No. 1
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Highland Zone |
    When the user clicks 'Add'
    And the user enters Rate Card Name
    And the user clicks Save
    Then Rate Card 'Highland Zone' is created and the pop-up closes
    And Toaster 'Rate Card added successfully.' is displayed
    And List is shown on page 1 and 'Highland Zone' is Sl. No. 1; previous rows move down by one

  # Ref: FRD 5.2 FB-5; FRD 5.4 FB-2
  @TC_RC_013 @Functional @High @Automation
  Scenario: Verify Created By and Created On are recorded when a Rate Card is created
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Highland Zone |
      | User           | Admin_User1   |
    When the user clicks 'Add'
    And the user enters Rate Card Name and click Save
    And the user selects View from the kebab menu of the new row
    And the user observes Created By and Created On
    Then Created By shows Admin_User1
    And Created On shows the current date-time of the save

  # Ref: FRD 5.2 BR-7; FRD 5.2 FB-5
  @TC_RC_014 @Functional @Medium @Automation
  Scenario: Verify a unique Internal ID is generated for each new Rate Card
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Names | Highland Zone, Lowland Zone |
    When the user creates Rate Card 'Highland Zone'
    And the user creates Rate Card 'Lowland Zone'
    And the user queries the Rate Card master for the Internal ID of both records
    Then Each record has a system-generated Internal ID
    And The two Internal IDs are different and not null

  # Ref: FRD 5.2 BR-7
  @TC_RC_015 @Functional @High @Automation
  Scenario: Verify the Internal ID never changes when a Rate Card is renamed
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Hill Zone -> Hill Zone North |
    When the user records the Internal ID of 'Hill Zone' from the Rate Card master
    And the user edits 'Hill Zone' to 'Hill Zone North' and Save
    And the user queries the Internal ID of 'Hill Zone North'
    Then Internal ID is identical before and after the rename
    And Internal ID is not editable by the user

  # Ref: FRD 5.2 FB-1; FRD 5.2 FB-5
  @TC_RC_016 @Functional @High @Automation
  Scenario: Verify the first Rate Card created from the empty state replaces the empty state with the list
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card empty state
    And Empty dataset DS-0 (no Rate Card exists) (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Civit-ratecard |
    When the user clicks 'Add' on the empty state
    And the user enters Rate Card Name
    And the user clicks Save
    Then Toaster 'Rate Card added successfully.' is displayed
    And Empty state is replaced by the Rate Card List showing 'Civit-ratecard' as Sl. No. 1

  # Ref: FRD 5.2 FB-1; FRD 5.2 FB-2
  @TC_RC_017 @Functional @High @Automation
  Scenario: Verify 'Add' on the Rate Card List opens the Add Rate Card pop-up
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1 |
    When the user clicks 'Add' above the grid
    Then 'Add Rate Card' pop-up opens with the fields Rate Card Name and Associated Offices and buttons Save and Cancel

  # Ref: FRD 5.2 FB-5; US-2 AC-2; FRD 5.3 FB-7
  @TC_RC_018 @Functional @High @Automation
  Scenario: Verify the list is shown on page 1 with column search cleared after adding a Rate Card
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Pilot Zone |
      | Search         | Bulk       |
      | Page           | 2          |
    When the user goes to page 2 of the list
    And the user types 'Bulk' in the Rate Card Name search box
    And the user clicks 'Add'
    And the user enters Rate Card Name 'Pilot Zone' and click Save
    Then Rate Card is created
    And List is on page 1 and both column search boxes are empty
    And 'Pilot Zone' is shown as Sl. No. 1

  # Ref: US-7 AC-4; FRD 5.3 FB-1
  @TC_RC_019 @Functional @High @Automation
  Scenario: Verify a newly added Rate Card is placed at the top of the sequence and all others move down by one
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New Rate Card | Highland Zone |
    When the user notes the sequence of the 8 baseline Rate Cards
    And the user adds Rate Card 'Highland Zone'
    And the user compares the sequence
    Then 'Highland Zone' is Sl. No. 1
    And 'Coastal Region' moves from Sl. No. 1 to 2 and every other row moves down by one

  # Ref: FRD 5.2 BR-2; FRD 5.2 F-Name
  @TC_RC_020 @Functional @Medium @Automation
  Scenario: Verify leading and trailing spaces are removed from Rate Card Name on save
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | ' Foothill Zone ' |
    When the user clicks 'Add'
    And the user enters Rate Card Name with leading and trailing spaces
    And the user clicks Save
    And the user opens View of the new Rate Card
    Then Rate Card is saved and displayed as 'Foothill Zone' without leading/trailing spaces

  # Ref: FRD 5.2 BR-2; FRD 5.2 F-Name
  @TC_RC_021 @Functional @Medium @Automation
  Scenario: Verify a run of two or more internal spaces is reduced to one space on save
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | 'Foothill Zone' |
    When the user clicks 'Add'
    And the user enters Rate Card Name containing a run of internal spaces
    And the user clicks Save
    And the user observes the saved name in the list
    Then Rate Card is saved and displayed as 'Foothill Zone' (single space)

  # Ref: FRD 5.2 BR-4
  @TC_RC_022 @Functional @Medium @Automation
  Scenario: Verify Rate Card Name is saved with the letter case exactly as entered
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | sKy ZoNe |
    When the user clicks 'Add'
    And the user enters Rate Card Name in mixed case
    And the user clicks Save
    Then Rate Card is saved and displayed as 'sKy ZoNe' (case not altered)

  # Ref: US-2 AC-6; FRD 5.2 BR-4; FRD 5.2 F-Name
  @TC_RC_023 @Functional @High @Automation
  Scenario: Verify a Rate Card Name with special characters is saved exactly as entered and shown as plain text
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Plains (Zone-A) & <Hills> |
    When the user clicks 'Add'
    And the user enters Rate Card Name with special characters
    And the user clicks Save
    And the user observes the row in the list
    Then Rate Card is saved exactly as 'Plains (Zone-A) & <Hills>'
    And Name is displayed as plain text; no markup is interpreted

  # Ref: FRD 5.2 F-Name
  @TC_RC_024 @Functional @Medium @Automation
  Scenario: Verify a Rate Card Name of exactly 100 characters is accepted (boundary max)
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | 100 characters - 'A' repeated 100 times |
    When the user clicks 'Add'
    And the user enters a 100-character Rate Card Name
    And the user clicks Save
    Then Rate Card is saved with all 100 characters
    And Toaster 'Rate Card added successfully.' is displayed

  # Ref: FRD 5.2 F-Name
  @TC_RC_025 @Functional @Low @Automation
  Scenario: Verify a Rate Card Name of 99 characters is accepted (boundary max-1)
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | 99 characters - 'B' repeated 99 times |
    When the user clicks 'Add'
    And the user enters a 99-character Rate Card Name
    And the user clicks Save
    Then Rate Card is saved with all 99 characters

  # Ref: FRD 5.2 F-Name; FRD 5.2 BR-1
  @TC_RC_026 @Functional @Low @Automation
  Scenario: Verify a single-character Rate Card Name is accepted (boundary min)
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Z |
    When the user clicks 'Add'
    And the user enters a 1-character Rate Card Name
    And the user clicks Save
    Then Rate Card 'Z' is saved (no minimum length other than mandatory)

  # Ref: FRD 5.2 BR-4; FRD 5.2 F-Name
  @TC_RC_027 @Functional @Medium @Automation
  Scenario: Verify a Rate Card Name containing digits, symbols and quotes is accepted
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Region #5 / "Hill's" 2026 - 10% @ ₹ |
    When the user clicks 'Add'
    And the user enters the Rate Card Name
    And the user clicks Save
    Then Rate Card is saved exactly as entered (any characters are allowed)

  # Ref: FRD 5.2 FB-6
  @TC_RC_028 @Functional @Medium @Automation
  Scenario: Verify an error shown on Save is cleared as soon as the user corrects the value
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Valley Zone |
    When the user clicks 'Add'
    And the user leaves Rate Card Name blank and click Save
    And the user observes the error
    And the user types 'Valley Zone' in Rate Card Name
    Then After step 2 the error 'Rate Card Name is required.' is displayed
    And After step 4 the error message and red border disappear immediately, before clicking Save

  # Ref: FRD 5.2 FB-3
  @TC_RC_029 @Functional @Medium @Automation
  Scenario: Verify the required-name check is performed on the screen without a server request
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | (blank) |
    When the user opens browser network monitoring
    And the user clicks 'Add'
    And the user leaves Rate Card Name blank and click Save
    And the user inspects network calls
    Then Error 'Rate Card Name is required.' is displayed
    And No create/save request is sent to the server (screen validation runs first)

  # Ref: FRD 5.2 FB-8; FRD 5.2 F-Save
  @TC_RC_030 @Functional @High @Automation
  Scenario: Verify a single click on Save creates exactly one Rate Card and a double click cannot create two
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Twin Zone |
    When the user clicks 'Add'
    And the user enters Rate Card Name 'Twin Zone'
    And the user double-clicks Save quickly
    And the user checks the list and the Rate Card master
    Then Save is disabled while the save request is in progress
    And Only one 'Twin Zone' record exists
    And Only one Activity Log entry 'Rate Card Created' exists

  # Ref: US-2 AC-5; FRD 5.2 BR-5
  @TC_RC_031 @Functional @High @Automation
  Scenario: Verify migrated data has no two Rate Cards with the same name (case-insensitive, after trimming)
    Given Production-copy data after the go-live migration is loaded in the test database
    And the following test data is used
      | Query | group by lower(trim(Rate Card Name)) having count(*) > 1 |
    When the user runs a query grouping Rate Cards by LOWER(TRIM(name)) with count > 1
    Then The query returns 0 rows; every migrated Rate Card Name is unique

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-3; FRD 5.2 BR-1; FRD Sec 7 FieldError #1
  @TC_RC_142 @Negative @Medium @Automation
  Scenario: Verify a blank Rate Card Name is rejected on Add
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | (blank) |
    When the user clicks 'Add'
    And the user leaves Rate Card Name blank
    And the user clicks Save
    Then Field-level error 'Rate Card Name is required.' is displayed below the field
    And No Rate Card is created

  # Ref: US-2 AC-3; FRD 5.2 BR-2; FRD 5.2 F-Name
  @TC_RC_143 @Negative @Medium @Automation
  Scenario: Verify a spaces-only Rate Card Name is rejected on Add
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | ' ' (6 spaces) |
    When the user clicks 'Add'
    And the user enters only spaces in Rate Card Name
    And the user clicks Save
    Then Field-level error 'Rate Card Name is required.' is displayed
    And No Rate Card is created

  # Ref: FRD 5.2 FB-4
  @TC_RC_144 @Negative @Medium @Automation
  Scenario: Verify on a validation failure the pop-up stays open, the cursor stays in the field and the border is red
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | (blank) |
    When the user clicks 'Add'
    And the user leaves Rate Card Name blank and click Save
    And the user checks the pop-up, focus and field border
    Then The pop-up remains open
    And Focus remains in Rate Card Name
    And Field border is highlighted in red

  # Ref: FRD 5.2 FB-4; US-2 AC-4
  @TC_RC_145 @Negative @Medium @Automation
  Scenario: Verify the entered value is retained when Add fails with a duplicate-name error
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | ' sub mountanious ' |
    When the user clicks 'Add'
    And the user enters ' sub mountanious ' in Rate Card Name
    And the user clicks Save
    Then Error 'A Rate Card with this name already exists.' is displayed
    And The pop-up stays open and the entered value is retained in the field

  # Ref: FRD 5.2 FB-4; FRD Sec 7 TR-3
  @TC_RC_146 @Negative @Medium @Automation
  Scenario: Verify no toaster is displayed for a validation failure
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | (blank) |
    When the user clicks 'Add'
    And the user leaves Rate Card Name blank and click Save
    And the user observes the screen for 6 seconds
    Then Only the field-level error is displayed; no toaster appears

  # Ref: FRD 5.2 BR-3; FRD Sec 7 FieldError #2
  @TC_RC_147 @Negative @High @Automation
  Scenario: Verify a duplicate Rate Card Name with identical case is rejected on Add
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Sub Mountanious |
    When the user clicks 'Add'
    And the user enters an existing name
    And the user clicks Save
    Then Field-level error 'A Rate Card with this name already exists.' is displayed
    And No second 'Sub Mountanious' is created

  # Ref: FRD 5.2 BR-3; FRD Sec 7 FieldError #2
  @TC_RC_148 @Negative @High @Automation
  Scenario: Verify a duplicate Rate Card Name with different letter case is rejected on Add
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | SUB MOUNTANIOUS |
    When the user clicks 'Add'
    And the user enters the name in upper case
    And the user clicks Save
    Then Field-level error 'A Rate Card with this name already exists.' is displayed

  # Ref: US-2 AC-4; FRD 5.2 BR-3
  @TC_RC_149 @Negative @High @Automation
  Scenario: Verify ' sub mountanious ' (spaces and lower case) is rejected as a duplicate of 'Sub Mountanious'
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | ' sub mountanious ' |
    When the user clicks 'Add'
    And the user enters the name with leading/trailing spaces in lower case
    And the user clicks Save
    Then Field-level error 'A Rate Card with this name already exists.' is displayed

  # Ref: FRD 5.2 BR-2; FRD 5.2 BR-3
  @TC_RC_150 @Negative @High @Automation
  Scenario: Verify a name differing only by repeated internal spaces is rejected as a duplicate
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | 'Sub Mountanious' |
    When the user clicks 'Add'
    And the user enters the name with a run of internal spaces
    And the user clicks Save
    Then Field-level error 'A Rate Card with this name already exists.' is displayed (internal spaces are reduced to one before the uniqueness check)

  # Ref: FRD 5.2 F-Name
  @TC_RC_151 @Negative @Medium @Automation
  Scenario: Verify the Rate Card Name box does not accept more than 100 characters when typing
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed text | 'C' repeated 101 times |
    When the user clicks 'Add'
    And the user types 101 characters in Rate Card Name
    Then Typing stops at 100 characters; the box contains exactly 100 characters (max+1 rejected)

  # Ref: FRD 5.2 F-Name
  @TC_RC_152 @Negative @Medium @Automation
  Scenario: Verify pasted text longer than 100 characters is cut at 100 characters
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Pasted text | 'D' repeated 150 times |
    When the user clicks 'Add'
    And the user pastes a 150-character text into Rate Card Name
    And the user clicks Save
    Then Only the first 100 characters remain in the box and are saved

  # Ref: FRD 5.2 FB-3; FRD 5.2 BR-3; FRD 5.2 BR-8
  @TC_RC_153 @Negative @High @Automation
  Scenario: Verify the server rejects a duplicate name sent directly through the API (screen check bypassed)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1              |
      | Payload | {name:'sub mountanious'} |
    When the user sends a create-Rate Card request with the name of an existing Rate Card
    And the user checks the Rate Card master
    Then Request is rejected as a duplicate; no second record is created

  # Ref: FRD 5.2 BR-8; FRD 5.2 BR-1
  @TC_RC_154 @Negative @High @Automation
  Scenario: Verify the server rejects a blank name sent directly through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1 |
      | Payload | {name:' '}  |
    When the user sends a create-Rate Card request with a blank name
    And the user checks the Rate Card master
    Then Request is rejected; no Rate Card is created

  # Ref: FRD 5.2 BR-8; FRD 5.2 F-Name
  @TC_RC_155 @Negative @High @Automation
  Scenario: Verify the server rejects a name longer than 100 characters sent directly through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1       |
      | Payload | {name: 'E' x 101} |
    When the user sends a create-Rate Card request with a 101-character name
    And the user checks the Rate Card master
    Then Request is not saved with 101 characters (server-side validation; rejection text is not defined in the FRD - see Assumption A-6)

  # Ref: FRD 5.2 BR-8
  @TC_RC_156 @Negative @High @Automation
  Scenario: Verify a SQL-injection style name is stored as plain text and the Rate Card table stays intact
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Zone'; DROP TABLE RateCard;-- |
    When the user clicks 'Add'
    And the user enters the name and click Save
    And the user checks the list and the Rate Card master
    Then Rate Card is saved as the literal text and displayed as plain text
    And The Rate Card table and its other rows are unaffected (parameterized queries)

  # Ref: FRD 5.2 BR-8; US-2 AC-6
  @TC_RC_157 @Negative @High @Automation
  Scenario: Verify a script tag in Rate Card Name is shown as plain text and never executed in the list
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | <script>alert('x')</script> |
    When the user clicks 'Add'
    And the user enters the name and click Save
    And the user observes the list
    Then Text is displayed as plain text in the list
    And No alert or script execution occurs (HTML-encoded)

  # Ref: FRD 5.2 BR-8
  @TC_RC_158 @Negative @High @Automation
  Scenario: Verify a script tag in Rate Card Name is shown as plain text in the View pop-up
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data plus Rate Card '<script>alert(1)</script>' (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | <script>alert(1)</script> |
    When the user selects View on the row '<script>alert(1)</script>'
    Then Name is displayed as plain text; no script runs

  # Ref: FRD 5.2 BR-8
  @TC_RC_159 @Negative @Medium @Automation
  Scenario: Verify a Rate Card Name with markup is shown as plain text in the Edit pop-up field
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data plus Rate Card '<b>Bold</b> & "Q"' (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | <b>Bold</b> & "Q" |
    When the user selects Edit on the row '<b>Bold</b> & "Q"'
    Then Text box contains the literal text '<b>Bold</b> & "Q"'; no markup is rendered

  # Ref: FRD 5.2 BR-8; FRD 5.7 FB-1
  @TC_RC_160 @Negative @High @Automation
  Scenario: Verify a Rate Card Name with markup is shown as plain text in a dependent process selection
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Office Creation screen
    And Baseline data plus Rate Card '<img src=x onerror=alert(1)>' (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | <img src=x onerror=alert(1)> |
    When the user opens the Rate Card selection in Office Creation
    Then Option text is displayed as plain text; no script runs

  # Ref: FRD 5.2 BR-8; FRD 5.6 BR-5
  @TC_RC_161 @Negative @Medium @Automation
  Scenario: Verify office names containing markup are shown as plain text in Associated Offices
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data plus office '<b>Patiala</b>' associated with 'Coastal Region' (see Summary) is loaded
    And the following test data is used
      | Office | <b>Patiala</b> |
    When the user observes the Associated Offices cell of 'Coastal Region'
    And the user opens View of 'Coastal Region'
    Then Office name is displayed as the literal text '<b>Patiala</b>' in the grid and in View; no bold rendering

  # Ref: FRD 5.2 FB-7; FRD 5.2 F-Cancel
  @TC_RC_162 @Negative @Medium @Automation
  Scenario: Verify Cancel on the Add pop-up creates no record and no Activity Log entry
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Draft Zone |
    When the user clicks 'Add'
    And the user enters Rate Card Name 'Draft Zone'
    And the user clicks 'Cancel'
    And the user checks the list and Activity Log
    Then Pop-up closes
    And 'Draft Zone' is not created and no Activity Log entry exists

  # Ref: FRD 5.2 FB-7
  @TC_RC_163 @Negative @Medium @Automation
  Scenario: Verify the close (X) icon on the Add pop-up creates no record and no Activity Log entry
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Draft Zone |
    When the user clicks 'Add'
    And the user enters Rate Card Name 'Draft Zone'
    And the user clicks the close (X) icon
    And the user checks the list and Activity Log
    Then Pop-up closes
    And 'Draft Zone' is not created and no Activity Log entry exists

  # Ref: FRD 5.2 BR-6; FRD 5.6 BR-1
  @TC_RC_164 @Negative @High @Automation
  Scenario: Verify Associated Offices sent in a create request is ignored
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1                                      |
      | Payload | {name:'Api Zone', associatedOffices:['Patiala']} |
    When the user sends a create-Rate Card request with an Associated Offices value
    And the user views the created Rate Card
    Then Rate Card 'Api Zone' is created with no associated offices ('No offices associated yet'); the office 'Patiala' stays with its Rate Card

  # Ref: FRD 5.2 BR-7
  @TC_RC_165 @Negative @High @Automation
  Scenario: Verify the Internal ID cannot be supplied or changed through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1                             |
      | Payload | {internalId:'RC-9999', name:'Api Zone'} |
    When the user sends a create-Rate Card request with an Internal ID value
    And the user sends an update request changing the Internal ID of 'Hill Zone'
    Then The supplied Internal ID is ignored/rejected; the system generates its own ID and the Internal ID of 'Hill Zone' is unchanged
