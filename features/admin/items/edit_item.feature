Feature: Edit images

  As a Cal Teach advisor
  So that I can update item information
  I want to be able to edit existing items

Background:

  Given the following items exist:
  | name                    | quantity  |
  | Globe                   | 5         |
  And there is an admin
  And I am logged into the admin panel
  And I am on the home page
  And I switch to Card View
  When I follow "Globe" within Card View

Scenario:
  Then I should see "Admin"
  When I press "Edit item"
  Then I should see "Edit Item"
  When I fill in "Name" with "Big Globe"
  And I press "Submit"
  Then I should be on the item info page for Big Globe
  And I should see "successfully updated"
  And I should see "Big Globe"
