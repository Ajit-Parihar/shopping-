class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :product, null: false, foreign_key: true
      t.references :seller, null: false, foreign_key: { to_table: :admin_users }
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
