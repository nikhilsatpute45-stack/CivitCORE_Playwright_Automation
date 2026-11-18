@DMS @FolderPin
Feature: Folder Pin
  Automated scenarios for the "Folder Pin" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.6 FB-Pin; FRD Sec 8 T6; FRD Sec 8 T7
  @TC_CP_041 @Functional @Medium @Automation
  Scenario: Verify a folder is pinned to the top of the Pinned section and can be unpinned
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Folder 'Reports' is not pinned
    And the following test data is used
      | Folder | Reports |
    When the user clicks kebab > Pin on 'Reports'
    And the user observes the Pinned section and list
    And the user clicks kebab > Unpin
    And the user observes the list
    Then On Pin, 'Folder pinned successfully.' is displayed, 'Reports' appears at the top of Pinned with a pin icon
    And On Unpin, 'Folder unpinned successfully.' is displayed, the icon is removed and the folder returns to its original position

  # Ref: FRD 6.1.6 BR-PinMenu
  @TC_CP_042 @Functional @Medium @Automation
  Scenario: Verify the kebab menu shows Pin for an unpinned folder and Unpin for a pinned folder
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Reports' is pinned; 'Archive' is not pinned
    And the following test data is used
      | Folders | Archive, Reports |
    When the user opens the kebab menu on 'Archive'
    And the user opens the kebab menu on 'Reports'
    Then 'Archive' shows 'Pin'
    And 'Reports' shows 'Unpin'

  # Ref: US-2 AC-4; FRD 6.1.6 BR-UserSpecific
  @TC_CP_043 @Functional @High @Automation
  Scenario: Verify pinning is user-specific and does not change folder permissions
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And Admin_User1 pins 'Reports'
    And Editor_User1 also has access to 'Reports'
    And the following test data is used
      | Users | Admin_User1, Editor_User1 |
    When the user pins 'Reports' as Admin_User1
    And the user logs in as Editor_User1 and view the Pinned section
    And the user opens Manage Access for 'Reports'
    Then Editor_User1 does not see 'Reports' in Pinned
    And Folder permissions are unchanged by pinning

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-4; FRD 6.1.6 BR-NoAccess
  @TC_CP_384 @Negative @High @Automation
  Scenario: Verify a pinned folder disappears or is marked unavailable when the user's access is removed
    Given Editor_User1 has pinned 'Drawings' through Role access
    And the following test data is used
      | Folder | Drawings     |
      | User   | Editor_User1 |
    When As Admin_User1 remove Editor_User1's access to 'Drawings'
    And As Editor_User1 open the Pinned section and try to open 'Drawings'
    Then 'Drawings' disappears from Pinned (or is marked unavailable)
    And The folder cannot be opened through the pin

  # Ref: US-2 AC-4; FRD 6.1.6 BR-Deleted
  @TC_CP_385 @Negative @Medium @Automation
  Scenario: Verify a pinned folder that is deleted disappears from the pinned list
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded. 'Empty Folder' is pinned
    And the following test data is used
      | Folder | Empty Folder |
    When the user deletes 'Empty Folder'
    And the user checks the Pinned section
    Then 'Empty Folder' no longer appears in Pinned (or is marked unavailable)
