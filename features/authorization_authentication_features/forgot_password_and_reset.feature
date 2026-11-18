@AuthNAuthZ @ForgotPasswordReset
Feature: Forgot Password & Reset
  Automated scenarios for the "Forgot Password & Reset" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-1; 6.4 FB-1; Sec 8 Toaster #3
  @TC_CP_033 @Functional @High @Automation
  Scenario: Verify Forgot Password with registered email shows the generic OTP-sent message
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Email | rahul.sharma@example.com |
    When the user clicks 'Forgot Password'
    And the user enters Email 'rahul.sharma@example.com' and a valid CAPTCHA
    And the user clicks Send OTP
    Then Toaster 'If the details match an active account, an OTP has been sent to the registered email address.' is shown (US-3 AC-1, 6.4 FB-1, Sec 8 Toaster #3)

  # Ref: US-3 AC-2; 6.4 FB-2
  @TC_CP_034 @Functional @High @Automation
  Scenario: Verify correct OTP opens Reset Password screen with password policy checklist
    Given OTP requested via Forgot Password for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | OTP | as received |
    When the user enters the correct OTP and click Verify
    Then Reset Password screen opens and shows the password policy (US-3 AC-2, 6.4 FB-2)

  # Ref: US-3 AC-5; 6.4 FB-5; 6.1 P-ResetEnds; Sec 8 Toaster #5
  @TC_CP_036 @Functional @High @Automation
  Scenario: Verify successful password reset saves password, ends sessions, sends email and shows success message
    Given rahul.sharma has an active session in another browser
    And Reset Password screen is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New password | Rahul@2027y |
    When the user enters New Password 'Rahul@2027y' and Confirm 'Rahul@2027y'
    And the user clicks Reset Password
    And the user checks the other browser session, the email inbox and the OTP
    And the user logs in with the new password
    Then Message 'Your password has been reset successfully. Please log in with your new password.' is shown on the Login page
    And Password is saved, OTP and reset authorization are invalidated, all active sessions end and a password-change email is sent (US-3 AC-5, 6.4 FB-5, 6.1 P-ResetEnds)
    And Login with the new password succeeds

  # Ref: 6.1 P-Password; 6.4 BR-2
  @TC_CP_037 @Functional @High @Automation
  Scenario: Verify password of exactly 8 and exactly 64 characters is accepted (policy boundaries)
    Given Reset Password screen is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | 8 chars  | Abcd@123    |
      | 64 chars | 'Aa1!' x 16 |
    When the user enters New Password and Confirm of 8 characters; click Reset Password
    And the user repeats the flow with 64 characters
    Then Both lengths are accepted and saved (6.1 P-Password, 6.4 BR-2)

  # Ref: 6.1 P-Password; US-3 AC-6
  @TC_CP_038 @Functional @Medium @Automation
  Scenario: Verify the 4th previous password can be reused while the last 3 cannot (history boundary)
    Given User has password history P1 (oldest), P2, P3, P4 (current)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | P1 | Old@Pass1a |
      | P2 | Old@Pass2b |
    When the user resets to P1 value (4th previous)
    And the user resets to P2 value
    Then P1 (outside the last 3) is accepted, subsequent change to a value inside the last 3 is rejected under the policy (6.1 P-Password, US-3 AC-6)

  # Ref: 6.4 BR-4; 7.1 A-Lock
  @TC_CP_039 @Functional @High @Automation
  Scenario: Verify successful reset unlocks a locked account and resets the failed-attempt count
    Given lock.user is locked
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | lock.user  |
      | New password | Lock@2027y |
    When the user resets the password of lock.user through Forgot Password
    And the user logs in with the new password
    Then Account is unlocked, the failed-attempt count is 0 and login succeeds (6.4 BR-4); 'Account Unlocked' reason 'password reset' is audited

  # Ref: 6.4 BR-5
  @TC_CP_040 @Functional @Medium @Automation
  Scenario: Verify password reset does not grant any organization, office, module or role
    Given kiran.patil has no role in Gamma Water Board
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User | kiran.patil |
    When the user resets the password of kiran.patil
    And the user logs in to Gamma Water Board with the new password
    And the user checks mappings, roles and modules
    Then Mappings and roles are unchanged and no module is available (6.4 BR-5)

  # Ref: 6.4 FB-6; 6.4 F-Cancel
  @TC_CP_041 @Functional @Medium @Automation
  Scenario: Verify Cancel on Reset Password returns to Login without changing the password
    Given Reset Password screen is open with values typed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Typed | Temp@12345 |
    When the user types 'Temp@12345' in both fields
    And the user clicks Cancel
    And the user logs in with the old password
    Then Login page is displayed; password is unchanged and the old password works (6.4 FB-6, 6.4 F-Cancel)

  # Ref: 6.4 BR-3; 6.11 SR-1
  @TC_CP_042 @Functional @High @Automation
  Scenario: Verify passwords are stored only as salted adaptive hashes
    Given DB access available
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Users         | rahul.sharma, anita.desai |
      | Same password | Same@12345                |
    When the user queries the stored credential of rahul.sharma and anita.desai (same test password set for both)
    And the user compares the stored values
    Then Stored values are bcrypt/Argon2 hashes with different salts; no readable password exists in DB or logs (6.4 BR-3, 6.11 SR-1)

  # ---------------------------------------------------------------
  # Negative scenarios
  # ---------------------------------------------------------------

  # Ref: US-3 AC-2; 6.4 BR-1
  @TC_CP_186 @Negative @High @Automation
  Scenario: Verify Reset Password screen cannot be opened directly without OTP verification
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | URL | /reset-password |
    When the user opens the Reset Password URL directly without completing OTP
    And the user tries again with a copied URL from another session
    Then Access is blocked and the user is returned to Login (US-3 AC-2, 6.4 BR-1)

  # Ref: US-3 AC-1; 6.11 SR-4
  @TC_CP_187 @Negative @High @Automation
  Scenario: Verify Forgot Password with unregistered email shows generic message and sends nothing
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Email | unknown@example.com |
    When the user submits unknown@example.com with valid CAPTCHA
    Then Generic message is shown; no OTP sent (US-3 AC-1, 6.11 SR-4)

  # Ref: 6.4 BR-6
  @TC_CP_188 @Negative @High @Automation
  Scenario: Verify Forgot Password for an inactive account cannot reset the password
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Email | inactive.user@example.com |
    When the user submits inactive.user@example.com with valid CAPTCHA
    Then Generic message is shown but no OTP is sent and reset is impossible (6.4 BR-6)

  # Ref: 6.4 FB-1; 6.3 F-Email
  @TC_CP_189 @Negative @Medium @Automation
  Scenario: Verify Forgot Password with wrong CAPTCHA or empty email is rejected
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | CAPTCHA | ZZZZ // Email: (blank) |
    When the user submits with CAPTCHA 'ZZZZ'
    And the user submits with empty email
    Then 'Invalid CAPTCHA. Please try again.' and 'Email Address is required.' are shown (6.4 FB-1, 6.3 F-Email)

  # Ref: 6.4 F-NewPassword; 6.4 F-ConfirmPassword
  @TC_CP_190 @Negative @High @Automation
  Scenario: Verify empty New Password and Confirm New Password show required messages
    Given Reset Password screen is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Fields | blank |
    When the user clicks Reset Password with both fields empty
    Then 'New Password is required.' and 'Confirm New Password is required.' are shown (6.4 Fields)

  # Ref: US-3 AC-4; EX-09
  @TC_CP_191 @Negative @High @Automation
  Scenario: Verify mismatched passwords show 'Passwords do not match.'
    Given Reset Password screen is open
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New     | Rahul@2027y |
      | Confirm | Rahul@2027z |
    When the user enters New 'Rahul@2027y' and Confirm 'Rahul@2027z'
    And the user clicks Reset Password
    Then 'Passwords do not match.' is shown and the password is not saved (US-3 AC-4, EX-09)

  # Ref: US-3 AC-3; 6.1 P-Password; EX-09
  @TC_CP_192 @Negative @High @Automation
  Scenario: Verify password shorter than 8 characters is rejected by the policy
    Given Reset Password screen is open for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New/Confirm | Ab@1xyz |
    When the user enters New Password and Confirm New Password with the value below (7 characters)
    And the user clicks Reset Password
    Then 'New Password does not meet the password policy.' is shown, the unmet rule is marked in the checklist and the password is not saved (US-3 AC-3, 6.1 P-Password, EX-09)

  # Ref: US-3 AC-3; 6.1 P-Password; EX-09
  @TC_CP_193 @Negative @High @Automation
  Scenario: Verify password longer than 64 characters is rejected by the policy
    Given Reset Password screen is open for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New/Confirm | 'Aa1!' x 16 + 'A' |
    When the user enters New Password and Confirm New Password with the value below (65 characters)
    And the user clicks Reset Password
    Then 'New Password does not meet the password policy.' is shown, the unmet rule is marked in the checklist and the password is not saved (US-3 AC-3, 6.1 P-Password, EX-09)

  # Ref: US-3 AC-3; 6.1 P-Password; EX-09
  @TC_CP_194 @Negative @High @Automation
  Scenario: Verify password without uppercase is rejected by the policy
    Given Reset Password screen is open for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New/Confirm | rahul@2027y |
    When the user enters New Password and Confirm New Password with the value below (no uppercase)
    And the user clicks Reset Password
    Then 'New Password does not meet the password policy.' is shown, the unmet rule is marked in the checklist and the password is not saved (US-3 AC-3, 6.1 P-Password, EX-09)

  # Ref: US-3 AC-3; 6.1 P-Password; EX-09
  @TC_CP_195 @Negative @High @Automation
  Scenario: Verify password without lowercase is rejected by the policy
    Given Reset Password screen is open for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New/Confirm | RAHUL@2027Y |
    When the user enters New Password and Confirm New Password with the value below (no lowercase)
    And the user clicks Reset Password
    Then 'New Password does not meet the password policy.' is shown, the unmet rule is marked in the checklist and the password is not saved (US-3 AC-3, 6.1 P-Password, EX-09)

  # Ref: US-3 AC-3; 6.1 P-Password; EX-09
  @TC_CP_196 @Negative @High @Automation
  Scenario: Verify password without a number is rejected by the policy
    Given Reset Password screen is open for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New/Confirm | Rahul@abcdY |
    When the user enters New Password and Confirm New Password with the value below (no number)
    And the user clicks Reset Password
    Then 'New Password does not meet the password policy.' is shown, the unmet rule is marked in the checklist and the password is not saved (US-3 AC-3, 6.1 P-Password, EX-09)

  # Ref: US-3 AC-3; 6.1 P-Password; EX-09
  @TC_CP_197 @Negative @High @Automation
  Scenario: Verify password without a special character is rejected by the policy
    Given Reset Password screen is open for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New/Confirm | Rahul2027yy |
    When the user enters New Password and Confirm New Password with the value below (no special character)
    And the user clicks Reset Password
    Then 'New Password does not meet the password policy.' is shown, the unmet rule is marked in the checklist and the password is not saved (US-3 AC-3, 6.1 P-Password, EX-09)

  # Ref: US-3 AC-3; 6.1 P-Password; EX-09
  @TC_CP_198 @Negative @High @Automation
  Scenario: Verify password equal to the username is rejected by the policy
    Given Reset Password screen is open for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New/Confirm | rahul.sharma |
    When the user enters New Password and Confirm New Password with the value below (equals username)
    And the user clicks Reset Password
    Then 'New Password does not meet the password policy.' is shown, the unmet rule is marked in the checklist and the password is not saved (US-3 AC-3, 6.1 P-Password, EX-09)

  # Ref: US-3 AC-3; 6.1 P-Password; EX-09
  @TC_CP_199 @Negative @High @Automation
  Scenario: Verify password equal to the email is rejected by the policy
    Given Reset Password screen is open for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New/Confirm | rahul.sharma@example.com |
    When the user enters New Password and Confirm New Password with the value below (equals email)
    And the user clicks Reset Password
    Then 'New Password does not meet the password policy.' is shown, the unmet rule is marked in the checklist and the password is not saved (US-3 AC-3, 6.1 P-Password, EX-09)

  # Ref: US-3 AC-6; 6.1 P-Password
  @TC_CP_200 @Negative @High @Automation
  Scenario: Verify the new password equal to the 1st last password is rejected
    Given rahul.sharma password history: current 1-position value is 'Rahul@2026x'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New/Confirm | Rahul@2026x |
    When the user enters the history value as New and Confirm password
    And the user clicks Reset Password
    Then Password is rejected under the policy with 'New Password does not meet the password policy.' (US-3 AC-6, 6.1 P-Password)

  # Ref: US-3 AC-6; 6.1 P-Password
  @TC_CP_201 @Negative @High @Automation
  Scenario: Verify the new password equal to the 2nd last password is rejected
    Given rahul.sharma password history: current 2-position value is 'Prev@Pass2b'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New/Confirm | Prev@Pass2b |
    When the user enters the history value as New and Confirm password
    And the user clicks Reset Password
    Then Password is rejected under the policy with 'New Password does not meet the password policy.' (US-3 AC-6, 6.1 P-Password)

  # Ref: US-3 AC-6; 6.1 P-Password
  @TC_CP_202 @Negative @High @Automation
  Scenario: Verify the new password equal to the 3rd last password is rejected
    Given rahul.sharma password history: current 3-position value is 'Prev@Pass3c'
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | New/Confirm | Prev@Pass3c |
    When the user enters the history value as New and Confirm password
    And the user clicks Reset Password
    Then Password is rejected under the policy with 'New Password does not meet the password policy.' (US-3 AC-6, 6.1 P-Password)

  # Ref: 6.4 FB-2; US-2 AC-4
  @TC_CP_203 @Negative @High @Automation
  Scenario: Verify a wrong OTP in the Forgot Password flow is rejected with attempts message
    Given Forgot Password OTP requested for rahul.sharma
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | OTP | 000000 |
    When the user enters wrong OTP '000000'
    Then 'Invalid OTP. 4 attempt(s) remaining.' is shown and Reset Password does not open (6.4 FB-2, US-2 AC-4)

  # Ref: 6.4 FB-3; 6.11 SR-8
  @TC_CP_204 @Negative @High @Automation
  Scenario: Verify the Reset Password screen expires after 10 minutes
    Given OTP verified at T. Baseline data (see Summary) is loaded
    And the following test data is used
      | Validity | 10 minutes |
    When the user waits 10 minutes 1 second
    And the user submits valid matching passwords
    Then Reset is rejected and the user must start again (6.4 FB-3, 6.11 SR-8)

  # Ref: 6.4 FB-3; 6.11 SR-8
  @TC_CP_205 @Negative @High @Automation
  Scenario: Verify the Reset Password authorization cannot be used twice
    Given Reset completed once
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Token | used |
    When the user reuses the same reset URL/token to reset again
    Then Second reset is rejected (6.4 FB-3, 6.11 SR-8)
