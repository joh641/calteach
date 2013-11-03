Feature: Create account
  As a user
  So that I can access the CalTeach Site
  I want to be able to create an account using my email

Background:
    Given I am on the home page

Scenario:
    When I follow "Sign up"
    Then I should see "Name"
    And I should see "Email"
    And I should see "Password"
    And I fill in "Email" with "bob@gmail.com"
    And I fill in "Name" with "Bob"
    And I fill in "Phone" with "858-335-9258"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"


    When I press "Sign up"
    Then I should see "A message with a confirmation link has been sent to your email address."

