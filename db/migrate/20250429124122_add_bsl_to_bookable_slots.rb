class AddBslToBookableSlots < ActiveRecord::Migration[6.1]
  def change
    add_column :bookable_slots, :bsl, :boolean, default: false, null: false
  end
end
