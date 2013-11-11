Feature: See available inventory

  As a student
  So that I know what resources are available for use in the resource room
  I want to be able to see a list of the available inventory

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
    And I am logged into the admin panel
    And I am on the home page

Scenario:

    Then I should see all the items

Scenario:

    Then "Gold" should be unavailable
    And "Globe" should be available

Scenario:

    When I search for "Globe"
    And I press "Search"
    Then I should see "Globe"
    And I should not see "Gold"

Scenario:
    When I search for "Silver"
    And I press "Search"
    Then there should be no results

Scenario:
    When I follow "Globe"
    Then I should see "Reserve this item"

