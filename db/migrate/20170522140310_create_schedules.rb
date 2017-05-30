class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.string :location_id, null: false, index: true

      Schedule::SLOT_ATTRIBUTES.each do |attribute|
        t.boolean attribute, default: true, null: false
      end

      t.timestamps
    end
  end
end
