class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.string :location_id, null: false, index: true

      t.boolean :monday_am, default: true, null: false
      t.boolean :monday_pm, default: true, null: false
      t.boolean :tuesday_am, default: true, null: false
      t.boolean :tuesday_pm, default: true, null: false
      t.boolean :wednesday_am, default: true, null: false
      t.boolean :wednesday_pm, default: true, null: false
      t.boolean :thursday_am, default: true, null: false
      t.boolean :thursday_pm, default: true, null: false
      t.boolean :friday_am, default: true, null: false
      t.boolean :friday_pm, default: true, null: false

      t.timestamps
    end
  end
end
