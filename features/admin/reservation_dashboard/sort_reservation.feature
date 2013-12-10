Feature: Admin sort reservations

  As a Cal Teach advisor
  So that I browse reservations in order of fields such as date or status
  I want to be able to sort the reservations table by column

Background:
  Given the following items exist:
  | name   | quantity |
  | Globe  | 1        |
  | Pencil | 1        |
  And there is an admin
  And I am logged into the admin panel
  And I reserve Globe from today+0 to today+1
  And I reserve Pencil from today+1 to today+3
  And I am on the reservation dashboard

Scenario: I should be able to sort reservations on the Date Out column
  Given this is pending
  When I follow "Date Out"
  Then I should see the reservations in this order:
   | Globe  |
   | Pencil |