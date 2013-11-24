class AddCanceledToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :canceled, :boolean
  end
end
