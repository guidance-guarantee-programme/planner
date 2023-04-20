module BookingLocationable
  BookingLocationNotFound = Class.new(StandardError)

  def booking_location(location_id: current_user.booking_location_id)
    @booking_location ||= begin
                            booking_location = BookingLocations.find(location_id)

                            raise BookingLocationNotFound unless booking_location

                            BookingLocationDecorator.new(booking_location)
                          end
  end

  def self.included(base)
    base.helper_method :booking_location

    base.rescue_from BookingLocationable::BookingLocationNotFound do
      render 'shared/booking_location_not_found'
    end
  end
end
