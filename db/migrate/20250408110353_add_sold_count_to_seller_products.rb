class AddSoldCountToSellerProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :seller_products, :sold_count, :integer
  end
end
