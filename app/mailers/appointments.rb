class Appointments < ApplicationMailer
  def booking_manager_cancellation(booking_manager, appointment)
    @appointment = appointment

    mailgun_headers :sms_appointment_cancellation

    mail(to: booking_manager.email, subject: 'Pension Wise Appointment SMS Cancellation')
  end

  def customer(appointment, booking_location)
    @appointment = LocationAwareEntity.new(
      entity: appointment,
      booking_location: booking_location
    )

    identification_headers_for(appointment)

    mail(
      to: appointment.email,
      subject: 'Your Pension Wise Appointment',
      reply_to: booking_location.online_booking_reply_to
    )
  end

  def reminder(appointment, booking_location)
    @appointment = LocationAwareEntity.new(
      entity: appointment,
      booking_location: booking_location
    )

    mailgun_headers :appointment_reminder

    mail(
      to: appointment.email,
      subject: 'Your Pension Wise Appointment Reminder',
      reply_to: booking_location.online_booking_reply_to
    )
  end

  private

  def identification_headers_for(appointment)
    value = appointment.updated? ? 'appointment_modified' : 'appointment_confirmation'

    mailgun_headers(value)
  end
end
