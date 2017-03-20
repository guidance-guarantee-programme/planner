class BatchBookingRequestReassignment
  def initialize(booking_location_id:, location_id:)
    @booking_location_id = booking_location_id
    @location_id = location_id
  end

  def call
    affected_bookings
      .update_all(booking_location_id: booking_location_id) # rubocop:disable Rails/SkipsModelValidations

    BookingLocations.clear_cache
  end

  private

  attr_reader :booking_location_id, :location_id

  def affected_bookings
    @affected_bookings ||= BookingRequest.where(location_id: location_id)
  end
end
