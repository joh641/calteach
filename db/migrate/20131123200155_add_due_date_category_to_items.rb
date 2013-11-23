class AddDueDateCategoryToItems < ActiveRecord::Migration
  def change
    add_column :items, :due_date_category, :string
  end
end
