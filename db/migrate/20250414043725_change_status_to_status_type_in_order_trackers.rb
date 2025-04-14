class ChangeStatusToStatusTypeInOrderTrackers < ActiveRecord::Migration[8.0]
  def change
        remove_column :order_trackers, :status, :integer
    add_column :order_trackers, :status_type, :string, default: "ordered"
  end
end
