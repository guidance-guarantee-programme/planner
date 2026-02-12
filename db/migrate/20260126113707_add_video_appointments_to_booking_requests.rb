class AddVideoAppointmentsToBookingRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_requests, :video_appointment, :boolean, default: false
    add_column :booking_requests, :video_appointment_url, :string, null: false, default: ''
  end
end
