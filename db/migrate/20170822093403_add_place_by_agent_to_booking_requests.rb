class AddPlaceByAgentToBookingRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :booking_requests, :placed_by_agent, :boolean, null: false, default: false
  end
end
