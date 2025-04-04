class AddBusinessToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :business, null: false, foreign_key: true
  end
end
