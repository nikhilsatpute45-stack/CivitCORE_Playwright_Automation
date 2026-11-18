@StandardsFormats @StandardsFormatsDeletion
Feature: Standards & Formats Deletion
  Automated scenarios for the "Standards & Formats Deletion" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-5 AC-1; FRD 6.7 FB-1; FRD 6.7 FB-5; FRD 6.7 DT-3; FRD 6.7 BR-2; FRD Sec 8 Toaster #7; FRD Fig 3
  @TC_SF_131 @Functional @High @Automation
  Scenario: Verify a Quantity configuration with no Organization selection is deleted after confirmation
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Spare Quantity (QF-0003) - not selected by any Organization |
    When the user clicks Delete against 'Spare Quantity'
    And the user observes the confirmation dialog
    And the user confirms the deletion
    Then The configuration is deleted and removed from the Quantity list
    And Toaster 'Quantity format deleted successfully.' is displayed

  # Ref: US-4 AC-1; FRD 6.7 FB-3; FRD 6.7 DT-1; FRD 6.7 BR-1; FRD 6.7 BR-4; FRD Sec 8 Toaster #10; FRD Fig 3
  @TC_SF_132 @Functional @High @Automation
  Scenario: Verify deleting a Quantity configuration that is selected by an Organization is blocked
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in. 'Standard Quantity' (QF-0001) is selected by ORG-001
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record     | Standard Quantity (QF-0001) |
      | Dependency | ORG-001                     |
    When the user clicks Delete against 'Standard Quantity'
    And the user observes the message and whether a confirmation dialog opens
    Then Deletion is blocked
    And Toaster 'This Format cannot be deleted as it is in use by Organizations.' is displayed
    And No delete confirmation dialog is displayed
    And The record remains in the list

  # Ref: US-5 AC-2; FRD 6.7 FB-6; FRD 6.7 DT-4
  @TC_SF_133 @Functional @High @Automation
  Scenario: Verify cancelling the delete confirmation retains the Quantity configuration unchanged
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Euro Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Euro Quantity (QF-0002) - no Organization selection |
    When the user clicks Delete against 'Euro Quantity'
    And the user clicks Cancel in the confirmation dialog
    And the user opens 'Euro Quantity' in View mode
    Then The configuration is not deleted and remains in the list
    And Its values are unchanged and no success toaster is shown

  # Ref: US-5 AC-1; FRD 6.7 FB-1; FRD 6.7 FB-5; FRD 6.7 DT-3; FRD 6.7 BR-2; FRD Sec 8 Toaster #8; FRD Fig 3
  @TC_SF_134 @Functional @High @Automation
  Scenario: Verify a Currency configuration with no Organization selection is deleted after confirmation
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Currency' exists in the Currency tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Spare Currency (CF-0003) - not selected by any Organization |
    When the user clicks Delete against 'Spare Currency'
    And the user observes the confirmation dialog
    And the user confirms the deletion
    Then The configuration is deleted and removed from the Currency list
    And Toaster 'Currency format deleted successfully.' is displayed

  # Ref: US-4 AC-1; FRD 6.7 FB-3; FRD 6.7 DT-1; FRD 6.7 BR-1; FRD 6.7 BR-4; FRD Sec 8 Toaster #10; FRD Fig 3
  @TC_SF_135 @Functional @High @Automation
  Scenario: Verify deleting a Currency configuration that is selected by an Organization is blocked
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in. 'Standard Currency' (CF-0001) is selected by ORG-001
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record     | Standard Currency (CF-0001) |
      | Dependency | ORG-001                     |
    When the user clicks Delete against 'Standard Currency'
    And the user observes the message and whether a confirmation dialog opens
    Then Deletion is blocked
    And Toaster 'This Format cannot be deleted as it is in use by Organizations.' is displayed
    And No delete confirmation dialog is displayed
    And The record remains in the list

  # Ref: US-5 AC-2; FRD 6.7 FB-6; FRD 6.7 DT-4
  @TC_SF_136 @Functional @High @Automation
  Scenario: Verify cancelling the delete confirmation retains the Currency configuration unchanged
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Euro Currency' exists in the Currency tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Euro Currency (CF-0004) - no Organization selection |
    When the user clicks Delete against 'Euro Currency'
    And the user clicks Cancel in the confirmation dialog
    And the user opens 'Euro Currency' in View mode
    Then The configuration is not deleted and remains in the list
    And Its values are unchanged and no success toaster is shown

  # Ref: US-5 AC-1; FRD 6.7 FB-1; FRD 6.7 FB-5; FRD 6.7 DT-3; FRD 6.7 BR-2; FRD Sec 8 Toaster #9; FRD Fig 3
  @TC_SF_137 @Functional @High @Automation
  Scenario: Verify a Date & Time configuration with no Organization selection is deleted after confirmation
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Spare Date Time' exists in the Date Time tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Spare Date Time (DF-0003) - not selected by any Organization |
    When the user clicks Delete against 'Spare Date Time'
    And the user observes the confirmation dialog
    And the user confirms the deletion
    Then The configuration is deleted and removed from the Date Time list
    And Toaster 'Date & Time format deleted successfully.' is displayed

  # Ref: US-4 AC-1; FRD 6.7 FB-3; FRD 6.7 DT-1; FRD 6.7 BR-1; FRD 6.7 BR-4; FRD Sec 8 Toaster #10; FRD Fig 3
  @TC_SF_138 @Functional @High @Automation
  Scenario: Verify deleting a Date & Time configuration that is selected by an Organization is blocked
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in. 'Standard Date Time' (DF-0001) is selected by ORG-001
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record     | Standard Date Time (DF-0001) |
      | Dependency | ORG-001                      |
    When the user clicks Delete against 'Standard Date Time'
    And the user observes the message and whether a confirmation dialog opens
    Then Deletion is blocked
    And Toaster 'This Format cannot be deleted as it is in use by Organizations.' is displayed
    And No delete confirmation dialog is displayed
    And The record remains in the list

  # Ref: US-5 AC-2; FRD 6.7 FB-6; FRD 6.7 DT-4
  @TC_SF_139 @Functional @High @Automation
  Scenario: Verify cancelling the delete confirmation retains the Date & Time configuration unchanged
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Euro Date Time' exists in the Date Time tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | Euro Date Time (DF-0004) - no Organization selection |
    When the user clicks Delete against 'Euro Date Time'
    And the user clicks Cancel in the confirmation dialog
    And the user opens 'Euro Date Time' in View mode
    Then The configuration is not deleted and remains in the list
    And Its values are unchanged and no success toaster is shown

  # Ref: FRD 6.7 FB-4; FRD 6.7 DT-2; FRD 6.7 BR-2
  @TC_SF_140 @Functional @High @Automation
  Scenario: Verify a delete confirmation dialog with confirm and cancel choices is displayed when no dependency exists
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And Record 'Euro Quantity' exists in the Quantity tab
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0002 |
    When the user clicks Delete against 'Euro Quantity'
    And the user observes the dialog
    Then A delete confirmation dialog is displayed allowing the user to confirm or cancel. Note: Dialog wording is not defined in the FRD (OQ-13)

  # Ref: FRD 6.6 BR-4; FRD 6.7 BR-1; FRD Sec 8 Toaster #10
  @TC_SF_141 @Functional @High @Automation
  Scenario: Verify a configuration selected by two Organizations stays blocked from deletion
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And QF-0001 is selected by ORG-001 and ORG-002
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record     | QF-0001          |
      | Dependency | ORG-001, ORG-002 |
    When the user clicks Delete against 'Standard Quantity'
    Then Toaster 'This Format cannot be deleted as it is in use by Organizations.' is displayed and deletion is blocked; no dialog

  # Ref: FRD 6.6 BR-4; FRD 6.7 BR-1
  @TC_SF_142 @Functional @High @Automation
  Scenario: Verify a configuration remains blocked while at least one Organization still selects it
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And QF-0001 is selected by ORG-001 and ORG-002
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record               | QF-0001 |
      | Remaining dependency | ORG-001 |
    When the user edits ORG-002 and change Quantity to 'Euro Quantity'
    And the user saves
    And the user clicks Delete against 'Standard Quantity'
    Then Deletion is still blocked because ORG-001 selects QF-0001

  # Ref: FRD 6.7 BR-2; FRD 6.7 BR-3; FRD Sec 8 Toaster #7
  @TC_SF_143 @Functional @High @Automation
  Scenario: Verify a configuration can be deleted once no Organization selects it
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And QF-0001 is selected only by ORG-001 and ORG-002
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0001 |
    When the user changes Quantity of ORG-001 and ORG-002 to 'Euro Quantity'
    And the user clicks Delete against 'Standard Quantity'
    And the user confirms the deletion
    Then The dependency check passes at delete time, the confirmation dialog is displayed and the record is deleted with toaster 'Quantity format deleted successfully.'

  # Ref: FRD 6.7 FB-2; FRD 6.7 BR-3
  @TC_SF_144 @Functional @High @Automation
  Scenario: Verify the dependency check runs at the time of the delete action, not at list load
    Given Two sessions: Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) in Session A and Session B. 'Spare Quantity' (QF-0003) has no Organization selection when Session A loads the list
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record           | QF-0003                 |
      | Session B action | ORG-001 selects QF-0003 |
    When In Session A open the Quantity list
    And In Session B edit ORG-001 and select 'Spare Quantity' as Quantity
    And In Session A click Delete against 'Spare Quantity' without refreshing
    Then Deletion is blocked with toaster 'This Format cannot be deleted as it is in use by Organizations.'; no confirmation dialog is shown

  # Ref: FRD 6.7 FB-3; FRD 6.6 BR-3
  @TC_SF_145 @Functional @High @Automation
  Scenario: Verify a blocked deletion leaves the record and the Organization association unchanged
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And QF-0001 is selected by ORG-001
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0001 |
    When the user clicks Delete against 'Standard Quantity'
    And the user opens 'Standard Quantity' and ORG-001
    Then The record exists with unchanged values and ORG-001 still selects QF-0001

  # Ref: FRD 6.7 FB-7; FRD 6.6 BR-3
  @TC_SF_146 @Functional @High @Automation
  Scenario: Verify a deleted configuration is no longer available for Organization selection
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in. 'Spare Currency' (CF-0003) was deleted
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Deleted record | Spare Currency (CF-0003) |
    When the user opens Organization Management and Add Organization
    And the user opens the Currency dropdown
    Then 'Spare Currency' is not listed for selection

  # Ref: FRD 6.7 BR-4; FRD Sec 8 Toaster #10
  @TC_SF_148 @Functional @High @Automation
  Scenario: Verify the delete rule is applied to all three configuration types
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And QF-0001, CF-0001 and DF-0001 are selected by ORG-001
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Records | QF-0001, CF-0001, DF-0001 |
    When the user deletes QF-0001 from the Quantity tab
    And the user deletes CF-0001 from the Currency tab
    And the user deletes DF-0001 from the Date Time tab
    Then All three deletions are blocked with the same toaster; no type is exempt

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.7 BR-1; FRD 6.6 BR-3; US-4 AC-1
  @TC_SF_289 @Negative @High @Automation
  Scenario: Verify a Quantity delete request is rejected at API level when an Organization selects it
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User       | Admin_User1 |
      | Record     | QF-0001     |
      | Dependency | ORG-001     |
    When the user sends a delete request for QF-0001
    And the user checks the Master
    Then Request is rejected with 'This Format cannot be deleted as it is in use by Organizations.'; the record still exists

  # Ref: FRD 6.7 BR-1; FRD 6.6 BR-3; US-4 AC-1
  @TC_SF_290 @Negative @High @Automation
  Scenario: Verify a Currency delete request is rejected at API level when an Organization selects it
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User       | Admin_User1 |
      | Record     | CF-0001     |
      | Dependency | ORG-001     |
    When the user sends a delete request for CF-0001
    And the user checks the Master
    Then Request is rejected with 'This Format cannot be deleted as it is in use by Organizations.'; the record still exists

  # Ref: FRD 6.7 BR-1; FRD 6.6 BR-3; US-4 AC-1
  @TC_SF_291 @Negative @High @Automation
  Scenario: Verify a Date & Time delete request is rejected at API level when an Organization selects it
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User       | Admin_User1 |
      | Record     | DF-0001     |
      | Dependency | ORG-001     |
    When the user sends a delete request for DF-0001
    And the user checks the Master
    Then Request is rejected with 'This Format cannot be deleted as it is in use by Organizations.'; the record still exists

  # Ref: FRD 6.7 FB-7
  @TC_SF_292 @Negative @Medium @Automation
  Scenario: Verify direct access to a deleted configuration fails
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in
    And QF-0003 was deleted
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Record | QF-0003 (deleted) |
    When the user opens the View URL of QF-0003 directly
    Then The record is not found; no configuration data is shown
