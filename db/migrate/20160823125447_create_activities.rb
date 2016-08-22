class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :message, null: false
      t.references :user
      t.references :booking_request, null: false
      t.string :type, null: false

      t.timestamps null: false

      t.index %w(booking_request_id type)
    end
  end
end
