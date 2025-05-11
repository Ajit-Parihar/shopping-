class MakeSellerAndUserNullableInOrdersAndTransactions < ActiveRecord::Migration[8.0]
  def change
    change_column_null :orders, :seller_id, true
    change_column_null :orders, :user_id, true
    change_column_null :transactions, :seller_id, true
  end
end
