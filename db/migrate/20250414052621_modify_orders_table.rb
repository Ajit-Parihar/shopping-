class ModifyOrdersTable < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :deliver, :boolean
    remove_column :orders, :pending, :boolean
    remove_column :orders, :cancel, :boolean

    add_column :orders, :status_type, :string, default: "ordered"
  end
end
