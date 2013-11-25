Feature: Send out alerts

  As a Cal Teach advisor
  So that I make sure resources are returned
  I want to automatically send out alerts when checked out resources are overdue

Background:
  Given the following items exist:
  | name                    | quantity  |
  | Globe                   | 2         |
  | Book                    | 1         |
  | Camera                  | 0         |
  And there is an admin
  And there is a user

Scenario: user gets an email 
  Given there is a reservation for "Book" that is due in 1 day exists under "user"
  And the cron task runs
  Then "cucumberuser@gmail.com" should receive 2 emails

Scenario: user does not get an email
  Given there is a reservation for "Book" that is due in 2 days exists under "user"
  And the cron task runs
  Then "cucumberuser@gmail.com" should receive no emails