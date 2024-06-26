module Agent
  class AppointmentsController < Agent::ApplicationController
    before_action do
      authorise_user!(User::AGENT_MANAGER_PERMISSION)
    end

    before_action :load_appointment

    def edit
      @activities = @appointment.activities
    end

    def update
      if @appointment.update(edit_appointment_params)
        notify_customer(@appointment.entity)

        redirect_to edit_agent_appointment_path(@appointment),
                    success: 'The appointment was updated.'
      else
        @activities = @appointment.activities

        render :edit
      end
    end

    private

    def load_appointment
      @appointment = Appointment.find(params[:id])

      @appointment = LocationAwareEntity.new(
        entity: @appointment,
        booking_location: BookingLocations.find(@appointment.location_id)
      )
    end

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
          :additional_info,
          :third_party,
          booking_request_attributes: %i(
            id
            data_subject_name
            data_subject_date_of_birth
            bsl
          )
        )
    end

    def notify_customer(appointment)
      return unless appointment.notify?

      BookingManagerAppointmentChangeNotificationJob.perform_later(appointment)
      AppointmentChangeNotificationJob.perform_later(appointment)
      PrintedConfirmationLetterJob.perform_later(appointment)
    end
  end
end
