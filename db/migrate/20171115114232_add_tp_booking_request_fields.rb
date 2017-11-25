class AddTpBookingRequestFields < ActiveRecord::Migration[5.1]
  def change
    add_column :booking_requests, :agent_id, :integer
    add_column :booking_requests, :address_line_one, :string, default: '', null: false
    add_column :booking_requests, :address_line_two, :string, default: '', null: false
    add_column :booking_requests, :address_line_three, :string, default: '', null: false
    add_column :booking_requests, :town, :string, default: '', null: false
    add_column :booking_requests, :county, :string, default: '', null: false
    add_column :booking_requests, :postcode, :string, default: '', null: false
    add_column :booking_requests, :country, :string, default: '', null: false
  end
end
