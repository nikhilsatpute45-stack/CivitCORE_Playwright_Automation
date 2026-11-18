@MiscellaneousMaster @DisplayConfiguration
Feature: Display Configuration
  Automated scenarios for the "Display Configuration" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: Section 4 AC-DS-1; FRD 5.6 FB-1; FRD 5.6 FB-2; FRD Sec 7 Toaster #7
  @TC_MM_094 @Functional @High @Automation
  Scenario: Verify checking the Display checkbox in the list saves immediately with a toaster
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Specialization |
      | Display | unchecked -> checked   |
    When the user clicks the Display checkbox of 'List of Specialization' (unchecked)
    And the user observes the page without clicking any Save button
    Then The new value is saved immediately; toaster 'Display setting updated successfully.' is displayed
    And The checkbox shows checked

  # Ref: FRD 5.6 DST-1; Section 4 AC-DS-1
  @TC_MM_095 @Functional @High @Automation
  Scenario: Verify a Title becomes available in the Specialization Master after Display is checked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Specialization |
      | Display | unchecked -> checked   |
    When the user checks the Display checkbox of 'List of Specialization'
    And the user opens or refresh Specialization Master
    Then 'List of Specialization' is available in Specialization Master for configuration and adding values

  # Ref: FRD 5.6 DST-2; Section 4 AC-DS-1; FRD Sec 7 Toaster #7
  @TC_MM_096 @Functional @High @Automation
  Scenario: Verify unchecking Display makes the Title unavailable in the Specialization Master
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title   | List of Operator     |
      | Display | checked -> unchecked |
    When the user unchecks the Display checkbox of 'List of Operator'
    And the user opens or refresh Specialization Master
    Then Toaster 'Display setting updated successfully.' is displayed
    And 'List of Operator' is not available in Specialization Master

  # Ref: FRD 5.6 DST-2
  @TC_MM_097 @Functional @High @Automation
  Scenario: Verify values already added are not deleted when Display is unchecked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title  | Zone Type    |
      | Values | Urban, Rural |
    When the user notes the values added under 'Zone Type' in Specialization Master (Urban, Rural)
    And the user unchecks Display of 'Zone Type'
    And the user re-checks Display of 'Zone Type'
    And the user opens Specialization Master
    Then After unchecking, 'Zone Type' cannot be configured and no values can be added
    And After re-checking, the values 'Urban' and 'Rural' are still present

  # Ref: FRD 5.6 FB-3
  @TC_MM_098 @Functional @Medium @Automation
  Scenario: Verify the Display checkbox is disabled while the update request is in progress
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | List of Specialization |
    When the user throttles the Display update API by 5 seconds
    And the user clicks the Display checkbox of 'List of Specialization'
    And Immediately try to click it again
    Then The checkbox is disabled while the request is in progress; repeated clicks have no effect and only one update is recorded

  # Ref: FRD 5.6 BR-3; FRD 5.6 FB-2
  @TC_MM_099 @Functional @Medium @Automation
  Scenario: Verify Display change updates Last Modified By/On and changes no other field
    Given Editor_User1 (Miscellaneous Master: View/Edit) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User  | Editor_User1           |
      | Title | List of Specialization |
    When the user notes all values of 'List of Specialization' in View
    And As Editor_User1 check its Display checkbox
    And the user opens View again
    Then Last Modified By is 'Editor_User1' with the current date-time
    And Field Title, Parent Title and Enum ID are unchanged

  # Ref: Section 4 AC-DS-2; FRD 5.6 BR-1
  @TC_MM_100 @Functional @High @Automation
  Scenario: Verify the Display checkbox is shown in its saved state but disabled for a user without Edit permission
    Given Viewer_User1 (Miscellaneous Master: View only) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Viewer_User1 |
      | Permissions | View only    |
    When the user opens Miscellaneous Master
    And the user observes and click the Display checkboxes of 'List of Title' (checked) and 'List of Specialization' (unchecked)
    Then Checkboxes show the saved states (checked / unchecked) and are disabled; clicking changes nothing

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: Section 4 AC-DS-3; FRD 5.6 FB-4; FRD 5.6 DST-3
  @TC_MM_225 @Negative @Medium @Automation
  Scenario: Verify the Display checkbox reverts and no toaster or audit entry occurs when the update fails
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title             | List of Specialization |
      | Simulated failure | HTTP 500               |
    When the user configures the Display update API to return a server error
    And the user clicks the Display checkbox of 'List of Specialization'
    And the user checks the checkbox, toasters and Activity Log
    Then The checkbox returns to its previous (unchecked) state, no toaster message is displayed and no Activity Log entry is created
