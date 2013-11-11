Feature: Reserve resources

  As a student
  So that I can get a hold of a desired resource
  I want to be able to reserve resources online 

Background:

  Given the following items exist:
  | name                    | quantity  |
  | Globe                   | 5         |
  And there is an admin
  And I am logged into the admin panel
  And I am on the item info page for item with id 1

  
Scenario: 
  When I fill in "reservation_start_date" with "11/11/2013"
  And I fill in "reservation_end_date" with "11/12/2013"
  And I press "Reserve"
  Then I should be on the item info page for item with id 1