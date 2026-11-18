@MembersConfiguration @ActiveStatusFromTheList
Feature: Active Status from the List
  Automated scenarios for the "Active Status from the List" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-4 AC-1; FRD 5.5 FB-2; FRD Sec 7 Toaster #2
  @TC_MC_076 @Functional @High @Automation
  Scenario: Verify unchecking Active in the list saves immediately and shows the status toaster
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project              |
      | Active | checked -> unchecked |
    When the user unchecks the Active checkbox of member 'Project'
    Then Status is saved immediately without any other action
    And Toaster 'Member status updated successfully.' is displayed
    And Checkbox stays unchecked after the list refreshes

  # Ref: FRD 5.5 FB-2; FRD Sec 7 Toaster #2
  @TC_MC_077 @Functional @High @Automation
  Scenario: Verify checking Active of an inactive member in the list saves immediately
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Modernization        |
      | Active | unchecked -> checked |
    When the user checks the Active checkbox of member 'Modernization'
    Then Status is saved immediately
    And Toaster 'Member status updated successfully.' is displayed and checkbox stays checked

  # Ref: FRD 5.5 FB-2
  @TC_MC_078 @Functional @High @Automation
  Scenario: Verify an Active change in the list records Last Modified By and Last Modified On
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project     |
      | User   | Admin_User1 |
    When the user unchecks the Active checkbox of member 'Project'
    And the user opens 'View' for 'Project'
    Then Last Modified By shows 'Admin_User1' and Last Modified On shows the date-time of the change

  # Ref: FRD 5.5 BR-2
  @TC_MC_079 @Functional @High @Automation
  Scenario: Verify an Active change in the list does not change the Description or any other field
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member             | RepairAndMaintenance |
      | Description before | AMC                  |
    When the user unchecks the Active checkbox of member 'RepairAndMaintenance'
    And the user opens 'View' for 'RepairAndMaintenance'
    Then Description is still 'AMC'; Member Name and Product Enum unchanged; only Active changed

  # Ref: FRD 5.5 BR-1; US-4 AC-2
  @TC_MC_080 @Functional @Medium @Automation
  Scenario: Verify a status change from the list and from the Edit pop-up have the same effect
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Members 'Project' and 'Consultancy' are both active
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Members | Project (list), Consultancy (Edit pop-up) |
    When the user unchecks Active of 'Project' in the list
    And the user edits 'Consultancy', uncheck Active and Save
    And the user compares the saved status, Last Modified By/On and Create Work Proposal Nature options for the two members
    Then Both members are inactive with Last Modified By/On set
    And Neither is offered in Proposal Nature on Create Work; effect is identical for both paths

  # Ref: FRD 5.5 BR-3
  @TC_MC_081 @Functional @High @Automation
  Scenario: Verify a member used in saved records can be made inactive
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Work WRK-0001 is saved with Proposal Nature = RepairAndMaintenance
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member       | RepairAndMaintenance |
      | Saved record | WRK-0001             |
    When the user unchecks the Active checkbox of 'RepairAndMaintenance'
    Then Change is allowed; toaster 'Member status updated successfully.' is displayed

  # Ref: US-4 AC-5; FRD 5.5 BR-4
  @TC_MC_082 @Functional @High @Automation
  Scenario: Verify all members of a Product Enum can be made inactive
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen. 'Proposal Classification' is selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum | Proposal Classification (Government, Private, PSU) |
    When the user unchecks Active of 'Government'
    And the user unchecks Active of 'Private'
    And the user unchecks Active of 'PSU'
    Then All three changes are allowed, each with toaster 'Member status updated successfully.'
    And All 3 checkboxes are unchecked

  # Ref: FRD 5.4 F-Active; US-4 AC-5
  @TC_MC_083 @Functional @Medium @Automation
  Scenario: Verify the last active member can be made inactive through the Edit pop-up
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Only 'Government' is active in 'Proposal Classification' (Private and PSU inactive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Enum   | Proposal Classification |
      | Member | Government              |
    When the user clicks the kebab (⋮) icon of member 'Government'
    And the user selects 'Edit'
    And the user unchecks 'Active'
    And the user clicks 'Save'
    Then Saved; toaster 'Member updated successfully.' is displayed
    And No member of the enum is active

  # Ref: FRD 5.5 FB-3
  @TC_MC_084 @Functional @Medium @Automation
  Scenario: Verify the Active checkbox is disabled while the status request is in progress
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Network is throttled so the status request takes about 5 seconds
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member  | Project |
      | Latency | 5 s     |
    When the user unchecks the Active checkbox of 'Project'
    And Immediately observe that checkbox
    And the user waits for the request to finish
    Then Checkbox is disabled during the request
    And It is enabled again after the request completes

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-4 AC-7; FRD 5.5 FB-3; FRD Sec 7 Toaster #3
  @TC_MC_175 @Negative @High @Automation
  Scenario: Verify the checkbox returns to its previous state and the error toaster shows when the status cannot be saved
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And The status save request is made to fail (network blocked for that request)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member            | Project         |
      | Simulated failure | request blocked |
    When the user unchecks the Active checkbox of 'Project'
    Then Checkbox returns to checked
    And Toaster 'Unable to update member status. Please try again.' is displayed
    And No success toaster is displayed

  # Ref: FRD Sec 7 TR-2; FRD Sec 7 Toaster #3
  @TC_MC_176 @Negative @Medium @Automation
  Scenario: Verify the error toaster for a failed status change closes automatically after 5 seconds
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And The status save request is made to fail
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Toaster | Unable to update member status. Please try again. |
    When the user unchecks the Active checkbox of 'Project'
    And the user measures how long the error toaster stays visible
    Then Error toaster closes automatically after 5 seconds

  # Ref: FRD 5.5 FB-1
  @TC_MC_177 @Negative @Medium @Automation
  Scenario: Verify no confirmation dialog or Save button is shown when the Active checkbox is clicked
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member | Project |
    When the user clicks the Active checkbox of 'Project'
    And the user observes the screen
    Then No confirmation dialog and no separate Save button appears; the change is saved immediately
