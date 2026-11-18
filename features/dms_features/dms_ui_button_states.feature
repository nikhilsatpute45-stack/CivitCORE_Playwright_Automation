@DMS @DmsUiButtonStates
Feature: DMS UI - Button States
  Automated scenarios for the "DMS UI - Button States" module of Document Management System.
  Source: CivitCORE_DMS_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-001_CivitCORE_CORE Module_Document Management System.pdf (Ver 0.1, 19-Oct-2026)

  # ---------------------------------------------------------------
  # UI / Visual scenarios
  # ---------------------------------------------------------------

  # Ref: FRD 6.1.1 F-Create; FRD 6.1.3 F-Save; FRD 6.1.4 F-Move; FRD 6.1.5 F-Copy; FRD 6.8.1 F-Checkout; FRD 6.8.2 F-CheckinCTA; FRD 6.8.5 F-Compare; FRD 6.10.2 F-Post
  @TC_CP_352 @UIVisual @Medium @Automation
  Scenario: Verify primary action buttons are disabled until their enabling conditions are met
    Given Admin_User1 (all DMS permissions: Create Folder, Upload, Edit Metadata, View, Download, Check-out/Check-in, Move, Copy, Delete, Share, Manage Access, View Activity Log, Compare Versions) is logged in to CivitCORE and the 'Organization Document' repository is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Data | Create Folder |
      | Data | Rename Save   |
      | Data | Move Folder   |
      | Data | Copy Folder   |
      | Data | Check-out     |
      | Data | Check-in      |
      | Data | Compare       |
      | Data | Post comment  |
    When the user opens each form with empty/initial values and read the button state
    And the user satisfies the condition and read the state again
    And the user repeats for each value
    Then Each button is disabled until its condition is met (name entered / name changed / target selected / valid name+target / note entered / file+note / both versions / comment entered) and enabled afterwards
