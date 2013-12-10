Feature: See available inventory

  As a Cal Teach advisor
  So that I can manage resources quickly without having to click each resource
  I want to be able to archive (or unarchive), edit, and checkout resources from the inventory page

Background: items have been added to inventory

    Given the following items exist:
    | name                    | quantity  |
    | Globe                   | 5         |
    And there is an admin
    And there is a user
    And I am on the home page
    And I switch to List View

Scenario: Admin can delete, edit and checkout items from inventory page
  Given I am logged into the admin panel
  Then I should see "Archive"
  Then I should see "Edit" within List View
  Then I should see "Checkout"

  When I follow "Archive"
  Then I should see "was successfully archived"

  When I follow "Show Archived"
  Then I should see "Globe"
  Then I should see "Unarchive"

  When I follow "Unarchive"
  Then I should see "was successfully unarchived"

Scenario: User cannot delete, edit and checkout items from inventory page
  Given I am logged into the user panel
  Then I should not see "Deactivate"
  Then I should not see "Edit" within List View
  Then I should not see "Checkout"
  Then I should see "Reserve"
