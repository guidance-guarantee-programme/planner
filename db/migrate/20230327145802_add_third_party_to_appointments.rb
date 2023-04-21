class AddThirdPartyToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :third_party, :boolean, default: false, null: false
  end
end
