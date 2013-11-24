Feature: Edit account
  As a user
  So that I can change my own user data
  I want to be able to edit my account

Background:
  Given there is a user

Scenario:
  Given I am logged into the user panel
  When I am on the edit user page for "user"
  Then I should see "Edit User"
  When I fill in "Name" with "Bob"
  And I fill in "Current password" with "password"
  And I press "Update"
  Then I should see "You updated your account successfully."
  When I am on the edit user page for "Bob"
  Then I should see "Edit User"