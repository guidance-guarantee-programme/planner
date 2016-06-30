class BookingRequestsController < ApplicationController
  def index
    @booking_requests = LocationAwareEntities.new(
      unfulfilled_booking_requests,
      booking_location
    )
  end

  private

  def unfulfilled_booking_requests
    current_user.unfulfilled_booking_requests.page(params[:page])
  end

  def show
    @booking_request = BookingRequest.find(params[:id])
  end
end
