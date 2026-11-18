@NumberConfiguration @NumberConfigurationCreation
Feature: Number Configuration Creation
  Automated scenarios for the "Number Configuration Creation" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-2; FRD 6.2 FB-2; FRD 6.2 BR-2; FRD 6.2 F-Separator; FRD 6.2 F-StartWith; FRD 6.2 F-Digits
  @TC_NC_008 @Functional @High @Automation
  Scenario: Verify the Add form is pre-filled with the default values
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Purchase Order |
    When the user clicks 'Add'
    And the user observes Separator, Start With, Digits, Financial Year / Budget Year Format and Calendar Year Format
    Then Separator = '/'
    And Start With = '1'
    And Digits = '0001'
    And Financial Year / Budget Year Format = 'YYYY' and Calendar Year Format = 'YYYY'
    And All five remain editable

  # Ref: FRD 6.2 BR-1; FRD 6.2 FB-1; FRD 6.2 F-Process
  @TC_NC_009 @Functional @High @Automation
  Scenario: Verify Add operates on the currently selected Process
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Work Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Work Order |
    When the user clicks 'Add'
    And the user observes the Process shown on the form and the attribute pool
    Then The form is for 'Work Order'
    And Pool shows Office, Contractor Code, Financial Year
    And Saving creates the configuration under 'Work Order' only

  # Ref: US-2 AC-1; FRD 6.2 FB-4; FRD 6.2 BR-9; FRD 6.2 F-Status
  @TC_NC_010 @Functional @High @Automation
  Scenario: Verify Status is pre-filled Active and editable when the Process has no configuration
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Invoice' selected (no configurations exist)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Invoice |
    When the user clicks 'Add'
    And the user observes the Status field
    And the user opens the Status dropdown
    Then Status is pre-filled 'Active'
    And Status is editable and offers Active / InActive

  # Ref: US-2 AC-2; FRD 6.2 BR-9; FRD 6.2 F-Status
  @TC_NC_011 @Functional @High @Automation
  Scenario: Verify Status is pre-filled InActive and non-editable when configurations already exist
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and on the Number Configuration screen with Process 'Purchase Order' selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Purchase Order |
    When the user clicks 'Add'
    And the user observes the Status field
    And the user tries to change the Status
    Then Status is pre-filled 'InActive'
    And Status cannot be edited on this screen

  # Ref: FRD 6.2 BR-9; US-2 AC-2
  @TC_NC_012 @Functional @Medium @Automation
  Scenario: Verify Status stays InActive and non-editable when all existing configurations are InActive
    Given Admin_User1 is logged in
    And WO-Cfg-1 has been deactivated via the Deactivate action so every Work Order configuration is InActive
    And Process 'Work Order' is selected
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process | Work Order (WO-Cfg-1 InActive, WO-Cfg-2 InActive) |
    When the user clicks 'Add'
    And the user observes the Status field
    Then Status is pre-filled 'InActive' and not editable because configurations already exist (rule keys on existence, not on an Active one)

  # Ref: FRD 6.2 FB-10; FRD 6.2 FB-11; US-3 AC-8; FRD Sec 8 Toaster #1; FRD Sec 2 Fig 1
  @TC_NC_013 @Functional @High @Automation
  Scenario: Verify the first configuration for a Process is created as Active and shown in the grid
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Invoice' (no configurations exist, so Status is Active)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process    | Invoice                         |
      | Separator  | /                               |
      | Start With | 1                               |
      | Digits     | 0001                            |
      | Status     | Active                          |
      | Attributes | Company Code (CC), Office (OFF) |
    When the user drags attribute 'Company Code' into the attribute grid
    And the user enters Abbreviation 'CC' for 'Company Code'
    And the user drags attribute 'Office' into the attribute grid
    And the user enters Abbreviation 'OFF' for 'Office'
    And the user leaves all defaults and Status 'Active'
    And the user clicks Save
    Then System validates and creates the configuration record
    And Toaster 'Number Configuration created successfully.' is displayed
    And The configuration is visible in the Invoice grid with Status 'Active' and a Preview of its attribute sequence

  # Ref: FRD 6.2 F-Status; US-2 AC-1; FRD Sec 8 Toaster #1
  @TC_NC_014 @Functional @Medium @Automation
  Scenario: Verify the first configuration can be saved as InActive when Status is changed
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Invoice' (no configurations exist, so Status is Active)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process   | Invoice      |
      | Status    | InActive     |
      | Attribute | Office (OFF) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user changes Status to 'InActive'
    And the user clicks Save
    Then Configuration is saved with Status 'InActive'
    And Toaster 'Number Configuration created successfully.' is displayed
    And No Active configuration exists for 'Invoice'

  # Ref: US-2 AC-3; FRD 6.2 BR-9; FRD Sec 8 Toaster #1
  @TC_NC_015 @Functional @High @Automation
  Scenario: Verify a subsequent configuration is saved as InActive
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Process   | Purchase Order        |
      | Attribute | Department (DEPT)     |
      | Status    | InActive (pre-filled) |
    When the user drags attribute 'Department' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'DEPT' for attribute 'Department'
    And the user clicks Save
    Then Configuration is created with Status 'InActive'
    And Toaster 'Number Configuration created successfully.' is displayed
    And PO-Cfg-1 remains the only Active configuration

  # Ref: US-2 AC-3; FRD 6.3 FB-3
  @TC_NC_016 @Functional @High @Automation
  Scenario: Verify a newly saved InActive configuration is made Active using the Activate action
    Given Admin_User1 is logged in
    And A new InActive Purchase Order configuration 'PO-Cfg-5' was just created from the Add form
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Config | PO-Cfg-5 (InActive) |
    When the user selects Process 'Purchase Order'
    And the user clicks 'Activate' on PO-Cfg-5
    And the user confirms the warning that an Active configuration already exists
    Then PO-Cfg-5 becomes Active and PO-Cfg-1 becomes InActive
    And Toaster 'Number Configuration activated successfully.' is displayed

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_017 @Functional @Medium @Automation
  Scenario: Verify common Separator '-' (hyphen) is accepted and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | -            |
      | Attribute | Office (OFF) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clears the Separator and enter '-'
    And the user clicks Save
    Then Separator '-' is accepted (approved set: / - _ . :)
    And Configuration is saved; toaster 'Number Configuration created successfully.'
    And Edit shows common Separator '-'

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_018 @Functional @Medium @Automation
  Scenario: Verify common Separator '_' (underscore) is accepted and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | _            |
      | Attribute | Office (OFF) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clears the Separator and enter '_'
    And the user clicks Save
    Then Separator '_' is accepted (approved set: / - _ . :)
    And Configuration is saved; toaster 'Number Configuration created successfully.'
    And Edit shows common Separator '_'

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_019 @Functional @Medium @Automation
  Scenario: Verify common Separator '.' (period) is accepted and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | .            |
      | Attribute | Office (OFF) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clears the Separator and enter '.'
    And the user clicks Save
    Then Separator '.' is accepted (approved set: / - _ . :)
    And Configuration is saved; toaster 'Number Configuration created successfully.'
    And Edit shows common Separator '.'

  # Ref: FRD 6.2 F-Separator; FRD 6.2 BR-7
  @TC_NC_020 @Functional @Medium @Automation
  Scenario: Verify common Separator ':' (colon) is accepted and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Separator | :            |
      | Attribute | Office (OFF) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clears the Separator and enter ':'
    And the user clicks Save
    Then Separator ':' is accepted (approved set: / - _ . :)
    And Configuration is saved; toaster 'Number Configuration created successfully.'
    And Edit shows common Separator ':'

  # Ref: FRD 6.2 BR-15; US-3 AC-4; FRD 6.2 F-Separator
  @TC_NC_021 @Functional @High @Automation
  Scenario: Verify changing the common Separator updates every attribute Separator that was not overridden
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Common Separator | / then -               |
      | Attributes       | Office, Financial Year |
    When the user adds attributes 'Office' (OFF) and 'Financial Year' (FY) without overriding their Separators
    And the user changes the common Separator from '/' to '-'
    And the user observes each attribute's Separator
    Then Both attribute Separators change to '-'

  # Ref: FRD 6.2 BR-15; US-3 AC-4
  @TC_NC_022 @Functional @High @Automation
  Scenario: Verify changing the common Separator keeps an individually overridden attribute Separator
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Override         | Financial Year = . |
      | Common Separator | -                  |
    When the user adds attributes 'Office' (OFF) and 'Financial Year' (FY)
    And the user overrides the Separator of 'Financial Year' to '.'
    And the user changes the common Separator to '-'
    And the user observes both attribute Separators
    Then 'Office' Separator becomes '-'
    And 'Financial Year' keeps '.' (not individually overridden rule)

  # Ref: FRD 6.2 F-StartWith; FRD 6.2 BR-8; FRD 6.2 FB-5
  @TC_NC_023 @Functional @Medium @Automation
  Scenario: Verify Start With '1' (minimum value) is accepted
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | 1 |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Start With '1'
    And the user clicks Save
    Then Save succeeds; toaster 'Number Configuration created successfully.'

  # Ref: FRD 6.2 F-StartWith; FRD 6.2 BR-8
  @TC_NC_024 @Functional @Medium @Automation
  Scenario: Verify a whole-number Start With of 100 is accepted and persisted
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Start With | 100 |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Start With '100'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds; toaster 'Number Configuration created successfully.'
    And Edit shows Start With '100'

  # Ref: FRD 6.2 F-Digits
  @TC_NC_025 @Functional @Medium @Automation
  Scenario: Verify Digits '00001' (5-digit width) is accepted and persisted
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Digits | 00001 |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Digits '00001'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds; toaster 'Number Configuration created successfully.'
    And Edit shows Digits '00001'

  # Ref: FRD 6.2 F-Digits
  @TC_NC_026 @Functional @Medium @Automation
  Scenario: Verify Digits '001' (3-digit width) is accepted and persisted
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Digits | 001 |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Digits '001'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds; toaster 'Number Configuration created successfully.'
    And Edit shows Digits '001'

  # Ref: FRD 6.2 F-FYFormat; FRD 6.2 BR-3
  @TC_NC_027 @Functional @Medium @Automation
  Scenario: Verify Financial Year / Budget Year Format 'YYYY-YYYY' can be selected and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Financial Year / Budget Year Format | YYYY-YYYY           |
      | Attribute                           | Financial Year (FY) |
    When the user drags attribute 'Financial Year' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'FY' for attribute 'Financial Year'
    And the user selects Financial Year / Budget Year Format 'YYYY-YYYY'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds; toaster 'Number Configuration created successfully.'
    And Edit shows format 'YYYY-YYYY'

  # Ref: FRD 6.2 F-FYFormat; FRD 6.2 BR-3
  @TC_NC_028 @Functional @Medium @Automation
  Scenario: Verify Financial Year / Budget Year Format 'YY-YY' can be selected and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Financial Year / Budget Year Format | YY-YY               |
      | Attribute                           | Financial Year (FY) |
    When the user drags attribute 'Financial Year' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'FY' for attribute 'Financial Year'
    And the user selects Financial Year / Budget Year Format 'YY-YY'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds; toaster 'Number Configuration created successfully.'
    And Edit shows format 'YY-YY'

  # Ref: FRD 6.2 F-FYFormat; FRD 6.2 BR-3
  @TC_NC_029 @Functional @Medium @Automation
  Scenario: Verify Financial Year / Budget Year Format 'YYYY-YY' can be selected and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Financial Year / Budget Year Format | YYYY-YY             |
      | Attribute                           | Financial Year (FY) |
    When the user drags attribute 'Financial Year' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'FY' for attribute 'Financial Year'
    And the user selects Financial Year / Budget Year Format 'YYYY-YY'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds; toaster 'Number Configuration created successfully.'
    And Edit shows format 'YYYY-YY'

  # Ref: FRD 6.2 F-CYFormat; FRD 6.2 BR-4
  @TC_NC_030 @Functional @Medium @Automation
  Scenario: Verify Calendar Year Format 'YY' can be selected and saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Calendar Year Format | YY                 |
      | Attribute            | Calendar Year (CY) |
    When the user drags attribute 'Calendar Year' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'CY' for attribute 'Calendar Year'
    And the user selects Calendar Year Format 'YY'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds; toaster 'Number Configuration created successfully.'
    And Edit shows format 'YY'

  # Ref: FRD 6.2 BR-5; FRD 6.2 BR-6; FRD 6.2 FB-3
  @TC_NC_031 @Functional @Medium @Automation
  Scenario: Verify year formats are only captured when no year attribute is selected
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | FY Format | YY-YY       |
      | CY Format | YY          |
      | Attribute | Office only |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user selects Financial Year / Budget Year Format 'YY-YY' and Calendar Year Format 'YY'
    And the user clicks Save (no year attribute added)
    And the user opens the configuration via Edit
    Then Save succeeds without error
    And Formats are stored (visible on Edit) but have no effect on the configuration since no year attribute is selected

  # Ref: FRD 6.2 F-Prefix; US-3 AC-3
  @TC_NC_032 @Functional @Medium @Automation
  Scenario: Verify an optional Prefix is saved against the attribute
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Prefix | PO- |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Prefix 'PO-' for 'Office'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds
    And Edit shows Prefix 'PO-' on 'Office'

  # Ref: FRD 6.2 F-Suffix; US-3 AC-3
  @TC_NC_033 @Functional @Medium @Automation
  Scenario: Verify an optional Suffix is saved against the attribute
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Suffix | A1 |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Suffix 'A1' for 'Office'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds
    And Edit shows Suffix 'A1' on 'Office'

  # Ref: FRD 6.2 F-Prefix
  @TC_NC_034 @Functional @Medium @Automation
  Scenario: Verify a Prefix of exactly 10 characters (maximum) is accepted
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Prefix | PREFIX1234 (10 chars) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Prefix 'PREFIX1234'
    And the user clicks Save
    Then Save succeeds; toaster 'Number Configuration created successfully.'
    And Full 10-character Prefix is persisted

  # Ref: FRD 6.2 F-Suffix
  @TC_NC_035 @Functional @Medium @Automation
  Scenario: Verify a Suffix of exactly 10 characters (maximum) is accepted
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Suffix | SUFFIX1234 (10 chars) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Suffix 'SUFFIX1234'
    And the user clicks Save
    Then Save succeeds; toaster 'Number Configuration created successfully.'
    And Full 10-character Suffix is persisted

  # Ref: FRD 6.2 F-Prefix
  @TC_NC_036 @Functional @Medium @Automation
  Scenario: Verify leading/trailing spaces in Prefix are trimmed before persistence
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Prefix | ' PO ' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Prefix ' PO ' (with spaces)
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds
    And Persisted Prefix is 'PO' (spaces trimmed)

  # Ref: FRD 6.2 F-Suffix
  @TC_NC_037 @Functional @Medium @Automation
  Scenario: Verify leading/trailing spaces in Suffix are trimmed before persistence
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Suffix | ' 26 ' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Suffix ' 26 ' (with spaces)
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds
    And Persisted Suffix is '26' (spaces trimmed)

  # Ref: FRD 6.2 F-Prefix; FRD 6.2 F-Suffix
  @TC_NC_038 @Functional @Medium @Automation
  Scenario: Verify Prefix and Suffix left blank are accepted (optional)
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Prefix | (blank) |
      | Suffix | (blank) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user leaves Prefix and Suffix blank
    And the user clicks Save
    Then Save succeeds; toaster 'Number Configuration created successfully.'

  # Ref: FRD 6.2 F-Abbreviation
  @TC_NC_039 @Functional @Medium @Automation
  Scenario: Verify a 1-character Abbreviation (minimum) is accepted
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | O |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'O' for attribute 'Office'
    And the user clicks Save
    Then Save succeeds; toaster 'Number Configuration created successfully.'

  # Ref: FRD 6.2 F-Abbreviation
  @TC_NC_040 @Functional @Medium @Automation
  Scenario: Verify an Abbreviation of exactly 10 alphanumeric characters (maximum) is accepted
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | ABCDE12345 |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'ABCDE12345' for attribute 'Office'
    And the user clicks Save
    Then Save succeeds; toaster 'Number Configuration created successfully.'
    And Full 10-character Abbreviation is persisted

  # Ref: FRD 6.2 F-Abbreviation
  @TC_NC_041 @Functional @Medium @Automation
  Scenario: Verify the Abbreviation case as typed is preserved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | Po |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'Po' for attribute 'Office'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Persisted Abbreviation is exactly 'Po' (case not altered)

  # Ref: FRD 6.2 F-Abbreviation
  @TC_NC_042 @Functional @Medium @Automation
  Scenario: Verify leading/trailing spaces in Abbreviation are trimmed
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | ' OFF ' |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation ' OFF ' for attribute 'Office'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds
    And Persisted Abbreviation is 'OFF'

  # Ref: FRD 6.2 BR-14; FRD 6.2 F-Abbreviation
  @TC_NC_043 @Functional @Medium @Automation
  Scenario: Verify the same Abbreviation is allowed in a different configuration of the same Process
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviation | OFF (already used in PO-Cfg-1) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user clicks Save
    Then Save succeeds because uniqueness applies only within the same configuration
    And Toaster 'Number Configuration created successfully.'

  # Ref: FRD 6.2 BR-12; FRD 6.2 FB-10
  @TC_NC_044 @Functional @Medium @Automation
  Scenario: Verify a configuration using every attribute of the pool can be saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Abbreviations | CC, OFF, FY, CY, DEPT |
    When the user drags all five attributes (Company Code, Office, Financial Year, Calendar Year, Department) into the grid
    And the user enters unique Abbreviations CC, OFF, FY, CY, DEPT
    And the user clicks Save
    Then Save succeeds; toaster 'Number Configuration created successfully.'
    And The attribute pool is empty once all attributes are added
