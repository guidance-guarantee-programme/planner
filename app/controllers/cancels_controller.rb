class CancelsController < ApplicationController
  skip_before_action :authorise!

  before_action do
    authorise_user!(any_of: [User::AGENT_MANAGER_PERMISSION, User::AGENT_PERMISSION])
  end

  def create
    if appointment.cancel_by_agent!(current_user)
      send_notifications(appointment)
      redirect_back success: 'The appointment was cancelled.', fallback_location: agent_search_index_path
    else
      redirect_back warning: 'The appointment could not be cancelled.', fallback_location: agent_search_index_path
    end
  end

  private

  def send_notifications(appointment)
    AppointmentCancellationNotificationJob.perform_later(appointment)
    BookingManagerAppointmentChangeNotificationJob.perform_later(appointment)
  end

  def appointment
    @appointment ||= Appointment.find(params[:appointment_id])
  end
end
