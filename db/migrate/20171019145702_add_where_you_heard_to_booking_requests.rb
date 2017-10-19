class AddWhereYouHeardToBookingRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :booking_requests, :where_you_heard, :integer, default: 0, null: false
  end
end
