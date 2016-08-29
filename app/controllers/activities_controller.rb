class ActivitiesController < ApplicationController
  def index
    @activities = booking_request.activities.since(since)

    if @activities.present?
      render partial: @activities
    else
      head :not_modified
    end
  end

  def create
    @activity = MessageActivity.create(message_params)

    respond_to do |format|
      format.js { render @activity }
    end
  end

  private

  def message_params
    params
      .require(:activity)
      .permit(:message)
      .merge(
        user: current_user,
        booking_request: booking_request
      )
  end

  def since
    timestamp = params[:timestamp].to_i / 1000
    Time.zone.at(timestamp)
  end

  def booking_request
    current_user.booking_requests.find(params[:booking_request_id])
  end
end
