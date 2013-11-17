class ChangeReservationDateTimesToDates < ActiveRecord::Migration
  def up
    change_column :reservations, :reservation_out, :date
    change_column :reservations, :reservation_in, :date
    change_column :reservations, :date_out, :date
    change_column :reservations, :date_in, :date
  end

  def down
    change_column :reservations, :reservation_out, :datetime
    change_column :reservations, :reservation_in, :datetime
    change_column :reservations, :date_out, :datetime
    change_column :reservations, :date_in, :datetime
  end
end
