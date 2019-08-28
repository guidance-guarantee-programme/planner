class ConfirmationsController < ApplicationController
  def create
    @booking_request = booking_request

    if @booking_request.appointment
      AppointmentChangeNotificationJob.perform_later(@booking_request.appointment)
    else
      CustomerConfirmationJob.perform_later(@booking_request)
    end

    redirect_back success: 'The confirmation was re-sent successfully.', fallback_location: root_path
  end

  private

  def authorise!
    authorise_user!(any_of: [User::BOOKING_MANAGER_PERMISSION, User::AGENT_MANAGER_PERMISSION])
  end

  def booking_request
    scope = current_user.agent_manager? ? BookingRequest : current_user.booking_requests

    scope.find(params[:booking_request_id])
  end
end
