@RateCard @DisplaySequence
Feature: Display Sequence
  Automated scenarios for the "Display Sequence" module of Rate Card.
  Source: CivitINFRA_RateCard_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CIC-F-007_CivitINFRA Configuration_Rate Card Management.pdf (Ver 1.0, 04-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-7 AC-1; FRD 5.3 SEQ-2; FRD Sec 7 Toaster #5
  @TC_RC_060 @Functional @High @Automation
  Scenario: Verify dragging a row from position 3 to position 1 saves the order immediately and shows the toaster
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Civit-ratecard |
      | From      | 3              |
      | To        | 1              |
    When the user drags the handle of 'Civit-ratecard' (Sl. No. 3) and drop it at position 1
    And the user observes the list and toaster
    Then 'Civit-ratecard' is Sl. No. 1
    And 'Coastal Region' and 'Desert Zone' move down by one (Sl. No. 2 and 3)
    And Toaster 'Sequence updated successfully.' is displayed and no Save button is needed

  # Ref: FRD 5.3 SEQ-1; FRD 5.3 SEQ-2
  @TC_RC_061 @Functional @Medium @Automation
  Scenario: Verify dragging a row down moves the rows in between up by one
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Coastal Region |
      | From      | 1              |
      | To        | 4              |
    When the user drags the handle of 'Coastal Region' (Sl. No. 1) and drop it at position 4
    Then 'Coastal Region' is Sl. No. 4
    And 'Desert Zone', 'Civit-ratecard' and 'Sub Mountanious' move up to Sl. No. 1, 2 and 3

  # Ref: FRD 5.3 SEQ-2; FRD 5.3 FB-1
  @TC_RC_062 @Functional @Medium @Automation
  Scenario: Verify Sl. No. is re-sequenced after a drop
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Hill Zone |
      | From      | 5         |
      | To        | 2         |
    When the user drags 'Hill Zone' (Sl. No. 5) to position 2
    And the user reads the Sl. No. column top to bottom
    Then Sl. No. reads 1, 2, 3 ... 8 consecutively with no gaps or duplicates

  # Ref: FRD 5.3 SEQ-2; US-7 AC-1
  @TC_RC_063 @Functional @Medium @Automation
  Scenario: Verify the new sequence persists after page refresh
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Civit-ratecard |
    When the user drags 'Civit-ratecard' to position 1
    And the user refreshes the browser
    And the user observes the list
    Then 'Civit-ratecard' is still Sl. No. 1 after refresh

  # Ref: FRD 5.3 SEQ-1; FRD 5.3 BR-2
  @TC_RC_064 @Functional @Medium @Automation
  Scenario: Verify a row can be reordered within page 2 and Sl. No. stays continuous
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Page | 2  |
      | From | 75 |
      | To   | 52 |
    When the user goes to page 2 (Sl. No. 51 to 100)
    And the user drags the row at Sl. No. 75 to Sl. No. 52
    Then Row moves to Sl. No. 52; rows 52 to 74 move down by one; Sl. No. remains 51 to 100 on page 2

  # Ref: US-7 AC-3; FRD 5.3 SEQ-6; FRD 5.7 FB-2
  @TC_RC_065 @Functional @High @Automation
  Scenario: Verify the new order is used by every dependent process selection
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Civit-ratecard moved to Sl. No. 1 |
    When the user drags 'Civit-ratecard' to position 1
    And the user opens the Rate Card selection of Office Creation
    And the user repeats for Resource Rate, Item definition, Reports and Lead Rate Management
    Then Each selection lists the Rate Cards in the new order with 'Civit-ratecard' first

  # Ref: US-7 AC-4
  @TC_RC_066 @Functional @Medium @Automation
  Scenario: Verify a Rate Card added after a reorder is still placed at the top
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Highland Zone    |
      | Reordered | Hill Zone 5 -> 8 |
    When the user drags 'Hill Zone' (Sl. No. 5) and drop it at position 8 (bottom)
    And the user adds Rate Card 'Highland Zone'
    Then 'Highland Zone' is Sl. No. 1 and all other Rate Cards (including the reordered ones) move down by one keeping their relative order

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-7 AC-5; FRD 5.3 SEQ-5
  @TC_RC_198 @Negative @High @Automation
  Scenario: Verify drag handles are disabled while a column search is active
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Search | Zone |
    When the user types 'Zone' in the Rate Card Name search box
    And the user tries to drag 'Hill Zone' above 'Desert Zone'
    Then The row cannot be moved; the order is unchanged and no toaster is displayed

  # Ref: US-7 AC-5; FRD 5.3 SEQ-5
  @TC_RC_199 @Negative @High @Automation
  Scenario: Verify drag handles are disabled for a user without Edit permission
    Given Viewer_User1 (Rate Card: View only) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | Viewer_User1 |
    When the user tries to drag 'Hill Zone' above 'Desert Zone'
    Then The row cannot be moved; the order is unchanged

  # Ref: US-7 AC-2; FRD 5.3 SEQ-4
  @TC_RC_200 @Negative @High @Automation
  Scenario: Verify a row cannot be dropped on another page
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Large dataset DS-120 (120 Rate Cards) (see Summary) is loaded
    And the following test data is used
      | Row    | Sl. No. 1 |
      | Target | page 2    |
    When On page 1 drag the row at Sl. No. 1 and drop it onto the 'Next' control / page 2 number
    Then The row stays on page 1 in its original position; page 2 is unchanged

  # Ref: FRD 5.3 SEQ-4
  @TC_RC_201 @Negative @Medium @Automation
  Scenario: Verify dropping a row outside the grid leaves the order unchanged
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Rate Card | Hill Zone |
    When the user drags 'Hill Zone' and drop it on the page header area outside the grid
    Then Order is unchanged and no toaster is displayed

  # Ref: US-7 AC-6; FRD 5.3 SEQ-3; FRD Sec 7 Toaster #6
  @TC_RC_202 @Negative @High @Automation
  Scenario: Verify rows return to the previous order and an error toaster is shown when the sequence cannot be saved
    Given Admin_User1 (Rate Card: View/Add/Edit/Delete) is logged in and on the Rate Card List page
    And Baseline data (the sequence-save API is forced to fail) (see Summary) is loaded
    And the following test data is used
      | Rate Card | Civit-ratecard |
      | Save      | forced failure |
    When the user drags 'Civit-ratecard' (Sl. No. 3) to position 1
    And the user observes the list and toaster
    Then Error toaster 'Unable to update the sequence. Please try again.' is displayed
    And Rows return to their previous order ('Civit-ratecard' is Sl. No. 3 again)
