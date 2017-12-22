class BookingRequestsController < ApplicationController
  def index
    return redirect_to agent_search_index_path if agent_only?

    @search = BookingRequestsSearchForm.new(search_params)

    @booking_requests = LocationAwareEntities.new(
      @search.results.page(params[:page]),
      booking_location
    )
  end

  def update
    booking_request.attributes = booking_request_params

    if booking_request.changed?
      booking_request.save!
      ActivationActivity.from(booking_request, current_user, params[:status_message])
    end

    redirect_to new_booking_request_appointment_path(booking_request)
  end

  private

  def agent_only?
    current_user.agent? && !current_user.booking_manager?
  end

  def search_params # rubocop:disable Metrics/MethodLength
    params
      .fetch(:search, {})
      .permit(
        :reference,
        :name,
        :status,
        :location
      ).merge(
        current_user: current_user,
        page: params[:page]
      )
  end

  def booking_request_params
    params.require(:booking_request).permit(:status)
  end

  def booking_request
    @booking_request ||= current_user.booking_requests.find(params[:id])
  end
end
