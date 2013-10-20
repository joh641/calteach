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
    | Chocolat                | 0         |
    | Amelie                  | 5         |
    | 2001: A Space Odyssey   | 5         |
    | The Incredibles         | 5         |
    | Raiders of the Lost Ark | 5         |
    | Chicken Run             | 5         |

    And I am on the Calteach inventory page

Scenario:

    Then I should see all the items