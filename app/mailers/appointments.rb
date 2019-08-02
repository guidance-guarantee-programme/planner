class Appointments < ApplicationMailer
  def booking_manager_appointment_changed(appointment, booking_manager)
    @appointment = appointment

    mailgun_headers :booking_manager_appointment_changed

    mail(to: booking_manager.email, subject: 'Pension Wise Appointment Changed')
  end

  def cancellation(appointment)
    @appointment = decorate(appointment)

    mailgun_headers :appointment_cancellation

    mail(
      to: @appointment.email,
      subject: 'Your Pension Wise Appointment Cancellation',
      reply_to: @appointment.online_booking_reply_to
    )
  end

  def booking_manager_cancellation(booking_manager, appointment)
    @appointment = decorate(appointment)

    mailgun_headers :sms_appointment_cancellation

    mail(to: booking_manager.email, subject: 'Pension Wise Appointment SMS Cancellation')
  end

  def customer(appointment, booking_location)
    @appointment = decorate(appointment, booking_location)

    identification_headers_for(appointment)

    mail(
      to: appointment.email,
      subject: 'Your Pension Wise Appointment',
      reply_to: booking_location.online_booking_reply_to
    )
  end

  def reminder(appointment, booking_location)
    @appointment = decorate(appointment, booking_location)

    mailgun_headers :appointment_reminder

    mail(
      to: appointment.email,
      subject: 'Your Pension Wise Appointment Reminder',
      reply_to: booking_location.online_booking_reply_to
    )
  end

  private

  def decorate(appointment, booking_location = nil)
    booking_location ||= BookingLocations.find(appointment.location_id)

    LocationAwareEntity.new(
      entity: appointment,
      booking_location: booking_location
    )
  end

  def identification_headers_for(appointment)
    value = appointment.updated? ? 'appointment_modified' : 'appointment_confirmation'

    mailgun_headers(value)
  end
end
