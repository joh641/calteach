Feature: Admin create users
  As a Cal Teach advisor,
  So that I can create users myself,
  I want to allow for creating new users.

  Background:
    Given there is an admin

  Scenario:
    Given I am logged into the admin panel
    And I am on the user dashboard
    And I should see "admin"
    And I follow "Add User"
    And I fill in the following:
      | Name  | Bob           |
      | Email | bob@gmail.com |
      | Phone | 1230987654    |
    And I press "Submit"
    Then I should see "User was successfully created."
    And I should see "Bob"