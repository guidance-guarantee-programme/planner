class AppointmentIndices < ActiveRecord::Migration[5.2]
  def change
    add_index :appointments, %i[guider_id proceeded_at]
    add_index :bookable_slots, %i[schedule_id date]
  end
end
