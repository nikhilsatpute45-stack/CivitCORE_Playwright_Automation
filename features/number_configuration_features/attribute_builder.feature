@NumberConfiguration @AttributeBuilder
Feature: Attribute Builder
  Automated scenarios for the "Attribute Builder" module of Number Configuration.
  Source: CivitCORE_NumberConfiguration_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-014_CivitCORE_Core Configuration_Number Configuration.pdf (Ver 1.0, 30-Sep-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-1; FRD 6.2 FB-6; FRD 6.2 BR-12
  @TC_NC_045 @Functional @High @Automation
  Scenario: Verify a dragged attribute is added at the drop position, removed from the pool and shows its Order
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute | Office |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user observes the attribute grid and the attribute pool
    Then 'Office' is added to the grid at the dropped position with Order 1
    And 'Office' is no longer available in the pool

  # Ref: US-3 AC-1; FRD 6.2 FB-6
  @TC_NC_046 @Functional @High @Automation
  Scenario: Verify an attribute dropped between two existing rows is inserted at that position
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attributes | Office, Financial Year, Company Code |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user drags attribute 'Financial Year' from the attribute pool into the attribute grid
    And the user drags 'Company Code' and drop it between 'Office' and 'Financial Year'
    And the user observes the Order column
    Then Grid sequence is Office (1), Company Code (2), Financial Year (3)

  # Ref: US-3 AC-2; FRD 6.2 FB-8; FRD 6.2 BR-13
  @TC_NC_047 @Functional @High @Automation
  Scenario: Verify dragging a row to a new position updates the Order of all affected attributes
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Initial | Office, Financial Year, Company Code |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user drags attribute 'Financial Year' from the attribute pool into the attribute grid
    And the user drags attribute 'Company Code' from the attribute pool into the attribute grid
    And the user drags the 'Company Code' row to the first position
    And the user observes the Order column
    Then New sequence: Company Code (1), Office (2), Financial Year (3)
    And Order of every affected attribute is updated

  # Ref: US-3 AC-7; FRD 6.2 FB-9; FRD 6.2 BR-12
  @TC_NC_048 @Functional @High @Automation
  Scenario: Verify removing an attribute returns it to the available pool
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute | Office |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user removes 'Office' from the grid
    And the user observes the grid and the attribute pool
    Then 'Office' is removed from the grid
    And 'Office' is available again in the pool

  # Ref: US-3 AC-7; FRD 6.2 BR-12
  @TC_NC_050 @Functional @Medium @Automation
  Scenario: Verify a removed attribute can be added again
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute | Office |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user removes 'Office' from the grid
    And the user drags attribute 'Office' from the attribute pool into the attribute grid
    Then 'Office' is added again with default Display and Start New Number checked and a blank Abbreviation

  # Ref: FRD 6.2 BR-13; US-3 AC-2
  @TC_NC_051 @Functional @Medium @Automation
  Scenario: Verify Order is renumbered when a middle attribute is removed
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Initial | Office (1), Financial Year (2), Company Code (3) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user drags attribute 'Financial Year' from the attribute pool into the attribute grid
    And the user drags attribute 'Company Code' from the attribute pool into the attribute grid
    And the user removes 'Financial Year' from the grid
    And the user observes the Order column
    Then Remaining attributes are Office (1) and Company Code (2); Order stays position-based

  # Ref: US-3 AC-4; FRD 6.2 F-AttrSeparator
  @TC_NC_052 @Functional @High @Automation
  Scenario: Verify each attribute Separator is pre-filled from the common Separator
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Common Separator | : |
    When the user sets the common Separator to ':'
    And the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user observes the Separator of 'Office'
    Then 'Office' Separator is pre-filled with ':'

  # Ref: US-3 AC-4; FRD 6.2 BR-15; FRD 6.2 F-AttrSeparator
  @TC_NC_053 @Functional @High @Automation
  Scenario: Verify an attribute Separator override is saved and used instead of the common Separator
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Common Separator | / |
      | Office Separator | - |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user changes the Separator of 'Office' to '-'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Edit shows common Separator '/' and 'Office' Separator '-'
    And The override '-' is used for that attribute going forward

  # Ref: US-3 AC-5; FRD 6.2 BR-16; FRD 6.2 BR-17; FRD 6.2 F-Display; FRD 6.2 F-StartNew
  @TC_NC_054 @Functional @High @Automation
  Scenario: Verify Display and Start New Number are checked by default on an added attribute
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Attribute | Office |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user observes the Display and Start New Number checkboxes
    Then Display is checked
    And Start New Number is checked

  # Ref: US-3 AC-5; FRD 6.2 F-Display; FRD 6.2 F-StartNew
  @TC_NC_055 @Functional @Medium @Automation
  Scenario: Verify unchecking Display and Start New Number is saved
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Display          | unchecked |
      | Start New Number | unchecked |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user unchecks Display and uncheck Start New Number for 'Office'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Save succeeds
    And Edit shows both checkboxes unchecked

  # Ref: US-3 AC-3
  @TC_NC_056 @Functional @High @Automation
  Scenario: Verify Prefix, Abbreviation, Suffix and Display are persisted against each attribute
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Prefix       | P-        |
      | Abbreviation | OFF       |
      | Suffix       | -X        |
      | Display      | unchecked |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user enters Abbreviation 'OFF' for attribute 'Office'
    And the user enters Prefix 'P-' and Suffix '-X' for 'Office'
    And the user unchecks Display
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Edit shows Prefix 'P-', Abbreviation 'OFF', Suffix '-X', Display unchecked for 'Office'

  # Ref: FRD 6.2 BR-13; US-3 AC-2
  @TC_NC_058 @Functional @High @Automation
  Scenario: Verify the attribute order is persisted after Save
    Given Admin_User1 (Number Configuration: Add/View/Edit/Delete/Activate) is logged in and the 'Add' form is open for Process 'Purchase Order' (configurations already exist, so Status is InActive)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Order | Financial Year (1), Office (2) |
    When the user drags attribute 'Office' from the attribute pool into the attribute grid
    And the user drags attribute 'Financial Year' from the attribute pool into the attribute grid
    And the user enters Abbreviations OFF and FY
    And the user drags 'Financial Year' above 'Office'
    And the user clicks Save
    And the user opens the configuration via Edit
    Then Edit shows Financial Year (1) then Office (2)
