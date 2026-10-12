class MyAppointmentsController < ApplicationController
  def show
    respond_to do |format|
      format.html
      format.json { render json: my_appointments(date_range_params) }
    end
  end

  private

  def canonical_guiders_location
    location.guiders.empty? ? booking_location : location
  end
  helper_method :canonical_guiders_location

  def location
    booking_location.location_for(location_id)
  end
  helper_method :location

  def location_id
    params[:location_id]
  end
  helper_method :location_id

  def my_appointments(date_range)
    current_user.appointments.where(location_id: location_id, proceeded_at: date_range)
  end

  def date_range_params
    starts = params[:start].to_date.beginning_of_day
    ends   = params[:end].to_date.beginning_of_day

    starts..ends
  end
end
