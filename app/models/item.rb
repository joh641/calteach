class Item < ActiveRecord::Base
  attr_accessible :category, :description, :legacy_id, :name, :quantity, :image

  has_attached_file :image, :styles => { :medium => "165x165>", :thumb => "100x100>" }, :default_url => "http://placekitten.com/165/165"
  has_many :reservations
  has_many :users, :through => :reservations

  def self.all_categories
    ["Geography", "Math", "Science", "Social Studies"]
  end
end
