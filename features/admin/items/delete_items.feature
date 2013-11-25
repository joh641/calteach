Feature: Admin delete items
  As a Cal Teach advisor,
  So that I can remove items from being viewed in the inventory,
  I want to allow for marking of items as inactive.

Background: 
  Given the following items exist:
  | name                    | quantity  |
  | Globe                   | 5         |
  | Math book               | 5         |
  | Gold                    | 0         |
  And there is an admin

@javascript
Scenario:
  Given I am logged into the admin panel
  And I am on the home page
  And I switch to List View
  When I follow "Math book" within List View
  Then I should see "Admin"

  Given I expect to click "OK" on a confirmation box saying "Are you sure?"
  When I press "Delete item"
  Then the confirmation box should have been displayed

  Then I should see "Item Math book was successfully deleted."
  When I follow "Inventory"
  Then I should not see "Math book"