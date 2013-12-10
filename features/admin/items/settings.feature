Feature: Edit Due Date Categories

  As a Cal Teach advisor
  So that I can manage the different types of automatic checkouts
  I want to be able to edit the due date categories

Background:
  Given the following items exist:
  | name                    | quantity  |
  | Globe                   | 5         |
  And there is an admin
  And I am logged into the admin panel
  And I am on the home page

Scenario:
  When I click with id "#edit-due-date-categories"
  Then I should see "Edit Due Date Categories"
  When I select "6" from "Other-days"
  And I press "Save Changes"
  Then I should see "Due date categories successfully updated."

Scenario: 
  When I click with id "#edit-due-date-categories"
  Then I should see "Edit Due Date Categories"
  When I fill in "category" with "New Category"
  And I press "Add Category"
  Then I should see "Due date categories successfully updated."