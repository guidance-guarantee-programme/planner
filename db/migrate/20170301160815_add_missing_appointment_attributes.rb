class AddMissingAppointmentAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :appointments, :memorable_word, :string, default: '', null: false
    add_column :appointments, :date_of_birth, :date, null: true
    add_column :appointments, :defined_contribution_pot_confirmed, :boolean, default: true, null: false
    add_column :appointments, :accessibility_requirements, :boolean, default: false, null: false
  end
end
