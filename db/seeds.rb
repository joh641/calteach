# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

items = [{:legacy_id => '1234', :name => "Globe", :quantity => 2, :description => 'Description', :category => 'Geography'}]

items.each do |item|
  Item.create(item)
end
