class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :legacy_id
      t.string :name
      t.integer :quantity
      t.string :description
      t.string :category

      t.timestamps
    end
  end
end
