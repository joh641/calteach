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
    And there is a user
    And I am on the home page

Scenario: Admin can see all items and their availabilities
    Given I am logged into the admin panel
    Then I should see all the items
    Then "Gold" should be unavailable within Card View
    And "Globe" should be available within Card View

Scenario: User can see all items and their availabilities
    Given I am logged into the user panel
    Then I should see all the items
    Then "Gold" should be unavailable within Card View
    And "Globe" should be available within Card View

Scenario: User can search for items
    Given I am logged into the user panel
    When I search for "Globe"
    And I press "Search"
    Then I should see "Globe" within Card View
    And I should not see "Gold" within Card View

Scenario: User can search for items and see no results
    Given I am logged into the user panel
    When I search for "Silver"
    And I press "Search"
    Then there should be no results

Scenario: User can reserve item on item's individual page
    Given I am logged into the user panel
    When I follow "Globe" within Card View
    Then I should see "Reserve this item"


Scenario: Admin can delete, edit and checkout items from inventory page
  Given I am logged into the admin panel
  And I switch to List View
  Then I should see "Archive"
  Then I should see "Edit" within List View
  Then I should see "Checkout"

Scenario: User cannot delete, edit and checkout items from inventory page
  Given I am logged into the user panel
  And I switch to List View
  Then I should not see "Deactivate"
  Then I should not see "Edit" within List View
  Then I should not see "Checkout"
  Then I should see "Reserve"
