class AddSellerReferenceToBusinesses < ActiveRecord::Migration[8.0]
  def change
    add_reference :businesses, :seller, foreign_key: { to_table: :admin_users }, null: false  end
end
