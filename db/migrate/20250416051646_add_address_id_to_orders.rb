class AddAddressIdToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :address, foreign_key: { to_table: :user_addresses }  end
 end
