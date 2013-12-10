class RemoveCategoryFromItems < ActiveRecord::Migration
  def up
    remove_column :items, :category
  end

  def down
    add_column :items, :category, :string
  end
end
