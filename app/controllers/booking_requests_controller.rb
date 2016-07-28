class BookingRequestsController < ApplicationController
  def index
    @booking_requests = LocationAwareEntities.new(
      current_user.unfulfilled_booking_requests,
      booking_location
    ).all
  end
end
