class BookingRequestsController < ApplicationController
  def index
    @booking_requests = LocationAwareBookingRequests.new(
      current_user.booking_requests,
      booking_location
    ).all
  end
end
