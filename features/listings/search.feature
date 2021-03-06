@sphinx
Feature: Search
  In order to find needed contents
  As a user
  I want to search listings by typing a keyword to search box and hitting enter
  
  
  Background: 
    Given there is item offer with title "old sofa for sale" and with share type "sell"
    And that listing has a description "I'm selling my wonderlful pink sofa!"
    And I am on the home page
    And the Listing indexes are processed

  @javascript
  @sphinx
  Scenario: basic search
    When I fill in "q" with "sofa"
    And I press "search-button"
    Then I should see "old sofa for sale"
    
  @javascript
  @sphinx
  Scenario: should exclude non-matching results
    When I fill in "q" with "chair"
    And I press "search-button"
    Then I should not see "old sofa for sale"
    And I should see "We couldn't find any results that matched your search criteria"

  @javascript
  @sphinx
  Scenario: Finding by description
    When I fill in "q" with "pink"
    And I press "search-button"
    Then I should see "old sofa for sale"

  @javascript
  @sphinx
  Scenario: Finding by partial word
    When I fill in "q" with "wond"
    And I press "search-button"
    Then I should see "old sofa for sale"

    When I fill in "q" with "ofa"
    And I press "search-button"
    Then I should see "old sofa for sale"

  

  
