module BookingLocationable
  def booking_location(location_id: current_user.booking_location_id)
    @booking_location ||= BookingLocationDecorator.new(BookingLocations.find(location_id))
  end

  def self.included(base)
    base.helper_method :booking_location
  end
end
