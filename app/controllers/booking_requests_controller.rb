class BookingRequestsController < ApplicationController
  def index
    @booking_requests = LocationAwareEntities.new(
      unfulfilled_booking_requests,
      booking_location
    )
  end

  def update
    booking_request.update_attributes!(booking_request_params)
    ActivationActivity.from(booking_request, current_user)

    redirect_to booking_requests_path
  end

  private

  def booking_request_params
    params.require(:booking_request).permit(:status)
  end

  def show_hidden_booking_requests?
    params.fetch(:hidden, 'false') == 'true'
  end
  helper_method :show_hidden_booking_requests?

  def booking_request
    @booking_request ||= current_user.booking_requests.find(params[:id])
  end

  def unfulfilled_booking_requests
    current_user
      .unfulfilled_booking_requests(hidden: show_hidden_booking_requests?)
      .page(params[:page])
  end
end
