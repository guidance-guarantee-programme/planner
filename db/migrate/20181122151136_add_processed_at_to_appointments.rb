class AddProcessedAtToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :processed_at, :datetime
  end
end
