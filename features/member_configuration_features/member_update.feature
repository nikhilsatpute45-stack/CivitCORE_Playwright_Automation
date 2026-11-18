@MembersConfiguration @MemberUpdate
Feature: Member Update
  Automated scenarios for the "Member Update" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-1; FRD 5.4 FB-1; FRD 5.4 FB-2; FRD 5.4 F-ProductEnum; FRD 5.4 F-MemberName
  @TC_MC_054 @Functional @High @Automation
  Scenario: Verify Edit opens the Edit Member pop-up with read-only Product Enum and Member Name and pre-filled editable fields
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | RepairAndMaintenance |
    When the user clicks the kebab (⋮) icon of member 'RepairAndMaintenance'
    And the user selects 'Edit'
    And the user observes the pop-up
    Then 'Edit Member' pop-up opens
    And Product Enum 'Proposal Nature' and Member Name 'RepairAndMaintenance' are read-only
    And Description is pre-filled 'AMC' and editable; Active is pre-filled checked and editable
    And Buttons 'Save' and 'Cancel' are shown

  # Ref: US-3 AC-2; FRD 5.4 FB-5; FRD Sec 7 Toaster #1
  @TC_MC_055 @Functional @High @Automation
  Scenario: Verify a valid new Description is saved, the pop-up closes and the success toaster is displayed
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | RepairAndMaintenance               |
      | Description | AMC -> Annual Maintenance Contract |
    When the user clicks the kebab (⋮) icon of member 'RepairAndMaintenance'
    And the user selects 'Edit'
    And the user replaces Description with the new value
    And the user clicks 'Save'
    Then Changes are saved and the pop-up closes
    And Toaster 'Member updated successfully.' is displayed
    And List shows 'Annual Maintenance Contract' for the member

  # Ref: FRD 5.4 FB-5
  @TC_MC_056 @Functional @High @Automation
  Scenario: Verify Last Modified By and Last Modified On are recorded after a successful Edit
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Consultancy                         |
      | Description | Consultancy -> Consultancy Services |
    When the user clicks the kebab (⋮) icon of member 'Consultancy'
    And the user selects 'Edit'
    And the user replaces Description with the new value
    And the user clicks 'Save'
    And the user opens 'View' for 'Consultancy'
    Then Last Modified By shows 'Admin_User1' and Last Modified On shows the save date-time

  # Ref: FRD 5.4 FB-5; US-3 AC-2
  @TC_MC_057 @Functional @Medium @Automation
  Scenario: Verify the Edit refreshes the list showing the new Description
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Project                    |
      | Description | Project -> Capital Project |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user replaces Description with the new value
    And the user clicks 'Save'
    And the user observes the list
    Then List is refreshed and the row 'Project' shows 'Capital Project'; Member Name is still 'Project'

  # Ref: US-3 AC-6; FRD 5.4 FB-6
  @TC_MC_058 @Functional @High @Automation
  Scenario: Verify Save with no change closes the pop-up without a toaster
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project          |
      | Data   | No field changed |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user does not change any field
    And the user clicks 'Save'
    Then Pop-up closes
    And No toaster is displayed

  # Ref: US-3 AC-6; FRD 5.4 FB-6
  @TC_MC_059 @Functional @High @Automation
  Scenario: Verify Save with no change does not update the record or write an Activity Log entry
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Last Modified On of 'Project' and its Activity Log entry count are noted
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project          |
      | Data   | No field changed |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user does not change any field
    And the user clicks 'Save'
    And the user checks the record and, as Auditor_User1, the Activity Log
    Then Record is not updated: Last Modified By/On are unchanged
    And No Activity Log entry is created

  # Ref: US-3 AC-7; FRD 5.4 FB-7; FRD 5.4 F-Cancel
  @TC_MC_060 @Functional @High @Automation
  Scenario: Verify Cancel closes the Edit pop-up without saving
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member            | Project         |
      | Typed Description | Capital Project |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user changes Description to 'Capital Project'
    And the user clicks 'Cancel'
    Then Pop-up closes
    And Description of 'Project' is still 'Project'; no toaster and no Activity Log entry

  # Ref: US-3 AC-7; FRD 5.4 FB-7
  @TC_MC_061 @Functional @High @Automation
  Scenario: Verify the close (X) icon closes the Edit pop-up without saving
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member            | Project         |
      | Typed Description | Capital Project |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user changes Description to 'Capital Project'
    And the user clicks the close (X) icon
    Then Pop-up closes
    And Description of 'Project' is still 'Project'; no toaster and no Activity Log entry

  # Ref: FRD 5.4 F-Desc; FRD 5.4 BR-2
  @TC_MC_062 @Functional @Medium @Automation
  Scenario: Verify a Description of 1 character is accepted (minimum boundary)
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others |
      | Description | X      |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with 'X'
    And the user clicks 'Save'
    Then Saved; toaster 'Member updated successfully.' is displayed and list shows 'X'

  # Ref: FRD 5.4 F-Desc
  @TC_MC_063 @Functional @Medium @Automation
  Scenario: Verify a Description of 99 characters is accepted (max-1 boundary)
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others                         |
      | Description | 'D' repeated 99 times (D x 99) |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with the 99-character value
    And the user clicks 'Save'
    Then Saved; toaster 'Member updated successfully.' is displayed and the full 99 characters are stored

  # Ref: FRD 5.4 F-Desc
  @TC_MC_064 @Functional @High @Automation
  Scenario: Verify a Description of exactly 100 characters is accepted (maximum boundary)
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others                           |
      | Description | 'D' repeated 100 times (D x 100) |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with the 100-character value
    And the user clicks 'Save'
    Then Saved; toaster 'Member updated successfully.' is displayed and all 100 characters are stored

  # Ref: FRD 5.4 BR-2
  @TC_MC_065 @Functional @High @Automation
  Scenario: Verify leading and trailing spaces are removed from Description before saving
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Others                               |
      | Typed  | ' Other Works ' (3 spaces each side) |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with the value that has leading and trailing spaces
    And the user clicks 'Save'
    Then Stored Description is 'Other Works' without leading or trailing spaces; list shows 'Other Works'

  # Ref: FRD 5.4 BR-2
  @TC_MC_066 @Functional @High @Automation
  Scenario: Verify a run of two or more internal spaces is reduced to one space
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Others                                           |
      | Typed  | 'Other Works Contract' (4 and 3 internal spaces) |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with the value that has repeated internal spaces
    And the user clicks 'Save'
    Then Stored Description is 'Other Works Contract' (single spaces)

  # Ref: FRD 5.4 BR-3
  @TC_MC_067 @Functional @Medium @Automation
  Scenario: Verify Description accepts special characters
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others                                |
      | Description | R&M / O#2 (50%) @Site-A! ~$^*_+=;:,.? |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with the special-character value
    And the user clicks 'Save'
    Then Saved with all special characters as entered; toaster 'Member updated successfully.' is displayed

  # Ref: FRD 5.4 BR-3
  @TC_MC_068 @Functional @Medium @Automation
  Scenario: Verify Description is saved with the letter case exactly as entered
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others      |
      | Description | aMc ReNeWaL |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with the mixed-case value
    And the user clicks 'Save'
    Then Stored and displayed Description is 'aMc ReNeWaL' with no case conversion

  # Ref: US-3 AC-5; FRD 5.4 BR-4
  @TC_MC_069 @Functional @High @Automation
  Scenario: Verify the same Description is allowed in a different Product Enum
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'Proposal Classification' has member Government with Description 'Government'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum        | Proposal Nature |
      | Member      | Modernization   |
      | Description | Government      |
    When the user clicks the kebab (⋮) icon of member 'Modernization'
    And the user selects 'Edit'
    And the user replaces Description with 'Government'
    And the user clicks 'Save'
    Then Saved; toaster 'Member updated successfully.' is displayed
    And Both enums now have a member described 'Government'

  # Ref: FRD 5.4 BR-4; FRD 5.4 BR-3
  @TC_MC_070 @Functional @High @Automation
  Scenario: Verify changing only the letter case of a member's own Description is allowed (own record excluded from duplicate check)
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | RepairAndMaintenance |
      | Description | AMC -> amc           |
    When the user clicks the kebab (⋮) icon of member 'RepairAndMaintenance'
    And the user selects 'Edit'
    And the user replaces Description 'AMC' with 'amc'
    And the user clicks 'Save'
    Then Saved; the member is not treated as a duplicate of itself
    And Toaster 'Member updated successfully.' is displayed and list shows 'amc'

  # Ref: US-4 AC-2; FRD 5.4 F-Active; FRD Sec 7 Toaster #1
  @TC_MC_071 @Functional @High @Automation
  Scenario: Verify Active can be changed through the Edit pop-up with the update toaster
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project              |
      | Active | checked -> unchecked |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user unchecks 'Active'
    And the user clicks 'Save'
    Then Member is saved as inactive
    And Toaster 'Member updated successfully.' (not the list toaster) is displayed
    And List shows the Active checkbox unchecked

  # Ref: FRD 5.4 FB-5; US-7 AC-2
  @TC_MC_072 @Functional @High @Automation
  Scenario: Verify Description and Active can be changed together in one save
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Others                  |
      | Description | Others -> Miscellaneous |
      | Active      | checked -> unchecked    |
    When the user clicks the kebab (⋮) icon of member 'Others'
    And the user selects 'Edit'
    And the user replaces Description with 'Miscellaneous'
    And the user unchecks 'Active'
    And the user clicks 'Save'
    Then Both changes are saved with one toaster 'Member updated successfully.'
    And List shows 'Miscellaneous' with Active unchecked

  # Ref: FRD 5.4 FB-8; FRD 5.4 F-Save
  @TC_MC_073 @Functional @Medium @Automation
  Scenario: Verify Save is disabled only while the save request is in progress
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Network is throttled so the save request takes about 5 seconds
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Project         |
      | Description | Capital Project |
      | Latency     | 5 s             |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user changes Description to 'Capital Project'
    And the user clicks 'Save'
    And the user observes the Save button during the request
    And the user waits for the request to finish
    Then Save is disabled while the request is in progress (prevents a second submit)
    And After completion the pop-up closes and Save is not left disabled

  # Ref: FRD 5.4 FB-3
  @TC_MC_074 @Functional @Medium @Automation
  Scenario: Verify the Description is validated on the screen before the server request is sent
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Browser network log is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Project |
      | Description | (blank) |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user clears the Description field
    And the user clicks 'Save'
    And the user checks the network log
    Then Error 'Description is required.' appears without any save request reaching the server (screen validation first)

  # Ref: FRD 5.4 FB-5
  @TC_MC_075 @Functional @Medium @Automation
  Scenario: Verify a saved Description is still shown after reloading the screen
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member      | Project         |
      | Description | Capital Project |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user replaces Description with 'Capital Project'
    And the user clicks 'Save'
    And the user reloads the browser page and reopen Members Configuration
    Then 'Project' shows 'Capital Project' after reload (change is persisted)
