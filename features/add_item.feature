Feature: Add items

  As a Cal Teach advisor
  So that I can reflect new additions to the inventory
  I want to be able to add items to the inventory list

Background:

  Given I am logged in as "admin"
  And I am on the create item page

Scenario: 
  When I fill in "name" with "Globe"
  And I fill in "quantity" with "2"
  And I fill in "category" with "Geography"
  And I fill in "legacy_id" with "F123"
  And I press "create_item_submit"
  Then I should see "Globe"
