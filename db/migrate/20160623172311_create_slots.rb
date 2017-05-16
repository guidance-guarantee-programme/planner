class CreateSlots < ActiveRecord::Migration[4.2]
  def change
    create_table :slots do |t|
      t.belongs_to :booking_request, foreign_key: true, index: true
      t.date :date, null: false
      t.string :from, null: false
      t.string :to, null: false
      t.integer :priority, null: false

      t.timestamps null: false
    end
  end
end
