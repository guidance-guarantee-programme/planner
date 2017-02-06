class AppointmentsController < ApplicationController
  before_action :populate_appointment_form, only: %i(new create)
  before_action :populate_edit_appointment_form, only: %i(edit update)

  def index
    @search = AppointmentsSearchForm.new(search_params)

    @appointments = LocationAwareEntities.new(
      @search.results,
      booking_location
    )
  end

  def edit
  end

  def update
    if @appointment_form.update(edit_appointment_params)
      notify_customer(@appointment_form.entity)

      redirect_to appointments_path
    else
      render :edit
    end
  end

  def new
  end

  def create
    if @appointment_form.valid?
      @appointment = Appointment.create(@appointment_form.appointment_params)
      notify_customer(@appointment)

      redirect_to booking_requests_path
    else
      render :new
    end
  end

  private

  def search_params
    {
      search_term: params.dig(:search, :search_term),
      appointment_date: params.dig(:search, :appointment_date),
      current_user: current_user,
      page: params[:page]
    }
  end

  def notify_customer(appointment)
    return unless appointment.notify?

    Appointments.customer(appointment, booking_location).deliver_later
  end

  def location_aware_appointment
    LocationAwareEntity.new(
      entity: current_user.appointments.find(params[:id]),
      booking_location: booking_location
    )
  end

  def populate_edit_appointment_form
    @activities = location_aware_appointment.activities

    @appointment_form = EditAppointmentForm.new(location_aware_appointment)
  end

  def populate_appointment_form
    @activities = location_aware_booking_request.activities

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

  def edit_appointment_params # rubocop:disable Metrics/MethodLength
    munge_time_params!

    params
      .require(:appointment)
      .permit(
        :name,
        :email,
        :phone,
        :guider_id,
        :location_id,
        :proceeded_at,
        :status
      )
  end

  def munge_time_params!
    appointment_params = params[:appointment]

    hour   = appointment_params.delete('proceeded_at(4i)')
    minute = appointment_params.delete('proceeded_at(5i)')

    appointment_params[:proceeded_at] += " #{hour}:#{minute}" if hour && minute
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
