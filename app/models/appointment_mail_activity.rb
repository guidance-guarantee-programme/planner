class AppointmentMailActivity < Activity
  def self.from(appointment)
    create!(
      booking_request: appointment.booking_request,
      message: appointment.updated? ? 'updated' : 'booked'
    )
  end
end
