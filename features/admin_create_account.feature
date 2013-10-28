Feature: Admin create user accounts

  As a Cal Teach advisor
  So that I can control and keep track of the reservation system
  I want to allow for the creation of user accounts

Background:

Scenario:

    When I follow "Create account"
    Then I should see "Name"
    And I should see "Email"
    And I should see "Password"
    When I press "Submit"
    Then I should see "Log out"
