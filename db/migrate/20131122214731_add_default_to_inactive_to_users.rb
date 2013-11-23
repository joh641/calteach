class AddDefaultToInactiveToUsers < ActiveRecord::Migration
  def change
    change_column :users, :inactive, :boolean, :default => false
  end
end
