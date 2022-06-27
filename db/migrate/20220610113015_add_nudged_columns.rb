class AddNudgedColumns < ActiveRecord::Migration[5.2]
  def change
    add_column :booking_requests, :nudged, :boolean, default: false, null: false
    add_column :appointments, :nudged, :boolean, default: false, null: false
  end
end
