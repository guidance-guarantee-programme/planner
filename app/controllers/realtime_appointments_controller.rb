class RealtimeAppointmentsController < ApplicationController
  def index
    render json: Appointment.realtime_appointments(location_id, date_range)
  end

  private

  def location_id
    params[:location_id]
  end

  def date_range
    starting = params.fetch(:start) { Time.current.beginning_of_day }
    ending   = params.fetch(:end) { Time.current.end_of_day }

    starting..ending
  end
end
