Feature: Create special faculty accounts
  
  As a Cal Teach advisor,
  So that I can distinguish between students and faculty and allow faculty to have additional privileges
  I want to be able to create special faculty accounts

Background:
  Given there is an admin
  Given I am logged into the admin panel
  And I am on the user dashboard
  And I should see "admin"
  When I follow "Add User"

Scenario: 
  And I fill in the following:
    | Name  | Bob           |
    | Email | bob@gmail.com |
    | Phone | 1230987654    |
  And I select "Faculty" from "User Type"
  And I press "Submit"
  Then I should see "User was successfully created."
  And I should see "Bob"
  When I am on the user dashboard
  Then I should see "Faculty"