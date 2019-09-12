class RemoveRedundantBookableSlotColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :bookable_slots, :date, :date, null: false
    remove_column :bookable_slots, :start, :string, null: false
    remove_column :bookable_slots, :end, :string, null: false
  end
end
