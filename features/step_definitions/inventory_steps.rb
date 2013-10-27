Given /the following items exist/ do |items_table|
  items_table.hashes.each do |item|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that item to the database here.
    Item.create(item)
  end
end

Then /I should see all the items/ do
  # Make sure that all the items in the app are visible in the table
  expect(page).to have_selector('.item-container', count: Item.all.length)
end

Then /"(.*)" should be (un)?available/ do |item, unavailable|
  # not page.find(:xpath, '//.item-container[@data-item_id="%s"' % Item.find_by_name(item).id).find(".subtitle.unavailable")
  # not page.find('.item-container'[item-id="4"]).find(".subtitle.available")
  elem = page.find(".item-container[data-item-id='%s']" % Item.find_by_name(item).id)
  if unavailable
  	has_css?(".subtitle.unavailable")
  else
  	has_css?(".subtitle.available")
  end
end

When /I search for "(.*)"/ do |query|
	page.find(".search-bar").set(query)
end

Then /there should be no results/ do
  # Make sure that all the items in the app are visible in the table
  expect(page).to have_selector('.item-container', count: 0)
end

# And /I press submit/ do
# 	page.find(".search-submit").click()
# end

# Then /I should see "*(.*)"/ do |item|
