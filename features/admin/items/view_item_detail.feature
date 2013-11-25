Feature: View item detail

    As a Cal Teach advisor,
    So that I can decide whether to checkout an item
    I want to be able to see the reservation history of a resource and how many are available

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
    Given I switch to List View
    When I follow "Globe" within List View
    Then I should see "Reserve this item"
    And I should see "Quantity"
    And I should see "Reservations on this item"

