@AuthNAuthZ @LoginInitiationSecurityParameters
Feature: Login Initiation & Security Parameters
  Automated scenarios for the "Login Initiation & Security Parameters" module of Authentication & Authorization.
  Source: CivitCORE_AuthN_AuthZ_TestCases.xlsx (only rows with Execution Type = Automation).
  FRD Reference: CC-F-002_CivitCORE_CORE Module_Authentication Authorization Management.pdf (Ver 1.0, 03-Nov-2026)

  # ---------------------------------------------------------------
  # Functional (positive) scenarios
  # ---------------------------------------------------------------

  # Ref: 6.1 FB-1
  @TC_CP_001 @Functional @High @Automation
  Scenario: Verify unauthenticated user of a product is redirected to common CivitCORE Login and returned to the requested page after login
    Given No active session
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | User           | rahul.sharma                                      |
      | Password       | Rahul@2026x                                       |
      | Organization   | Alpha Infra Ltd                                   |
      | Requested page | CivitINFRA > Project Management > Project Listing |
    When the user opens the CivitINFRA 'Project Listing' page URL directly in a new browser session
    And the user observes the page shown
    And the user logs in as rahul.sharma with Organization 'Alpha Infra Ltd'
    And the user observes the page opened after login
    Then The user is redirected to the common CivitCORE Login page (6.1 FB-1)
    And After successful login the user returns to CivitINFRA 'Project Listing', the page originally requested, because the user is authorized

  # Ref: 6.1 FB-1
  @TC_CP_002 @Functional @High @Automation
  Scenario: Verify CivitBUILD also redirects an unauthenticated user to the common CivitCORE Login page
    Given No active session
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Product | CivitBUILD |
    When the user opens the CivitBUILD home URL in a new browser session
    And the user observes the page shown
    Then Every Civit product redirects to the same common CivitCORE Login page; no product-specific login page exists (6.1 FB-1)

  # Ref: 6.1 FB-2; 6.2 F-Login; 6.2 F-OTPLink; 6.2 F-ForgotLink
  @TC_CP_003 @Functional @Medium @Automation
  Scenario: Verify Login page offers Login, Login Using OTP and Forgot Password
    Given Civit Login page is displayed
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Page | Login |
    When the user opens the Civit Login page
    And the user inspects the available actions
    Then The Login CTA, the 'Login Using OTP' link and the 'Forgot Password' link are all available (6.1 FB-2)

  # Ref: 6.1 FB-3; 6.1 P-Lockout
  @TC_CP_004 @Functional @Medium @Automation
  Scenario: Verify the security parameters are configurable in the backend by an authorized system administrator and defaults are applied
    Given System administrator has backend configuration access
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Defaults      | lock 5 failures/30 min; OTP 6 digits/5 min; 5 OTP attempts; resend 60 s x3; rate 5 per user & 20 per IP per hour; password 8-64 chars, history 3; idle 30 min; absolute 12 h |
      | Changed value | 3                                                                                                                                                                            |
      | User          | lock.user                                                                                                                                                                    |
    When the user opens the backend security-parameter configuration
    And the user reads all parameter values before any change
    And the user changes 'Failed login attempts before lock' from 5 to 3 and save
    And the user attempts 3 consecutive wrong-password logins for lock.user
    Then Default values match the 6.1 table
    And After the change, lock.user is locked on the 3rd consecutive failure (6.1 FB-3, 6.1 P-Lockout)
    And Restore default value 5 after the test

  # Ref: 6.1 P-Lockout; US-1 AC-5
  @TC_CP_005 @Functional @High @Automation
  Scenario: Verify a locked account is automatically unlocked after 30 minutes
    Given lock.user is locked after 5 consecutive failed logins at time T. Baseline data (see Summary) is loaded
    And the following test data is used
      | User         | lock.user       |
      | Password     | Lock@2026x      |
      | Organization | Alpha Infra Ltd |
    When At T+29 min attempt login with the correct password
    And At T+31 min attempt login with the correct password and a valid CAPTCHA
    Then At T+29 min the lock message is shown (EX-03)
    And At T+31 min the account is unlocked automatically and login succeeds with 'Login successful.' (6.1 P-Lockout)

  # Ref: 6.1 P-Lockout; 7.1 A-Lock
  @TC_CP_006 @Functional @Medium @Automation
  Scenario: Verify an administrator can unlock a locked account earlier than 30 minutes
    Given lock.user is locked 5 minutes ago. admin.user is logged in
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Locked user | lock.user     |
      | Reason      | administrator |
    When As admin.user, unlock lock.user using the account unlock option
    And the user logs in as lock.user with the correct password
    And the user checks the Audit Trail
    Then Account is unlocked immediately and lock.user logs in successfully (6.1 P-Lockout)
    And An 'Account Unlocked' entry with reason 'administrator' is recorded (7.1)

  # Ref: 6.1 P-Idle; 6.1 P-Absolute
  @TC_CP_007 @Functional @High @Automation
  Scenario: Verify idle timeout and absolute lifetime defaults are enforced
    Given rahul.sharma is logged in to Alpha Infra Ltd (active role: Project Manager)
    And Baseline data (see Summary) is loaded
    And the following test data is used
      | Idle timeout      | 30 min   |
      | Absolute lifetime | 12 hours |
    When the user remains idle for 30 minutes and send any request
    And the user logs in again and perform an action every 10 minutes for 12 hours; then send a request
    Then After 30 idle minutes the next request redirects to Login with 'Your session has expired. Please log in again.' (6.1 P-Idle)
    And After 12 hours, even with continuous activity, login is required again (6.1 P-Absolute)
