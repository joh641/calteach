Feature: Checkout resources

  As a CalTeach advisor
  So that I can allow students to get a desired resource
  I want to be able to checkout resources to students online 

Background:

  Given the following reservations exist:
  |  id   |  name                    |  items     |  
  |  1    |  User                    |  Globe     |
  And I am on the admin page
  
Scenario: 
  When I check "Reservation_1"
  And I press "Checkout"
  Then I should be on the checkout confirmation page
  And I should see "Check out successful"
  And I should see "Globe"
