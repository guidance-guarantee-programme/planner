class CreateBookableSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :bookable_slots do |t|
      t.belongs_to :schedule, null: false, foreign_key: true, index: true
      t.date :date, null: false
      t.string :start, null: false
      t.string :end, null: false

      t.timestamps
    end
  end
end
