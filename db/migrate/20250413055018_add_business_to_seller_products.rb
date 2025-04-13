class AddBusinessToSellerProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :seller_products, :business, null: false, foreign_key: true
  end
end
