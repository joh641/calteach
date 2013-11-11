class Reservation < ActiveRecord::Base
  attr_accessible :date_in, :date_out, :item_id, :notes, :reservation_in, :reservation_out, :user_id, :status

  belongs_to :user
  belongs_to :item

  def self.hide_archived
    Reservation.find(:all, :conditions => [ "status != 'Archived'" ])
  end
end
