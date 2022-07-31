class MyAppointmentsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: my_appointments(date_range_params) }
    end
  end

  private

  def my_appointments(date_range)
    current_user.appointments.where(proceeded_at: date_range)
  end

  def date_range_params
    starts = params[:start].to_date.beginning_of_day
    ends   = params[:end].to_date.beginning_of_day

    starts..ends
  end
end
