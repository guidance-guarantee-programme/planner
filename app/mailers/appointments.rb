class Appointments < ApplicationMailer
  def booking_manager_appointment_changed(appointment, booking_manager)
    @appointment = appointment

    mailgun_headers :booking_manager_appointment_changed

    mail(to: booking_manager, subject: appointment_changed_subject(appointment))
  end

  def customer_video_appointment(appointment, booking_location)
    @appointment = decorate(appointment, booking_location)

    mailgun_headers :customer_video_appointment

    mail(
      to: @appointment.email,
      subject: 'Your Pension Wise Video Appointment Link',
      reply_to: @appointment.online_booking_reply_to
    )
  end

  def missed(appointment)
    @appointment = decorate(appointment)

    mailgun_headers :appointment_missed

    mail(
      to: @appointment.email,
      subject: @appointment.subject,
      reply_to: @appointment.online_booking_reply_to
    )
  end

  def cancellation(appointment)
    @appointment = decorate(appointment)

    mailgun_headers :appointment_cancellation

    mail(
      to: @appointment.email,
      subject: @appointment.subject(suffix: ' Cancellation'),
      reply_to: @appointment.online_booking_reply_to
    )
  end

  def booking_manager_cancellation(booking_manager, appointment)
    @appointment = decorate(appointment)

    mailgun_headers :sms_appointment_cancellation

    mail(to: booking_manager, subject: 'Pension Wise Appointment SMS Cancellation')
  end

  def customer(appointment, booking_location)
    @appointment = decorate(appointment, booking_location)

    identification_headers_for(appointment)

    mail(
      to: appointment.email,
      subject: @appointment.subject,
      reply_to: @appointment.online_booking_reply_to
    )
  end

  def bsl_customer_exit_poll(appointment, booking_location)
    @appointment = decorate(appointment, booking_location)

    mailgun_headers :bsl_customer_exit_poll

    mail(
      to: appointment.email,
      subject: 'Your Pension Wise BSL Video Appointment',
      reply_to: @appointment.online_booking_reply_to
    )
  end

  def reminder(appointment, booking_location)
    @appointment = decorate(appointment, booking_location)

    mailgun_headers :appointment_reminder

    mail(
      to: appointment.email,
      subject: @appointment.subject(suffix: ' Reminder'),
      reply_to: @appointment.online_booking_reply_to
    )
  end

  private

  def appointment_changed_subject(appointment)
    subject = 'Pension Wise Appointment'

    suffix = if appointment.cancelled?
               'Cancelled'
             else
               'Changed'
             end

    "#{subject} #{suffix}"
  end

  def decorate(appointment, booking_location = nil)
    booking_location ||= BookingLocations.find(appointment.location_id)

    AppointmentEmailDecorator.new(
      LocationAwareEntity.new(
        entity: appointment,
        booking_location: booking_location
      )
    )
  end

  def identification_headers_for(appointment)
    value = appointment.updated? ? 'appointment_modified' : 'appointment_confirmation'

    mailgun_headers(value)
  end
end
