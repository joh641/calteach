Feature: Cancel a reservation

  As a Cal Teach advisor
  To cancel a reservation that was never checked out
  I want to be able to cancel reservations

Background:
  Given the following items exist:
  | name  | quantity |
  | Globe | 1        |
  And there is an admin
  And I am logged into the admin panel
  And I reserve Globe from today+0 to today+1
  And I am on the reservation dashboard

Scenario: I should be able to cancel a reservation if it is reserved
  Given this is pending
  When I press "Cancel"
  Then I should see "Reservation was successfully canceled."
  And I should not see "Reserved"
