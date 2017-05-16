class CreateAppointments < ActiveRecord::Migration[4.2]
  def change
    create_table :appointments do |t|
      t.belongs_to :booking_request, null: false, index: true

      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.integer :guider_id, null: false
      t.string :location_id, null: false, index: true
      t.datetime :proceeded_at, null: false

      t.timestamps null: false
    end
  end
end
