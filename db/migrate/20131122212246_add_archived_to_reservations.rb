class AddArchivedToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :archived, :boolean
  end
end
