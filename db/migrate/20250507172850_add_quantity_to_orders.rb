class AddQuantityToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :quantity, :integer
  end
end
