@MiscellaneousMaster @TitleView
Feature: Title View
  Automated scenarios for the "Title View" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: Section 4 AC-VW-1; FRD 5.4 FB-1; FRD 5.4 FB-2
  @TC_MM_067 @Functional @Medium @Automation
  Scenario: Verify View shows all eight details of a Title in read-only mode
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Unit of Measurement (Enum ID 106, Parent Measurement Groups, Display unchecked) |
    When the user clicks the kebab on 'Unit of Measurement' and select View
    Then 'View Title' pop-up shows Enum ID 106, Field Title 'Unit of Measurement', Parent Title 'Measurement Groups', Display, Created By, Created On, Last Modified By and Last Modified On

  # Ref: Section 4 AC-VW-1; FRD 5.4 FB-2
  @TC_MM_068 @Functional @Medium @Automation
  Scenario: Verify Display is shown as Yes for a checked Title and No for an unchecked Title in View
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Titles | List of Operator, List of Specialization |
    When the user opens View for 'List of Operator' (Display checked)
    And the user closes and open View for 'List of Specialization' (Display unchecked)
    Then View shows Display 'Yes' for 'List of Operator' and 'No' for 'List of Specialization'

  # Ref: Section 4 AC-VW-2; FRD 5.4 FB-2
  @TC_MM_069 @Functional @Medium @Automation
  Scenario: Verify no field is editable on the View pop-up
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | List of Operator |
    When the user opens View for 'List of Operator'
    And the user tries to click into and change every value
    Then No field is editable; values cannot be changed

  # Ref: FRD 5.4 FB-3; FRD 5.5 FB-1; Section 4 AC-VW-2
  @TC_MM_070 @Functional @Medium @Automation
  Scenario: Verify the Edit button on View opens the Edit Title form for the same Title for a user with Edit permission
    Given Editor_User1 (Miscellaneous Master: View/Edit) is logged in and on the Title List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User  | Editor_User1     |
      | Title | List of Operator |
    When the user opens View for 'List of Operator'
    And the user clicks 'Edit'
    Then 'Edit Title' pop-up opens pre-filled with the values of 'List of Operator'

  # Ref: FRD 5.4 FB-4; Section 4 AC-VW-2
  @TC_MM_071 @Functional @Medium @Automation
  Scenario: Verify Close on View returns to the same page and column search values
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset C (120 Titles, see Summary) is loaded
    And the following test data is used
      | Data         | Dataset C |
      | Title search | Bulk      |
      | Page         | 2         |
    When On the Dataset C list type 'Bulk' in Title search and open page 2
    And the user opens View for any row
    And the user clicks 'Close'
    Then The Title List is displayed on page 2 with Title search 'Bulk' retained

  # Ref: FRD 5.4 FB-4
  @TC_MM_072 @Functional @Medium @Automation
  Scenario: Verify the close (X) icon on View returns to the same page and column search values
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset C (120 Titles, see Summary) is loaded
    And the following test data is used
      | Data         | Dataset C |
      | Title search | Bulk      |
      | Page         | 2         |
    When On the Dataset C list type 'Bulk' in Title search and open page 2
    And the user opens View for any row
    And the user clicks the close (X) icon
    Then The Title List is displayed on page 2 with Title search 'Bulk' retained

  # Ref: FRD 5.4 BR-2
  @TC_MM_073 @Functional @Medium @Automation
  Scenario: Verify opening a Title in View that was deleted by another user refreshes the list without a toaster
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Session A | Admin_User1    |
      | Session B | Admin_User2    |
      | Title     | Obsolete Field |
    When In Session A note the row 'Obsolete Field' on the list
    And In Session B delete 'Obsolete Field'
    And In Session A open View for 'Obsolete Field'
    Then The list is refreshed and 'Obsolete Field' is no longer shown; no toaster message is displayed
