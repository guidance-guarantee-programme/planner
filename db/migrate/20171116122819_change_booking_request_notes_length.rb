class ChangeBookingRequestNotesLength < ActiveRecord::Migration[5.1]
  def change
    change_column :booking_requests, :additional_info, :string, limit: 500, null: false, default: ''
  end
end
