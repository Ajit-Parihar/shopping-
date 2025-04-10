class ChangeUserDetailsToUserInUserAddresses < ActiveRecord::Migration[8.0]
  def change
      remove_column :user_addresses, :user_detail_id, :integer

       add_reference :user_addresses, :user, null: false, foreign_key: { to_table: :admin_users }
  end
end
