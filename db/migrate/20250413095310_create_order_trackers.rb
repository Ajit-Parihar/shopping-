class CreateOrderTrackers < ActiveRecord::Migration[8.0]
  def change
    create_table :order_trackers do |t|
      t.references :user, null: false, foreign_key: { to_table: :admin_users }

      t.string :status
      t.decimal :total_price

      t.timestamps
    end
  end
end
