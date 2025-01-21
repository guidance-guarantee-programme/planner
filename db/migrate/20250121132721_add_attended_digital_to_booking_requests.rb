class AddAttendedDigitalToBookingRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_requests, :attended_digital, :string
  end
end
