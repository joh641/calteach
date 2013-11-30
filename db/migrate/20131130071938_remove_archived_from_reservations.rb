class RemoveArchivedFromReservations < ActiveRecord::Migration
  def change
    remove_column :reservations, :archived
  end
end
