class AddDefaultToInactiveToItems < ActiveRecord::Migration
  def change
    change_column :items, :inactive, :boolean, :default => false
  end
end
