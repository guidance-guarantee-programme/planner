class BatchBookingRequestReassignment
  def initialize(booking_location_id:, location_id:)
    @booking_location_id = booking_location_id
    @location_id = location_id
  end

  def call
    affected_bookings
      .update_all(booking_location_id: booking_location_id) # rubocop:disable Rails/SkipsModelValidations

    create_reassignment_activities

    BookingLocations.clear_cache
  end

  private

  attr_reader :booking_location_id, :location_id

  def create_reassignment_activities
    CreateReassignmentActivitiesJob.perform_later(affected_bookings.ids)
  end

  def affected_bookings
    @affected_bookings ||= begin
      key = if BookingRequest.exists?(booking_location_id: location_id)
              :booking_location_id
            else
              :location_id
            end

      BookingRequest.where(key => location_id)
    end
  end
end
