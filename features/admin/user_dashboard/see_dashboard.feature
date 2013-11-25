Feature: Admin sees user dashboard
  As a Cal Teach advisor,
  So that I can edit users,
  I want to have a user dashboard.

  Background:
    Given there is an admin
    And there is a user

  Scenario: Non-admin cannot see the dashboard
    Given I am logged into the user panel
    Then I should not see "All users"
    When I am on the user dashboard
    Then I should see "Error: Not an admin"

  Scenario: Admin can see the dashboard
    Given I am logged into the admin panel
    Then I should see "All users"
    When I am on the user dashboard
    Then I should see "cucumberuser@gmail.com"