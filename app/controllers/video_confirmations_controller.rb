class VideoConfirmationsController < ApplicationController
  def create
    AppointmentVideoUrlNotificationJob.perform_later(booking_request.appointment)

    redirect_back success: 'The video link instructions were re-sent successfully.', fallback_location: root_path
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
