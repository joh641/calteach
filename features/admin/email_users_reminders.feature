Feature: Send out alerts

  As a Cal Teach advisor
  So that I make sure resources are returned
  I want to automatically send out alerts when checked out resources are overdue

Background:

Scenario: user gets an email 
  Given there is a user
  And there is a reservation that is due in 1 days exists under "user"
  And the cron task runs
  Then "Bob" should receive an email

Scenario: user does not get an email
  Given there is a user
  And there is a reservation that is due in 2 days exists under "user"
  And the cron task runs
  Then "Bob" should receive no emails