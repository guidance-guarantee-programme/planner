class CreateBookingRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :booking_requests do |t|
      t.string :location_id, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :memorable_word, null: false
      t.string :age_range, null: false
      t.boolean :accessibility_requirements, null: false
      t.boolean :marketing_opt_in, null: false
      t.boolean :defined_contribution_pot, null: false

      t.timestamps null: false
    end
  end
end
