class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :price
      t.string :brand_name

      t.timestamps
    end
  end
end
