class AddDefaultToArchiveReservations < ActiveRecord::Migration
  def change
    change_column :reservations, :archived, :boolean, :default => false
    change_column :reservations, :canceled, :boolean, :default => false
  end
end
