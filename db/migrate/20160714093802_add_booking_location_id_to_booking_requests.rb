class AddBookingLocationIdToBookingRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :booking_requests, :booking_location_id, :string, null: false, index: true
  end
end
