class RemoveStatusFromReservations < ActiveRecord::Migration
  def up
    remove_column :reservations, :status
  end

  def down
    add_column :reservations, :status, :string
  end
end
