class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.integer :item_id
      t.string :notes
      t.datetime :reservation_out
      t.datetime :reservation_in
      t.datetime :date_out
      t.datetime :date_in

      t.timestamps
    end
  end
end
