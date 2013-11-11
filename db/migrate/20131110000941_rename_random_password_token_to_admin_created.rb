class RenameRandomPasswordTokenToAdminCreated < ActiveRecord::Migration
  def change
    rename_column(:users, :random_password_token, :admin_created)
  end
end
