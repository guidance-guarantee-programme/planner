class AddMissingValuesToAppointments < ActiveRecord::Migration[5.0]
  def up
    Appointment.find_each do |appointment|
      appointment.without_auditing do
        appointment.update_attributes(
          memorable_word: appointment.booking_request.memorable_word,
          date_of_birth: appointment.booking_request.date_of_birth,
          defined_contribution_pot_confirmed: appointment.booking_request.defined_contribution_pot_confirmed,
          accessibility_requirements: appointment.booking_request.accessibility_requirements
        )
      end
    end
  end

  def down
    # noop
  end
end
