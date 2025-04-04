class RemoveSellerProductIdFromProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :products, :seller_product_id, :bigint
  end
end
