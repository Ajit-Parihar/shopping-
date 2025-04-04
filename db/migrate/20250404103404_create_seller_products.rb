class CreateSellerProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :seller_products do |t|
      t.timestamps
    end
  end
end
