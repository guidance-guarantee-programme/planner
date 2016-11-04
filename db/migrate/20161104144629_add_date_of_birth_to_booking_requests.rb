class AddDateOfBirthToBookingRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :booking_requests, :date_of_birth, :date, null: true
  end
end
