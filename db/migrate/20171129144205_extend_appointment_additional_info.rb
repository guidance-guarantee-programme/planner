class ExtendAppointmentAdditionalInfo < ActiveRecord::Migration[5.1]
  def change
    change_column :appointments, :additional_info, :string, limit: 500, null: false, default: ''
  end
end
