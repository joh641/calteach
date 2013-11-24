class AddQuantityToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :quantity, :integer
  end
end
