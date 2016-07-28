class AppointmentsController < ApplicationController
  before_action :populate_appointment_form, except: :index

  def index
    @appointments = LocationAwareEntities.new(
      current_user.appointments,
      booking_location
    ).all
  end

  def new
  end

  def create
    if @appointment_form.valid?
      @appointment = Appointment.create(@appointment_form.appointment_params)
      Appointments.customer(@appointment, booking_location).deliver_later

      redirect_to booking_requests_path
    else
      render :new
    end
  end

  private

  def populate_appointment_form
    @appointment_form = AppointmentForm.new(
      location_aware_booking_request,
      appointment_params
    )
  end

  def location_aware_booking_request
    LocationAwareEntity.new(
      entity: current_user.booking_requests.find(params[:booking_request_id]),
      booking_location: booking_location
    )
  end

  def appointment_params
    params
      .fetch(:appointment, {})
      .permit(
        :guider_id,
        :location_id,
        :date,
        :time
      )
  end
end
