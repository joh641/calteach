class AddInactiveToItems < ActiveRecord::Migration
  def change
    add_column :items, :inactive, :boolean
  end
end
