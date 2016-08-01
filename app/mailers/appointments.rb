class Appointments < ApplicationMailer
  def customer(appointment, booking_location)
    @appointment = LocationAwareEntity.new(
      entity: appointment,
      booking_location: booking_location
    )

    mailgun_headers('appointment_confirmation')
    mail to: appointment.email, subject: 'Your Pension Wise Appointment'
  end
end
