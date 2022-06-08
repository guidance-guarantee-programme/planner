class AddSecondaryStatusToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :secondary_status, :string, null: false, default: ''
  end
end
