@MembersConfiguration @ToasterMessages
Feature: Toaster Messages
  Automated scenarios for the "Toaster Messages" module of Members Configuration.
  Source: CivitINFRA_Members_Configuration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-004_CivitINFRA Configuration_Members Configuration.pdf (Ver 1.0, 05-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD Sec 7 TR-2; FRD Sec 7 Toaster #1
  @TC_MC_085 @Functional @Medium @Automation
  Scenario: Verify the success toaster of Edit closes automatically after 5 seconds
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member  | Project                      |
      | Toaster | Member updated successfully. |
    When the user clicks the kebab (⋮) icon of member 'Project'
    And the user selects 'Edit'
    And the user changes Description to 'Capital Project'
    And the user clicks 'Save'
    And the user measures how long the toaster stays visible
    Then Toaster 'Member updated successfully.' closes automatically after 5 seconds

  # Ref: FRD Sec 7 TR-2; FRD Sec 7 Toaster #2
  @TC_MC_086 @Functional @Medium @Automation
  Scenario: Verify the status toaster from the list closes automatically after 5 seconds
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Member  | Project                             |
      | Toaster | Member status updated successfully. |
    When the user unchecks the Active checkbox of 'Project'
    And the user measures how long the toaster stays visible
    Then Toaster 'Member status updated successfully.' closes automatically after 5 seconds

  # Ref: FRD Sec 7 TR-1
  @TC_MC_087 @Functional @Medium @Automation
  Scenario: Verify no toaster is displayed for events outside the Toaster table
    Given Admin_User1 (Members Configuration: View + Edit) is logged in and on the Members Configuration screen
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Events | select enum, search, View, Cancel |
    When the user selects 'Tender Type' in the Product Enum dropdown
    And the user types 'open' in the Description search box
    And the user opens and close 'View' for 'OpenTender'
    And the user opens 'Edit' for 'OpenTender' and click 'Cancel'
    Then No toaster is displayed for any of these events
