module Agent
  class AppointmentsController < Agent::ApplicationController
    def edit
      @appointment = Appointment.find(params[:id])
      @activities  = @appointment.activities
    end

    def update
      @appointment = Appointment.find(params[:id])

      if @appointment.update(edit_appointment_params)
        notify_customer(@appointment)

        redirect_to edit_agent_appointment_path(@appointment),
                    success: 'The appointment was updated.'
      else
        @activities = @appointment.activities

        render :edit
      end
    end

    private

    def edit_appointment_params # rubocop:disable Metrics/MethodLength
      params
        .require(:appointment)
        .permit(
          :name,
          :email,
          :phone,
          :defined_contribution_pot_confirmed,
          :accessibility_requirements,
          :memorable_word,
          :date_of_birth,
          :additional_info
        )
    end

    def notify_customer(appointment)
      return unless appointment.notify?

      AppointmentChangeNotificationJob.perform_later(appointment)
      PrintedConfirmationLetterJob.perform_later(appointment)
    end
  end
end
