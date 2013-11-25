Given /the following reservations exist/ do |reservations_table|
  reservations_table.hashes.each do |reservation|
    reservation_out = Date.today + reservation[:reservation_out].split("+")[1].to_i if reservation[:reservation_out].split("+").length > 1
    reservation_in = Date.today + reservation[:reservation_in].split("+")[1].to_i if reservation[:reservation_out].split("+").length > 1
    Reservation.create(reservation)
  end
end

Given /user has reserved "(.*?)"/ do |item|
  page.driver.submit :delete, "/users/sign_out", {}
  step %Q{I am logged into the user panel}
  step %Q{I am on the home page}
  step %Q{I switch to List View}
  step %Q{I follow "#{item}" within List View}
  step %Q{I fill in "reservation_start_date" with "11/16/2013"}
  step %Q{I fill in "reservation_end_date" with "11/26/2013"}
  step %Q{I press "Reserve Item"}
  page.driver.submit :delete, "/users/sign_out", {}
end

Then /the reservation under "(.*?)" should be for (.*?) days/ do |user_email, days|
  user = User.find_by_email(user_email)
  res = Reservation.find_by_user_id(user.id)
  assert(res.reservation_in - res.reservation_out == days)
end

Given(/^there is a reservation for "(.*?)" that is due in (\d+) days? exists under "(.*?)"$/) do |item_name, days, user_name|
  item = Item.find_by_name(item_name)
  user = User.find_by_name(user_name)
  date = Date.today + days.to_i

  Reservation.create(user_id: user.id, item_id: item.id, date_out: Date.today, reservation_out: Date.today, reservation_in: date, quantity: 1)
  puts "reservation created"
end

When /I reserve (.*) from (.*) to (.*)/ do |item_name, reservation_out, reservation_in|
  reservation_out = Date.today + reservation_out.split("+")[1].to_i if reservation_out.split("+").length > 1
  reservation_in = Date.today + reservation_in.split("+")[1].to_i if reservation_in.split("+").length > 1
  step %Q{I am on the item info page for #{item_name}}
  step %Q{I fill in "reservation_start_date" with "#{reservation_out}"}
  step %Q{I fill in "reservation_end_date" with "#{reservation_in}"}
  step %Q{I press "Reserve"}
end

Then /there should (not )?be a reservation for (.*) from (.*) to (.*)/ do |not_exist, item_name, reservation_out, reservation_in|
  item = Item.find_by_name(item_name)

  start_date = reservation_out.split("+").length ? Date.today + reservation_out.split("+")[1].to_i : Date.strptime(reservation_out, "%m/%d/%Y")
  end_date = reservation_in.split("+").length ? Date.today + reservation_in.split("+")[1].to_i : Date.strptime(reservation_in, "%m/%d/%Y")

  reservation = nil
  item.reservations.each do |r|
    if r.reservation_out and r.reservation_in and r.reservation_out.to_date == start_date.to_date and r.reservation_in.to_date == end_date.to_date
      reservation = r
    end
  end

  if not_exist
    assert(reservation == nil)
  else
    assert(reservation != nil)
  end
end
