class BookingRequests < ApplicationMailer
  def customer(booking_request, booking_location)
    @booking_request  = booking_request
    @booking_location = booking_location

    mail to: booking_request.email, subject: 'Your Pension Wise Appointment Request'
  end
end
