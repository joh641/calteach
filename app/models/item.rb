class Item < ActiveRecord::Base

  scope :active, -> { where(inactive: false) }
  scope :inactive, -> { where(inactive: true) }
  attr_accessible :category, :description, :legacy_id, :name, :quantity, :image, :due_date_category

  has_attached_file :image,
  :storage => :s3,
  :s3_credentials => S3_CREDENTIALS,
  :path => "/items/:style/:id/:filename",
  :styles => { :medium => "165x165>", :thumb => "100x100>" },
  :default_url => "http://placekitten.com/165/165"
  has_many :reservations
  has_many :users, :through => :reservations

  @@due_dates = {"video equipment" => 2, "books" => 10, "other" => 5}
  @@due_dates.default = 5

  def is_available
    quantity > 0
  end

  def available
    if is_available
      "Available"
    else
      "Unavailable"
    end
  end

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

  def get_due_date
    @@due_dates[self.due_date_category]
  end

  def soft_delete
    update_attribute(:inactive, true)
  end

end
