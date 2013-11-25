Feature: View resource's reservation history

  As a Cal Teach advisor
  So that I can decide whether to keep a resource in the inventory
  I want to be able to see the reservation history of a resource

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
    When I follow "Globe" within Card View
    Then I should see "Reservations on this item"

