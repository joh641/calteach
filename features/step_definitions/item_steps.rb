Given /the following items exist/ do |items_table|
  items_table.hashes.each do |item|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that item to the database here.
    Item.create(item)
  end
end

Then /I should see all the items that are in the database/ do
  Item.all.each do |item|
  	assert page.body.index(item.name) != nil
  end
end

Given /I am logged in as "(.*)"/ do |user_type|
  #TODO User implementation currently unfinished
  pass "Not implemented"
end
