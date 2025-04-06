class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :user_id, null: false
      t.integer :product_id, null: false
      t.references :seller, null: false, foreign_key: { to_table: :admin_users }

      t.timestamps
    end

    add_index :orders, :user_id
    add_index :orders, :product_id
  end
end
