Given /user has reserved "(.*?)"/ do |item|
  page.driver.submit :delete, "/users/sign_out", {}
  step %Q{I am logged into the user panel}
  step %Q{I am on the home page}
  step %Q{I follow "#{item}"}
  step %Q{I fill in "reservation_start_date" with "11/16/2013"}
  step %Q{I fill in "reservation_end_date" with "11/26/2013"}
  step %Q{I press "Reserve"}
  page.driver.submit :delete, "/users/sign_out", {}
end