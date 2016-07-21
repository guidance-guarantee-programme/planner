class LocationAwareBookingRequest < SimpleDelegator
  attr_reader :booking_location

  def initialize(booking_location:, booking_request:)
    @booking_location = booking_location
    super(booking_request)
  end

  def location_name
    booking_location.name_for(location_id)
  end
end
