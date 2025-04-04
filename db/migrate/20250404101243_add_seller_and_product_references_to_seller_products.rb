class AddSellerAndProductReferencesToSellerProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :seller_products, :seller, polymorphic: true, null: false
    add_reference :seller_products, :product, null: false, foreign_key: true
  end
end
rails generate migration RemoveSellerTypeFromSellerProducts seller_type:string
