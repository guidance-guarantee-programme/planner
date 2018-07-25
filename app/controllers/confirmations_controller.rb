class ConfirmationsController < ApplicationController
  def create
    @booking_request = current_user.booking_requests.find(params[:booking_request_id])

    if @booking_request.appointment
      AppointmentChangeNotificationJob.perform_later(@booking_request.appointment)
    else
      CustomerConfirmationJob.perform_later(@booking_request)
    end

    redirect_back success: 'The confirmation was re-sent successfully.', fallback_location: root_path
  end
end
