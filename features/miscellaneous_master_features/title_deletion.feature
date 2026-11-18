@MiscellaneousMaster @TitleDeletion
Feature: Title Deletion
  Automated scenarios for the "Title Deletion" module of Miscellaneous Master.
  Source: CivitINFRA_MiscellaneousMaster_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-003_CivitINFRA Configuration_Miscellaneous Master.pdf (Ver 1.0, 02-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: Section 4 AC-BL-1; FRD 5.8 BR-1; FRD 5.8 DR-1; FRD Sec 7 Toaster #4; FRD 5.8 FB-1; FRD Fig 2
  @TC_MM_109 @Functional @High @Automation
  Scenario: Verify deletion is blocked for a Title used in transactions
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Site Category (used in TXN-0001) |
    When the user clicks the kebab on 'Site Category' and select Delete
    Then Error toaster 'This title is used in one or more transactions and cannot be deleted.' is displayed
    And No confirmation dialog is shown and the Title remains in the list

  # Ref: Section 4 AC-BL-2; FRD 5.8 BR-2; FRD 5.8 DR-2; FRD Sec 7 Toaster #5
  @TC_MM_110 @Functional @High @Automation
  Scenario: Verify deletion is blocked for a Title that is the Parent Title of another Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Measurement Groups (parent of Unit of Measurement) |
    When the user clicks the kebab on 'Measurement Groups' and select Delete
    Then Error toaster 'This title is set as Parent Title for one or more titles and cannot be deleted.' is displayed
    And No confirmation dialog is shown and the Title remains

  # Ref: Section 4 AC-BL-3; FRD 5.8 BR-3; FRD 5.8 DR-3; FRD 5.7 BR-2; FRD Sec 7 Toaster #6
  @TC_MM_111 @Functional @High @Automation
  Scenario: Verify deletion is blocked for a Title mapped in the Specialization Master
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Zone Type (mapped in Specialization Master) |
    When the user clicks the kebab on 'Zone Type' and select Delete
    Then Error toaster 'This title is mapped in Specialization Master and cannot be deleted.' is displayed
    And No confirmation dialog is shown and the Title remains

  # Ref: FRD 5.8 FB-2; FRD 5.8 FB-3
  @TC_MM_112 @Functional @High @Automation
  Scenario: Verify the transaction message is shown first when a Title is both used in a transaction and a Parent Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Project Type (used in transaction and parent of Project Subtype) |
    When the user clicks the kebab on 'Project Type' and select Delete
    Then Toaster 'This title is used in one or more transactions and cannot be deleted.' is displayed (first dependency in the order transaction, parent, Specialization Master)

  # Ref: FRD 5.8 FB-2; FRD 5.8 FB-3
  @TC_MM_113 @Functional @High @Automation
  Scenario: Verify the Parent Title message is shown before the Specialization Master message
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Material Group (parent of Material Subgroup and mapped in Specialization Master) |
    When the user clicks the kebab on 'Material Group' and select Delete
    Then Toaster 'This title is set as Parent Title for one or more titles and cannot be deleted.' is displayed

  # Ref: Section 4 AC-BL-4; FRD 5.8 FB-2
  @TC_MM_114 @Functional @High @Automation
  Scenario: Verify the dependency check is made in real time when Delete is selected
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Obsolete Field |
    When the user opens the Title List and note 'Obsolete Field' as deletable
    And In another session map 'Obsolete Field' in Specialization Master (without refreshing the first session)
    And In the first session select Delete on 'Obsolete Field'
    Then Toaster 'This title is mapped in Specialization Master and cannot be deleted.' is displayed and no confirmation dialog is shown

  # Ref: Section 4 AC-DL-1; FRD 5.8 FB-4; FRD 5.8 BR-4
  @TC_MM_115 @Functional @High @Automation
  Scenario: Verify the confirmation dialog is displayed for a Title with no dependency
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Obsolete Field |
    When the user clicks the kebab on 'Obsolete Field' and select Delete
    Then Dialog 'Are you sure you want to delete the title "Obsolete Field"?' is displayed with 'Yes' and 'No' buttons

  # Ref: Section 4 AC-DL-2; FRD 5.8 FB-5; FRD 5.8 DR-4; FRD Sec 7 Toaster #3; FRD Fig 2
  @TC_MM_116 @Functional @High @Automation
  Scenario: Verify clicking Yes deletes the Title and shows the success toaster
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Obsolete Field |
    When the user selects Delete on 'Obsolete Field'
    And the user clicks 'Yes'
    Then Toaster 'Title deleted successfully.' is displayed
    And 'Obsolete Field' is removed from the list

  # Ref: Section 4 AC-DL-2; FRD 5.3 BR-2
  @TC_MM_117 @Functional @High @Automation
  Scenario: Verify the list is refreshed and Sl. No. is re-sequenced after deletion
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Obsolete Field (Sl. No. 16) |
    When the user notes Sl. No. of 'Draft Field' (17) and 'Legacy Field' (18)
    And the user deletes 'Obsolete Field' (16) and click Yes
    And the user observes Sl. No
    Then List refreshes automatically; 'Draft Field' is now Sl. No. 16 and 'Legacy Field' is Sl. No. 17 (Sl. No. is continuous)

  # Ref: Section 4 AC-DL-2; FRD 5.7 BR-3
  @TC_MM_118 @Functional @High @Automation
  Scenario: Verify a deleted Title no longer appears in any Parent Title dropdown
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Obsolete Field |
    When the user deletes 'Obsolete Field' and click Yes
    And the user clicks 'Add' and open the Parent Title dropdown
    Then 'Obsolete Field' is not listed in the Parent Title dropdown

  # Ref: Section 4 AC-DL-2; FRD 5.7 BR-3
  @TC_MM_119 @Functional @High @Automation
  Scenario: Verify a deleted Title no longer appears in the Specialization Master
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Draft Field (Display checked, not mapped) |
    When the user checks Display of 'Draft Field' and confirm it is listed in Specialization Master (not mapped)
    And the user deletes 'Draft Field' and click Yes
    And the user opens Specialization Master
    Then 'Draft Field' is not shown in Specialization Master

  # Ref: Section 4 AC-DL-4; FRD 5.8 BR-6
  @TC_MM_120 @Functional @High @Automation
  Scenario: Verify the Enum ID of a deleted Title can be entered on another Title
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Deleted   | Legacy Field (601)  |
      | New Title | Contractor Category |
      | Enum ID   | 601                 |
    When the user deletes 'Legacy Field' (Enum ID 601) and click Yes
    And the user adds a new Title using Enum ID 601
    Then The new Title is saved with Enum ID 601 without 'Enum ID already exists.'

  # Ref: Section 4 AC-BL-4; FRD 5.8 DR-6; FRD 5.8 FB-5
  @TC_MM_121 @Functional @High @Automation
  Scenario: Verify the server repeats the dependency check when Yes is clicked
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Obsolete Field |
    When the user selects Delete on 'Obsolete Field' so the confirmation dialog is displayed
    And In another session map 'Obsolete Field' in Specialization Master
    And the user clicks 'Yes'
    Then Deletion is blocked; toaster 'This title is mapped in Specialization Master and cannot be deleted.' is displayed; the Title is not deleted

  # Ref: FRD 5.8 FB-5
  @TC_MM_122 @Functional @High @Automation
  Scenario: Verify the previous page is shown when the current page becomes empty after deletion
    Given Admin_User1 (View/Add/Edit/Delete) is logged in and on the Title List page
    And Pagination Dataset B (51 Titles, see Summary) is loaded
    And the following test data is used
      | Dataset B | 51 Titles  |
      | Row       | Sl. No. 51 |
    When the user goes to page 2 (single row, Sl. No. 51)
    And the user deletes that row and click Yes
    Then The list shows the previous page (page 1) with 50 rows instead of an empty page 2

  # Ref: FRD 5.8 FB-7
  @TC_MM_123 @Functional @Medium @Automation
  Scenario: Verify a Title already deleted by another user refreshes the list without a toaster on Delete
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Session A | Admin_User1    |
      | Session B | Admin_User2    |
      | Title     | Obsolete Field |
    When In Session A note 'Obsolete Field' in the list
    And In Session B delete 'Obsolete Field'
    And In Session A select Delete on 'Obsolete Field'
    Then The list is refreshed and 'Obsolete Field' is gone; no toaster message is displayed

  # Ref: FRD 5.8 BR-2; FRD 5.8 DR-4
  @TC_MM_124 @Functional @High @Automation
  Scenario: Verify a Parent Title can be deleted once its child Titles are deleted
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Titles | District then State |
    When the user deletes 'District' and click Yes
    And the user deletes 'State' and click Yes
    Then 'District' (child, no dependency) is deleted with toaster 'Title deleted successfully.'
    And 'State' is then deletable (no longer a Parent Title) and is deleted with the same toaster

  # Ref: FRD Sec 7 (Toaster rules)
  @TC_MM_125 @Functional @Medium @Automation
  Scenario: Verify success toaster closes automatically after 5 seconds
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Toaster | Title deleted successfully. |
    When the user deletes 'Obsolete Field' and click Yes
    And the user starts a timer when the toaster appears and observe it
    Then Toaster closes automatically after 5 seconds

  # Ref: FRD Sec 7 (Toaster rules)
  @TC_MM_126 @Functional @Medium @Automation
  Scenario: Verify error toaster closes automatically after 5 seconds
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Toaster | This title is used in one or more transactions and cannot be deleted. |
    When the user selects Delete on 'Site Category'
    And the user starts a timer when the error toaster appears and observe it
    Then Error toaster closes automatically after 5 seconds

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: Section 4 AC-DL-3; FRD 5.8 FB-6; FRD 5.8 DR-5
  @TC_MM_226 @Negative @Medium @Automation
  Scenario: Verify clicking No on the confirmation dialog leaves the Title unchanged with no audit entry
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Obsolete Field |
    When the user selects Delete on 'Obsolete Field'
    And the user clicks 'No'
    And the user checks the list and the Activity Log
    Then The dialog closes; 'Obsolete Field' remains; no 'Title Deleted' entry is created

  # Ref: Section 4 AC-DL-3; FRD 5.8 FB-6
  @TC_MM_227 @Negative @Medium @Automation
  Scenario: Verify closing the confirmation dialog with the X icon leaves the Title unchanged
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Obsolete Field |
    When the user selects Delete on 'Obsolete Field'
    And the user clicks the close (X) icon of the dialog
    And the user checks the list and the Activity Log
    Then The dialog closes; 'Obsolete Field' remains; no 'Title Deleted' entry is created

  # Ref: FRD 5.8 FB-6; Section 4 AC-DL-3
  @TC_MM_228 @Negative @Medium @Automation
  Scenario: Verify pressing Esc on the confirmation dialog leaves the Title unchanged
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title | Obsolete Field |
    When the user selects Delete on 'Obsolete Field'
    And the user presses the Esc key
    And the user checks the list and the Activity Log
    Then The dialog closes; 'Obsolete Field' remains; no 'Title Deleted' entry is created

  # Ref: Section 4 AC-BL-4; FRD 5.8 BR-1
  @TC_MM_229 @Negative @High @Automation
  Scenario: Verify the server rejects deletion of a Title used in a transaction when called directly through the API
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User  | Admin_User1                      |
      | Title | Site Category (used in TXN-0001) |
    When the user sends a delete-Title request for 'Site Category' through the API
    Then The request is rejected with the transaction dependency message; 'Site Category' still exists

  # Ref: FRD 5.2 BR-10; FRD 5.3 FB-8
  @TC_MM_230 @Negative @Medium @Automation
  Scenario: Verify a search entry containing SQL-like text is treated as plain text
    Given Admin_User1 (Miscellaneous Master: View/Add/Edit/Delete) is logged in and on the Title List page (Admin > Configuration > Miscellaneous Master)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Title search | ' OR '1'='1 |
    When the user types SQL-like text in the Title search box
    Then The grid displays 'No records found.'; no unexpected rows are returned and no error occurs
