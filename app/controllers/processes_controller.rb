class ProcessesController < ApplicationController
  def create
    @appointment = current_user.appointments.find(params[:appointment_id])
    @appointment.process!(current_user)

    redirect_back success: 'The appointment was marked as processed.', fallback_location: root_path
  end
end
