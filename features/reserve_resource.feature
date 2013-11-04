Feature: Reserve resources

  As a student
  So that I can get a hold of a desired resource
  I want to be able to reserve resources online 

Background:

  Given the following items exist:
  | name                    | quantity  |
  | Globe                   | 5         |

  And I am on the home page
  
Scenario: 
  When I check "Globe"
  And I press "Reserve"
  Then I should be on the Reserve Cart page
  And I should see "Globe"
  When I press "Confirm"
  Then I should see "You have successfully reserved"
  And I should see "Globe"  