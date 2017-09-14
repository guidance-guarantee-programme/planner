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

  def booking_manager(booking_manager)
    mailgun_headers('booking_manager_booking_request')
    mail to: booking_manager.email, subject: 'Pension Wise Booking Request'
  end
end
