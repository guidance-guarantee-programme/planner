class RenameBslVideoOnBookingRequests < ActiveRecord::Migration[5.2]
  def change
    rename_column :booking_requests, :bsl_video, :bsl
  end
end
