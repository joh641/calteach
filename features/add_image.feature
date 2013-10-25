Feature: Add images

  As a Cal Teach advisor
  So that I can represent resources in the inventory
  I want to be able to add images of resources

Background:

  Given I am logged in as "admin"
  And I am on the edit page for item with id 1

Scenario: 
  When I upload the image "features/support/test_image.jpg" to "image_upload"
  And I press "edit_item_submit"
  Then I should see "test_image.jpg"
