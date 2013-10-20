Given /the following items exist/ do |items_table|
  flunk "Unimplemented"
  items_table.hashes.each do |item|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that item to the database here.
    Item.create(item)
  end
end

Then /I should see all the items/ do
  # Make sure that all the items in the app are visible in the table

  flunk "Unimplemented"
end