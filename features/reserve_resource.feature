Feature: Reserve resources

  As a student
  So that I can get a hold of a desired resource
  I want to be able to reserve resources online 

Background:

  Given the following items exist:
  | name                    | quantity  |
  | Globe                   | 2         |
  | Book                    | 1         |
  | Camera                  | 0         |
  And there is an admin
  And there is a user

  
Scenario: I should be able to reserve an item if available
  When I am logged into the user panel
  And I reserve Globe from today+0 to today+1
  Then I should be on the item info page for Globe
  And there should be a reservation for Globe from today+0 to today+1

Scenario: I should not be able to reserve an item if not in stock.
  When I am logged into the user panel
  And I reserve Camera from today+0 to today+1
  Then I should be on the item info page for Camera
  And there should not be a reservation for Camera from today+0 to today+1

Scenario: I should be able to reserve an item if there is a preexisting and non-conflicting reservation in the future.
  When I am logged into the user panel
  And the following reservations exist:
  | user_id  | item_id   | reservation_out | reservation_in |
  | 1        | 2         | today+3         | today+4        |
  And I reserve Book from today+0 to today+1
  Then I should be on the item info page for Book
  And there should be a reservation for Book from today+0 to today+1

Scenario: I should be not able to reserve an item if there is a conflicting reservation.
  When I am logged into the user panel
  And the following reservations exist:
  | user_id  | item_id   | reservation_out | reservation_in |
  | 1        | 2         | today+0         | today+3        |
  And I reserve Book from today+1 to today+2
  Then there should not be a reservation for Globe from today+1 to today+2
  And I should be on the item info page for Book

Scenario: It should fail gracefully if the reserve date fields are blank.
  When I am logged into the user panel
  And I am on the item info page for Globe
  And I press "Reserve"
  Then I should be on the item info page for Globe
  And there should not be a reservation for Globe from today+0 to today+1