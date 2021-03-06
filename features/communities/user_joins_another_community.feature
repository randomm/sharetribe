Feature: User joins another community
  In order to be able to post listings simultaneously to multiple communities
  As a user
  I want to be able to join more than one Sharetribe community with my user account
  
  @javascript
  Scenario: User joins another community
    Given there are following users:
      | person | 
      | kassi_testperson3 |
    And I am on the home page
    And I move to community "test2"
    And I am on the home page
    And I log in as "kassi_testperson3"
    Then I should see "Join community"
    When I press "Join community"
    Then I should see "This field is required"
    When I check "community_membership_consent"
    And I press "Join community"
    Then I should see "You have successfully joined this community"
    And I should see "Post a new listing"
  
  @javascript
  Scenario: User joins another community that is invitation-only
    Given there are following users:
      | person | 
      | kassi_testperson3 |
    And I am on the home page
    And I move to community "test2"
    And community "test2" requires invite to join
    And there is an invitation for community "test2" with code "GH1JX8"
    And I am on the home page
    And I am logged in as "kassi_testperson3"
    Then Invitation with code "GH1JX8" should have 1 usages_left
    And I should see "Invitation code"
    When I check "community_membership_consent"
    And I fill in "Invitation code" with "random"
    And I press "Join community"
    Then I should see "The invitation code is not valid."
    When I fill in "Invitation code" with "GH1JX8"
    And I press "Join community"
    Then I should see "You have successfully joined this community"
    And I should see "Post a new listing"
    And Invitation with code "GH1JX8" should have 0 usages_left
    
  
  @javascript
  Scenario: User joins another community that accepts only certain email addresses
    Given there are following users:
      | person | email |
      | kassi_testperson3 | k3@lvh.me |
    And I am logged in as "kassi_testperson3"
    And community "test2" requires users to have an email address of type "@example.com"
    When I move to community "test2"
    And I am on the home page
    Then I should see "Join community"
    And I should see "Email address"
    When I check "community_membership_consent"
    And I press "Join community"
    Then I should see "This field is required."
    
    # Try address that is already occupied by other user
    When I fill in "Email address" with "kassi_testperson1@example.com"
    And I check "community_membership_consent"
    And I press "Join community"
    Then I should see "This email is not allowed for this community or it is already in use."
    
    #try address that doesn't match the requirement
    When I fill in "Email address" with "random@gmail.com"
    And I check "community_membership_consent"
    And I press "Join community"
    Then I should see "This email is not allowed for this community or it is already in use."
    And "random@gmail.com" should have no emails
    And "random@example.com" should have no emails
    
    # Try good address
    When I fill in "Email address" with "random@example.com"
    And I check "community_membership_consent"
    And I press "Join community"
    Then I should not see "This email is not allowed for this community or it is already in use."
    
    And wait for 1 second
    Then I should see "Confirm your email"
    And "random@example.com" should receive an email
    And user "kassi_testperson3" should have unconfirmed email "random@example.com"
    
    # Try resending
    When I press "Resend confirmation instructions"
    Then I should see "Check your inbox"
    And "random@example.com" should have 2 emails
    And I should see "Your email is random@example.com. Change"
    
    # Try changing the email
    When I follow "Change"
    Then I should see "New email address"
    And the "person_email" field should contain "random@example.com"
    When I fill in "person_email" with "other.email@wrong.com"
    And I press "Change"
    Then I should see "This email is not allowed for this community or it is already in use."
    When I fill in "person_email" with "other.email@example.com"
    And I press "Change"
    Then I should see "Check your inbox"
    And wait for 1 second
    And "other.email@example.com" should receive an email
    
    # confirm
    When I open the email
    And I follow "confirmation" in the email
    Then I should see "The email you entered is now confirmed"
    And user "kassi_testperson3" should have confirmed email "other.email@example.com"
    And I should not see "Email address"
    Then I should see "Test P"
    And "other.email@example.com" should have 2 emails
    And I should receive an email with subject "Welcome to Sharetribe Test2 - here are some tips to get you started"
