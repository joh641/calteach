Feature: Limit checkout length based on category

  As a Cal Teach advisor
  So that I can account for the popularity of resources
  I want to be able to limit how long a resource can be checked out based on the category it belongs to

Background:

  Given the following items exist:
  | name   | quantity | due_date_category        |
  | Globe  | 1        | other                    |
  | Book   | 1        | books                    |
  | Camera | 1        | video equipment          |

  And there is a user
  And there is an admin
  And I am logged into the admin panel
  And I am on the home page

Scenario: Video Equipment can only be checked out for 2 days
  Given I switch to List View
  When I follow "Camera" within List View
  And I press "Checkout item"
  And I fill in "email" with "cucumberuser@gmail.com"
  And I press "Checkout Item"
  Then the reservation under "cucumberuser@gmail.com" should be for 2 days

Scenario: Books can only be checked out for 10 days
  Given I switch to List View
  When I follow "Book" within List View
  And I press "Checkout item"
  And I fill in "email" with "cucumberuser@gmail.com"
  And I press "Checkout Item"
  Then the reservation under "cucumberuser@gmail.com" should be for 10 days
  
Scenario: Other items can only be checked out for 5 days
  Given I switch to List View
  When I follow "Globe" within List View
  And I press "Checkout item"
  And I fill in "email" with "cucumberuser@gmail.com"
  And I press "Checkout Item"
  Then the reservation under "cucumberuser@gmail.com" should be for 5 days
