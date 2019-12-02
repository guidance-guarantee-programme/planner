module BookingManager
  class AppointmentsController < ApplicationController
    include RealtimeProcessable

    def new
      @appointment = BookingManagerAppointmentForm.new(appointment_params)
    end

    def preview
      @appointment = BookingManagerAppointmentForm.new(appointment_params)

      if @appointment.valid?
        render :preview
      else
        render :new
      end
    end

    def create
      @appointment = BookingManagerAppointmentForm.new(appointment_params)

      if creating?
        @appointment = @appointment.create_appointment!
        process_booking_request(@appointment)

        redirect_to booking_manager_appointment_path(@appointment, location_id: location_id)
      else
        render :new
      end
    end

    def show
      @appointment = current_user.booking_requests.find(params[:id])
    end

    private

    def location_id
      params[:location_id]
    end
    helper_method :location_id

    def location
      @location ||= booking_location.location_for(location_id)
    end
    helper_method :location

    def slots
      @slots ||= schedule.without_appointments
    end
    helper_method :slots

    def appointment_params
      params
        .fetch(:appointment, {})
        .permit(BookingManagerAppointmentForm::ATTRIBUTES)
        .merge(
          booking_location_id: current_user.booking_location_id,
          location_id: location_id,
          agent: current_user
        )
    end

    def creating?
      params[:editing].nil?
    end

    def schedule
      @schedule ||= Schedule.current(location_id)
    end
  end
end
