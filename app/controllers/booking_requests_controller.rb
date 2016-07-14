class BookingRequestsController < ApplicationController
  def index
    @booking_requests = LocationAwareBookingRequests.new(
      current_user.booking_requests,
      booking_location
    ).all
  end

  private

  def booking_location
    BookingLocations.find(current_user.organisation_content_id)
  end
end
