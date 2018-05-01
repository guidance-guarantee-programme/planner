class BookingManagerConfirmationJob < ActiveJob::Base
  queue_as :default

  def perform(booking_request)
    booking_managers = User.active.where(organisation_content_id: booking_request.booking_location_id)

    raise BookingManagersNotFoundError unless booking_managers.present?

    booking_managers.each do |booking_manager|
      BookingRequests.booking_manager(booking_manager).deliver_later
    end
  end
end
