@RateCard @RateCardDeletion
Feature: Rate Card Deletion
  Automated scenarios for the "Rate Card Deletion" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-9 AC-1; FRD 5.8 FB-1; FRD 5.8 FB-4; FRD 5.8 DR-2
  @TC_RC_101 @Functional @High @Automation
  Scenario: Verify the confirmation dialog is shown for an unused Rate Card with the exact text and Yes/No buttons
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region (unused) |
    When the user selects Delete from the kebab menu of 'Coastal Region'
    And the user reads the dialog
    Then Dialog shows: Are you sure you want to delete the Rate Card “Coastal Region”?
    And Buttons 'Yes' and 'No' are displayed

  # Ref: US-9 AC-2; FRD 5.8 FB-5; FRD 5.8 BR-2; FRD Sec 7 Toaster #3
  @TC_RC_102 @Functional @High @Automation
  Scenario: Verify clicking Yes deletes the Rate Card, shows the toaster and re-sequences Sl. No.
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region |
    When the user selects Delete from the kebab menu of 'Coastal Region'
    And the user clicks Yes
    Then Toaster 'Rate Card deleted successfully.' is displayed
    And 'Coastal Region' is removed and Sl. No. is re-sequenced 1 to 7

  # Ref: FRD 5.8 FB-5
  @TC_RC_103 @Functional @Medium @Automation
  Scenario: Verify the previous page is shown when the deleted Rate Card was the only record on the last page
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Dataset DS-101 (101 Rate Cards; page 3 holds one Rate Card) (see Summary) is loaded
    And the following test data is used
      | Records | 101 |
      | Page    | 3   |
    When the user goes to page 3
    And the user deletes its only Rate Card and click Yes
    Then Page 3 no longer exists; page 2 is displayed with indicator '2 / 2'

  # Ref: US-9 AC-5; FRD 5.8 BR-4
  @TC_RC_104 @Functional @High @Automation
  Scenario: Verify the name of a deleted Rate Card can be used again for a new Rate Card
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card Name | Coastal Region |
    When the user deletes 'Coastal Region' (Yes)
    And the user clicks 'Add', enter 'Coastal Region' and Save
    Then Rate Card is created and toaster 'Rate Card added successfully.' is displayed (no duplicate error)

  # Ref: FRD 5.8 BR-4
  @TC_RC_105 @Functional @Medium @Automation
  Scenario: Verify deletion is permanent
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region |
    When the user deletes 'Coastal Region' (Yes)
    And the user searches the Rate Card master for the record
    Then The record no longer exists in the master (hard delete); it cannot be restored from the screen

  # Ref: FRD 5.8 FB-2; US-8 AC-3
  @TC_RC_106 @Functional @High @Automation
  Scenario: Verify the dependency check is performed again when Delete is selected (Rate Card became used after list load)
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Desert Zone |
      | Office    | Samana-2    |
    When the user keeps the list open
    And In another session, create office 'Samana-2' with Rate Card 'Desert Zone'
    And In the first session, select Delete on 'Desert Zone' without refreshing
    Then Deletion is blocked with 'This Rate Card is used in one or more transactions and cannot be deleted.'
    And Confirmation dialog is not displayed

  # Ref: FRD 5.8 FB-4; FRD 5.2 BR-8
  @TC_RC_107 @Functional @Medium @Automation
  Scenario: Verify the delete confirmation shows plain-text names (name is not interpreted as markup)
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data plus unused Rate Card named 'Plains (Zone-A) & <Hills>' (see Summary) is loaded
    And the following test data is used
      | Rate Card | Plains (Zone-A) & <Hills> |
    When the user selects Delete from the kebab menu of 'Plains (Zone-A) & <Hills>'
    Then Dialog reads: Are you sure you want to delete the Rate Card “Plains (Zone-A) & <Hills>”? with the name shown as plain text

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-8 AC-2; FRD 5.8 FB-2; FRD 5.8 FB-3; FRD Sec 7 Toaster #4
  @TC_RC_175 @Negative @High @Automation
  Scenario: Verify deletion is blocked for a Rate Card whose only link is one associated office
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Single Office Card |
      | Office    | Amritsar           |
    When the user selects Delete on 'Single Office Card' (office Amritsar)
    Then Error toaster 'This Rate Card is used in one or more transactions and cannot be deleted.' is displayed
    And Confirmation dialog is not displayed and the Rate Card remains

  # Ref: US-8 AC-2; FRD 5.8 DR-1
  @TC_RC_176 @Negative @High @Automation
  Scenario: Verify deletion is blocked for a Rate Card associated with several offices
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Sub Mountanious |
    When the user selects Delete on 'Sub Mountanious' (4 offices)
    Then Error toaster 'This Rate Card is used in one or more transactions and cannot be deleted.' is displayed
    And No confirmation dialog is displayed and the Rate Card remains

  # Ref: US-8 AC-1; FRD 5.8 BR-1; FRD 5.8 DR-1; FRD 5.7 BR-2; FRD 5.7 BR-3
  @TC_RC_177 @Negative @High @Automation
  Scenario: Verify deletion is blocked for a Rate Card used in a Resource Rate record in Draft status
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card     | Hill Zone      |
      | Resource Rate | RR-001 (Draft) |
    When the user selects Delete on 'Hill Zone' (used in Resource Rate RR-001, status Draft)
    Then Error toaster 'This Rate Card is used in one or more transactions and cannot be deleted.' is displayed
    And No confirmation dialog is displayed (record status does not matter)

  # Ref: US-8 AC-1; FRD 5.8 BR-1; FRD 5.7 BR-2
  @TC_RC_178 @Negative @High @Automation
  Scenario: Verify deletion is blocked for a Rate Card used in an Approved Item record
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Item Rate Card     |
      | Item      | ITM-001 (Approved) |
    When the user selects Delete on 'Item Rate Card' (used in Item ITM-001, status Approved)
    Then Error toaster 'This Rate Card is used in one or more transactions and cannot be deleted.' is displayed and no confirmation dialog appears

  # Ref: US-8 AC-1; FRD 5.8 BR-1; FRD 5.7 BR-2
  @TC_RC_179 @Negative @High @Automation
  Scenario: Verify deletion is blocked for a Rate Card used in a Lead Rate record
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Lead Rate Card |
      | Lead Rate | LR-001         |
    When the user selects Delete on 'Lead Rate Card' (used in Lead Rate LR-001)
    Then Error toaster 'This Rate Card is used in one or more transactions and cannot be deleted.' is displayed and no confirmation dialog appears

  # Ref: FRD 5.8 DR-4; US-8 AC-3; FRD 5.8 FB-5
  @TC_RC_180 @Negative @High @Automation
  Scenario: Verify the server blocks the deletion if the Rate Card became used between Delete click and Yes
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region |
      | Office    | Samana-2       |
    When the user selects Delete on 'Coastal Region' so that the confirmation dialog is displayed
    And In another session create office 'Samana-2' with Rate Card 'Coastal Region'
    And the user clicks Yes in the first session
    Then Server check blocks the deletion and shows 'This Rate Card is used in one or more transactions and cannot be deleted.'
    And 'Coastal Region' remains in the list

  # Ref: US-9 AC-3; FRD 5.8 FB-6; FRD 5.8 DR-3
  @TC_RC_181 @Negative @High @Automation
  Scenario: Verify clicking No on the confirmation dialog leaves the Rate Card unchanged and creates no deletion entry
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region |
    When the user selects Delete on 'Coastal Region'
    And the user clicks 'No'
    And the user checks the list and Activity Log
    Then Dialog closes; 'Coastal Region' remains unchanged
    And No 'Rate Card Deleted' entry exists in the Activity Log

  # Ref: US-9 AC-3; FRD 5.8 FB-6; FRD 5.8 DR-3
  @TC_RC_182 @Negative @Medium @Automation
  Scenario: Verify closing the confirmation dialog with the X icon leaves the Rate Card unchanged
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region |
    When the user selects Delete on 'Coastal Region'
    And the user clicks the close (X) icon of the dialog
    Then Dialog closes; 'Coastal Region' remains; no deletion entry is recorded

  # Ref: FRD 5.8 FB-6; US-9 AC-3
  @TC_RC_183 @Negative @Medium @Automation
  Scenario: Verify pressing Esc on the confirmation dialog leaves the Rate Card unchanged
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region |
    When the user selects Delete on 'Coastal Region'
    And the user presses Esc
    Then Dialog closes; 'Coastal Region' remains; no deletion entry is recorded

  # Ref: FRD 5.8 FB-7
  @TC_RC_184 @Negative @Medium @Automation
  Scenario: Verify deleting a Rate Card already deleted by another user refreshes the list without a toaster
    Given Admin_User1 and Admin_User2 are logged in in two sessions
    And Baseline data (see Summary) is loaded and both are on the Rate Card List page
    And the following test data is used
      | Rate Card | Coastal Region |
    When In session 2 delete 'Coastal Region' (Yes)
    And In session 1 (without refreshing) select Delete on 'Coastal Region'
    Then The list is refreshed and 'Coastal Region' is gone
    And No toaster message is displayed

  # Ref: FRD 5.8 BR-1; US-8 AC-3
  @TC_RC_185 @Negative @High @Automation
  Scenario: Verify the delete API rejects a Rate Card that is used in a transaction
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User      | Admin_User1 |
      | Rate Card | Hill Zone   |
    When the user sends a delete request for 'Hill Zone' (used in RR-001)
    And the user checks the Rate Card master
    Then Request is rejected by the dependency check; 'Hill Zone' still exists
