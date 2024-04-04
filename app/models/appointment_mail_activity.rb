class AppointmentMailActivity < Activity
  def self.from(appointment)
    message = if appointment.cancelled?
                'cancelled'
              elsif appointment.no_show?
                'missed'
              elsif appointment.updated?
                'updated'
              else
                'booked'
              end

    create!(booking_request: appointment.booking_request, message: message)
  end
end
