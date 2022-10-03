class CreateGuiderLookups < ActiveRecord::Migration[5.2]
  def change
    create_table :guider_lookups do |t|
      t.integer :guider_id, null: false, index: true
      t.string :name, null: false
      t.string :booking_location_id, null: false, index: true

      t.timestamps
    end
  end
end
