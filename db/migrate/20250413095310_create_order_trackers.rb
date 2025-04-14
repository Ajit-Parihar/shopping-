class CreateOrderTrackers < ActiveRecord::Migration[8.0]
  def change
    create_table :order_trackers do |t|
      t.integer :status, default: 0
      t.references :user, foreign_key: { to_table: :admin_users }

      t.timestamps
    end
  end
end
