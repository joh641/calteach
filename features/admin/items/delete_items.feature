Feature: Admin delete items
  As a Cal Teach advisor,
  So that I can remove items from being viewed in the inventory,
  I want to allow for marking of items as inactive.

Background: 
  Given the following items exist:
  | name                    | quantity  |
  | Globe                   | 5         |
  | Math book               | 5         |
  | Gold                    | 1         |
  And there is an admin

@javascript
Scenario:
  Given I am logged into the admin panel
  And I am on the home page
  And I switch to Card View
  When I follow "Globe" within Card View
  Then I should see "Admin"

  When I press "Archive item"
  And I confirm popup

  Then I should see "Item Globe was successfully archived."
  When I am on the home page
  Then I should not see "Globe"