@location @permissions
Feature: Permissions

  @TC-Loc-065 @negative @high
  # Ref: FRD 6.1 BR-1; 3 ('authorized user')
  Scenario: Verify a user without Location Management permission cannot access the module
    Given I am logged in as "NoAccess_User1" with no Location permission
    When I check the System Configuration menu for Location
    And I open the Location Management URL directly
    Then the menu entry should not be displayed
    And direct URL access should be denied
    And no Location data should be exposed
    # Note: Inferred from 'authorized user' wording

  @TC-Loc-066 @negative @high
  # Ref: FRD 6.1 BR-1; US-1 AC-2
  Scenario: Verify view-only user cannot create a Location via API (server-side permission)
    Given a "Viewer_User1" token is available
    When I send a create-Location request using the Viewer's token with payload
      """
      {name:'Rajkot', shortName:'RJK', categoryId:District, regionId:Western, parentId:Gujarat}
      """
    And I check the Location Master
    Then the request should be rejected with 403
    And no Location should be created

  @TC-Loc-067 @negative @high
  # Ref: FRD 6.1 BR-1
  Scenario: Verify Edit-only user cannot delete a Location via API
    Given an "Editor_User1" token with View and Edit access is available
    When I send a delete request for "Surat" using the Editor's token
    Then the request should be rejected with 403
    And "Surat" should still exist
