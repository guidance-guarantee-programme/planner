class VideoAppointmentUrlActivity < Activity
  def self.from(appointment)
    create(
      booking_request_id: appointment.booking_request.id,
      message: 'The video appointment URL was delivered to the customer'
    )
  end
end
