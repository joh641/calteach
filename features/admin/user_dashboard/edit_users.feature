Feature: Admin edit users
  As a Cal Teach advisor,
  So that I can change user data,
  I want to allow for editting other users.

  Background: 
    Given there is an admin

  Scenario:
    Given I am logged into the admin panel
    And I am on the user dashboard
    And I should see "admin"
    When I follow "Edit"
    Then I should see "Edit User"
    When I fill in "Name" with "Bob"
    And I press "Submit"
    Then I should see "User was successfully updated."
    And I should see "Bob"