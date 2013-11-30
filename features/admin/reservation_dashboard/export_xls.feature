Feature: Download Excel File of Reservations

  As a CalTeach admin
  So that I can view statistics on reservation data
  I want to be able to export past reservations to an excel file

  Background:
    Given the following items exist:
    | name                    | quantity  |
    | Globe                   | 2         |
    | Book                    | 1         |
    | Camera                  | 0         |

    Given there is an admin
    And there is a user
    And there is a reservation for "Book" that is due in 2 days exists under "user"

  Scenario: Admin should be able to download reservations
    Given I am logged into the admin panel
    When I am on the reservation dashboard
    Then I should see "Download"
    When I follow "Excel"
    Then I should get a download file with a header of "Reservation ID"