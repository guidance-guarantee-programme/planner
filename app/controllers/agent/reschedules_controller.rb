module Agent
  class ReschedulesController < Agent::ApplicationController
    before_action do
      authorise_user!(User::AGENT_MANAGER_PERMISSION)
    end

    def create
      return redirect_back fallback_location: root_path unless appointment_params

      message = if appointment.allocate!(appointment_params)
                  send_notifications(appointment)
                  { success: 'The appointment was rescheduled and the customer has been notified.' }
                else
                  { warning: 'The appointment could not be rescheduled to the chosen slot.' }
                end

      redirect_back fallback_location: root_path, **message
    end

    private

    def send_notifications(appointment)
      return unless appointment.notify?

      BookingManagerAppointmentChangeNotificationJob.perform_later(appointment)

      if appointment.video_appointment_url?
        AppointmentVideoUrlNotificationJob.perform_later(appointment)
      else
        AppointmentChangeNotificationJob.perform_later(appointment)
      end
    end

    def appointment
      @appointment ||= current_user.appointments.find(params[:appointment_id])
    end

    def appointment_params
      proceeded_at = params.dig(:appointment, :proceeded_at)

      return if proceeded_at.blank?

      Time.zone.strptime(proceeded_at, '%Y-%m-%d-%H%M')
    end
  end
end
