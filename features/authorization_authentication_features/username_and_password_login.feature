@AuthNAuthZ @UsernamePasswordLogin
Feature: Username & Password Login
  Automated scenarios for the "Username & Password Login" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-1; 6.2 FB-3; Sec 8 Toaster #1
  @TC_CP_008 @Functional @High @Automation
  Scenario: Verify successful Username + Password + CAPTCHA login starts a session in the selected organization
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | rahul.sharma    |
      | Password     | Rahul@2026x     |
      | Organization | Alpha Infra Ltd |
      | CAPTCHA      | as displayed    |
    When the user enters Username 'rahul.sharma' and Password 'Rahul@2026x'
    And the user selects Organization 'Alpha Infra Ltd'
    And the user enters the displayed CAPTCHA correctly
    And the user clicks Login
    Then The toaster 'Login successful.' is displayed
    And A session starts with 'Alpha Infra Ltd' as active organization and the ERP opens (US-1 AC-1, 6.2 FB-3, Sec 8 Toaster #1)

  # Ref: 6.2 BR-1; 6.2 F-Username
  @TC_CP_009 @Functional @High @Automation
  Scenario: Verify Username is matched case-insensitively after trimming spaces
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Username     | ' RAHUL.SHARMA ' |
      | Password     | Rahul@2026x      |
      | Organization | Alpha Infra Ltd  |
    When the user enters Username ' RAHUL.SHARMA ' (leading and trailing spaces, upper case)
    And the user enters Password 'Rahul@2026x', select 'Alpha Infra Ltd', enter the CAPTCHA
    And the user clicks Login
    Then Username is trimmed and matched case-insensitively; login succeeds with 'Login successful.' (6.2 BR-1, 6.2 F-Username)

  # Ref: 6.2 F-Username
  @TC_CP_010 @Functional @Medium @Automation
  Scenario: Verify Username accepts exactly 100 characters (boundary)
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Username | 'a' x 100 |
    When the user enters a 100-character Username in the Username box
    And the user counts the characters retained in the box
    Then All 100 characters are accepted (6.2 F-Username max 100)

  # Ref: 6.2 F-Password
  @TC_CP_011 @Functional @Medium @Automation
  Scenario: Verify Password accepts exactly 64 characters (boundary)
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Password | 'Aa1!' x 16 (64 chars) |
    When the user enters a 64-character Password in the Password box
    And the user counts the characters retained in the box
    Then All 64 characters are accepted (6.2 F-Password max 64)

  # Ref: US-4 AC-1; 6.2 F-Organization; 6.5 FB-1
  @TC_CP_012 @Functional @Medium @Automation
  Scenario: Verify Organization dropdown lists only active organizations in alphabetical order with default 'Select Organization'
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Active   | Alpha Infra Ltd, Beta Constructions, Gamma Water Board |
      | Inactive | Delta Legacy Pvt Ltd                                   |
    When the user opens the Login page and observe the dropdown default
    And the user expands the Organization dropdown
    Then Default text is 'Select Organization'
    And List order is Alpha Infra Ltd, Beta Constructions, Gamma Water Board; inactive 'Delta Legacy Pvt Ltd' is not listed (US-4 AC-1, 6.2 F-Organization)

  # Ref: US-4 AC-1; 6.5 FB-1
  @TC_CP_013 @Functional @Medium @Automation
  Scenario: Verify Organization dropdown is mandatory even for a user mapped to only one organization
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | anita.desai     |
      | Password     | Anita@2026x     |
      | Organization | Alpha Infra Ltd |
    When the user enters anita.desai credentials (mapped only to Alpha Infra Ltd)
    And the user selects Organization 'Alpha Infra Ltd' manually and enter the CAPTCHA
    And the user clicks Login
    Then The dropdown is not pre-selected for the single-org user; after manual selection login succeeds and 'Alpha Infra Ltd' becomes the active organization (US-4 AC-1, 6.5 FB-1)

  # Ref: 6.2 F-OTPLink; 6.2 F-ForgotLink
  @TC_CP_014 @Functional @Low @Automation
  Scenario: Verify Login Using OTP and Forgot Password links open their screens
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Links | Login Using OTP, Forgot Password |
    When the user clicks 'Login Using OTP'
    And the user returns to Login and click 'Forgot Password'
    Then 'Login Using OTP' opens the Login Using OTP screen
    And 'Forgot Password' opens the Forgot Password screen (6.2 F-OTPLink, 6.2 F-ForgotLink)

  # Ref: 6.2 F-CAPTCHA
  @TC_CP_015 @Functional @Medium @Automation
  Scenario: Verify CAPTCHA is case-insensitive and refresh icon generates a new CAPTCHA
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | rahul.sharma                    |
      | Password     | Rahul@2026x                     |
      | Organization | Alpha Infra Ltd                 |
      | CAPTCHA      | displayed text in opposite case |
    When the user notes the CAPTCHA text
    And the user clicks the refresh icon and note the new CAPTCHA
    And the user enters the new CAPTCHA in the opposite letter case with valid credentials and click Login
    Then A new CAPTCHA is generated on refresh
    And The CAPTCHA is accepted irrespective of case and login proceeds (6.2 F-CAPTCHA)

  # Ref: 6.2 FB-4; EX-01; US-1 AC-3; Sec 8 Toaster #2
  @TC_CP_016 @Functional @High @Automation
  Scenario: Verify wrong credentials clear Password and CAPTCHA, keep Username and Organization, refresh CAPTCHA and increase the failed count
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | rahul.sharma    |
      | Password     | Wrong@123       |
      | Organization | Alpha Infra Ltd |
    When the user enters Username 'rahul.sharma', wrong Password 'Wrong@123', Organization 'Alpha Infra Ltd', valid CAPTCHA
    And the user clicks Login
    And the user observes the form and the failed-attempt counter
    Then Toaster 'Invalid username or password.' is displayed
    And Password and CAPTCHA fields are cleared; Username and Organization are retained; a new CAPTCHA is shown
    And Failed-attempt count is increased by 1 (6.2 FB-4, EX-01, Sec 8 Toaster #2)

  # Ref: US-1 AC-5; 6.2 FB-5; 6.1 P-Lockout
  @TC_CP_017 @Functional @High @Automation
  Scenario: Verify 5th consecutive failure locks the account for 30 minutes and sends a lock notification email
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User             | lock.user             |
      | Wrong password   | Wrong@123             |
      | Registered email | lock.user@example.com |
    When the user submits 5 consecutive logins for lock.user with a wrong password and valid CAPTCHA
    And the user checks the inbox of the registered email
    And the user verifies the lock state in the admin user screen
    Then Account is locked for 30 minutes (US-1 AC-5, 6.2 FB-5)
    And A lock notification email is sent to the registered email address
    And 'Account Locked' is audited with reason 'failed attempts'

  # Ref: US-1 AC-7
  @TC_CP_018 @Functional @High @Automation
  Scenario: Verify the failed-attempt count is reset to 0 after a successful login
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User           | anita.desai     |
      | Password       | Anita@2026x     |
      | Organization   | Alpha Infra Ltd |
      | Wrong password | Wrong@123       |
    When the user fails login 3 times for anita.desai
    And the user logs in successfully for anita.desai
    And the user logs out, then fail login 4 times for anita.desai
    And the user observes whether the account is locked
    Then After the successful login the counter is reset to 0, so 4 further failures do not lock the account (US-1 AC-7)

  # Ref: 6.5 FB-4; 6.8 SW-1; US-7 AC-2
  @TC_CP_019 @Functional @High @Automation
  Scenario: Verify successful login loads mapped offices and roles and makes the first assigned role active
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User           | rahul.sharma                                |
      | Password       | Rahul@2026x                                 |
      | Organization   | Alpha Infra Ltd                             |
      | Roles in Alpha | Project Manager (1st), Finance Viewer (2nd) |
      | Offices        | Head Office, Pune Office                    |
    When the user logs in as rahul.sharma with Organization 'Alpha Infra Ltd'
    And the user inspects the header and the Switch Role list
    Then Active organization is 'Alpha Infra Ltd', offices Head Office and Pune Office are loaded, and 'Project Manager' is the active role (6.5 FB-4, 6.8 SW-1, US-7 AC-2)

  # Ref: 6.2 FB-1; EX-02
  @TC_CP_020 @Functional @High @Automation
  Scenario: Verify password and username checks are skipped until Organization and CAPTCHA are provided and correct (order of checks)
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | rahul.sharma       |
      | Password     | Rahul@2026x        |
      | Organization | Alpha Infra Ltd    |
      | CAPTCHA      | wrong value 'XXXX' |
    When the user enters valid credentials for rahul.sharma but leave the failed-attempt counter noted at 0
    And the user submits with a correct Organization but wrong CAPTCHA
    And the user verifies the failed-attempt counter
    Then 'Invalid CAPTCHA. Please try again.' is shown and the credentials are not checked, so the counter is unchanged (6.2 FB-1, EX-02)

  # Ref: 6.2 FB-2; EX-04
  @TC_CP_021 @Functional @High @Automation
  Scenario: Verify account status is evaluated only after correct credentials (credentials first, then status)
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User             | inactive.user  |
      | Correct password | Inactive@2026x |
      | Wrong password   | Wrong@123      |
    When the user logs in as inactive.user with correct password
    And the user logs in as inactive.user with wrong password
    Then Correct password shows 'Your account is inactive. Please contact your administrator.' (EX-04)
    And Wrong password shows only 'Invalid username or password.'; account status is not revealed (6.2 FB-2)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-1 AC-2; 6.2 FB-1; 6.2 F-Organization
  @TC_CP_145 @Negative @High @Automation
  Scenario: Verify login without Organization shows 'Organization is required.' and does not check credentials
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | rahul.sharma   |
      | Password     | Rahul@2026x    |
      | Organization | (not selected) |
    When the user enters valid Username, Password and CAPTCHA
    And the user leaves Organization as 'Select Organization'
    And the user clicks Login
    Then 'Organization is required.' is shown; credentials are not checked and the failed-attempt count is unchanged (US-1 AC-2, 6.2 FB-1)

  # Ref: 6.2 F-Username
  @TC_CP_146 @Negative @High @Automation
  Scenario: Verify empty Username shows 'Username is required.'
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Username | (blank) |
    When the user leaves Username empty; fill other fields; click Login
    Then 'Username is required.' is displayed and no login is attempted (6.2 F-Username)

  # Ref: 6.2 F-Password
  @TC_CP_147 @Negative @High @Automation
  Scenario: Verify empty Password shows 'Password is required.'
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Password | (blank) |
    When the user leaves Password empty; fill other fields; click Login
    Then 'Password is required.' is displayed (6.2 F-Password)

  # Ref: 6.2 F-CAPTCHA; 6.2 FB-1
  @TC_CP_148 @Negative @High @Automation
  Scenario: Verify empty CAPTCHA shows 'CAPTCHA is required.'
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | CAPTCHA | (blank) |
    When the user leaves CAPTCHA empty; fill other fields; click Login
    Then 'CAPTCHA is required.' is displayed and credentials are not checked (6.2 F-CAPTCHA, 6.2 FB-1)

  # Ref: US-1 AC-4; EX-02
  @TC_CP_149 @Negative @High @Automation
  Scenario: Verify wrong CAPTCHA shows 'Invalid CAPTCHA. Please try again.', refreshes CAPTCHA and does not check credentials
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | rahul.sharma    |
      | Password     | Rahul@2026x     |
      | Organization | Alpha Infra Ltd |
      | CAPTCHA      | ZZZZ            |
    When the user enters valid credentials and organization, wrong CAPTCHA 'ZZZZ'
    And the user clicks Login
    Then 'Invalid CAPTCHA. Please try again.' is shown; CAPTCHA is refreshed; credentials are not checked and the failed count is not increased (US-1 AC-4, EX-02)

  # Ref: US-1 AC-3; EX-01; 6.11 SR-4
  @TC_CP_150 @Negative @High @Automation
  Scenario: Verify wrong Username shows the same message as a wrong Password (no field disclosure)
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Username | nobody.user                 |
      | Password | Rahul@2026x // rahul.sharma |
      | Data     | Wrong@123                   |
    When the user logs in with unknown username 'nobody.user' and a valid password
    And the user logs in with valid username and wrong password
    Then Both show 'Invalid username or password.' without revealing which field is wrong; CAPTCHA refreshed and count increased (US-1 AC-3, EX-01)

  # Ref: 6.2 BR-1
  @TC_CP_151 @Negative @High @Automation
  Scenario: Verify Password is case-sensitive
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Password | rahul@2026x |
    When the user logs in with Password 'rahul@2026x' (lower case)
    Then Login fails with 'Invalid username or password.' (6.2 BR-1)

  # Ref: 6.2 BR-1
  @TC_CP_152 @Negative @Medium @Automation
  Scenario: Verify Password is never trimmed
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Password | 'Rahul@2026x ' |
    When the user logs in with Password 'Rahul@2026x ' (trailing space)
    Then Login fails because spaces are part of the password (6.2 BR-1)

  # Ref: 6.2 F-Username
  @TC_CP_153 @Negative @Medium @Automation
  Scenario: Verify Username of 101 characters is not accepted
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Username | 'a' x 101 |
    When the user pastes a 101-character username into the Username box
    Then The field restricts input to 100 characters (6.2 F-Username)

  # Ref: 6.2 F-Password
  @TC_CP_154 @Negative @Medium @Automation
  Scenario: Verify Password of 65 characters is not accepted
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Password | 'Aa1!' x 16 + 'A' |
    When the user pastes a 65-character password into the Password box
    Then The field restricts input to 64 characters (6.2 F-Password)

  # Ref: US-1 AC-5; EX-03
  @TC_CP_155 @Negative @High @Automation
  Scenario: Verify correct credentials during lock show the locked message and do not start a session
    Given lock.user is locked
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | lock.user       |
      | Password     | Lock@2026x      |
      | Organization | Alpha Infra Ltd |
    When the user logs in with the correct credentials and CAPTCHA
    Then 'Your account is temporarily locked. Please try again after 30 minutes or contact your administrator.' is shown; no session (US-1 AC-5, EX-03)

  # Ref: 6.2 FB-2
  @TC_CP_156 @Negative @High @Automation
  Scenario: Verify lock message is not shown when the password is wrong for a locked account
    Given lock.user is locked
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | lock.user |
      | Data | Wrong@123 |
    When the user logs in with a wrong password
    Then Only 'Invalid username or password.' is shown, so lock status is not disclosed (6.2 FB-2)

  # Ref: 6.1 P-Lockout
  @TC_CP_157 @Negative @High @Automation
  Scenario: Verify 4 consecutive failures do not lock the account (boundary)
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | anita.desai     |
      | Password     | Anita@2026x     |
      | Organization | Alpha Infra Ltd |
      | Wrong        | Wrong@123       |
    When the user fails login 4 times for anita.desai
    And the user logs in correctly
    Then The account is not locked after 4 failures and the correct login succeeds (6.1 P-Lockout)

  # Ref: US-1 AC-6; EX-04
  @TC_CP_158 @Negative @High @Automation
  Scenario: Verify inactive account with correct credentials is blocked with the inactive message
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | inactive.user   |
      | Password     | Inactive@2026x  |
      | Organization | Alpha Infra Ltd |
    When the user logs in with inactive.user using correct credentials
    Then 'Your account is inactive. Please contact your administrator.' is shown and no session starts (US-1 AC-6, EX-04)

  # Ref: US-1 AC-6; EX-04
  @TC_CP_159 @Negative @High @Automation
  Scenario: Verify suspended account with correct credentials is blocked with the inactive message
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | suspended.user  |
      | Password     | Suspend@2026x   |
      | Organization | Alpha Infra Ltd |
    When the user logs in with suspended.user using correct credentials
    Then 'Your account is inactive. Please contact your administrator.' is shown and no session starts (US-1 AC-6, EX-04)

  # Ref: 6.2 BR-2
  @TC_CP_160 @Negative @High @Automation
  Scenario: Verify a locked, inactive or suspended account cannot authenticate by OTP or SSO
    Given lock.user is locked; inactive.user is inactive
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Users | lock.user, inactive.user |
    When the user requests OTP for each account and use any OTP
    And the user tries an SSO token for each account
    Then No OTP is delivered and no authentication through any method is possible (6.2 BR-2)

  # Ref: US-4 AC-2; EX-05a; 6.5 FB-2
  @TC_CP_161 @Negative @High @Automation
  Scenario: Verify an unmapped organization does not count as a failed attempt
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | anita.desai        |
      | Password     | Anita@2026x        |
      | Organization | Beta Constructions |
    When the user logs in as anita.desai with correct credentials selecting 'Beta Constructions' 5 times
    And the user logs in with 'Alpha Infra Ltd'
    Then Each attempt shows 'You are not mapped to the selected organization. Please contact your administrator.'; failed count is not increased and the account is not locked (US-4 AC-2, EX-05a)

  # Ref: US-4 AC-3; EX-05; 6.5 FB-3
  @TC_CP_162 @Negative @High @Automation
  Scenario: Verify a user with no organization mapping gets the no-organization message for any selection
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User     | nomap.user  |
      | Password | NoMap@2026x |
    When the user logs in as nomap.user with correct credentials selecting 'Alpha Infra Ltd'
    And the user repeats selecting 'Gamma Water Board'
    Then 'No organization is assigned to your account. Please contact your administrator.' is shown both times; no session (US-4 AC-3, EX-05, 6.5 FB-3)

  # Ref: 6.5 BR-3
  @TC_CP_163 @Negative @High @Automation
  Scenario: Verify manipulated organization value in the login request is rejected
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | anita.desai             |
      | Password     | Anita@2026x             |
      | Organization | Alpha Infra Ltd         |
      | Data         | organizationId tampered |
    When the user intercepts the login request for anita.desai and replace organizationId with that of 'Gamma Water Board'
    Then The server rejects the unmapped value; no session is started (6.5 BR-3)

  # Ref: 6.2 F-Organization
  @TC_CP_164 @Negative @Medium @Automation
  Scenario: Verify the Organization dropdown does not list inactive organizations
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Inactive | Delta Legacy Pvt Ltd |
    When the user opens the Organization dropdown
    Then 'Delta Legacy Pvt Ltd' is not listed (6.2 F-Organization)
