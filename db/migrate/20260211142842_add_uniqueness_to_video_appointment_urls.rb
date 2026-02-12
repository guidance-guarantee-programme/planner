class AddUniquenessToVideoAppointmentUrls < ActiveRecord::Migration[6.1]
  def change
    add_index :booking_requests, :video_appointment_url, unique: true, where: "video_appointment_url != '' AND video_appointment_url IS NOT NULL"
  end
end
