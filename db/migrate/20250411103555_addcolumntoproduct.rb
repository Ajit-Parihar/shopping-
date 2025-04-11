class Addcolumntoproduct < ActiveRecord::Migration[8.0]
  def change
# Migration example
add_column :products, :rating, :decimal, precision: 2, scale: 1
  end
end
