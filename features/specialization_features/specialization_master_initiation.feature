@Specialization @SpecializationMasterInitiation
Feature: Specialization Master Initiation
  Automated scenarios for the "Specialization Master Initiation" module of Specialization.
  Source: CivitINFRA_Specialization_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-001_CivitINFRA Configuration_Specialization Master.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-1; FRD 5.1 FB-1; FRD 5.1 FB-2
  @TC_SP_001 @Functional @High @Automation
  Scenario: Verify Specialization screen loads with the first Misc Type selected and its entry list
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Admin_User1                            |
      | Path | Admin > Configuration > Specialization |
    When the user clicks Admin in the left navigation tree
    And the user clicks Configuration > Specialization
    And the user observes the Misc Type dropdown and the list below it
    Then Screen opens with the Misc Type dropdown at the top showing 'List of Title' (first Misc Type) selected
    And The Specialization Entry List of 'List of Title' (7 entries) is displayed below the dropdown

  # Ref: US-1 AC-2; FRD 5.3 FB-1
  @TC_SP_002 @Functional @High @Automation
  Scenario: Verify Misc Type dropdown lists only Display-checked Titles in Miscellaneous Master order
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded. 'List of Department' has Display unchecked in the Miscellaneous Master
    And the following test data is used
      | Data              | Display-checked Titles in Misc Master order: List of Title, List of Firm Type, List of Grade, List of Qualification |
      | Display-unchecked | List of Department                                                                                                  |
    When the user clicks the Misc Type dropdown
    And the user reads the options in the order shown
    Then Options are exactly: List of Title, List of Firm Type, List of Grade, List of Qualification, in that order
    And 'List of Department' is not listed

  # Ref: US-1 AC-3; FRD 5.3 FB-1
  @TC_SP_003 @Functional @High @Automation
  Scenario: Verify changing Misc Type reloads the list on page 1 with column search cleared
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Qualification' selected
    And Baseline data (see Summary) is loaded
    And Misc Type 'List of Qualification' is selected, Next page was clicked (page 2) and 'Q1' was typed in the Code column search
    And the following test data is used
      | Misc Type       | List of Grade |
      | Previous search | Code = Q1     |
    When the user selects 'List of Grade' in the Misc Type dropdown
    And the user observes the list, page indicator and column search boxes
    Then List reloads with the Specialization Entries of 'List of Grade' only
    And List is on page 1
    And Code, Name and Remark search boxes are empty

  # Ref: US-1 AC-7; FRD 5.1 FB-3
  @TC_SP_004 @Functional @High @Automation
  Scenario: Verify kebab menu on a row offers View, Edit and Delete to a fully permitted user
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row  | Mr.         |
      | User | Admin_User1 |
    When the user clicks the kebab (⋮) icon on the row 'Mr.'
    And the user reads the menu options
    Then Menu shows View, Edit and Delete

  # Ref: FRD 5.1 FB-4
  @TC_SP_005 @Functional @Medium @Automation
  Scenario: Verify clicking outside an open kebab menu closes it without any action
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Mr. |
    When the user clicks the kebab icon on row 'Mr.'
    And the user clicks on an empty area outside the menu
    And the user observes the menu and the list
    Then Kebab menu closes
    And No pop-up opens and no data changes

  # Ref: FRD 5.1 FB-4
  @TC_SP_006 @Functional @Medium @Automation
  Scenario: Verify pressing Esc closes an open kebab menu without any action
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Row | Mr. |
      | Key | Esc |
    When the user clicks the kebab icon on row 'Mr.'
    And the user presses Esc
    And the user observes the menu and the list
    Then Kebab menu closes
    And No pop-up opens and no data changes

  # Ref: FRD 5.1 FB-4
  @TC_SP_007 @Functional @Medium @Automation
  Scenario: Verify only one kebab menu can be open at a time
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rows | Mr., Mrs. |
    When the user clicks the kebab icon on row 'Mr.'
    And the user clicks the kebab icon on row 'Mrs.' without closing the first menu
    And the user counts the open menus
    Then Only the menu of row 'Mrs.' is open; the menu of row 'Mr.' is closed

  # Ref: FRD 5.6 BR-4
  @TC_SP_008 @Functional @Medium @Automation
  Scenario: Verify Misc Type dropdown shows a renamed Title the next time the screen is opened
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in and on the Specialization screen with Misc Type 'List of Title' selected
    And Baseline data (see Summary) is loaded
    And In the Miscellaneous Master, Title 'List of Firm Type' is renamed to 'List of Firm Types'
    And the following test data is used
      | Old name | List of Firm Type  |
      | New name | List of Firm Types |
    When the user opens Admin > Configuration > Specialization
    And the user clicks the Misc Type dropdown
    Then Dropdown shows 'List of Firm Types' in place of 'List of Firm Type'

  # Ref: FRD 5.6 BR-3
  @TC_SP_009 @Functional @High @Automation
  Scenario: Verify a Title with Specialization Entries cannot be deleted in the Miscellaneous Master
    Given Admin_User1 (Specialization: View/Add/Edit/Delete) is logged in
    And Baseline data (see Summary) is loaded
    And Admin_User1 also has Delete permission in the Miscellaneous Master (CIC-F-003)
    And the following test data is used
      | Title | List of Title |
    When the user opens the Miscellaneous Master
    And the user attempts to delete the Title 'List of Title' (7 Specialization Entries)
    Then Title is treated as 'mapped in Specialization Master' and is not deleted (message text is defined in CIC-F-003, not in this FRD)
