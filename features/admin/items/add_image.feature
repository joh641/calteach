Feature: Add images

  As a Cal Teach advisor
  So that I can represent resources in the inventory
  I want to be able to add images of resources

Background:

  Given the following items exist:
  | name                    | quantity  |
  | Globe                   | 5         |
  And there is an admin
  And I am logged into the admin panel
  And I am on the edit page for item with id 1

Scenario:
  When I attach the file "features/support/test_image.jpg" to "item[image]"
  And I press "Submit"
  Then I should be on the item info page for Globe
  And I should see "successfully updated"
