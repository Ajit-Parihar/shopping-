class AddDeletedAtToAllTables < ActiveRecord::Migration[8.0]
  def change
      add_column :add_to_cards, :deleted_at, :datetime
      add_column :admin_users, :deleted_at, :datetime
      add_column :businesses, :deleted_at, :datetime
      add_column :orders, :deleted_at, :datetime
      add_column :products, :deleted_at, :datetime
      add_column :ratings, :deleted_at, :datetime
      add_column :seller_products, :deleted_at, :datetime
      add_column :user_addresses, :deleted_at, :datetime
  end
end
