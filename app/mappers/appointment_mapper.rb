class AppointmentMapper
  def self.map(appointment_form)
    {
      name: appointment_form.name,
      email: appointment_form.email,
      phone: appointment_form.phone,
      guider_id: appointment_form.guider_id,
      location_id: appointment_form.location_id,
      proceeded_at: Time.zone.parse("#{appointment_form.date} #{appointment_form.time.strftime('%H:%M')}"),
      booking_request_id: appointment_form.reference
    }
  end
end
