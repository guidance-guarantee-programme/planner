class AddActiveToBookingRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :booking_requests, :active, :boolean, null: false, default: true
  end
end
