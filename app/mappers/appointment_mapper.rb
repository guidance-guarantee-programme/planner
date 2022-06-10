class AppointmentMapper
  def self.map(appointment_form) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    {
      name: appointment_form.name,
      email: appointment_form.email,
      phone: appointment_form.phone,
      memorable_word: appointment_form.memorable_word,
      date_of_birth: appointment_form.date_of_birth,
      defined_contribution_pot_confirmed: appointment_form.defined_contribution_pot_confirmed,
      accessibility_requirements: appointment_form.accessibility_requirements,
      guider_id: appointment_form.guider_id,
      location_id: appointment_form.location_id,
      proceeded_at: Time.zone.parse("#{appointment_form.date} #{appointment_form.time.strftime('%H:%M')}"),
      booking_request_id: appointment_form.reference,
      additional_info: appointment_form.additional_info,
      recording_consent: appointment_form.recording_consent,
      nudged: appointment_form.nudged
    }
  end
end
