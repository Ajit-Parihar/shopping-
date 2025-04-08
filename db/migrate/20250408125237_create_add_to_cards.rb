class CreateAddToCards < ActiveRecord::Migration[8.0]
  def change
    create_table :add_to_cards do |t|
      t.integer :quantity
      t.references :admin_user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
