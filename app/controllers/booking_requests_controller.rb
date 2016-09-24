class BookingRequestsController < ApplicationController
  def index
    @booking_requests = LocationAwareEntities.new(
      unfulfilled_booking_requests,
      booking_location
    )
  end

  def destroy
    booking_request.deactivate!

    redirect_to booking_requests_path
  end

  private

  def booking_request
    current_user.booking_requests.find(params[:id])
  end

  def unfulfilled_booking_requests
    current_user.unfulfilled_booking_requests.page(params[:page])
  end
end
