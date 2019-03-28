class ChangeScheduleDefaults < ActiveRecord::Migration[5.2]
  def change
    Schedule::SLOT_ATTRIBUTES.each do |attr|
      change_column_default(:schedules, attr, from: true, to: false)
    end
  end
end
