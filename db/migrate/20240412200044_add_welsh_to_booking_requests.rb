class AddWelshToBookingRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :booking_requests, :welsh, :boolean, default: false
  end
end
