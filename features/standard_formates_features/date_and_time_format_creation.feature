@StandardsFormats @DateTimeFormatCreation
Feature: Date & Time Format Creation
  Automated scenarios for the "Date & Time Format Creation" module of Standards & Formats.
  Source: CivitCORE_StandardsFormats_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-011 CivitCORE Core Configuration - Standards & Format (Quantity, Currency, Date & Time), Ver 1.0, 24-Sep-2026

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-1; FRD 6.2 FB-1; FRD 6.2 FB-2; FRD 6.2 FB-4; FRD 6.2 FB-5; FRD 6.2 FB-6; FRD Sec 8 Toaster #3; FRD Fig 1
  @TC_SF_011 @Functional @High @Automation
  Scenario: Verify a Date & Time configuration is created with all mandatory fields and toaster is shown
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Date Time tab of Standards & Formats Management
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India)    |
      | Name              | India Date Time 01 |
      | Long Date Format  | dd MMMM yyyy       |
      | Date Separator    | /                  |
      | Short Date Format | dd/MM/yyyy         |
      | Time Separator    | :                  |
      | AM Symbol         | AM                 |
      | PM Symbol         | PM                 |
      | Time Format       | hh:mm:ss tt        |
    When the user clicks 'Add'
    And the user selects the Culture
    And the user enters the Name
    And the user selects/enter all remaining mandatory fields
    And the user clicks Save
    Then System generates a unique Date & Time Formats ID and creates the record in the Standards & Formats Master
    And Toaster 'Date & Time format created successfully.' is displayed
    And The new record 'India Date Time 01' is visible in the Date Time list

  # Ref: FRD 6.2.3 F-Culture; FRD 6.2 FB-3
  @TC_SF_018 @Functional @High @Automation
  Scenario: Verify selecting a Culture loads culture-specific defaults on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture | English (United States) |
    When the user selects Culture 'English (United States)'
    And the user observes the defaults/options of the remaining fields
    Then Culture-specific defaults/options for English (United States) are loaded

  # Ref: FRD 6.2.3 F-Sample
  @TC_SF_039 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Long Date Format is changed on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Long Date Format | dd MMMM yyyy -> MMMM dd, yyyy |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Long Date Format as per Test Data
    And the user observes the Sample area without clicking Save
    Then Long Date sample changes from '16 November 2026' to 'November 16, 2026' (illustrative date)
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.3 F-Sample
  @TC_SF_040 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Date Separator is changed on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Date Separator | / -> - |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Date Separator as per Test Data
    And the user observes the Sample area without clicking Save
    Then Short Date sample changes separator (e.g., 16/11/2026 -> 16-11-2026)
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.3 F-Sample
  @TC_SF_041 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Short Date Format is changed on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Short Date Format | dd/MM/yyyy -> MM/dd/yyyy |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Short Date Format as per Test Data
    And the user observes the Sample area without clicking Save
    Then Short Date sample changes from 16/11/2026 to 11/16/2026
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.3 F-Sample
  @TC_SF_042 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Time Separator is changed on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Time Separator | : -> . |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Time Separator as per Test Data
    And the user observes the Sample area without clicking Save
    Then Time sample changes separator (e.g., 02:30:15 PM -> 02.30.15 PM)
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.3 F-Sample
  @TC_SF_043 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when AM Symbol is changed on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | AM Symbol | AM -> A.M. |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes AM Symbol as per Test Data
    And the user observes the Sample area without clicking Save
    Then Time sample for a morning time shows 'A.M.' (e.g., 09:15:00 A.M.)
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.3 F-Sample
  @TC_SF_044 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when PM Symbol is changed on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | PM Symbol | PM -> P.M. |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes PM Symbol as per Test Data
    And the user observes the Sample area without clicking Save
    Then Time sample for an afternoon time shows 'P.M.' (e.g., 02:30:15 P.M.)
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.3 F-Sample
  @TC_SF_045 @Functional @Medium @Automation
  Scenario: Verify Sample refreshes when Time Format is changed on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Time Format | hh:mm:ss tt -> HH:mm:ss |
    When the user selects Culture 'English (India)' and fill the other mandatory fields
    And the user notes the Sample area
    And the user changes Time Format as per Test Data
    And the user observes the Sample area without clicking Save
    Then Time sample changes from 12-hour with AM/PM to 24-hour (e.g., 14:30:15)
    And The Sample is read-only and refreshes immediately. Note: Sample strings are illustrative; Positive/Negative Format option lists and sample patterns are not enumerated in the FRD (OQ-6)

  # Ref: FRD 6.2.3 F-Sample
  @TC_SF_047 @Functional @Medium @Automation
  Scenario: Verify Sample displays Long Date, Short Date and Time values
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India)    |
      | Name              | India Date Time 01 |
      | Long Date Format  | dd MMMM yyyy       |
      | Date Separator    | /                  |
      | Short Date Format | dd/MM/yyyy         |
      | Time Separator    | :                  |
      | AM Symbol         | AM                 |
      | PM Symbol         | PM                 |
      | Time Format       | hh:mm:ss tt        |
    When the user fills all mandatory fields with Test Data
    And the user observes the Sample (Long Date / Short Date / Time) area
    Then A live sample for Long Date, Short Date and Time is generated from the selected values

  # Ref: FRD 6.2.3 F-Name; FRD Sec 8 Toaster #3
  @TC_SF_059 @Functional @High @Automation
  Scenario: Verify Date & Time Name accepts alphabetic characters, numbers and spaces
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India)      |
      | Name              | Format Set 2026 Plan |
      | Long Date Format  | dd MMMM yyyy         |
      | Date Separator    | /                    |
      | Short Date Format | dd/MM/yyyy           |
      | Time Separator    | :                    |
      | AM Symbol         | AM                   |
      | PM Symbol         | PM                   |
      | Time Format       | hh:mm:ss tt          |
    When the user fills all mandatory fields
    And the user enters Name 'Format Set 2026 Plan'
    And the user clicks Save
    Then Record is saved with Name 'Format Set 2026 Plan'
    And Toaster 'Date & Time format created successfully.' is displayed

  # Ref: FRD 6.2.3 F-Name
  @TC_SF_060 @Functional @Medium @Automation
  Scenario: Verify Date & Time Name accepts uppercase and lowercase characters
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India)      |
      | Name              | UPPER lower Mixed 07 |
      | Long Date Format  | dd MMMM yyyy         |
      | Date Separator    | /                    |
      | Short Date Format | dd/MM/yyyy           |
      | Time Separator    | :                    |
      | AM Symbol         | AM                   |
      | PM Symbol         | PM                   |
      | Time Format       | hh:mm:ss tt          |
    When the user fills all mandatory fields
    And the user enters Name 'UPPER lower Mixed 07'
    And the user clicks Save
    Then Record is saved and the Name is stored with the entered case

  # Ref: FRD 6.2 BR-5; FRD 6.2.3 F-Name
  @TC_SF_061 @Functional @High @Automation
  Scenario: Verify leading and trailing spaces in Date & Time Name are trimmed before persistence
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India) |
      | Name              | Trimmed Name 01 |
      | Long Date Format  | dd MMMM yyyy    |
      | Date Separator    | /               |
      | Short Date Format | dd/MM/yyyy      |
      | Time Separator    | :               |
      | AM Symbol         | AM              |
      | PM Symbol         | PM              |
      | Time Format       | hh:mm:ss tt     |
    When the user fills all mandatory fields
    And the user enters Name ' Trimmed Name 01 ' (3 leading and 3 trailing spaces)
    And the user clicks Save
    And the user opens the record in View mode
    Then Record is saved and the stored Name is 'Trimmed Name 01' without leading/trailing spaces

  # Ref: FRD 6.2.3 F-Name
  @TC_SF_062 @Functional @Medium @Automation
  Scenario: Verify a single-character Date & Time Name (minimum length) is accepted
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India) |
      | Name              | Z               |
      | Long Date Format  | dd MMMM yyyy    |
      | Date Separator    | /               |
      | Short Date Format | dd/MM/yyyy      |
      | Time Separator    | :               |
      | AM Symbol         | AM              |
      | PM Symbol         | PM              |
      | Time Format       | hh:mm:ss tt     |
    When the user fills all mandatory fields
    And the user enters Name 'Z'
    And the user clicks Save
    Then Record is saved with Name 'Z' (blank is the only invalid shorter value). Note: FRD defines no minimum length; 1 character assumed to be the minimum since blank is rejected (OQ-7)

  # Ref: FRD 6.2.3 F-Name
  @TC_SF_063 @Functional @Medium @Automation
  Scenario: Verify a 100-character Date & Time Name (recommended maximum) is accepted
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India)                                                                                      |
      | Name              | Maxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx |
      | Long Date Format  | dd MMMM yyyy                                                                                         |
      | Date Separator    | /                                                                                                    |
      | Short Date Format | dd/MM/yyyy                                                                                           |
      | Time Separator    | :                                                                                                    |
      | AM Symbol         | AM                                                                                                   |
      | PM Symbol         | PM                                                                                                   |
      | Time Format       | hh:mm:ss tt                                                                                          |
    When the user fills all mandatory fields
    And the user enters a 100-character Name
    And the user clicks Save
    Then Record is saved with the full 100-character Name

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-4; FRD 6.2.3 F-Culture; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_223 @Negative @High @Automation
  Scenario: Verify Save is blocked when Culture is left blank on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Culture                                                                                                                                                                       |
      | Other fields | Name=India Date Time 01; Long Date Format=dd MMMM yyyy; Date Separator=/; Short Date Format=dd/MM/yyyy; Time Separator=:; AM Symbol=AM; PM Symbol=PM; Time Format=hh:mm:ss tt |
    When the user fills every mandatory field except Culture
    And the user leaves Culture showing 'Select Culture'
    And the user clicks Save
    Then Save is blocked and the message 'Culture is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-4; FRD 6.2.3 F-Name; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_224 @Negative @High @Automation
  Scenario: Verify Save is blocked when Name is left blank on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Name                                                                                                                                                                          |
      | Other fields | Culture=English (India); Long Date Format=dd MMMM yyyy; Date Separator=/; Short Date Format=dd/MM/yyyy; Time Separator=:; AM Symbol=AM; PM Symbol=PM; Time Format=hh:mm:ss tt |
    When the user fills every mandatory field except Name
    And the user leaves Name showing 'Enter Name'
    And the user clicks Save
    Then Save is blocked and the message 'Name is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-4; FRD 6.2.3 F-LongDate; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_225 @Negative @High @Automation
  Scenario: Verify Save is blocked when Long Date Format is left blank on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Long Date Format                                                                                                                                                        |
      | Other fields | Culture=English (India); Name=India Date Time 01; Date Separator=/; Short Date Format=dd/MM/yyyy; Time Separator=:; AM Symbol=AM; PM Symbol=PM; Time Format=hh:mm:ss tt |
    When the user fills every mandatory field except Long Date Format
    And the user leaves Long Date Format showing 'Select Long Date Format'
    And the user clicks Save
    Then Save is blocked and the message 'Long Date Format is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-4; FRD 6.2.3 F-DateSep; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_226 @Negative @High @Automation
  Scenario: Verify Save is blocked when Date Separator is left blank on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Date Separator                                                                                                                                                                       |
      | Other fields | Culture=English (India); Name=India Date Time 01; Long Date Format=dd MMMM yyyy; Short Date Format=dd/MM/yyyy; Time Separator=:; AM Symbol=AM; PM Symbol=PM; Time Format=hh:mm:ss tt |
    When the user fills every mandatory field except Date Separator
    And the user leaves Date Separator showing 'Select Date Separator'
    And the user clicks Save
    Then Save is blocked and the message 'Date Separator is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-4; FRD 6.2.3 F-ShortDate; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_227 @Negative @High @Automation
  Scenario: Verify Save is blocked when Short Date Format is left blank on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Short Date Format                                                                                                                                                        |
      | Other fields | Culture=English (India); Name=India Date Time 01; Long Date Format=dd MMMM yyyy; Date Separator=/; Time Separator=:; AM Symbol=AM; PM Symbol=PM; Time Format=hh:mm:ss tt |
    When the user fills every mandatory field except Short Date Format
    And the user leaves Short Date Format showing 'Select Short Date Format'
    And the user clicks Save
    Then Save is blocked and the message 'Short Date Format is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-4; FRD 6.2.3 F-TimeSep; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_228 @Negative @High @Automation
  Scenario: Verify Save is blocked when Time Separator is left blank on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Time Separator                                                                                                                                                                       |
      | Other fields | Culture=English (India); Name=India Date Time 01; Long Date Format=dd MMMM yyyy; Date Separator=/; Short Date Format=dd/MM/yyyy; AM Symbol=AM; PM Symbol=PM; Time Format=hh:mm:ss tt |
    When the user fills every mandatory field except Time Separator
    And the user leaves Time Separator showing 'Select Time Separator'
    And the user clicks Save
    Then Save is blocked and the message 'Time Separator is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-4; FRD 6.2.3 F-AM; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_229 @Negative @High @Automation
  Scenario: Verify Save is blocked when AM Symbol is left blank on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | AM Symbol                                                                                                                                                                                |
      | Other fields | Culture=English (India); Name=India Date Time 01; Long Date Format=dd MMMM yyyy; Date Separator=/; Short Date Format=dd/MM/yyyy; Time Separator=:; PM Symbol=PM; Time Format=hh:mm:ss tt |
    When the user fills every mandatory field except AM Symbol
    And the user leaves AM Symbol showing 'Select AM Symbol'
    And the user clicks Save
    Then Save is blocked and the message 'AM Symbol is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-4; FRD 6.2.3 F-PM; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_230 @Negative @High @Automation
  Scenario: Verify Save is blocked when PM Symbol is left blank on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | PM Symbol                                                                                                                                                                                |
      | Other fields | Culture=English (India); Name=India Date Time 01; Long Date Format=dd MMMM yyyy; Date Separator=/; Short Date Format=dd/MM/yyyy; Time Separator=:; AM Symbol=AM; Time Format=hh:mm:ss tt |
    When the user fills every mandatory field except PM Symbol
    And the user leaves PM Symbol showing 'Select PM Symbol'
    And the user clicks Save
    Then Save is blocked and the message 'PM Symbol is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: US-1 AC-4; FRD 6.2.3 F-TimeFmt; FRD 6.2 FB-4; FRD 6.2 BR-3
  @TC_SF_231 @Negative @High @Automation
  Scenario: Verify Save is blocked when Time Format is left blank on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Blank field  | Time Format                                                                                                                                                                   |
      | Other fields | Culture=English (India); Name=India Date Time 01; Long Date Format=dd MMMM yyyy; Date Separator=/; Short Date Format=dd/MM/yyyy; Time Separator=:; AM Symbol=AM; PM Symbol=PM |
    When the user fills every mandatory field except Time Format
    And the user leaves Time Format showing 'Select Time Format'
    And the user clicks Save
    Then Save is blocked and the message 'Time Format is required' is displayed
    And No record is created and no ID is generated
    And No Activity Log entry is created

  # Ref: FRD 6.2 BR-5; FRD 6.2.3 F-Name
  @TC_SF_244 @Negative @High @Automation
  Scenario: Verify whitespace-only Name is rejected on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India) |
      | Name              | ' ' (5 spaces)  |
      | Long Date Format  | dd MMMM yyyy    |
      | Date Separator    | /               |
      | Short Date Format | dd/MM/yyyy      |
      | Time Separator    | :               |
      | AM Symbol         | AM              |
      | PM Symbol         | PM              |
      | Time Format       | hh:mm:ss tt     |
    When the user fills all mandatory fields
    And the user enters 5 spaces as Name
    And the user clicks Save
    Then Save is blocked with 'Name is required'; no record is created. Note: Whitespace-only treated as blank so the 'required' message is expected (OQ-1)

  # Ref: FRD 6.2 BR-4; FRD 6.2.3 F-Name
  @TC_SF_245 @Negative @High @Automation
  Scenario: Verify an exact duplicate Name is rejected on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India)    |
      | Name              | Standard Date Time |
      | Long Date Format  | dd MMMM yyyy       |
      | Date Separator    | /                  |
      | Short Date Format | dd/MM/yyyy         |
      | Time Separator    | :                  |
      | AM Symbol         | AM                 |
      | PM Symbol         | PM                 |
      | Time Format       | hh:mm:ss tt        |
    When the user fills all mandatory fields
    And the user enters Name 'Standard Date Time'
    And the user clicks Save
    Then Save is blocked with 'Name already exists'; no record is created

  # Ref: FRD 6.2 BR-4; FRD 6.2.3 F-Name
  @TC_SF_246 @Negative @High @Automation
  Scenario: Verify a Name differing only in case is treated as a duplicate on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India)    |
      | Name              | standard date time |
      | Long Date Format  | dd MMMM yyyy       |
      | Date Separator    | /                  |
      | Short Date Format | dd/MM/yyyy         |
      | Time Separator    | :                  |
      | AM Symbol         | AM                 |
      | PM Symbol         | PM                 |
      | Time Format       | hh:mm:ss tt        |
    When the user fills all mandatory fields
    And the user enters Name 'standard date time'
    And the user clicks Save
    Then Save is blocked with 'Name already exists' (case-insensitive uniqueness)

  # Ref: FRD 6.2 BR-5; FRD 6.2 BR-4; FRD 6.2.3 F-Name
  @TC_SF_247 @Negative @High @Automation
  Scenario: Verify a duplicate Name with surrounding spaces is rejected after trimming on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India)    |
      | Name              | Standard Date Time |
      | Long Date Format  | dd MMMM yyyy       |
      | Date Separator    | /                  |
      | Short Date Format | dd/MM/yyyy         |
      | Time Separator    | :                  |
      | AM Symbol         | AM                 |
      | PM Symbol         | PM                 |
      | Time Format       | hh:mm:ss tt        |
    When the user fills all mandatory fields
    And the user enters Name ' Standard Date Time '
    And the user clicks Save
    Then Spaces are trimmed before validation and 'Name already exists' is displayed

  # Ref: FRD 6.2.3 F-Name; FRD 6.2 FB-4
  @TC_SF_248 @Negative @High @Automation
  Scenario: Verify special characters in Name are rejected on the Date & Time form
    Given Admin_User1 (Standards & Formats Management: Add/View/Edit/Delete) is logged in and on the Add Date Time Format form (Date Time tab)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Culture           | English (India) |
      | Name              | Std@Qty#1       |
      | Long Date Format  | dd MMMM yyyy    |
      | Date Separator    | /               |
      | Short Date Format | dd/MM/yyyy      |
      | Time Separator    | :               |
      | AM Symbol         | AM              |
      | PM Symbol         | PM              |
      | Time Format       | hh:mm:ss tt     |
    When the user fills all mandatory fields
    And the user enters Name 'Std@Qty#1'
    And the user clicks Save
    Then Save is blocked; special characters are not allowed and no record is created. Note: Error message text for invalid characters is not defined (OQ-2)

  # Ref: FRD 6.2.3 F-Culture; FRD 6.2 FB-4
  @TC_SF_271 @Negative @High @Automation
  Scenario: Verify create is rejected when Culture is not from the configured list (Date & Time, API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1        |
      | Culture | Klingon (Mars)     |
      | Data    | other fields valid |
    When the user sends a create-Date & Time request with Culture set to an unsupported value
    And the user checks the Master
    Then Request is rejected with a validation error; no record is created

  # Ref: FRD 6.2.3 F-TimeFmt; FRD 6.2 FB-4
  @TC_SF_272 @Negative @High @Automation
  Scenario: Verify create is rejected when Time Format is not from the configured list (Date & Time, API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User        | Admin_User1        |
      | Time Format | zz:qq              |
      | Data        | other fields valid |
    When the user sends a create-Date & Time request with Time Format set to an unsupported value
    And the user checks the Master
    Then Request is rejected with a validation error; no record is created

  # Ref: FRD 6.2.3 F-Culture
  @TC_SF_275 @Negative @High @Automation
  Scenario: Verify create is rejected when Culture is null (Date & Time, API)
    Given API client authenticated with the token of the user named in Test Data
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User    | Admin_User1        |
      | Culture | null               |
      | Data    | other fields valid |
    When the user sends a create-Date & Time request with Culture null
    And the user checks the Master
    Then Request is rejected ('Culture is required'); no record is created (field shall not accept blank/null)
