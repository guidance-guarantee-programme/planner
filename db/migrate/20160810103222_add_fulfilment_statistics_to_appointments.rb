class AddFulfilmentStatisticsToAppointments < ActiveRecord::Migration[4.2]
  def up
    add_column :appointments, :fulfilment_time_seconds, :integer, default: 0, null: false
    add_column :appointments, :fulfilment_window_seconds, :integer, default: 0, null: false

    Appointment.find_each do |appointment|
      appointment.calculate_statistics
      appointment.save!
    end
  end

  def down
    remove_column :appointments, :fulfilment_time_seconds
    remove_column :appointments, :fulfilment_window_seconds
  end
end
