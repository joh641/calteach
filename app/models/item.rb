class Item < ActiveRecord::Base

  scope :active, -> { where(inactive: false) }
  scope :inactive, -> { where(inactive: true) }
  attr_accessible :category, :description, :legacy_id, :name, :quantity, :image

  has_attached_file :image,
  :storage => :s3,
  :s3_credentials => S3_CREDENTIALS,
  :path => "/items/:style/:id/:filename",
  :styles => { :medium => "165x165>", :thumb => "100x100>" },
  :default_url => "http://placekitten.com/165/165"
  has_many :reservations
  has_many :users, :through => :reservations

  def self.all_categories
    ["Geography", "Math", "Science", "Social Studies"]
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      item = find_by_legacy_id(row["legacy_id"]) || new
      item.attributes = row.to_hash.slice(*accessible_attributes)
      item.save!
    end
  end

  def soft_delete
    update_attribute(:inactive, true)
  end

end
