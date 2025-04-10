class AddDetailsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :deliver, :boolean
    add_column :orders, :pending, :boolean
    add_column :orders, :cancel, :boolean
  end
end
