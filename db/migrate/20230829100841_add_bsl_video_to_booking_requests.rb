class AddBslVideoToBookingRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :booking_requests, :bsl_video, :boolean, default: false, null: false
  end
end
