class AddAdditionalInfoFields < ActiveRecord::Migration[5.1]
  def change
    with_options default: '', null: false, limit: 160 do |options|
      options.add_column :booking_requests, :additional_info, :string
      options.add_column :appointments, :additional_info, :string
    end
  end
end
