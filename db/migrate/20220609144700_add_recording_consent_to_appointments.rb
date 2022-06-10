class AddRecordingConsentToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :booking_requests, :recording_consent, :boolean, default: false, null: false
    add_column :appointments, :recording_consent, :boolean, default: false, null: false
  end
end
