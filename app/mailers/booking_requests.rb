class BookingRequests < ApplicationMailer
  def customer(booking_request, booking_location)
    @booking_request  = booking_request
    @booking_location = booking_location

    mailgun_headers('customer_booking_request')
    mail to: booking_request.email, subject: 'Your Pension Wise Appointment Request'
  end

  def booking_manager(booking_manager)
    mailgun_headers('booking_manager_booking_request')
    mail to: booking_manager.email, subject: 'Pension Wise Booking Request'
  end
end
