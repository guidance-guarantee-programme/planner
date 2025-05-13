class AddAdjustmentsToBookingRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_requests, :adjustments, :string, null: false, default: ''
  end
end
