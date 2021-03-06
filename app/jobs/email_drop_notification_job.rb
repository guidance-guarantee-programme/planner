class EmailDropNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(booking_request)
    booking_managers = User.booking_managers(booking_request.booking_location_id)

    raise BookingManagersNotFoundError unless booking_managers.present?

    return if booking_managers.pluck(:email).include?(booking_request.email)

    booking_managers.each do |booking_manager|
      BookingRequests.email_failure(booking_request, booking_manager).deliver_later
    end
  end
end
