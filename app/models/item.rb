class Item < ActiveRecord::Base

  scope :active, -> { where(inactive: false) }
  scope :inactive, -> { where(inactive: true) }
  attr_accessible :category, :description, :due_date_category, :image, :legacy_id, :name, :quantity

  has_attached_file :image,
  :storage => :s3,
  :s3_credentials => S3_CREDENTIALS,
  :path => "/items/:style/:id/:filename",
  :styles => { :medium => "165x165>", :thumb => "100x100>" },
  :default_url => "http://placekitten.com/165/165"
  has_many :reservations
  has_many :users, :through => :reservations

  validates :name, :presence => true
  validates :quantity, :presence => true

  @@all_categories = ["Geography", "Math", "Science", "Social Studies"]
  @@due_dates = {"Video Equipment" => 2, "Books" => 10, "Other" => 5}
  @@due_dates.default = 5

  def self.due_date_categories
    @@due_dates.keys
  end

  def get_due_date
    @@due_dates[due_date_category]
  end
  
  def self.all_categories
    @@all_categories
  end
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      item = find_by_legacy_id(row["legacy_id"]) || new
      item.attributes = row.to_hash.slice(*accessible_attributes)
      item.save!
    end
  end

  def quantity_available(start_date= Date.today, end_date= Date.today, exclude_reservation= nil)
    number_available = quantity
    all_reservations = reservations.reject{|r| r == exclude_reservation}
    all_reservations.each do |reservation|
      if reservation.get_status == "Reserved" and reservation.overlaps?(start_date, end_date)
        number_available -= reservation.quantity
      elsif reservation.get_status == "Checked Out" and reservation.overlaps?(start_date, end_date)
        number_available -= reservation.quantity
      elsif reservation.get_status == "Overdue"
        number_available -= reservation.quantity
      end
    end
    number_available
  end
  
  def is_available
    quantity_available > 0
  end

  def available
    if is_available
      "Available"
    else
      "Unavailable"
    end
  end
  
  def active
    not inactive
  end

  def soft_delete
    update_attribute(:inactive, true)
  end
  
  def unarchive
    update_attribute(:inactive, false)
  end

end
