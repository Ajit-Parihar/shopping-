class AddSellerProdcutRefToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :seller_product, null: false, foreign_key: true
  end
end
