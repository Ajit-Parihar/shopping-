class AddFieldsToAdminUser < ActiveRecord::Migration[8.0]
  def change
    add_column :admin_users, :user_type, :string
  end
end
