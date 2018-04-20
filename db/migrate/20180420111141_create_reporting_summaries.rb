class CreateReportingSummaries < ActiveRecord::Migration[5.1]
  def change
    create_table :reporting_summaries do |t|
      t.string :location_id, null: false
      t.string :name, null: false
      t.boolean :four_week_availability, null: false
      t.date :first_available_slot_on

      t.timestamps
    end
  end
end
