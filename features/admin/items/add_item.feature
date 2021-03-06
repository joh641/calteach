Feature: Add items

  As a Cal Teach advisor
  So that I can reflect new additions to the inventory
  I want to be able to add items to the inventory list

Background:

  Given there is an admin
  And I am logged into the admin panel
  And I am on the create item page

Scenario: Create an item using valid inputs
  When I fill in "Name" with "Globe"
  And I fill in "Quantity" with "2"
  And I fill in "Edit Tags" with "Geography"
  And I fill in "ID" with "F123"
  And I press "Submit"
  Then I should be on the Calteach inventory page
  Then I should see "Globe"

Scenario: Create an item using invalid inputs, negative quantity (sad path)
  When I fill in "Name" with "Globe"
  And I fill in "Quantity" with "-2"
  And I fill in "Edit Tags" with "Geography"
  And I fill in "ID" with "F123"
  And I press "Submit"
  Then I should see "Add Item"
  And I should see "Invalid quantity specified."

Scenario: Mass Add Items
  When I follow "Import Items"
  When I attach the file "features/support/test.csv" to "file"
  And I press "Import"
  Then I should be on the Calteach inventory page
  And I should see "Items imported!"
  And I should see "Absolute Ethynol"