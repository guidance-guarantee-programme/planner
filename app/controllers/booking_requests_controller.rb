class BookingRequestsController < ApplicationController
  def index
    @booking_requests = BookingRequest.all
  end
end
