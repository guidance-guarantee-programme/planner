class AddGuiderIdToBookableSlots < ActiveRecord::Migration[5.1]
  def change
    add_column :bookable_slots, :guider_id, :integer
  end
end
