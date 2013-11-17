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

Then /the reservation should be for (.*?) days/ do |days|
  flunk "Unimplemented"
end

Given(/^there is a reservation that is due in (\d+) days? exists under "(.*?)"$/) do |days, user_name|
  flunk "Unimplemented"
end

When /I reserve (.*) from (.*) to (.*)/ do |item_name, reservation_out, reservation_in|
  step 'I am on the item info page for ' + item_name
  step 'I fill in "reservation_start_date" with "' + reservation_out + '"'
  step 'I fill in "reservation_end_date" with "' + reservation_in + '"'
  step 'I press "Reserve"'
end

Then /there should (not )?be a reservation for (.*) from (.*) to (.*)/ do |not_exist, item_name, reservation_out, reservation_in|
  item = Item.find_by_name(item_name)

  start_date = DateTime.strptime(reservation_out, "%m/%d/%Y")
  end_date = DateTime.strptime(reservation_in, "%m/%d/%Y")

  reservation = nil
  item.reservations.each do |r|
    if r.reservation_out.to_date  + 1 == start_date.to_date and r.reservation_in.to_date + 1 == end_date.to_date
      reservation = r
    end
  end

  if not_exist
    assert(reservation == nil)
  else
    assert(reservation != nil)
  end
end
