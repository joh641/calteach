Feature: Reserve resources

  As a student
  So that I can get a hold of a desired resource
  I want to be able to reserve resources online 

Background:

  Given the following items exist:
  | name                    | quantity  |
  | Globe                   | 2         |
  | Book                    | 1         |
  And there is an admin
  And there is a user

  
Scenario: I should be able to reserve an item if available
  When I am logged into the user panel
  And I am on the item info page for Globe
  And I fill in "reservation_start_date" with "11/11/2013"
  And I fill in "reservation_end_date" with "11/12/2013"
  And I press "Reserve"
  Then I should be on the item info page for Globe
  And there should be a reservation for Globe from 11/11/2013 to 11/12/2013

Scenario: I should not be able to reserve an item if not in stock.
  When I am logged into the user panel
  And the following reservations exist:
  | user_id  | item_id   | reservation_out | reservation_in | date_out   |
  | 1        | 2         | 11/11/2013      | 11/12/2013     | 11/11/2013 |
  And I reserve Book from 11/11/2013 to 11/12/2013
  Then there should not be a reservation for Book from 11/11/2013 to 11/12/2013
  And I should be on the item info page for Book

Scenario: I should be able to reserve an item if there is a preexisting and non-conflicting reservation in the future.
  When I am logged into the user panel
  And the following reservations exist:
  | user_id  | item_id   | reservation_out | reservation_in |
  | 1        | 2         | 11/13/2013      | 11/14/2013     |
  And I reserve from Book 11/11/2013 to 11/12/2013
  Then there should be a reservation for Globe from 11/11/2013 to 11/12/2013
  And I should be on the item info page for Book.

Scenario: I should be able to reserve an item if there is a preexisting and non-conflicting reservation in the future.
  When I am logged into the user panel
  And the following reservations exist:
  | user_id  | item_id   | reservation_out | reservation_in |
  | 1        | 2         | 11/13/2013      | 11/14/2013     |
  And I reserve from Book 11/11/2013 to 11/12/2013
  Then there should be a reservation for Globe from 11/11/2013 to 11/12/2013
  And I should be on the item info page for Book.