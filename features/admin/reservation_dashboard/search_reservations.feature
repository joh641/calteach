Feature: Search reservations
  As a CalTeach admin
  So that I can look through reservations
  I want to be able to search reservations by different elements

Background:
  Given the following items exist:
  | name   | quantity | due_date_category        |
  | Globe  | 1        | Other                    |
  | Book   | 1        | Books                    |
  | Camera | 1        | Video Equipment          |
  And there is an admin
  And there is a user
  And I am logged into the admin panel
  And I am on the home page
  Given I switch to Card View
  When I follow "Camera" within Card View
  And I press "Checkout item"
  And I fill in "email" with "cucumberuser@gmail.com"
  And I press "Checkout Item"
  Then the reservation under "cucumberuser@gmail.com" should be for 2 days
  When I go to the reservation dashboard

Scenario:
  Then I should see "Filter"
  And I should see "user"
  And I should see "Camera"
  When I fill in "name" with "user"
  And I press "Filter"
  Then I should see "user"
  And I should see "Camera"

Scenario:
  Then I should see "Filter"
  And I should see "user"
  And I should see "Camera"
  When I fill in "name" with "asdf"
  And I press "Filter"
  And I should not see "Camera"