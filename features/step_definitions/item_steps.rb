Then /I should see all the items that are in the database/ do
  Item.all.each do |item|
  	assert page.body.index(item.name) != nil
  end
end

Given /I am logged in as "(.*)"/ do |user_type|
  #TODO User implementation currently unfinished
  pass "Not implemented"
end
