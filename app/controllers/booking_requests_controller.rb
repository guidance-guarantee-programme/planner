class BookingRequestsController < ApplicationController
  def index
    @booking_requests = BookingRequest.all
  end

  def show
    @booking_request = BookingRequest.find(params[:id])
  end

  def scheduler
    @booking_request = BookingRequest.find(params[:id])
  end

  def guider
  end
end
