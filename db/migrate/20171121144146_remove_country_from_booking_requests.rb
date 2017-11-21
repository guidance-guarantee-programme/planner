class RemoveCountryFromBookingRequests < ActiveRecord::Migration[5.1]
  def change
    remove_column :booking_requests, :country, :string, null: false, default: ''
  end
end
