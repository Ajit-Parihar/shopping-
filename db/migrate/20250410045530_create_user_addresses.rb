class CreateUserAddresses < ActiveRecord::Migration[8.0]
  def change


      create_table :user_addresses do |t|
        t.string :country
        t.string :state
        t.string :dist
        t.string :block
        t.string :town
        t.integer :gali_no
        t.integer :house_no
        t.references :user_detail, null: false, foreign_key: true
  
        t.timestamps
    end
  end
end
