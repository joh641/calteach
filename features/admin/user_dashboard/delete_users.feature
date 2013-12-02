Feature: Admin delete users
  As a Cal Teach advisor,
  So that I can remove users from the website,
  I want to allow for marking of users as inactive.

  Background:
    Given there is an admin
    And there is a user

  Scenario:
    Given I am logged into the admin panel
    And I am on the user dashboard
    Then I should see "cucumberuser@gmail.com"
    And I should see "cucumberadmin@gmail.com"
    When I follow "Deactivate"
    Then I should see "cucumberadmin@gmail.com"
    Then I should not see "cucumberuser@gmail.com"

    When I follow "Show Inactive"
    Then I should see "cucumberuser@gmail.com"
    Then I should see "Activate"

    When I follow "Show Active"
    Then I should see "cucumberadmin@gmail.com"

    When I follow "Show Inactive"
    When I follow "Activate"
    Then I should see "was successfully activated"
