class DropOrderTrackersTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :order_trackers
  end
end
