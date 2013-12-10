Feature: Search available inventory

  As a student
  So that I can browse to see what's available
  I want to be able to search for items in the inventory

Background: items have been added to inventory

    Given the following items exist:
    | name                    | quantity  |
    | Globe                   | 5         |
    | Math book               | 5         |
    | When Harry Met Sally    | 5         |
    | The Help                | 5         |
    | Gold                    | 0         |
    | Amelie                  | 5         |
    | 2001: A Space Odyssey   | 5         |
    | The Incredibles         | 5         |
    | Raiders of the Lost Ark | 5         |
    | Chicken Run             | 5         |
    And there is an admin
    And there is a user
    And I am on the home page

Scenario: Admin can see all items and their availabilities
    Given I am logged into the admin panel
    Then I should see all the items
    When I fill in "search_query" with "globe"
    And I press "Go"
    Then I should see "Globe"
    Then "Globe" should be available within Card View
    And I should not see "Gold"
    When I follow "Reset Search"
    Then I should see "Gold"