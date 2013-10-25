class Reservation < ActiveRecord::Base
  attr_accessible :date_in, :date_out, :item_id, :notes, :reservation_in, :reservation_out, :user_id

  belongs_to :user
  belongs_to :item
end
