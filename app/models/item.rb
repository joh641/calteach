class Item < ActiveRecord::Base
  attr_accessible :category, :description, :legacy_id, :name, :quantity, :image

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  has_many :reservations
  has_many :users, :through => :reservations
end
