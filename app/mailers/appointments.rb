class Appointments < ApplicationMailer
  def customer(appointment, booking_location)
    @appointment = LocationAwareEntity.new(
      entity: appointment,
      booking_location: booking_location
    )

    identification_headers_for(appointment)

    mail to: appointment.email, subject: 'Your Pension Wise Appointment'
  end

  private

  def identification_headers_for(appointment)
    value = appointment.updated? ? 'appointment_modified' : 'appointment_confirmation'

    mailgun_headers(value)
  end
end
