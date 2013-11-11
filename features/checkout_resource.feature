Feature: Checkout resources

  As a CalTeach advisor
  So that I can allow students to get a desired resource
  I want to be able to checkout resources to students online 

Background:

  Given the following items exist:
  | name     | quantity  | 
  | Globe    | 1         |

  And there is a user
  And I am on the home page
  And I follow "Globe"

Scenario: 
  When I press "Checkout item"
  Then I should be on the checkout page for Globe
  And I should see "User's Email"
  When I fill in "email" with "cucumberuser@gmail.com"
  And I press "Checkout Item"
  Then I should see "Item Globe was successfully checked out" 
    
