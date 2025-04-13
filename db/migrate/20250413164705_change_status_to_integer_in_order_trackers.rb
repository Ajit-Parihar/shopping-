class ChangeStatusToIntegerInOrderTrackers < ActiveRecord::Migration[8.0]
  def change
    remove_column :order_trackers, :status, :string
    add_column :order_trackers, :status, :integer, default: 0

  end
end
