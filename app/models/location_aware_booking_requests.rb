class LocationAwareBookingRequests
  def initialize(booking_requests, booking_location)
    @booking_location = booking_location
    @booking_requests = booking_requests
  end

  def all
    @all ||= booking_requests.map do |booking_request|
      LocationAwareBookingRequest.new(
        booking_location: booking_location,
        booking_request: booking_request
      )
    end
  end

  private

  attr_reader :booking_location, :booking_requests
end
