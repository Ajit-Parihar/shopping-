class RemoveSellerTypeFromSellerProducts < ActiveRecord::Migration[8.0]
  def change
    remove_column :seller_products, :seller_type, :string
  end
end
