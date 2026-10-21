@region_management @region_audit_log
Feature: Region Audit Log
  As an Auditor
  I want every Region change to be captured in the Region Activity Log
  So that Region activity is traceable

  # Assumption stated in the test cases: the Activity Log screen/report location is not defined in the FRD.
  # Region Admin performs the action; Auditor opens the Region Activity Log.

  @TC-REG-070 @Audit @High
  Scenario: Verify an Activity Log entry is created for Region creation
    Given I am logged in as "Region Admin" with user "Admin_User1"
    When I create Region "Central Region"
    And an "Auditor" opens the Activity Log for the Region
    Then a "Region Created" entry should exist
    And the entry should contain User, Date/Time, Region ID and Region Name "Central Region"

  @TC-REG-071 @Audit @High
  Scenario: Verify an Activity Log entry is created for a Region update with previous and new values
    Given I am logged in as "Region Admin"
    And Region "Western Region" exists
    When I rename Region "Western Region" to "West Zone"
    And an "Auditor" opens the Activity Log
    Then a "Region Updated" entry should exist
    And the entry should contain User, Date/Time, Region ID
    And the Field Changed should be "Region Name"
    And the Previous Value should be "Western Region"
    And the New Value should be "West Zone"

  @TC-REG-072 @Audit @High
  Scenario: Verify an Activity Log entry is created for a successful Region deletion
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists with no Office or Location association
    When I delete Region "Delhi" and confirm
    And an "Auditor" opens the Activity Log
    Then a "Region Deleted" entry should exist
    And the entry should contain User, Date/Time, Region ID and Region Name "Delhi"

  @TC-REG-073 @Audit @High
  Scenario: Verify 'Region Deletion Blocked' is logged with Office information when an Office dependency blocks deletion
    Given I am logged in as "Region Admin"
    And Region "Western Region" has Office "Jodhpur"
    When I click "Delete" on Region "Western Region"
    And an "Auditor" opens the Activity Log
    Then a "Region Deletion Blocked" entry should exist
    And the entry should contain User, Date/Time, Region ID, Region Name and blocking dependency information "Jodhpur"

  @TC-REG-074 @Audit @High
  Scenario: Verify 'Region Deletion Blocked' is logged when a Location dependency blocks deletion
    Given I am logged in as "Region Admin"
    And Region "Southern Region" has Location "Pune" only
    When I click "Delete" on Region "Southern Region"
    And an "Auditor" opens the Activity Log
    Then a "Region Deletion Blocked" entry should exist for "Southern Region"
    And the entry should identify the Location dependency

  @TC-REG-075 @Audit @High
  Scenario: Verify 'Region Assigned to Office' is logged when a Region is selected on an Office
    Given I am logged in as "Region Admin"
    And Region "Delhi" exists
    When I create Office "Jaipur" and select Region "Delhi"
    And I save the Office
    And an "Auditor" opens the Activity Log for "Delhi"
    Then a "Region Assigned to Office" entry should exist
    And the entry should contain User, Date/Time, Region ID, Region Name, Office ID and Office Name "Jaipur"

  # Assumption stated in the test case: Region can be cleared on the Office form
  @TC-REG-076 @Audit @High
  Scenario: Verify 'Region Removed from Office' is logged when a Region is cleared from an Office
    Given I am logged in as "Region Admin"
    And Office "Jodhpur" is assigned to "Western Region"
    And the Office form allows the Region to be cleared
    When I edit Office "Jodhpur", clear its Region and save
    And an "Auditor" opens the Activity Log for "Western Region"
    Then a "Region Removed from Office" entry should exist
    And the entry should contain User, Date/Time, Region ID, Region Name, Office ID and Office Name "Jodhpur"

  @TC-REG-077 @Audit @High
  Scenario: Verify changing an Office's Region logs a removal for the old Region and an assignment for the new Region
    Given I am logged in as "Region Admin"
    And Office "Jodhpur" is assigned to "Western Region"
    When I edit Office "Jodhpur" and change Region to "Delhi"
    And I save the Office
    And an "Auditor" opens the Activity Logs for "Western Region" and "Delhi"
    Then the "Western Region" log should have "Region Removed from Office" for "Jodhpur"
    And the "Delhi" log should have "Region Assigned to Office" for "Jodhpur"

  # FRD gap flagged in the test case: 6.5 BR3 requires Location logging but 7.1 lists only Office activities
  @TC-REG-078 @Audit @Medium
  Scenario: Verify Location Region assignment or change is captured in the Activity Log
    Given I am logged in as "Region Admin"
    And Location "Pune" is assigned to "Southern Region"
    When I edit Location "Pune" and change Region to "Delhi"
    And I save the Location
    And an "Auditor" opens the Activity Logs for "Southern Region" and "Delhi"
    Then the change should be captured in the Activity Log with the Location reference

  @TC-REG-079 @Audit @Medium
  Scenario: Verify Activity Log entries are displayed most recent first
    Given Region "Central Region" has been created, renamed and then had a delete attempt blocked at different times
    When an "Auditor" opens the Activity Log for the Region
    Then the entries should be sorted in reverse-chronological order with the latest first

  @TC-REG-080 @Audit @High
  Scenario: Verify Activity Log entries are read-only and cannot be edited or deleted
    Given I am logged in as "Auditor"
    When I open the Activity Log
    Then no edit or delete control should be available on any entry
    When I attempt to modify or delete the "Region Created" entry through the API
    Then the API should reject the modification or deletion

  @TC-REG-081 @Audit @High
  Scenario: Verify no deletion entry is recorded when the user cancels the delete confirmation
    Given I am logged in as "Region Admin"
    And Region "Delhi" has no associations
    When I click "Delete" on Region "Delhi"
    And I click "Cancel"
    And an "Auditor" opens the Activity Log for "Delhi"
    Then no "Region Deleted" entry should be created
