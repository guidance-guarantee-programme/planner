class BookingManagersNotFoundError < StandardError; end

class BookingManagerConfirmationJob < ActiveJob::Base
  queue_as :default

  def perform(booking_request)
    booking_location = BookingLocations.find(booking_request.location_id)
    booking_managers = User.active.where(organisation_content_id: booking_location.id)

    raise BookingManagersNotFoundError unless booking_managers.present?

    booking_managers.each do |booking_manager|
      BookingRequests.booking_manager(booking_manager).deliver_later
    end
  end
end
