class AddThirdPartyToBookingRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :booking_requests, :third_party, :boolean, default: false, null: false
  end
end
