class BookingRequests < ApplicationMailer
  def customer(booking_request, booking_location)
    @booking_request  = booking_request
    @actual_location  = booking_location.location_for(booking_request.location_id)

    mailgun_headers('customer_booking_request')
    mail(
      to: booking_request.email,
      subject: 'Your Pension Wise Appointment Request',
      reply_to: booking_location.online_booking_reply_to
    )
  end

  def booking_manager(booking_request_or_appointment, booking_manager)
    @booking_request_or_appointment = decorate(booking_request_or_appointment)
    name = booking_request_or_appointment.model_name.human

    mailgun_headers('booking_manager_booking_request')
    mail to: booking_manager.email,
         subject: "Pension Wise #{name.titleize}" + accessibility_banner(@booking_request_or_appointment)
  end

  def email_failure(booking_request, booking_manager)
    @booking_request = booking_request
    @booking_manager = booking_manager

    mailgun_headers('email_failure_booking_request')
    mail to: booking_manager.email, subject: 'Email Failure - Pension Wise Booking Request'
  end

  private

  def accessibility_banner(entity)
    entity.accessibility_requirements? ? ' (Accessibility Adjustment)' : ''
  end

  def decorate(booking_request_or_appointment)
    booking_location = BookingLocations.find(booking_request_or_appointment.location_id)

    LocationAwareEntity.new(
      entity: booking_request_or_appointment,
      booking_location: booking_location
    )
  end
end
