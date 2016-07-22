class AppointmentsController < ApplicationController
  def new
    @appointment_form = AppointmentForm.new(
      location_aware_booking_request,
      appointment_params
    )
  end

  def create
    @appointment_form = AppointmentForm.new(
      location_aware_booking_request,
      appointment_params
    )

    render :new
  end

  private

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
