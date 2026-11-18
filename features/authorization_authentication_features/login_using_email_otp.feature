@AuthNAuthZ @LoginUsingEmailOtp
Feature: Login Using Email OTP
  Automated scenarios for the "Login Using Email OTP" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-1; 6.3 FB-1; 6.3 FB-2; Sec 8 Toaster #3
  @TC_CP_022 @Functional @High @Automation
  Scenario: Verify Send OTP with registered email shows the generic toaster and OTP Verification screen
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Email        | rahul.sharma@example.com |
      | Organization | Alpha Infra Ltd          |
    When the user clicks 'Login Using OTP'
    And the user enters Email 'rahul.sharma@example.com', select 'Alpha Infra Ltd', enter the CAPTCHA
    And the user clicks Send OTP
    Then Toaster 'If the details match an active account, an OTP has been sent to the registered email address.' is shown (US-2 AC-1, Sec 8 Toaster #3)
    And OTP Verification screen opens (6.3 FB-3)

  # Ref: US-2 AC-2; 6.1 P-OTP; 6.3 BR-1; 6.3 BR-2
  @TC_CP_024 @Functional @High @Automation
  Scenario: Verify the OTP is a 6-digit number valid for 5 minutes and sent only to the registered email
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Registered email | rahul.sharma@example.com |
      | OTP validity     | 5 minutes                |
    When the user requests an OTP for rahul.sharma@example.com
    And the user reads the OTP email
    And the user checks the OTP validity in the OTP store/test mailbox
    Then The OTP has exactly 6 numeric digits and is valid for 5 minutes (US-2 AC-2, 6.1 P-OTP)
    And It is delivered only to the registered address

  # Ref: US-2 AC-3; 6.3 FB-4; Sec 8 Toaster #1
  @TC_CP_025 @Functional @High @Automation
  Scenario: Verify correct unexpired OTP logs the user in without changing the password
    Given OTP requested for rahul.sharma@example.com; OTP received
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | OTP          | as received     |
      | Organization | Alpha Infra Ltd |
    When the user enters the received OTP and click Verify
    And the user logs out and login using the old password 'Rahul@2026x'
    Then Toaster 'Login successful.' is shown and the ERP opens in Alpha Infra Ltd (US-2 AC-3, 6.3 FB-4)
    And The password is unchanged and the old password still works

  # Ref: US-2 AC-7; 6.1 P-Resend; 6.3 F-Resend; Sec 8 Toaster #4
  @TC_CP_026 @Functional @High @Automation
  Scenario: Verify Resend OTP is enabled only after 60 seconds and shows the new-OTP toaster
    Given OTP requested for rahul.sharma@example.com at time T. Baseline data (see Summary) is loaded
    And the following test data is used
      | Resend interval | 60 seconds |
    When At T+30 s check the Resend OTP link
    And At T+61 s click Resend OTP
    Then At T+30 s Resend OTP is disabled with a countdown
    And At T+61 s it is enabled and the toaster 'If the details match an active account, a new OTP has been sent to the registered email address.' is shown (US-2 AC-7, Sec 8 Toaster #4)

  # Ref: 6.3 BR-3; US-2 AC-7
  @TC_CP_027 @Functional @High @Automation
  Scenario: Verify Resend OTP invalidates the previous OTP
    Given OTP1 requested at T; Resend used at T+61 s generating OTP2
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | OTP1 | first OTP  |
      | OTP2 | second OTP |
    When the user enters OTP1 and click Verify
    And the user enters OTP2 and click Verify
    Then OTP1 is rejected as invalid (6.3 BR-3)
    And OTP2 authenticates the user

  # Ref: 6.3 BR-5; 6.11 SR-2
  @TC_CP_028 @Functional @High @Automation
  Scenario: Verify OTP is stored only as a hash
    Given OTP requested for rahul.sharma@example.com
    And DB/test access available
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | OTP | as received |
    When the user queries the OTP store for the generated record
    And the user compares the stored value with the OTP in the email
    And the user searches application and audit logs for the OTP
    Then The stored value is a hash and differs from the plain OTP
    And The OTP is not found in logs or the Audit Trail (6.3 BR-5, 6.11 SR-2)

  # Ref: 6.3 BR-4
  @TC_CP_029 @Functional @High @Automation
  Scenario: Verify wrong OTP attempts count towards the account failed-attempt limit
    Given lock.user failed-attempt count is 0
    And OTP requested for lock.user@example.com
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User           | lock.user |
      | Wrong OTP      | 111111    |
      | Wrong password | Wrong@123 |
    When the user enters wrong OTP '111111' 3 times (OTP not yet exhausted)
    And the user performs 2 wrong-password logins for lock.user
    And the user observes the account state
    Then Wrong OTP attempts add to the failed-attempt count; the combined 5 failures lock the account for 30 minutes (6.3 BR-4)

  # Ref: 6.3 FB-4; 6.3 F-Organization
  @TC_CP_030 @Functional @Medium @Automation
  Scenario: Verify OTP is accepted only when organization is mapped (organization validated after OTP verification)
    Given OTP received for kiran.patil@example.com
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Email        | kiran.patil@example.com |
      | Organization | Gamma Water Board       |
    When On Login Using OTP select Organization 'Gamma Water Board' and request the OTP
    And the user enters the correct OTP and click Verify
    Then Organization is mapped, so the session starts with 'Login successful.' (6.3 F-Organization, 6.3 FB-4); with no role the user sees no module

  # Ref: 6.3 F-Email
  @TC_CP_031 @Functional @Medium @Automation
  Scenario: Verify Email Address field is trimmed and accepts 254 characters
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Email 1 | ' rahul.sharma@example.com '     |
      | Email 2 | 242 chars + '@example.com' (254) |
    When On Login Using OTP enter ' rahul.sharma@example.com ' with spaces
    And the user enters a 254-character valid-format email in a second attempt
    Then Email 1 is trimmed and matched with the registered email
    And Email 2 is accepted by the field (6.3 F-Email max 254)

  # Ref: 6.3 FB-3
  @TC_CP_032 @Functional @Low @Automation
  Scenario: Verify Back to Login returns to Login page
    Given OTP Verification screen is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Link | Back to Login |
    When the user clicks 'Back to Login'
    Then The Login page is displayed and no session is created (6.3 FB-3)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-2 AC-1; 6.3 FB-2; 6.11 SR-4
  @TC_CP_165 @Negative @High @Automation
  Scenario: Verify generic toaster for non-registered email and no OTP is sent
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Email | unknown@example.com |
    When the user opens Login Using OTP
    And the user enters 'unknown@example.com', select 'Alpha Infra Ltd', enter CAPTCHA, click Send OTP
    And the user checks the mailbox
    Then Toaster 'If the details match an active account, an OTP has been sent to the registered email address.' is shown; no OTP is generated or sent (US-2 AC-1, 6.3 FB-2)

  # Ref: 6.3 F-Email
  @TC_CP_166 @Negative @High @Automation
  Scenario: Verify empty Email Address shows 'Email Address is required.'
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Email | (blank) |
    When the user leaves Email empty and click Send OTP
    Then 'Email Address is required.' is shown (6.3 F-Email)

  # Ref: 6.3 F-CAPTCHA
  @TC_CP_167 @Negative @High @Automation
  Scenario: Verify wrong CAPTCHA on Send OTP shows 'Invalid CAPTCHA. Please try again.'
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Email   | rahul.sharma@example.com |
      | CAPTCHA | ZZZZ                     |
    When the user enters valid email and organization with CAPTCHA 'ZZZZ'
    And the user clicks Send OTP
    Then 'Invalid CAPTCHA. Please try again.' is shown and no OTP is sent (6.3 F-CAPTCHA)

  # Ref: 6.3 F-Organization
  @TC_CP_168 @Negative @High @Automation
  Scenario: Verify empty Organization on Login Using OTP shows 'Organization is required.'
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Organization | (blank) |
    When the user enters email and CAPTCHA without Organization
    And the user clicks Send OTP
    Then 'Organization is required.' is shown (6.3 F-Organization)

  # Ref: US-2 AC-2; 6.3 BR-1
  @TC_CP_169 @Negative @High @Automation
  Scenario: Verify an OTP cannot be delivered to a different email address
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | deliverTo | attacker@example.com |
    When the user requests OTP for rahul.sharma using an altered payload that carries a different 'deliverTo' address
    Then OTP goes only to the registered address; the extra address is ignored (US-2 AC-2, 6.3 BR-1)

  # Ref: 6.3 F-OTP
  @TC_CP_170 @Negative @High @Automation
  Scenario: Verify empty OTP shows 'OTP is required.'
    Given OTP Verification screen is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | OTP | (blank) |
    When the user clicks Verify with empty OTP
    Then 'OTP is required.' is shown (6.3 F-OTP)

  # Ref: 6.3 F-OTP
  @TC_CP_171 @Negative @Medium @Automation
  Scenario: Verify OTP length boundaries: 5 digits and 7 digits are rejected
    Given OTP Verification screen is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | OTP | 12345 // 1234567 |
    When the user enters 5 digits and click Verify
    And the user enters 7 digits and click Verify
    Then Exactly 6 digits are required; 5 and 7-digit entries are rejected without consuming validation attempts incorrectly (6.3 F-OTP)

  # Ref: US-2 AC-4; EX-07
  @TC_CP_172 @Negative @High @Automation
  Scenario: Verify wrong OTP shows remaining attempts
    Given OTP requested for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | OTP | 000000 |
    When the user enters wrong OTP '000000' and Verify
    Then 'Invalid OTP. 4 attempt(s) remaining.' is shown (US-2 AC-4, EX-07)

  # Ref: US-2 AC-4; 6.1 P-OTPAttempts; EX-07
  @TC_CP_173 @Negative @High @Automation
  Scenario: Verify 5 wrong OTP attempts invalidate the OTP
    Given OTP requested for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Wrong OTP | 000000 x5 |
    When the user enters wrong OTP 5 times
    And the user enters the correct OTP
    Then After the 5th, 'Maximum attempts exceeded. Please request a new OTP.' is shown; the correct OTP is then rejected (US-2 AC-4, 6.1 P-OTPAttempts)

  # Ref: 6.1 P-OTPAttempts
  @TC_CP_174 @Negative @Medium @Automation
  Scenario: Verify 4 wrong attempts followed by the correct OTP succeeds (boundary)
    Given OTP requested for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Wrong OTP | 000000 x4 |
    When the user enters wrong OTP 4 times
    And the user enters the correct OTP
    Then Login succeeds on the 5th attempt (6.1 P-OTPAttempts)

  # Ref: US-2 AC-5; 6.1 P-OTP
  @TC_CP_175 @Negative @High @Automation
  Scenario: Verify expired OTP is rejected with the expiry message
    Given OTP requested at T. Baseline data (see Summary) is loaded
    And the following test data is used
      | Validity | 5 minutes |
    When the user waits 5 minutes 1 second
    And the user enters the correct OTP and Verify
    Then 'OTP has expired. Please request a new OTP.' is shown (US-2 AC-5)

  # Ref: 6.1 P-OTP
  @TC_CP_176 @Negative @Medium @Automation
  Scenario: Verify OTP is accepted at 4 minutes 59 seconds (boundary)
    Given OTP requested at T. Baseline data (see Summary) is loaded
    And the following test data is used
      | Time | 4:59 |
    When the user verifies the correct OTP at T+4:59
    Then OTP is accepted (6.1 P-OTP)

  # Ref: US-2 AC-6; 6.1 P-OTP
  @TC_CP_177 @Negative @High @Automation
  Scenario: Verify a used OTP is rejected when entered again
    Given User logged in through OTP and logged out
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | OTP | used |
    When the user opens Login Using OTP verification and enter the same OTP
    Then OTP is rejected as invalid (US-2 AC-6)

  # Ref: US-2 AC-7; 6.1 P-Resend
  @TC_CP_178 @Negative @High @Automation
  Scenario: Verify Resend OTP is blocked before 60 seconds
    Given OTP requested at T. Baseline data (see Summary) is loaded
    And the following test data is used
      | Time | 30 s |
    When the user clicks Resend OTP at T+30 s
    Then Resend is disabled and no new OTP is sent (US-2 AC-7)

  # Ref: US-2 AC-7; 6.1 P-Resend; EX-07; 6.3 F-Resend
  @TC_CP_179 @Negative @High @Automation
  Scenario: Verify 4th resend shows 'Maximum resend limit reached. Please try again after 30 minutes.'
    Given OTP requested; 3 resends used
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Resend count | 4th |
    When the user waits 60 seconds and click Resend OTP again
    Then 'Maximum resend limit reached. Please try again after 30 minutes.' is shown; blocked for 30 minutes (US-2 AC-7, EX-07)

  # Ref: 6.3 FB-5; EX-08
  @TC_CP_180 @Negative @High @Automation
  Scenario: Verify email delivery failure shows the unable-to-send message and the OTP is not counted as sent
    Given Mail service is stubbed to fail
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Failure | SMTP unavailable |
    When the user requests OTP for rahul.sharma
    And the user checks the OTP request count
    Then 'Unable to send OTP at the moment. Please try again later.' is shown; OTP not counted as sent; 'OTP Delivery Failed' audited (6.3 FB-5, EX-08)

  # Ref: US-4 AC-2; EX-05a; 6.3 F-Organization
  @TC_CP_181 @Negative @High @Automation
  Scenario: Verify OTP for an unmapped organization shows not-mapped message and does not count as a failed attempt
    Given OTP received for anita.desai@example.com
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Email        | anita.desai@example.com |
      | Organization | Beta Constructions      |
    When the user requests OTP selecting 'Beta Constructions'
    And the user enters the correct OTP
    Then 'You are not mapped to the selected organization. Please contact your administrator.' is shown; no session; not a failed attempt (US-4 AC-2, EX-05a)

  # Ref: US-4 AC-3; EX-05
  @TC_CP_182 @Negative @High @Automation
  Scenario: Verify OTP for a user with no organization mapping shows the no-organization message
    Given OTP received for nomap.user
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | nomap.user |
    When the user verifies the correct OTP
    Then 'No organization is assigned to your account. Please contact your administrator.' is shown (US-4 AC-3, EX-05)

  # Ref: 6.1 P-RateLimit; 6.11 SR-3
  @TC_CP_183 @Negative @High @Automation
  Scenario: Verify OTP request rate limit blocks the 6th request per user in an hour
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Limit | 5 per user per hour |
    When the user requests OTP 6 times for rahul.sharma within one hour
    Then The 6th request is blocked by the rate limit (6.1 P-RateLimit, 6.11 SR-3)

  # Ref: 6.1 P-RateLimit
  @TC_CP_184 @Negative @High @Automation
  Scenario: Verify OTP request rate limit blocks the 21st request per IP in an hour
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Limit | 20 per IP per hour |
    When From one IP address request OTP for 21 different users within an hour
    Then The 21st request is blocked (6.1 P-RateLimit)

  # Ref: 6.3 FB-2; 6.4 BR-6
  @TC_CP_185 @Negative @High @Automation
  Scenario: Verify no OTP is sent for a locked or inactive account and generic message is still shown
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Emails | lock.user@example.com     |
      | Data   | inactive.user@example.com |
    When the user requests OTP for lock.user (locked) and inactive.user
    Then The generic toaster is shown but no OTP is generated or sent (6.3 FB-2, 6.4 BR-6)
