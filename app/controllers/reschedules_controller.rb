class ReschedulesController < ApplicationController
  def create
    return redirect_back fallback_location: root_path unless appointment_params

    message = if appointment.allocate!(appointment_params)
                send_notifications(appointment)
                { success: 'The appointment was rescheduled and the customer has been notified.' }
              else
                { warning: 'The appointment could not be rescheduled to the chosen slot.' }
              end

    redirect_to edit_appointment_path(appointment), message
  end

  private

  def send_notifications(appointment)
    return unless appointment.notify?

    AppointmentChangeNotificationJob.perform_later(appointment)
    PrintedConfirmationLetterJob.perform_later(appointment)
  end

  def appointment
    @appointment ||= current_user.appointments.find(params[:appointment_id])
  end

  def appointment_params
    proceeded_at = params.dig(:appointment, :proceeded_at)

    return if proceeded_at.blank?

    proceeded_at.delete!(BookableSlot::BSL_SLOT_DESIGNATOR)

    Time.zone.strptime(proceeded_at, '%Y-%m-%d-%H%M')
  end
end
