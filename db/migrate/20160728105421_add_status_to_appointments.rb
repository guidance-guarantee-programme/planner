class AddStatusToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :status, :integer, null: false, default: 0
  end
end
