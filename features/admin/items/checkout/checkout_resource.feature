Feature: Checkout resources

  As a CalTeach advisor
  So that I can allow students to get a desired resource
  I want to be able to checkout resources to students online

Background:

  Given the following items exist:
  | name     | quantity  |
  | Globe    | 1         |

  And there is a user
  And there is an admin
  And I am logged into the admin panel
  And I am on the home page
  And I switch to List View
  And I follow "Globe" within List View
  And I press "Checkout item"

Scenario: Checkout user exists and item not reserved
  Then I should be on the checkout page for Globe
  And I should see "User's Email"
  When I fill in "email" with "cucumberuser@gmail.com"
  And I press "Checkout Item"
  Then I should see "Item Globe was successfully checked out"
  When I follow "Check In"
  Then I should see "Item Globe was successfully checked in"

Scenario: Checkout to user that does not exist (sad path)
  When I fill in "email" with "thisuserdoesnotexist@gmail.com"
  And I press "Checkout Item"
  Then I should see "User does not exist"
  And I should see the "Checkout item" button
  And I should not see the "Check In" button

Scenario: Checkout to user when reserved for another user (sad path)
  Given there is a reservation for "Globe" that is due in 3 days exists under "user"
  Then I should be on the checkout page for Globe
  And I should see "User's Email"
  When I fill in "email" with "cucumberadmin@gmail.com"
  And I press "Checkout Item"
  Then I should see "Item Globe could not be checked out"
  And I should not see "Checked out to: admin"
