class AppointmentsController < ApplicationController
  def new
    @booking_request = current_user.booking_requests.find(params[:booking_request_id])
  end
end
