Feature: Admin create user accounts
  As a Cal Teach advisor,
  So that I can checkout users without accounts and give special privileges to users,
  I want to allow for the creation of user accounts of all types.

Background:
  Given I am on the home page
  Given there is an admin
  Given there is a user

Scenario: Admin can create other admins
  Given I am logged into the admin panel
  When I visit the User Dashboard
  Then I should see "Add User"
  When I follow "Add User"
  Then I should see "Name"
  And I should see "Email"
  Then I should see "User Type"
  And I fill in "Name" with "Bob"
  And I fill in "Email" with "bob@gmail.com"
  And I select "Admin" from "User Type"
  And I press "Submit"
  Then the created email account should receive a temporary password and confirmation
  Then I should see "User was successfully created."
  Then I should be on the user dashboard
  Then I should see "Bob"
  Then the type of "Bob" should be "admin"

Scenario: Admin can create faculty users
  Given I am logged into the admin panel
  When I visit the User Dashboard
  Then I should see "Add User"
  When I follow "Add User"
  Then I should see "Name"
  And I should see "Email"
  Then I should see "User Type"
  And I fill in "Name" with "Bob"
  And I fill in "Email" with "bob@gmail.com"
  And I select "Faculty" from "User Type"
  And I press "Submit"
  Then the created email account should receive a temporary password and confirmation
  Then I should see "User was successfully created."
  Then I should be on the user dashboard
  Then I should see "Bob"
  Then the type of "Bob" should be "faculty"

Scenario: Admin can create basic users
  Given I am logged into the admin panel
  When I visit the User Dashboard
  Then I should see "Add User"
  When I follow "Add User"
  Then I should see "Name"
  And I should see "Email"
  Then I should see "User Type"
  And I fill in "Name" with "Bob"
  And I fill in "Email" with "bob@gmail.com"
  And I select "Basic" from "User Type"
  And I press "Submit"
  Then the created email account should receive a temporary password and confirmation
  Then I should see "User was successfully created."
  Then I should be on the user dashboard
  Then I should see "Bob"
  Then the type of "Bob" should be "basic"
  When I edit "Bob"
  Then I should see "Name"
  And I fill in "Name" with "Bobby"
  And I press "Submit"
  Then I should see "Bobby"
  Then I should be on the user dashboard
  When I destroy "Bobby"
  Then I should not see "basic@berkeley.edu"
  Then I should be on the user dashboard


Scenario: Non-admin cannot create users
  Given I am logged into the user panel
  Then I should not see "Add User"
