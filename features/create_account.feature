Feature: Create account

  As a user
  So that I can access the CalTeach Site
  I want to be able to create an account using my email

Background:

Scenario:

    When I click "Create account"
    Then I should see "Name"
    Then I should see "Email"
    Then I should see "Password"
    When I press "Submit"
    Then I should see "Log out"

