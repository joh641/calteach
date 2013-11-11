class AddRandomPasswordTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :random_password_token, :boolean
  end
end
