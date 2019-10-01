class AddPensionProviderToBookingRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :booking_requests, :pension_provider, :string, null: false, default: ''
  end
end
