Feature: Add items

  As a Cal Teach advisor
  So that I can reflect new additions to the inventory
  I want to be able to add items to the inventory list

Background:

  Given there is an admin
  And I am logged into the admin panel
  And I am on the create item page

Scenario: 
  When I fill in "Name" with "Globe"
  And I fill in "Quantity" with "2"
  And I select "Geography" from "Category"
  And I fill in "ID" with "F123"
  And I press "Create Item"
  Then I should be on the Calteach inventory page
  Then I should see "Globe"
