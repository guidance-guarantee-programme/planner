class AddStatusToBookingRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :booking_requests, :status, :integer, null: false, default: 0

    BookingRequest.where(active: true).update_all(status: 'active')
    BookingRequest.where(active: false).update_all(status: 'hidden')

    remove_column :booking_requests, :active
  end
end
