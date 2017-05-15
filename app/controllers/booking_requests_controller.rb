class BookingRequestsController < ApplicationController
  def index
    @booking_requests = LocationAwareEntities.new(
      unfulfilled_booking_requests,
      booking_location
    )
  end

  def update
    booking_request.attributes = booking_request_params

    if booking_request.changed?
      booking_request.save!
      ActivationActivity.from(booking_request, current_user, params[:status_message])
    end

    redirect_to booking_requests_path
  end

  private

  def booking_request_params
    params.require(:booking_request).permit(:status)
  end

  def booking_request
    @booking_request ||= current_user.booking_requests.find(params[:id])
  end

  def state
    possible_states = BookingRequest.statuses.keys

    if !params[:state] || possible_states.exclude?(params[:state])
      possible_states.first
    else
      params[:state]
    end
  end
  helper_method :state

  def unfulfilled_booking_requests
    current_user
      .unfulfilled_booking_requests
      .send(state)
      .page(params[:page])
  end
end
