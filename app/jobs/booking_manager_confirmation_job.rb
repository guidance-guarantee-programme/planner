class BookingManagerConfirmationJob < ActiveJob::Base
  queue_as :default

  include BookingManagerable

  def perform(booking_request)
    booking_managers = booking_managers_for(booking_request.booking_location_id)

    raise BookingManagersNotFoundError if booking_managers.blank?

    booking_managers.each do |booking_manager|
      BookingRequests.booking_manager(
        booking_request.appointment || booking_request,
        booking_manager
      ).deliver_later
    end
  end
end
