class Item < ActiveRecord::Base
  attr_accessible :category, :description, :legacy_id, :name, :quantity

  has_many :reservations
  has_many :users, :through => :reservations
end
