class RemoveSellerIdFromBusinesses < ActiveRecord::Migration[8.0]
  def change
    remove_index :businesses, :seller_id if index_exists?(:businesses, :seller_id)
    remove_column :businesses, :seller_id, :bigint
  end
end
