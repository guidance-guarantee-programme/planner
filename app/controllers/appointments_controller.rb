class AppointmentsController < ApplicationController
  before_action :populate_appointment_form

  def new
  end

  def create
    Appointment.create(@appointment_form.appointment_params)

    redirect_to booking_requests_path
  end

  private

  def populate_appointment_form
    @appointment_form = AppointmentForm.new(
      location_aware_booking_request,
      appointment_params
    )
  end

  def location_aware_booking_request
    LocationAwareBookingRequest.new(
      booking_request: current_user.booking_requests.find(params[:booking_request_id]),
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
