class CustomerConfirmationJob < ActiveJob::Base
  queue_as :default

  def perform(booking_request)
    return unless booking_request.email?

    booking_location = BookingLocations.find(booking_request.location_id)

    BookingRequests.customer(booking_request, booking_location).deliver_now
  end
end
